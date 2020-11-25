//
//  VideoView.h
//  iOSMain
//
//  Created by shenjie on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "VideoProgressView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol VideoViewDelegate <NSObject>
@optional;
- (void)flipCameraClick;
- (void)sureClick;
- (void)cancelClick;
- (void)onCancelAction;
@end
@interface VideoView : UIView
@property (strong, nonatomic) UIImageView *bgView;
@property (strong, nonatomic) VideoProgressView *progressView;
//摄像头切换
@property (strong, nonatomic) UIButton *btnCamera;
@property (strong, nonatomic) UIImageView *imgRecord;
//确定
@property (strong, nonatomic) UIButton *btnEnsure;
//重新录制
@property (strong, nonatomic) UIButton *btnAfresh;
@property (strong, nonatomic) UIButton *btnBack;
@property (strong, nonatomic) UIImageView *focusCursor; //聚焦光标
@property (nonatomic, weak) id<VideoViewDelegate> delegate;
- (void)updateUI :(BOOL)flag;
@end

NS_ASSUME_NONNULL_END
