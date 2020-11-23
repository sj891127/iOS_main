//
//  NSTimer+timer.m
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import "NSTimer+timer.h"

@implementation NSTimer (timer)

+(NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)(void))aBlock userInfo:(id)userInfo repeats:(BOOL)yesOrNo{
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(ste_timerFireMethod:) userInfo:[aBlock copy ] repeats:yesOrNo];
}

+(void)ste_timerFireMethod:(NSTimer*)timer{
    void(^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

- (void)pauseTimer{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}
@end
