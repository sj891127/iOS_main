//
//  MainNetworkHelper.m
//  iOSMain
//
//  Created by shenjie on 2020/11/12.
//

#import "MainNetworkHelper.h"

@implementation MainNetworkHelper
SYNTHESIZE_ARC_SINGLETON_FOR_CLASS(MainNetworkHelper)
- (instancetype)init {
    if (self = [super init]) {
        self.env = EnvironmentDev;
    }
    return self;
}

- (AFNetworkReachabilityStatus)status {
    return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
}

- (NSString *)getStatusName {
    NSString *name = @"Unknow";
    switch ([self status]) {
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            name = @"WWAN";
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            name = @"WIFI";
        }
            break;
        default:
            break;
    }
    return name;
}

#pragma mark - Private
- (void)startUpdate {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)stopUpdate {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark - MKNetworkHelper
- (NSString *)getDomainByEnv:(Environment)env {
    NSString *reStr = nil;
    switch (env) {
        case EnvironmentDev:
            reStr = [NSString stringWithFormat:@"%@://%@/%@/%@/", SchemeHttp, Domain_Dev, Application, APIVersion];
            break;
        case EnvironmentPre: {
            
        }
            break;
        case EnvironmentOnline: {
            reStr = [NSString stringWithFormat:@"%@://%@/%@/%@/", SchemeHttp, Domain_Online, Application, APIVersion];
        }
            break;;
        default:
            break;
    }
    return reStr;
}
@end
