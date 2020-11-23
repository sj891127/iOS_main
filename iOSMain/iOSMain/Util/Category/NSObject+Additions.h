//
//  NSObject+Additions.h
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#import <Foundation/Foundation.h>

static const char * _Nullable  input_keys = "input_keys";

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Additions)
+ (BOOL)swizzleMethod:(SEL)arg1 withMethod:(SEL)arg2;

+ (BOOL)registClass:(NSString *)clsName
         superClass:(Class)superCls;

- (void)addProperty:(NSString *)propertyName
               type:(Class)typeCls;
@end

NS_ASSUME_NONNULL_END
