//
//  UIControl+Repeate.m
//  iOSMain
//
//  Created by shenjie on 2020/11/30.
//

#import "UIControl+Repeate.h"
#import <objc/runtime.h>

static char * const eventIntervalKey = "eventIntervalKey";
static char * const eventUnavailableKey = "eventUnavailableKey";

@interface UIControl ()

@property (nonatomic, assign) BOOL eventUnavailable;

@end

@implementation UIControl (Repeate)

+ (void)load {
    Method method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method repeat_method = class_getInstanceMethod(self, @selector(repeat_sendAction:to:forEvent:));
    method_exchangeImplementations(method, repeat_method);
}


#pragma mark - Action functions

- (void)repeat_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.eventUnavailable == NO) {
        self.eventUnavailable = YES;
        [self repeat_sendAction:action to:target forEvent:event];
        [self performSelector:@selector(setEventUnavailable:) withObject:@(NO) afterDelay:self.eventInterval];
    }
}


#pragma mark - Setter & Getter functions

- (NSTimeInterval)eventInterval {
    
    return [objc_getAssociatedObject(self, eventIntervalKey) doubleValue];
}

- (void)setEventInterval:(NSTimeInterval)eventInterval {
    objc_setAssociatedObject(self, eventIntervalKey, @(eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)eventUnavailable {
    
    return [objc_getAssociatedObject(self, eventUnavailableKey) boolValue];
}

- (void)setEventUnavailable:(BOOL)eventUnavailable {
    
    objc_setAssociatedObject(self, eventUnavailableKey, @(eventUnavailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
