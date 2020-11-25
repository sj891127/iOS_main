//
//  VideoViewController.h
//  iOSMain
//
//  Created by shenjie on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "VideoAVPlayer.h"
#import "VideoView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TakeOperationSureBlock)(id item);
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface VideoViewController : UIViewController<AVCaptureFileOutputRecordingDelegate,VideoViewDelegate>
@property (copy, nonatomic) TakeOperationSureBlock takeBlock;
@property (assign, nonatomic) NSInteger HSeconds;
@end

NS_ASSUME_NONNULL_END
