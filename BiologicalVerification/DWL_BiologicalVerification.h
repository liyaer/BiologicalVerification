//
//  BiologicalVerifivation.h
//  BiologicalVerification
//
//  Created by DuBenben on 2021/3/18.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


符合场景的使用方式：can 选1，start可选1或2
//生物验证使用何种策略
typedef NS_ENUM(NSInteger, WLPolicy) {
    WLPolicyDeviceOwnerAuthenticationWithBiometrics, //LAPolicyDeviceOwnerAuthenticationWithBiometrics策略
    WLPolicyDeviceOwnerAuthentication, //LAPolicyDeviceOwnerAuthentication策略
};

//设备支持的生物验证类型
typedef NS_ENUM(NSInteger, WLBiologicalVerificationType) {
    WLBiologicalVerificationNone,
    WLBiologicalVerificationTouchID,
    WLBiologicalVerificationFaceID
};


@protocol WLBiologicalVerificationDelegate <NSObject>

@optional
- (void)biologicalVerificationSuccessWithType:(WLBiologicalVerificationType)type;
- (void)biologicalVerificationFailureWithType:(WLBiologicalVerificationType)type errorString:(NSString *)errorString;
- (void)biologicalVerificationUserCancelWithType:(WLBiologicalVerificationType)type errorString:(NSString *)errorString;
- (void)biologicalVerificationUserFallbackWithType:(WLBiologicalVerificationType)type errorString:(NSString *)errorString;
- (void)biologicalVerificationSystemCancelWithType:(WLBiologicalVerificationType)type errorString:(NSString *)errorString;
- (void)biologicalVerificationPasscodeNotSetWithType:(WLBiologicalVerificationType)type errorString:(NSString *)errorString;
- (void)biologicalVerificationNotAvailableWithType:(WLBiologicalVerificationType)type errorString:(NSString *)errorString;
- (void)biologicalVerificationNotEnrolledWithType:(WLBiologicalVerificationType)type errorString:(NSString *)errorString;
- (void)biologicalVerificationLockoutWithType:(WLBiologicalVerificationType)type errorString:(NSString *)errorString;
- (void)biologicalVerificationNotSupportWithType:(WLBiologicalVerificationType)type errorString:(NSString *)errorString;

@end


@interface DWL_BiologicalVerification : NSObject

+ (instancetype)verificationWithPolicy:(WLPolicy)policy;

//检查支持何种类型的生物验证
- (WLBiologicalVerificationType)canBiologicalVerificationWithDelegate:(nullable id<WLBiologicalVerificationDelegate>)delegate;

//开始进行生物验证
- (void)startBiologicalVerificationWithFallbackTitle:(nullable NSString *)fallbackTitle delegate:(id<WLBiologicalVerificationDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

/*
 
 *   记得在info.plist中添加 NSFaceIDUsageDescription 权限
 
 
 *   LAPolicyDeviceOwnerAuthenticationWithBiometrics：（iOS 8.0以后可用，只支持生物校验）
 
        何时授权失败：
            当设备不具有 Touch ID / Face Id 功能，或者在系统设置中没有开启生物校验功能
 
        取得授权后：
            前三次生物校验失败，生物校验框不再弹出
            再次进入验证，还有两次验证机会，如果都失败，Touch ID（Face ID）被锁定，生物校验框不再弹出
            以后的每次验证都会因为生物校验被锁定而失败，生物校验框不再弹出
 
            点击fallbackTitle可响应自定义的事件（意思是指会出现 LAErrorUserFallback 此种case）

 
 *   LAPolicyDeviceOwnerAuthentication：（iOS 9.0以后可用，支持生物校验与密码验证）
 
        何时授权失败：
            当设备数字密码没有设置、不可用的时候
            
        取得授权后：
            生物校验失败三次后，弹出密码验证页面
            如果不进行密码输入，再次进入验证，还可以有两次机会进行生物校验；如果都失败则生物校验被锁定，并且弹出密码验证页面
            如果不进行密码输入，以后每次进入验证都是密码验证页面（调用系统的数字密码页面，输入正确的设备密码即可验证成功）,直到密码验证通过
            总结：当生物校验可用且没有被锁定，会进入生物校验；否则会进入密码验证
     
            点击fallbackTitle不可响应自定义的事件（不会出现 LAErrorUserFallback 此种case），弹出系统的密码验证页面
 
 
 *   Do not call this method in the reply block of evaluatePolicy:reply: because it could lead to a deadlock.
    （不要在 evaluatePolicy:localizedReason:reply: 方法的reply中调用 canEvaluatePolicy:error: 方法，会导致死锁）
 
 */

