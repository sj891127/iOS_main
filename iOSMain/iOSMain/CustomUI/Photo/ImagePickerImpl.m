//
//  ImagePickerImpl.m
//  iOSMain
//
//  Created by shenjie on 2020/11/26.
//

#import "ImagePickerImpl.h"
#import <CoreServices/CoreServices.h>

@implementation ImagePickerImpl
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = nil;
    if ([type isEqualToString:(NSString*)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        if (image) {
            
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    @weakify(self)
    [picker dismissViewControllerAnimated:YES
                               completion:^{
        @strongify(self)
        if (isSelectOriginalPhoto) {
            [[TZImageManager manager] getOriginalPhotoWithAsset:assets.firstObject newCompletion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                if (!isDegraded) {
                    
                }
            }];
        } else {
            if ([self.delegate respondsToSelector:@selector(imageDidSelected:)]) {
                
            }
        }
    }];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset {
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

@end
