//
//  AppDelegate.m
//  iOSMain
//
//  Created by shenjie on 2020/11/2.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TestViewController *root =[[TestViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
