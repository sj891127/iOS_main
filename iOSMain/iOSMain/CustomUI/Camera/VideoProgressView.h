//
//  VideoProgressView.h
//  iOSMain
//
//  Created by shenjie on 2020/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoProgressView : UIView
@property (assign, nonatomic) NSInteger timeMax;

- (void)clearProgress;
@end

NS_ASSUME_NONNULL_END
