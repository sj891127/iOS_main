//
//  VideoAVPlayer.h
//  iOSMain
//
//  Created by shenjie on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoAVPlayer : UIView
@property (nonatomic,strong) AVPlayer *player;//播放器对象

- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView url:(NSURL *)url;
@property (copy, nonatomic) NSURL *videoUrl;
- (void)stopPlayer;

@end

NS_ASSUME_NONNULL_END
