//
//  Tools.m
//  iOSMain
//
//  Created by shenjie on 2020/11/12.
//

#import "Tools.h"
#import <UserNotifications/UserNotifications.h>
#import <sys/utsname.h>
#import <CoreLocation/CLLocationManager.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation Tools
SYNTHESIZE_ARC_SINGLETON_FOR_CLASS(Tools)
#pragma clang diagnostic ignored "-Wdeprecated"

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([[NSString stringWithFormat:@"%@",string] isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

+ (UIImage *)p_createImageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)p_generateCornerRadiusImage:(UIImage *)original cornerRadius:(CGFloat)cornerRadius {
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0, 0.0, original.size.width, original.size.height);
    CGContextAddPath(ctx, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius].CGPath);
    CGContextClip(ctx);
    [original drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString*)mkTransTimeStampToTime:(long)timeStamp type:(int)timeType {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    formatter.weekdaySymbols = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    switch (timeType) {
        case 0:
            [formatter setDateFormat:@"MM-dd HH:mm"];
            break;
        case 1:
            [formatter setDateFormat:@"YY-MM-dd"];
            break;
        case 2:
            [formatter setDateFormat:@"MM月dd日"];
            break;
        case 3:
            [formatter setDateFormat:@"MM月dd日 HH:mm"];
            break;
        case 4:
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case 5:
            [formatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case 6:
            [formatter setDateFormat:@"dd"];
            break;
        case 7:
            [formatter setDateFormat:@"HH:mm"];
            break;
        case 8:
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            break;
        case 9:
            [formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
            break;
        case 10:
            [formatter setDateFormat:@"yyyy.MM.dd"];
            break;
        case 11:
            [formatter setDateFormat:@"yyyy年MM月d日"];
            break;
        case 12:
            [formatter setDateFormat:@"yyyy/MM/dd"];
            break;
        case 13:
            [formatter setDateFormat:@"M-d HH:mm:ss"];
            break;
        case 14:
            [formatter setDateFormat:@"M月dd日"];
            break;
        case 15:
            [formatter setDateFormat:@"M月d日 HH:mm"];
            break;
        case 16:
            [formatter setDateFormat:@"hh:mm:ss"];
            break;
        case 17:
            [formatter setDateFormat:@"MM.dd HH:mm"];
            break;
        case 18:
            [formatter setDateFormat:@"M月d日"];
            break;
        case 19:
            [formatter setDateFormat:@"yyyy年MM月"];
            break;
        case 20:
            [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
            break;
        case 21:
            [formatter setDateFormat:@"yyyy年MM月dd日 EEEE"];
            break;
        default:
            [formatter setDateFormat:@"MM-dd HH:mm"];
            break;
    }
    return [formatter stringFromDate:date];
}

+ (NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

+(CAShapeLayer *)setCorner :(CGRect)objectRect :(UIRectCorner)corners :(CGFloat)num{
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:objectRect byRoundingCorners:corners cornerRadii:CGSizeMake(num, num)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
    cornerRadiusLayer.frame = objectRect;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    return cornerRadiusLayer;
}

+ (NSString*)dictionaryToJson:(NSMutableDictionary *)dic{
    NSString *jsonStr;
    @try {
        if (dic!=nil) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options: NSJSONWritingPrettyPrinted error:&error];
            if (!jsonData) {
                NSLog(@"%@",error);
            }else{
                jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
        }
    } @catch (NSException *exception) {
        
    }
    return jsonStr;
}

+ (NSString *)calAge :(NSString *)birth1{
    if (birth1 != nil && birth1.integerValue == 0) {
        return @"0岁";
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nowDate = [NSDate date];
    NSString *birth = [Tools mkTransTimeStampToTime:[birth1 longLongValue] type:5];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
    NSInteger month = [date month];
    if (month == 0) {
        if ([date day] == 0) {
            month = 0;
        }else{
            month = 1;
        }
    }
    return [NSString stringWithFormat:(@"%ld岁%ld月"),(long)[date year],(long)month];
    //    if([date year] >0){
    //        if (![date month]) {
    //            return [NSString stringWithFormat:(@"%ld岁"),(long)[date year]];
    //        }else{
    //            return [NSString stringWithFormat:(@"%ld岁%ld月"),(long)[date year],(long)[date month]];
    //        }
    //    }else if([date month] >0){
    //        return [NSString stringWithFormat:(@"%ld月"),(long)[date month]];
    //    }else{
    //        return [NSString stringWithFormat:(@"%ld天"),(long)[date day]];
    //    }
}

+ (void)shakeView:(UIView*)viewToShake{
    CGFloat t =4.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

+ (NSString *)getCacheSizeWithFilePath:(NSString *)path{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray *subpathArray= [fileManager subpathsAtPath:path];
    NSString *filePath = nil;
    NSInteger totleSize=0;
    for (NSString *subpath in subpathArray){
        //拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subpath];
        //isDirectory，是否是文件夹，默认不是
        BOOL isDirectory = NO;
        //isExist，判断文件是否存在
        BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist || isDirectory || [filePath containsString:@".DS"]) continue;
        NSDictionary *dict=   [fileManager attributesOfItemAtPath:filePath error:nil];
        NSInteger size=[dict[@"NSFileSize"] integerValue];
        totleSize+=size;
    }
    //将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.1fMB",totleSize / 1000.0f /1000.0f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.1fKB",totleSize / 1000.0f ];
    }else if (totleSize > 0){
        totleStr = [NSString stringWithFormat:@"%.1fB",totleSize / 1.0f];
    }else{
        totleStr = @"0.0MB";
    }
    return totleStr;
}

+ (BOOL)clearCacheWithFilePath:(NSString *)path{
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr){
        filePath = [path stringByAppendingPathComponent:subPath];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"])   return @"Apple#iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])   return @"Apple#iPhone XS Max (China)";
    if ([platform isEqualToString:@"iPhone11,6"])   return @"Apple#iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"])   return @"Apple#iPhone XR";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod6,1"]) return @"iPod Touch 6G";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod Touch 7G";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air2";
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro(9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro(9.7-inch)";
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro(12.9-inch)";
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro(12.9-inch)";
    if ([platform isEqualToString:@"iPad6,11"]) return @"iPad 5G)";
    if ([platform isEqualToString:@"iPad6,12"]) return @"iPad 5G)";
    if ([platform isEqualToString:@"iPad7,1"]) return @"iPad Pro(12.9-inch,2G)";
    if ([platform isEqualToString:@"iPad7,2"]) return @"iPad Pro(12.9-inch,2G)";
    if ([platform isEqualToString:@"iPad7,3"]) return @"iPad Pro(10.5-inch)";
    if ([platform isEqualToString:@"iPad7,4"]) return @"iPad Pro(10.5-inch)";
    return platform;
}

+ (NSString *)getUUID{
    NSString *uuId = [NSUUID UUID].UUIDString;
    if (!uuId || [uuId isEqualToString:@""]) {
        uuId =  [[NSUserDefaults standardUserDefaults] objectForKey:@"uuId"];
    }
    return uuId;
}

+(NSString *)getTimeZone{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    CGFloat zoneNum = zone.secondsFromGMT / (60 * 60.0);
    if (zoneNum >= 0) {
        return [NSString stringWithFormat:@"+%.2f",zoneNum];
    }
    return [NSString stringWithFormat:@"%.2f",zoneNum];
}

+ (int)compareOneDay:(NSDate *)oneDay :(NSString *)format{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:currentDate];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {//下降a>b
        return 1;
    }else if (result == NSOrderedAscending){
        return -1;
    }else{
        return 0;
    }
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString*)getCurrentTime :(NSString *)format{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+(NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO){
            [categoryArray addObject:[array objectAtIndex:i]];
        }
    }
    return categoryArray;
}

+(BOOL)isContainChinese:(NSString*)str{
    BOOL flag=NO;
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if(a>0x4e00&&a<0x9fff){
            flag=YES;
            break;
        }
    }
    return flag;
}

+ (NSMutableArray *)calPicWidthHeight :(CGFloat)W :(CGFloat)H :(CGSize)size{
    if (W == H) {
        W = 390;
        H = 390;
    }else if(W > H){
        if (W >= 390) {
            W = 390;
            H = W / size.width * H;
        }else{
            if (H >= 390) {
                H = 390;
                W = H / size.height * W;
            }
        }
    }else{
        if (H >= 390) {
            H = 390;
            W = H / size.height * W;
        }else{
            if (W >= 390) {
                W = 390;
                H = W / size.width * H;
            }
        }
    }
    NSMutableArray *retArr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%lf",W],[NSString stringWithFormat:@"%lf",H], nil];
    return retArr;
}

+ (NSString *)fetchCurrentDayZeroTime{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger toGMTOffset = [[NSTimeZone localTimeZone] secondsFromGMTForDate:[NSDate date]];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:toGMTOffset]];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:0 toDate:startDate options:0];
    long long interval = (long long)[endDate timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%lld",interval];
    return timeStr;
}
+ (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        NSString *portType = [desc portType];
        if ([portType isEqualToString:AVAudioSessionPortHeadphones] || [portType isEqualToString:AVAudioSessionPortBluetoothHFP] || [portType isEqualToString:AVAudioSessionPortBluetoothA2DP] || [portType isEqualToString:AVAudioSessionPortBluetoothLE]){
            NSLog(@"蓝牙耳机");
            return YES;
        }
    }
    return NO;
}

+ (void)pushAuthority:(void (^)(BOOL))isOpenPushBlock {
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL isAllow = (settings.authorizationStatus == UNAuthorizationStatusAuthorized);
                isOpenPushBlock(isAllow);
            });
        }
         ];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
            BOOL isAllow = (settings.types != UIUserNotificationTypeNone);
            isOpenPushBlock(isAllow);
        });
    }
}

+ (NSString *)cameraAuthority{
    NSString *authority = @"0";
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            authority = @"0";//@"NotDetermined";
            break;
        case AVAuthorizationStatusRestricted:
            authority = @"0";//@"Restricted";
            break;
        case AVAuthorizationStatusDenied:
            authority = @"0";//@"Denied";
            break;
        case AVAuthorizationStatusAuthorized:
            authority = @"1";//@"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

+ (NSString *)audioAuthority{
    NSString *authority = @"0";
    NSString *mediaType = AVMediaTypeAudio;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            authority = @"0";//@"NotDetermined";
            break;
        case AVAuthorizationStatusRestricted:
            authority = @"0";//@"Restricted";
            break;
        case AVAuthorizationStatusDenied:
            authority = @"0";//@"Denied";
            break;
        case AVAuthorizationStatusAuthorized:
            authority = @"1";//@"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

+ (NSString *)photoAuthority{
    NSString *authority = @"";
   
    PHAuthorizationStatus current = [PHPhotoLibrary authorizationStatus];
    switch (current) {
        case PHAuthorizationStatusNotDetermined:    //用户还没有选择(第一次)
        {
            authority = @"NotDetermined";
        }
            break;
        case PHAuthorizationStatusRestricted:       //家长控制
        {
            authority = @"Restricted";
        }
            break;
        case PHAuthorizationStatusDenied:           //用户拒绝
        {
            authority = @"Denied";
        }
            break;
        case PHAuthorizationStatusAuthorized:       //已授权
        {
            authority = @"Authorized";
        }
            break;
        default:
            break;
    }
    return authority;
}

+ (NSString *)addressAuthority{
    NSString *authority = @"";
    if (@available(iOS 9.0, *)) {//iOS9.0之后
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (authStatus) {
            case CNAuthorizationStatusAuthorized:
                authority = @"Authorized";
                break;
            case CNAuthorizationStatusDenied:
            {
                authority = @"Denied";
            }
                break;
            case CNAuthorizationStatusNotDetermined:
            {
                authority = @"NotDetermined";
            }
                break;
            case CNAuthorizationStatusRestricted:
                authority = @"Restricted";
                break;
        }
    }else{//iOS9.0之前
        ABAuthorizationStatus authorStatus = ABAddressBookGetAuthorizationStatus();
        switch (authorStatus) {
            case kABAuthorizationStatusAuthorized:
                authority = @"Authorized";
                break;
            case kABAuthorizationStatusDenied:
            {
                authority = @"Denied";
            }
                break;
            case kABAuthorizationStatusNotDetermined:
            {
                authority = @"NotDetermined";
            }
                break;
            case kABAuthorizationStatusRestricted:
                authority = @"Restricted";
                break;
            default:
                break;
        }
    }
    return authority;
}

+ (NSString *)calendarAuthority{
    NSString *authority = @"";
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case EKAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case EKAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case EKAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case EKAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

+ (NSString *)remindAuthority{
    NSString *authority = @"";
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    switch (status) {
        case EKAuthorizationStatusNotDetermined:
            authority = @"NotDetermined";
            break;
        case EKAuthorizationStatusRestricted:
            authority = @"Restricted";
            break;
        case EKAuthorizationStatusDenied:
            authority = @"Denied";
            break;
        case EKAuthorizationStatusAuthorized:
            authority = @"Authorized";
            break;
        default:
            break;
    }
    return authority;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4{
    NSArray *searchArray = preferIPv4 ?
                            @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
                            @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;

    NSDictionary *addresses = [[self class] getIPAddresses];
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
        {
            address = addresses[key];
            if(address) *stop = YES;
        } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (NSString *)getNetconnType {
    NSString *netconnType = @"";
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.peilian.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {

            netconnType = @"no network";
        }
            break;

        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"wifi";
        }
            break;

        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];

            NSString *currentStatus = info.currentRadioAccessTechnology;

            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {

                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {

                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){

                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){

                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){

                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){

                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){

                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){

                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){

                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){

                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){

                netconnType = @"4G";
            }
        }
            break;

        default:
            break;
    }
    return netconnType;
}

@end
