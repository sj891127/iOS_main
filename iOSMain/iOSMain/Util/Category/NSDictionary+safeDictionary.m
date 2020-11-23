//
//  NSDictionary+safeDictionary.m
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import "NSDictionary+safeDictionary.h"
#import "NSObject+Additions.h"

@implementation NSDictionary (safeDictionary)

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
    NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:@selector(crashLogForDictionary:)];
    [self crashLogForDictionary:crashInfo];
    return signature;
}

- (void)crashLogForDictionary:(NSString *)crashInfo {
    NSLog(@"NSDictionary Crash：%@", crashInfo);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(safe_initWithObjects:forKeys:count:)];
        [self swizzleMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(safe_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)safe_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
            NSLog(@"NSDictionary Crash：%@ is nil", key);
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self safe_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)safe_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
            NSLog(@"NSDictionary Crash：%@ is nil", key);
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self safe_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end

@interface NSMutableDictionary (MutableDictionarySafe)

@end

@implementation NSMutableDictionary (MutableDictionarySafe)

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
    NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:@selector(crashLogForMutableDictionary:)];
    [self crashLogForMutableDictionary:crashInfo];
    return signature;
}

- (void)crashLogForMutableDictionary:(NSString *)crashInfo {
    NSLog(@"NSMutableDictionary Crash：%@", crashInfo);
}

@end
