//
//  ImagePickerImpl.h
//  iOSMain
//
//  Created by shenjie on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ImagePickerDelegate <NSObject>
@required
- (void)imageDidSelected:(NSString *)imageUrl;
@end
@interface ImagePickerImpl : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>
@property (nonatomic, weak) id<ImagePickerDelegate> delegate;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
