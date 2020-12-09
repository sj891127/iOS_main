//
//  UserDefaults+Extened.m
//  iOSMain
//
//  Created by shenjie on 2020/12/1.
//

#import "UserDefaults+Extened.h"

@implementation UserDefaults (Extened)

- (void)writeToObject:(id)object forKey:(NSString *)key {
    if (object == nil) {
        return;
    } else {
        [self.defaults setObject:object forKey:key];
        [self.defaults synchronize];
    }
   
}

- (id)readFileForKey:(NSString *)key {
    id file = [self.defaults objectForKey:key];
    if (file) {
        return file;
    }
    return nil;
}


- (void)writeToInt:(NSInteger)number forKey:(NSString *)key {
    [self.defaults setInteger:number forKey:key];
    [self.defaults synchronize];
}

- (NSInteger)readNumber:(NSString *)key {
    NSInteger number = [self.defaults integerForKey:key];
    return number;
}



- (void)removeFileForKey:(NSString *)key {
    [self.defaults removeObjectForKey:key];
}

@end
