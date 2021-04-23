//
//  DWL_UserDefault.m
//  BiologicalVerification
//
//  Created by DuBenben on 2021/4/13.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import "DWL_UserDefault.h"

@implementation DWL_UserDefault

#pragma mark - 增、改、删

+ (void)setObject:(id)value forKey:(NSString *)defaultName {
    
    if (defaultName) { //key = nil, crash
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    }
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
    
    if (defaultName) {
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:defaultName];
    }
}

#pragma mark - 查

+ (nullable id)objectForKey:(NSString *)defaultName {
    
    if (defaultName) { //key = nil, crash
        return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
    }
    
    return nil;
}

+ (NSInteger)integerForKey:(NSString *)defaultName {
    
    if (defaultName) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
    }
    
    return -999;
}

#pragma mark - 删

+ (void)removeObjectForKey:(NSString *)defaultName {
    
    if (defaultName) { //key = nil, crash
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
    }
}

+ (void)removeAllExceptRetainKeys:(NSArray<NSString *> *)retainKeys {
    
    if (retainKeys.count) {
        //字典键值唯一，无须转集合类型去除重复元素
        NSArray *allKeys = [NSUserDefaults standardUserDefaults].dictionaryRepresentation.allKeys;
        NSMutableArray *allKeys_m = [allKeys mutableCopy];
        //转集合去重
        NSSet *retaionKeys_set = [NSSet setWithArray:retainKeys];
        //上面所有操作都为了这里尽可能减少循环次数
        for (NSString *key in retaionKeys_set) {
            if ([allKeys containsObject:key]) {
                [allKeys_m removeObject:key];
            }
        }
        //得到待删除的数组
        for (NSString *key in allKeys_m) {
            [self removeObjectForKey:key];
        }
        
        [self synchronize];
    } else {
        [self removeAll];
    }
}

+ (void)removeAll {
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];    
}

#pragma mark - 立即更新

+ (void)synchronize {
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
