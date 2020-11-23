//
//  UIButton+button.h
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (button)
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

- (void)setEnlargeEdge:(CGFloat) size;

// 按钮垂直布局(上图下文)
- (void)vertiLayoutBottomTitleTopImageSpace:(CGFloat)space;

// 按钮水平布局(左文右图)
- (void)horLayoutLeftTitleRightImageSpace:(CGFloat)space;
@end

NS_ASSUME_NONNULL_END
