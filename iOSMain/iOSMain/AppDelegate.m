//
//  AppDelegate.m
//  iOSMain
//
//  Created by shenjie on 2020/11/2.
//

#import "AppDelegate.h"
#import <GTSDK/GeTuiSdk.h>
#import <UserNotifications/UserNotifications.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <Bugly/Bugly.h>
#import "IQKeyboardManager.h"
#if ENV == 3
#import <DoraemonKit/DoraemonManager.h>
#endif

AppDelegate *appDelegate = nil;

@interface AppDelegate ()<GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

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
    [self setNetwork];
    [self setUI];
    [self setHud];
    [self setToast];
    [self setDDLog];
    [self setGeTui];
    [self setShareSettings];
    [self setSharePlatforms];
    [self setBugly];
    [self setKeyBoard];
    [self setDoraemon];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [GeTuiSdk resetBadge];
}

- (void)setUI {
    [[UIButton appearance] setExclusiveTouch:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [UIStructHelper sharedInstance].rootController;
    [self.window makeKeyAndVisible];
}

- (void)setKeyBoard{
    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)setHud {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
}

- (void)setToast {
    CSToastStyle *toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    toastStyle.messageFont = [UIFont systemFontOfSize:14
                                               weight:UIFontWeightSemibold];
    toastStyle.messageAlignment = NSTextAlignmentCenter;
    toastStyle.horizontalPadding = 30;
    toastStyle.verticalPadding = 15;
    toastStyle.maxWidthPercentage = (375.0 - 90 * 2) / 375.0 * SCREEN_WIDTH;
//    toastStyle.backgroundColor = UIColorFromHex(0xFFE4E4E4);
    toastStyle.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    toastStyle.cornerRadius = 4;
    [CSToastManager setTapToDismissEnabled:NO];
    [CSToastManager setSharedStyle:toastStyle];
    [CSToastManager setDefaultDuration:1];
    [CSToastManager setDefaultPosition:CSToastPositionCenter];
}

- (void)setDoraemon {
#if ENV == 3
    //默认
    [[DoraemonManager shareInstance] install];
    // 或者使用传入位置,解决遮挡关键区域,减少频繁移动
    //[[DoraemonManager shareInstance] installWithStartingPosition:CGPointMake(66, 66)];
#endif
}

// 配置用户请求域名及header信息
- (void)setNetwork {
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

//初始化DDLog 配置
- (void)setDDLog{
    [DDLog addLogger:[DDOSLogger sharedInstance]]; // Uses os_lo
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

- (void)setGeTui{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"uuId"]) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%u",arc4random()%1000000] forKey:@"uuId"];
    }
    [GeTuiSdk startSdkWithAppId:@"" appKey:@"" appSecret:@"" delegate:self];
    [self registerAPNs];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [GeTuiSdk resetBadge];
}

- (void)registerAPNs{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if(!error ){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSDictionary *aps = userInfo[@"aps"];
    NSString *category = aps[@"category"];
    if (category.length == 0) return;
    if (userInfo) {
        NSData *jsonData = [(NSString *)category dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"result===%@",result);
    }
    completionHandler();
}

- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    if (payloadData!=nil) {
        NSError* error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"result===%@",result);
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    NSString *token = nil;
    if (@available(iOS 13.0, *)) {
        if (![deviceToken isKindOfClass:[NSData class]]) return;
        const unsigned *tokenBytes = [deviceToken bytes];
        token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                 ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                 ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                 ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        
    }else{
        token = [[deviceToken description] stringByTrimmingCharactersInSet:[
                                                                            NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    }
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"[DeviceToken Success]:%@", token);
    [GeTuiSdk registerDeviceTokenData:deviceToken];
    NSLog(@"clientId====%@",[GeTuiSdk clientId]);
    if (![Tools isBlankString:token]) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)GeTuiSdkDidRegisterClient:(NSString *)clientId{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",clientId] forKey:@"iOSclientId"];
}

- (void)setShareSettings{
    [UMConfigure initWithAppkey:@"" channel:@"App Store"];
    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"",@(UMSocialPlatformType_WechatTimeLine):@""};
}

- (void)setSharePlatforms{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
}

- (void)setBugly{
    [Bugly startWithAppId:@""];
}

@end
