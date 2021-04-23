//
//  DWL_UserDefault.h
//  BiologicalVerification
//
//  Created by DuBenben on 2021/4/13.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


//define keyString
static NSString *const biologicalVerificationTagKey = @"BiologicalVerificationTag";
static NSString *const testMethod_removeAllExceptRetainKeys = @"Test";


/*
    外界何时调用 +[... synchronize]
        1.在最后一次调用类似 +[... setObject: forKey:] 设置方法后
        2............ +[... removeObjectForKey:] 删除...
 */
@interface DWL_UserDefault : NSObject

#pragma mark - 增、改、删

+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName;

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;

//用到哪个方法可以再添加，这里写两个示例

#pragma mark - 查

+ (nullable id)objectForKey:(NSString *)defaultName;

+ (NSInteger)integerForKey:(NSString *)defaultName;

//用到哪个方法可以再添加，这里写两个示例

#pragma mark - 删

//单条删除
+ (void)removeObjectForKey:(NSString *)defaultName;//is equivalent to +[... setObject:nil forKey:defaultName]

//批量删除（包括全部删除）
+ (void)removeAllExceptRetainKeys:(NSArray<NSString *> *)retainKeys;

//全部删除（通过清除应用域的方式）
+ (void)removeAll;

#pragma mark - 立即更新

+ (void)synchronize;

@end

NS_ASSUME_NONNULL_END

/*
    NSUserDefaults 还有一个 Domain(域) 的概念，不同的域有不同的功能，有些域是可持久的，有些域则不行。
    当我们调用 NSUserDefaults.standardUserDefaults() 方法时，就会初始化 NSUserDefaults， 并且它默认会包含 5 个 Domain，分别是：

    NSArgumentDomain(参数域)：
        代表的是命令行参数，可以在 Edit Scheme->Arguments->Arguments Passed On Launch 中添加，格式是 -key value
    Application(应用域)：
        它存储着你App通过NSUserDefaults set…forKey添加的设置。
    NSGlobalDomain(全局域)：
        存储着系统的设置，所有应用程序都将公用该域
    Languages(语言域)：
        国际化语言版本域，包括地区、日期等
    NSRegistrationDomain(注册域)：
        临时域，- (void)registerDefaults:(NSDictionary*)registrationDictionary 方法被调用的数据是保存在这里

    当你读取一个键值的数据时，NSUserDefaults从上到下透过域的层级寻找正确的值，搜索顺序如下：
    NSArgumentDomain -> Application -> NSGlobalDomain -> Languages -> NSRegistrationDomain
 */
