//
//  NSSet+setSafe.m
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import "NSSet+setSafe.h"
#import "NSObject+Additions.h"

@implementation NSSet (setSafe)

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
    NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:@selector(crashLogForSet:)];
    [self crashLogForSet:crashInfo];
    return signature;
}

- (void)crashLogForSet:(NSString *)crashInfo {
    NSLog(@"NSSet Crash：%@", crashInfo);
}

@end

@interface NSMutableSet (VIPSetSafe)

@end

@implementation NSMutableSet (VIPSetSafe)

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
    NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:@selector(crashLogForMutableSet:)];
    [self crashLogForMutableSet:crashInfo];
    return signature;
}

- (void)crashLogForMutableSet:(NSString *)crashInfo {
    NSLog(@"NSMutableSet Crash：%@", crashInfo);
}

@end
