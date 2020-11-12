//
//  UIStructHelper.h
//  iOS_main
//
//  Created by shenjie on 2020/10/14.
//

#import <Foundation/Foundation.h>
#import "TestViewController.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, TabType) {
    TabType_Home = 0,
};

#define Tabs          @[@"TestViewController"]

@interface UIStructHelper : NSObject
SYNTHESIZE_ARC_SINGLETON_FOR_CLASS_HEADER(UIStructHelper)
@property (nonatomic, strong) UITabBarController                                                  *rootController;
@property (nonatomic, assign) NSInteger                                                           currentIndex;
@property (nonatomic, strong) NSArray<__kindof UIViewController<TabViewControllerProtocol> *>   *tabBarViewControllers;

@end
