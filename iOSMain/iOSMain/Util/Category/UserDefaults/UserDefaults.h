//
//  UserDefaults.h
//  iOSMain
//
//  Created by shenjie on 2020/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaults : NSObject

+ (instancetype)shareManger;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

NS_ASSUME_NONNULL_END
