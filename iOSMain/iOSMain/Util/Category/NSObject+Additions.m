//
//  NSObject+Additions.m
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import "NSObject+Additions.h"

typedef NS_ENUM(NSInteger, ObjectMethodType) {
    ObjectMethodType_Unknow,
    ObjectMethodType_Class,
    ObjectMethodType_instance
};

@implementation NSObject (Additions)

#pragma mark - Method
+ (BOOL)swizzleMethod:(SEL)arg1 withMethod:(SEL)arg2{
    ObjectMethodType type = ObjectMethodType_Unknow;
    Method method1 = class_getInstanceMethod(self, arg1);
    if (method1) {
        type = ObjectMethodType_instance;
    } else {
        method1 = class_getClassMethod(self, arg1);
        if (method1) {
            type = ObjectMethodType_Class;
        } else {
            return NO;;
        }
    }
    Method method2 = NULL;
    switch (type) {
        case ObjectMethodType_instance: {
            method2 = class_getInstanceMethod(self, arg2);
        }
            break;
        case ObjectMethodType_Class: {
            method2 = class_getClassMethod(self, arg2);
        }
            break;
        default:
            break;
    }
    if (!method2){
        return NO;
    }
    class_addMethod(self,
                    arg1,
                    class_getMethodImplementation(self, arg1),
                    method_getTypeEncoding(method1));
    class_addMethod(self,
                    arg2,
                    class_getMethodImplementation(self, arg2),
                    method_getTypeEncoding(method2));
    
    switch (type) {
        case ObjectMethodType_instance: {
            method_exchangeImplementations(class_getInstanceMethod(self, arg1), class_getInstanceMethod(self, arg2));
        }
            break;
        case ObjectMethodType_Class: {
            method_exchangeImplementations(class_getClassMethod(self, arg1), class_getClassMethod(self, arg2));
        }
            break;
        default:
            break;
    }
    return YES;
}

- (id)performSelector:(SEL)selector withValue:(void *)value
{
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    if (signature)
    {
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        if (value)
        {
            [invocation setArgument:value atIndex:2];
        }
        [invocation invoke];
        if (signature.methodReturnLength)
        {
            id anObject;
            [invocation getReturnValue:&anObject];
            return anObject;
        }
    }
    return nil;
}

- (id)performSelector:(SEL)selector withBoolValue:(BOOL)value{
    return [self performSelector:selector withValue:&value];
}

- (id)performSelector:(SEL)selector withIntegerValue:(BOOL)value{
    return [self performSelector:selector withValue:&value];
}

- (BOOL)implementationIsExistForSelector:(SEL)selector{
    Class cls = [self class];
    IMP imp = class_getMethodImplementation(cls, selector);
    if (imp){
        return YES;
    }
    return NO;
}

#pragma mark - Property
- (void)addProperty:(NSString *)propertyName
               type:(Class)typeCls {
    const char *name = [propertyName UTF8String];
    if (class_getProperty(self.class, name)) {
        return;
    }
    
    const char * propertyTypeStr = "@";
    if (typeCls) {
        propertyTypeStr = [[NSString stringWithFormat:@"@\\\"%@\\\"", NSStringFromClass(typeCls)] UTF8String];
    }
    objc_property_attribute_t type = { "T", propertyTypeStr };
    objc_property_attribute_t ownership1 = { "&", "" };
    objc_property_attribute_t ownership2 = { "N", "" };
    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", propertyName] UTF8String] };
    objc_property_attribute_t attrs[] = { type, ownership1, ownership2, backingivar };

    unsigned int attrsCount = 3;
    BOOL result = class_addProperty(self.class, name, attrs, attrsCount);
    if (!result) {
        class_replaceProperty(self.class, [propertyName UTF8String], attrs, attrsCount);
    }
    [self addMethodForProperty:propertyName];
}

- (void)addMethodForProperty:(NSString *)propertyName {
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", [[propertyName substringWithRange:NSMakeRange(0, 1)] uppercaseString], ([propertyName length]>1?[propertyName substringFromIndex:1]:@"")];
    class_addMethod(self.class, NSSelectorFromString(propertyName), (IMP)getter, "@@:");
    class_addMethod(self.class, NSSelectorFromString(setterName), (IMP)setter, "v@:@");
}

id getter(id object, SEL _cmd1) {
    NSString *inputKey = NSStringFromSelector(_cmd1);
    NSMutableDictionary *inputKeys = objc_getAssociatedObject(object, input_keys);
    if (inputKeys) {
        NSString *key = [inputKeys valueForKey:inputKey];
        if (key) {
            return objc_getAssociatedObject(object, (__bridge const void * _Nonnull)(key));
        }
    }
    return nil;
}

void setter(id object, SEL _cmd1, id newValue) {
    NSString *key = NSStringFromSelector(_cmd1);
    key = [key substringWithRange:NSMakeRange(3, key.length-4)];
    key = [NSString stringWithFormat:@"%@%@", [[key substringWithRange:NSMakeRange(0, 1)] lowercaseString], ([key length]>1?[key substringFromIndex:1]:@"")];
    
    NSMutableDictionary *inputKeys = objc_getAssociatedObject(object, input_keys);
    if (!inputKeys) {
        inputKeys = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(object, input_keys, inputKeys, OBJC_ASSOCIATION_RETAIN);
    }
    [inputKeys setValue:key forKey:key];
    objc_setAssociatedObject(object, (__bridge const void * _Nonnull)(key), newValue, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Class
+ (BOOL)registClass:(NSString *)clsName
         superClass:(Class)superCls {
    if (!clsName) {
        return NO;
    }
    Class existCls = NSClassFromString(clsName);
    if (existCls) {
        return YES;
    }
    if (!superCls) {
        superCls = [NSObject class];
    }
    Class targetCls = objc_allocateClassPair(superCls, [clsName UTF8String], 0);
    if (!targetCls) {
        return NO;
    }
    objc_registerClassPair(targetCls);
    return YES;;
}

@end
