//
//  TestViewController.h
//  iOS_main
//
//  Created by shenjie on 2020/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController : BasicViewController<TabViewControllerProtocol>
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end

NS_ASSUME_NONNULL_END
