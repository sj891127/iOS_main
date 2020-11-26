//
//  ImagePickerManager.h
//  iOSMain
//
//  Created by shenjie on 2020/11/26.
//

#import <UIKit/UIKit.h>
#import <TZImagePickerController.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagePickerManager : UIImagePickerController
+ (__kindof UIImagePickerController * _Nullable)showCamera:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate> _Nullable)delegate
                                                completion:(void (^ __nullable)(void))completion;

+ (__kindof UIImagePickerController * _Nullable)showSystemPhotoLibrary:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>)delegate completion:(void (^ __nullable)(void))completion;

+ (__kindof TZImagePickerController * _Nullable)showPhotoLibrary:(id<TZImagePickerControllerDelegate> _Nullable)delegate
                                                  maxImagesCount:(NSUInteger)maxImagesCount
                                                     videoEnable:(BOOL)videoEnable
                                                       gifEnable:(BOOL)gifEnable
                                                      completion:(void (^ __nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
