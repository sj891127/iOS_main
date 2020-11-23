//
//  NSTimer+timer.h
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (timer)
+(NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)(void))block userInfo:(id)userInfo repeats:(BOOL)yesOrNo;;
-(void)pauseTimer;
-(void)resumeTimer;
@end

NS_ASSUME_NONNULL_END
