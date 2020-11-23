//
//  NSArray+safeArray.m
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import "NSArray+safeArray.h"
#import "NSObject+Additions.h"

@implementation NSArray (safeArray)

-(id)forwardingTargetForSelector:(SEL)aSelector{
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //将此方法进行重写，在里这不进行任何操作，屏蔽会产生crash的方法调用
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *methodName =NSStringFromSelector(aSelector);
    if ([methodName hasPrefix:@"_"]) {//对私有方法不进行crash日志采集操作
        return nil;
    }
    NSString *crashInfo = [NSString stringWithFormat:@"[%@ %@]: unrecognized selector sent to instance",self,NSStringFromSelector(aSelector)];
    NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:@selector(crashLogForArray:)];
    [self crashLogForArray:crashInfo];
    return signature;
}

- (void)crashLogForArray:(NSString *)crashInfo {
    NSLog(@"NSArray Crash：%@", crashInfo);
}

+ (void)load{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{  //方法交换只要一次就好
        Method oldObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method newObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(cm_objectAtIndex:));
        
        Method fromSingleMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:));
        Method toSingleMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(cm_objectAtSingleIndex:));
        
        Method from0Method = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:));
        Method to0Method = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(cm_objectAt0Index:));
        
        Method fromSubscriptMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:));
        Method toSubscriptMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(cm_objectAtIndexedSubscrip:));

        Method fromSingleSubscriptMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndexedSubscript:));
        Method toSingleSubscriptMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(cm_objectAtIndexedSingleSubscrip:));
        
        Method from0SubscriptMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndexedSubscript:));
        Method to0SubscriptMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(cm_objectAtIndexed0Subscrip:));
        
        method_exchangeImplementations(oldObjectAtIndex, newObjectAtIndex);
        method_exchangeImplementations(fromSingleMethod, toSingleMethod);
        method_exchangeImplementations(from0Method, to0Method);
        if (iOSVersion>10.9) {
            method_exchangeImplementations(fromSubscriptMethod, toSubscriptMethod);
            method_exchangeImplementations(fromSingleSubscriptMethod, toSingleSubscriptMethod);
            method_exchangeImplementations(from0SubscriptMethod, to0SubscriptMethod);
        }
    });
}
- (id)cm_objectAtIndex:(NSUInteger)index{
    if (index > self.count - 1 || !self.count){
        @try {
            return [self cm_objectAtIndex:index];
        } @catch (NSException *exception) {
            //__throwOutException  抛出异常
            return nil;
        } @finally {
            
        }
    }
    else{
        return [self cm_objectAtIndex:index];
    }
}

-(id)cm_objectAtSingleIndex:(NSUInteger)index{
    if (index < self.count){
        return [self cm_objectAtSingleIndex:index];
    } else {
        @try {
            return [self cm_objectAtSingleIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }
}

-(id)cm_objectAt0Index:(NSUInteger)index{
    if (index < self.count){
        return [self cm_objectAt0Index:index];
    } else {
        @try {
            return [self cm_objectAt0Index:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }
}

-(id)cm_objectAtIndexedSubscrip:(NSUInteger)index{
    if (index < self.count){
        return [self cm_objectAtIndexedSubscrip:index];
    } else{
        @try {
            return [self cm_objectAtIndexedSubscrip:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }
}

-(id)cm_objectAtIndexedSingleSubscrip:(NSUInteger)index{
    if (index < self.count){
        return [self cm_objectAtIndexedSingleSubscrip:index];
    } else{
        @try {
            return [self cm_objectAtIndexedSingleSubscrip:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }
}

-(id)cm_objectAtIndexed0Subscrip:(NSUInteger)index{
    if (index < self.count){
        return [self cm_objectAtIndexed0Subscrip:index];
    } else{
        @try {
            return [self cm_objectAtIndexed0Subscrip:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }
}

@end



//mutableArray的对象也需要做方法交换
@interface NSMutableArray (MutableArraySafe)

@end

@implementation NSMutableArray (MutableArraySafe)

-(id)forwardingTargetForSelector:(SEL)aSelector{
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //将此方法进行重写，在里这不进行任何操作，屏蔽会产生crash的方法调用
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *methodName =NSStringFromSelector(aSelector);
    if ([methodName hasPrefix:@"_"]) {//对私有方法不进行crash日志采集操作
        return nil;
    }
    NSString *crashInfo = [NSString stringWithFormat:@"[%@ %@]: unrecognized selector sent to instance",self,NSStringFromSelector(aSelector)];
    NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:@selector(crashLogForMutableArray:)];
    [self crashLogForMutableArray:crashInfo];
    return signature;
}

- (void)crashLogForMutableArray:(NSString *)crashInfo {
    NSLog(@"NSMutableArray Crash：%@", crashInfo);
}

+ (void)load{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{  //方法交换只要一次就好
        Method oldObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
        Method newObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(cm_objectAtIndex:));
        
        Method fromSubscriptMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndexedSubscript:));
        Method toSubscriptMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(cm_objectAtIndexedSubscrip:));
        
        Method fromInsertMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(insertObject:atIndex:));
        Method toInsertMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(cm_insertObject:atIndex:));
        
        method_exchangeImplementations(oldObjectAtIndex, newObjectAtIndex);
        method_exchangeImplementations(fromInsertMethod, toInsertMethod);
        if (iOSVersion>10.9) {
            method_exchangeImplementations(fromSubscriptMethod, toSubscriptMethod);
        }
    });
}
- (id)cm_objectAtIndex:(NSUInteger)index{
    if (index > self.count - 1 || !self.count){
        @try {
            return [self cm_objectAtIndex:index];
        } @catch (NSException *exception) {
            //__throwOutException  抛出异常
            return nil;
        } @finally {
            
        }
    }
    else{
        return [self cm_objectAtIndex:index];
    }
}

-(id)cm_objectAtIndexedSubscrip:(NSUInteger)index{
    if (index < self.count){
        return [self cm_objectAtIndexedSubscrip:index];
    } else{
        @try {
            return [self cm_objectAtIndexedSubscrip:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }
}

- (void)cm_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject && index<=self.count) {
        [self cm_insertObject:anObject atIndex:index];
    } else {
        @try {
            return [self cm_insertObject:anObject atIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        } @finally {
            
        }
    }
}

@end
