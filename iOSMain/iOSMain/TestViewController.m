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

+ (void)load{
    NSLog(@"load");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"viewDidLoad");
//    NSArray *testArr = [[NSArray alloc]initWithObjects:@"1",@"2", nil];
//    NSMutableArray *testArr = [[NSMutableArray alloc]initWithObjects:@"1",@"2", nil];
//    NSLog(@"=====%@",testArr[2]);
//    NSLog(@"success=====");
//    NSLog(@"====%f",SCREEN_WIDTH);
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn setFrame:CGRectMake(0, 0, 100, 100)];
    testBtn.backgroundColor = [UIColor redColor];
    [testBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}

- (void)click{
    [self.view makeToast:@"test!!"];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"willAppear");
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

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
