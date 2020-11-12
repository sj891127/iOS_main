//
//  AppDelegate.m
//  iOSMain
//
//  Created by shenjie on 2020/11/2.
//

#import "AppDelegate.h"

AppDelegate *appDelegate = nil;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (__kindof UIViewController *)getCurrentViewController {
    __kindof UIViewController *reController = nil;
    __kindof UIViewController *rootViewController = [self.window rootViewController];
    if (rootViewController!=nil)
    {
        if ([rootViewController isKindOfClass:[UITabBarController class]]) {
            reController = [(UITabBarController *)rootViewController selectedViewController];
        } else if ([rootViewController isKindOfClass:[UINavigationController class]]){
            reController = [(UINavigationController *)rootViewController topViewController];
        } else {
            reController = rootViewController;
        }
        
        __kindof UIViewController * tempViewController = reController;
        while ([(UIViewController *)tempViewController presentedViewController]!=nil) {
            tempViewController = [(UIViewController *)tempViewController presentedViewController];
        }
        if (tempViewController!=nil) {
            if ([tempViewController isKindOfClass:[UINavigationController class]]
                && ![tempViewController isKindOfClass:[UIImagePickerController class]]) {
                reController = [(UINavigationController *)tempViewController topViewController];
            } else {
                reController = tempViewController;
            }
        }
    }
    return reController;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    appDelegate = self;
    return YES;;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupNetwork];
    [self setupUI];
    return YES;
}

- (void)setupUI {
    [[UIButton appearance] setExclusiveTouch:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [UIStructHelper sharedInstance].rootController;
    [self.window makeKeyAndVisible];
}

// 配置用户请求域名及header信息
- (void)setupNetwork {
    [RequestManager sharedInstance].delegate = [MainNetworkHelper sharedInstance];
    [[RequestManager sharedInstance] configEviroment:[MainNetworkHelper sharedInstance].env];
    [BasicHandler sharedInstance].delegate = [MainBusinessHelper sharedInstance];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [[MainBusinessHelper sharedInstance] setApplication:1];
        [[MainBusinessHelper sharedInstance] setDevice:1];
    }else{
        [[MainBusinessHelper sharedInstance] setApplication:2];
        [[MainBusinessHelper sharedInstance] setDevice:2];
    }
    [[MainBusinessHelper sharedInstance] setClientType:0];
    [[MainBusinessHelper sharedInstance] setVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

@end
