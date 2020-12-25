//
//  TestViewController.m
//  iOS_main
//
//  Created by shenjie on 2020/10/14.
//

#import "TestViewController.h"
#import "VideoViewController.h"
#import "ImagePickerImpl.h"

@interface TestViewController ()<ImagePickerDelegate>
@property (nonatomic, strong) ImagePickerImpl  *impl;
@end

@implementation TestViewController

+ (void)load{
    NSLog(@"load");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"viewDidLoad");
    self.impl = [[ImagePickerImpl alloc] init];
    self.impl.delegate = self;
    for (int i = 0; i<4; i++) {
        UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [testBtn setTitle:[self getBtnTitle:i] forState:UIControlStateNormal];
        [testBtn setFrame:CGRectMake(0, i*100 + i, SCREEN_WIDTH, 100)];
        testBtn.backgroundColor = [UIColor redColor];
        testBtn.tag = i;
        [testBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:testBtn];
    }
}

//abc
- (NSString *)getBtnTitle :(NSInteger)tag{
    switch (tag) {
        case 0:
            return @"openRecord";
            break;
        case 1:
            return @"openCamera";
            break;
        case 2:
            return @"openSystemLibrary";
            break;
        case 3:
            return @"openPhotoLibrary";
            break;
        default:
            return @"";
            break;
    }
}

- (void)click: (UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self openRecord];
            break;
        case 1:
            [self openCamera];
            break;
        case 2:
            [self openSystemLibrary];
            break;
        case 3:
            [self openPhotoLibrary];
            break;
    }
}

- (void)openRecord{
    VideoViewController *ctrl = [VideoViewController new];
    ctrl.HSeconds = 60;//设置可录制最长时间
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

- (void)openCamera{
    [ImagePickerManager showCamera:self.impl completion:^{

    }];
}

- (void)openSystemLibrary{
    [ImagePickerManager showSystemPhotoLibrary:self.impl completion:^{
        
    }];
}

- (void)openPhotoLibrary{
    TZImagePickerController *controller = [ImagePickerManager showPhotoLibrary:self.impl maxImagesCount:1 videoEnable:NO gifEnable:NO completion:nil];
    NSLog(@"vc====%@",controller);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"willAppear");
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)imageDidSelected:(NSString *)imageUrl{
    
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
