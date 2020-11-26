//
//  ImagePickerManager.m
//  iOSMain
//
//  Created by shenjie on 2020/11/26.
//

#import "ImagePickerManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"

#define PhotoLibraryEntranceWidth   40.f

@interface ImagePickerManager ()

@end

@implementation ImagePickerManager

+ (__kindof UIImagePickerController *)showCamera:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>)delegate
                                      completion:(void (^ __nullable)(void))completion {
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(statusVideo == AVAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"开启相机权限"
                                                                                 message:@"拍照"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [cancelAction setValue:UIColorFromHex(0xFFFF6159) forKey:@"titleTextColor"];
        [okAction setValue:UIColorFromHex(0xFF4A4A4A) forKey:@"titleTextColor"];
        [appDelegate.getCurrentViewController presentViewController:alertController animated:YES completion:nil];
        return nil;;
    } else {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return nil;
        }
        __kindof UIImagePickerController *picker = [[ImagePickerManager alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.videoQuality = UIImagePickerControllerQualityType640x480;
        picker.delegate = delegate;
        __kindof UIView *photoLibraryEntrance = [self photoLibraryOverlayView];
        photoLibraryEntrance.origin = CGPointMake(SCREEN_WIDTH-15-PhotoLibraryEntranceWidth, StatusBarHeight+2);
        picker.cameraOverlayView = photoLibraryEntrance;
        [appDelegate.getCurrentViewController presentViewController:picker
                                                           animated:YES
                                                         completion:completion];
        
        return picker;
    }
}

+ (__kindof UIImagePickerController *)showSystemPhotoLibrary:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>)delegate
                                                  completion:(void (^ __nullable)(void))completion {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return nil;
    }
    __kindof UIImagePickerController *picker = [[ImagePickerManager alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = delegate;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [appDelegate.getCurrentViewController presentViewController:picker
                                                       animated:YES
                                                     completion:completion];
    
    return picker;
}

+ (__kindof TZImagePickerController *)showPhotoLibrary:(id<TZImagePickerControllerDelegate>)delegate
                                        maxImagesCount:(NSUInteger)maxImagesCount
                                           videoEnable:(BOOL)videoEnable
                                             gifEnable:(BOOL)gifEnable
                                            completion:(void (^ __nullable)(void))completion {
    TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount
                                                                                 delegate:delegate];
    vc.isSelectOriginalPhoto = YES;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.allowTakeVideo = videoEnable;
    vc.allowPickingGif = gifEnable;
    vc.autoDismiss = NO;
    [appDelegate.getCurrentViewController presentViewController:vc
                                                       animated:YES
                                                     completion:completion];
    return vc;
}

- (BOOL)shouldAutorotate{
    return NO;
}

#pragma mark - Private
#pragma mark __________UI__________
+ (__kindof UIView *)photoLibraryOverlayView {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, PhotoLibraryEntranceWidth, PhotoLibraryEntranceWidth);
    [btn setImage:[UIImage imageNamed:@"photoIcon"]
         forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(plDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark __________Action__________
+ (void)plDidPressed:(UIButton *)sender {
    ImagePickerManager *vc = appDelegate.getCurrentViewController;
    if ([vc isKindOfClass:[ImagePickerManager class]]) {
        [vc dismissViewControllerAnimated:NO
                               completion:^{
            [self showPhotoLibrary:vc.delegate
                    maxImagesCount:1
                       videoEnable:NO
                         gifEnable:NO
                        completion:^{
                
            }];
        }];
    }
}

@end
