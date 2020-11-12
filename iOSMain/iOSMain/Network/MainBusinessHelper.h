//
//  MainBusinessHelper.h
//  iOSMain
//
//  Created by shenjie on 2020/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainBusinessHelper : NSObject<BusinessHelper>
SYNTHESIZE_ARC_SINGLETON_FOR_CLASS_HEADER(MainBusinessHelper)
// 手机系统 0：IOS 1：Android
@property (nonatomic,assign) NSInteger  clientType;

// 设备，1.pad 2.phone
@property (nonatomic,assign) NSInteger  device;

// 应用来源 1.pad 2.phone 3.小程序
@property (nonatomic,assign) NSInteger  application;

// app版本号
@property (nonatomic, copy) NSString   * version;
@end

NS_ASSUME_NONNULL_END
