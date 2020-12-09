//
//  UserDefaults+Extened.h
//  iOSMain
//
//  Created by shenjie on 2020/12/1.
//

#import "UserDefaults.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaults (Extened)
/**
 存入方法

 @param file 存储文件
 @param key key
 */
- (void)writeToObject:(id)object forKey:(NSString *)key;

/**
 读取方法
 
 @param key 获取文件Key
 @return 取得文件
 */
- (id)readFileForKey:(NSString *)key;

/**
 存入 Integer

 @param number number
 @param key key
 */
- (void)writeToInt:(NSInteger)number forKey:(NSString *)key;

/**
 获取 Integer

 @param key 取值Key
 @return 返回数值
 */
- (NSInteger)readNumber:(NSString *)key;

/**
 删除文件方法

 @param key 删除文件Key
 */
- (void)removeFileForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
