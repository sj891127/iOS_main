//
//  UIStructHelper.m
//  iOS_main
//
//  Created by shenjie on 2020/10/14.
//

#import "UIStructHelper.h"

@interface UIStructHelper () <UITabBarControllerDelegate>
@property (nonatomic, strong) TestViewController                                                  *testRoot;
@end

@implementation UIStructHelper
SYNTHESIZE_ARC_SINGLETON_FOR_CLASS(UIStructHelper)

- (__kindof UIViewController<TabViewControllerProtocol> *)selectTabAtIndex:(NSUInteger)index
                                                                   parameter:(id)parameter {
    __kindof UIViewController<TabViewControllerProtocol> *reVC = nil;
    if (index<self.rootController.viewControllers.count) {
        __kindof UIViewController *nowVC = [appDelegate getCurrentViewController];
        while ([(UIViewController *)nowVC presentingViewController] != nil) {
            nowVC = [(UIViewController *)nowVC presentingViewController];
            [nowVC dismissViewControllerAnimated:NO completion:nil];
        }
        
        if ([nowVC isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)nowVC popToRootViewControllerAnimated:NO];
        } else {
            [nowVC.navigationController popToRootViewControllerAnimated:NO];
        }
        
       reVC = self.tabBarViewControllers[index];
        if (parameter && [reVC respondsToSelector:@selector(setParameter:)]) {
            [reVC setParameter:parameter];
        }
        [self.rootController setSelectedIndex:index];
    }
    return reVC;
}

- (void)reloadTabBarBadge {
    [self.rootController.viewControllers enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __kindof UIViewController<TabViewControllerProtocol> *rootVc = (obj.viewControllers.count>0)?(obj.viewControllers[0]):nil;
        obj.tabBarItem.badgeValue = [rootVc tabBadge];
        obj.tabBarItem.badgeColor = [rootVc tabBadgeColor];
    }];
}

#pragma mark - Private
- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.rootController = [[UITabBarController alloc] init];
    self.rootController.delegate = self;
    [self reload];
    self.rootController.tabBar.barTintColor = [UIColor whiteColor];
    [[UITabBar appearance] setBackgroundColor:UIColor.whiteColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromHex(0xFF9B9B9B),
                                                        NSFontAttributeName : [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromHex(0xFFFF6A52),
                                                        NSFontAttributeName : [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold]}
                                             forState:UIControlStateSelected];
    
    if (@available(iOS 13.0, *))
    {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = UIColorFromHex(0xFFE9E9E9);
        [self.rootController.tabBar addSubview:lineView];

        [self.rootController.tabBar setShadowImage:[[UIImage alloc]init]];
        [self.rootController.tabBar setBackgroundImage:[[UIImage alloc]init]];
    }
}

- (void)reload {
    NSMutableArray *children = [NSMutableArray array];
    NSArray<NSString *> *tabClsTypes = Tabs;
    [tabClsTypes enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __kindof UINavigationController * child = [self installRoot:obj
                                                            atIndex:idx];
        if (child) {
            [children addObject:child];
        }
    }];
    self.rootController.viewControllers = children;
    NSMutableArray *tabBarVcs = [NSMutableArray arrayWithObjects:self.testRoot, nil];
    self.tabBarViewControllers = tabBarVcs;
}

- (__kindof UINavigationController *)installRoot:(NSString *)rootClsName
                                         atIndex:(NSUInteger)idx {
    Class vcCls = NSClassFromString(rootClsName);
    BaseNavigationController *navController = nil;
    if (vcCls) {
        __kindof UIViewController<TabViewControllerProtocol> * root = [[vcCls alloc] init];
        switch (idx) {
            case 0: {
                self.testRoot = root;
            }
                break;
           
            default:
                break;
        }
        
        navController = [[BaseNavigationController alloc] initWithRootViewController:root];
        navController.tabBarItem.title = [root tabTitle];
        navController.tabBarItem.image = [[root tabImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navController.tabBarItem.selectedImage = [[root tabSelectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navController.tabBarItem.tag = idx;
    }
    return navController;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    switch ([self.rootController.viewControllers indexOfObject:viewController]) {
        case TabType_Home: {
            
        }
            break;
        default:
            break;
    }
    return YES;
}
 
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"Current is:%@", [appDelegate getCurrentViewController]);
    if (self.currentIndex!=tabBarController.selectedIndex) {
        [[tabBarController.tabBar subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull tabBarBtn, NSUInteger section, BOOL * _Nonnull tabBarStop) {
            if ([tabBarBtn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarBtn.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull tabBarChild, NSUInteger row, BOOL * _Nonnull childStop) {
                    if ([tabBarChild isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) {
                        NSInteger tab = NSNotFound;
                        NSString *prefixStr = @"";
                        if ([[tabBarChild text] isEqualToString:self.testRoot.tabTitle]) {
                            tab = 0;
                            prefixStr = @"首页";
                        }
                        if (tab==tabBarController.selectedIndex) {
                            
                        }
                    }
                }];
            }
        }];
    }
    self.currentIndex = tabBarController.selectedIndex;
}

@end
