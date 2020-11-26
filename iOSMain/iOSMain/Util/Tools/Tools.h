//
//  Tools.h
//  iOSMain
//
//  Created by shenjie on 2020/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject
SYNTHESIZE_ARC_SINGLETON_FOR_CLASS_HEADER(Tools)
// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string;
//生成纯色图片
+ (UIImage *)p_createImageWithColor:(UIColor *)color andSize:(CGSize)size;
//纯色图片加圆角
+ (UIImage *)p_generateCornerRadiusImage:(UIImage *)original cornerRadius:(CGFloat)cornerRadius;
//时间转换
+ (NSString*)mkTransTimeStampToTime:(long)timeStamp type:(int)timeType;
//秒数转分秒
+ (NSString *)timeFormatted:(int)totalSeconds;
//设置圆角
+(CAShapeLayer *)setCorner :(CGRect)object :(UIRectCorner)corners :(CGFloat)num;
+ (NSString*)dictionaryToJson:(NSMutableDictionary *)dic;
//计算年龄
+ (NSString *)calAge :(NSString *)birth1;
//左右抖动
+ (void)shakeView:(UIView*)viewToShake;
//计算缓存大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;
//清除缓存
+ (BOOL)clearCacheWithFilePath:(NSString *)path;
//获取手机型号
+ (NSString *)iphoneType;
//获取UUID
+ (NSString *)getUUID;
//获取时区
+(NSString *)getTimeZone;
//比较一个日期是在过去还是未来 A>B
+ (int)compareOneDay:(NSDate *)oneDay :(NSString *)format;
//获取周几
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;
//获取当前时间
+(NSString*)getCurrentTime :(NSString *)format;
//去重
+(NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array;
//判断字符串内是否包含中文
+(BOOL)isContainChinese:(NSString*)str;
//宽高等比例计算
+ (NSMutableArray *)calPicWidthHeight :(CGFloat)W :(CGFloat)H :(CGSize)size;
// 获取0点时间戳
+ (NSString *)fetchCurrentDayZeroTime;
//判断是否有耳机或蓝牙外接设备
+ (BOOL)isHeadsetPluggedIn;
//获取系统通知权限
+ (void)pushAuthority:(void (^)(BOOL))isOpenPushBlock;
//照相机权限
+ (NSString *)cameraAuthority;
//音频权限
+ (NSString *)audioAuthority;
//图库权限
+ (NSString *)photoAuthority;
//通讯录权限
+ (NSString *)addressAuthority;
//日历权限
+ (NSString *)calendarAuthority;
//日历提醒权限
+ (NSString *)remindAuthority;
//获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses;
//获取网络状态
+ (NSString *)getNetconnType;
//调整image角度
+ (UIImage *)imageWithRightOrientation:(UIImage *)aImage;
@end

NS_ASSUME_NONNULL_END
