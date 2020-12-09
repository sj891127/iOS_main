//
//  UserDefaults.m
//  iOSMain
//
//  Created by shenjie on 2020/12/1.
//

#import "UserDefaults.h"

@implementation UserDefaults

+ (instancetype)shareManger {
    static UserDefaults *userDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefaults = [[UserDefaults alloc]init];
        userDefaults.defaults = [NSUserDefaults standardUserDefaults];
    });
    return userDefaults;
}

@end
