//
//  TestViewController.m
//  iOS_main
//
//  Created by shenjie on 2020/10/14.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"width====%lf",SCREEN_WIDTH);
}

#pragma mark - MKTabViewControllerProtocol
- (NSString *)tabTitle {
    return @"test";
}

- (UIImage *)tabImage {
    return [UIImage imageNamed:@""];
}

- (UIImage *)tabSelectedImage {
    return [UIImage imageNamed:@""];
}

- (NSString *)tabBadge {
    return nil;
}

- (UIColor *)tabBadgeColor {
    return nil;
}

@end
