//
//  NSArray+safeArray.h
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///对数组越界进行保护
// 适用于 objectAtIndex 的保护 ,对 array[index] 无效
// runtime实现, 无需导入头文件

@interface NSArray (safeArray)

@end

NS_ASSUME_NONNULL_END
