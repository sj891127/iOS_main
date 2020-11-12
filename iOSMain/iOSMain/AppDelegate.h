//
//  AppDelegate.h
//  iOSMain
//
//  Created by shenjie on 2020/11/2.
//

#import <UIKit/UIKit.h>
#import "UIStructHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
- (__kindof UIViewController *)getCurrentViewController;
extern AppDelegate *appDelegate;
@end

