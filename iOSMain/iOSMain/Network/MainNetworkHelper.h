//
//  MainNetworkHelper.h
//  iOSMain
//
//  Created by shenjie on 2020/11/12.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainNetworkHelper : NSObject<NetworkHelper>
SYNTHESIZE_ARC_SINGLETON_FOR_CLASS_HEADER(MainNetworkHelper)
@property (nonatomic, assign) Environment   env;

@property (nonatomic, assign, readonly) AFNetworkReachabilityStatus   status;

- (void)startUpdate;

- (void)stopUpdate;

- (NSString *)getStatusName;

@end

NS_ASSUME_NONNULL_END
