//
//  MainBusinessHelper.m
//  iOSMain
//
//  Created by shenjie on 2020/11/12.
//

#import "MainBusinessHelper.h"

@interface MainBusinessHelper ()

@property (nonatomic, strong) NSMutableDictionary *headersDic;

@end
@implementation MainBusinessHelper
SYNTHESIZE_ARC_SINGLETON_FOR_CLASS(MainBusinessHelper)
- (void)setVersion:(NSString *)version{
    _version = version;
    [self.headersDic setValue:version?version:@"" forKey:@"version"];
}

- (void)setDevice:(NSInteger)device{
    _device = device;
    [self.headersDic setValue:[NSString stringWithFormat:@"%ld",(long)device] forKey:@"device"];
}

- (void)setClientType:(NSInteger)clientType{
    _clientType = clientType;
    [self.headersDic setValue:[NSString stringWithFormat:@"%ld",(long)clientType] forKey:@"clientType"];
}

- (void)setApplication:(NSInteger)application{
    _application = application;
    [self.headersDic setValue:[NSString stringWithFormat:@"%ld",(long)application] forKey:@"application"];
}

- (NSMutableDictionary *)headersDic {
    if (_headersDic==nil) {
        _headersDic = [NSMutableDictionary dictionary];
    }
    return _headersDic;;
}

- (NSDictionary *)getHeadersByInfo:(NSString *)info {
    return self.headersDic;
}

@end
