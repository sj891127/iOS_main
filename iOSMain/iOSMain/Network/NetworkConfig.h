//
//  NetworkConfig.h
//  iOSMain
//
//  Created by shenjie on 2020/11/12.
//

#ifndef NetworkConfig_h
#define NetworkConfig_h
#pragma mark - Domain
#pragma mark _________Scheme__________
#define SchemeHttp      @"http"
#define SchemeHttps     @"https"

#pragma mark __________Host__________ 
#define Domain_Dev      @"art-api-v1-dev.peilian.com"
#define Domain_Pre      @""
#define Domain_Online   @"art-api-v1.xiaozhupainting.com"

#pragma mark __________Other________
#define Application     @"art-api"
#define APIVersion      @"v1"

#pragma mark - Method
#pragma mark __________Login__________
// 启动配置参数
static NSString * login_version = @"login/version";

#endif /* NetworkConfig_h */
