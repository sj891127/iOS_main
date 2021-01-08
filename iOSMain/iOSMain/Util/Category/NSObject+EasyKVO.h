//
//  NSObject+EasyKVO.h
//  iOSMain
//
//  Created by shenjie on 2021/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (EasyKVO)
- (void)observeProperty:(NSString*)keyPath changedBlock:(void(^)(id newValue, id oldValue))block;
@end

NS_ASSUME_NONNULL_END
