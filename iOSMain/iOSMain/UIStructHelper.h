//
//  UIStructHelper.h
//  iOS_main
//
//  Created by shenjie on 2020/10/14.
//

#import <Foundation/Foundation.h>
#import "TestViewController.h"

typedef NS_ENUM(NSInteger, AiArtsTabType) {
    TabType_Home = 0,
};

#define AiArtsTabs          @[@"TestViewController"]

@interface UIStructHelper : NSObject
//SYNTHESIZE_ARC_SINGLETON_FOR_CLASS_HEADER(UIStructHelper)
@end
