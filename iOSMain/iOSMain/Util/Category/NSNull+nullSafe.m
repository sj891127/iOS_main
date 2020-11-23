//
//  NSNull+nullSafe.m
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import "NSNull+nullSafe.h"
#import "NSObject+Additions.h"
@implementation NSNull (nullSafe)

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
    NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:@selector(crashLogForNull:)];
    [self crashLogForNull:crashInfo];
    return signature;
}

- (void)crashLogForNull:(NSString *)crashInfo {
    NSLog(@"NSNull Crash：%@", crashInfo);
}

@end
