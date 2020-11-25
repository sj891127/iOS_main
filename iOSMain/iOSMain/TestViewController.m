//
//  TestViewController.m
//  iOS_main
//
//  Created by shenjie on 2020/10/14.
//

#import "TestViewController.h"
#import "VideoViewController.h"

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
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn setFrame:CGRectMake(0, 0, 100, 100)];
    testBtn.backgroundColor = [UIColor redColor];
    testBtn.tag = 0;
    [testBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}

- (void)click: (UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self openCamera];
            break;
    }
}

- (void)openCamera{
    VideoViewController *ctrl = [VideoViewController new];
    ctrl.HSeconds = 15;//设置可录制最长时间
    ctrl.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            //视频
            NSURL *videoURL = item;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"video.mp4"];
            if (videoData) {
                [videoData writeToFile:filePath atomically:YES];
            }
        } else {
            //图片
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic.jpg"]];
            BOOL result = [UIImageJPEGRepresentation(item, 1) writeToFile: filePath atomically:YES];
            NSLog(@"result====%d",result);
        }
    };
    [self.navigationController pushViewController:ctrl animated:YES];
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
