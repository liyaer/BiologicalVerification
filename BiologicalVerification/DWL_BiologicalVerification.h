//
//  BiologicalVerifivation.h
//  BiologicalVerification
//
//  Created by DuBenben on 2021/3/18.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


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

////YES：只使用LAPolicyDeviceOwnerAuthenticationWithBiometrics策略
////NO：LAPolicyDeviceOwnerAuthenticationWithBiometrics（优先） + LAPolicyDeviceOwnerAuthentication策略
//@property (nonatomic, assign) BOOL onlyLAPolicyDeviceOwnerAuthenticationWithBiometrics;

+ (instancetype)verification;

//检查支持何种类型的生物验证
- (WLBiologicalVerificationType)canBiologicalVerificationWithDelegate:(nullable id<WLBiologicalVerificationDelegate>)delegate;

//开始进行生物验证
- (void)startBiologicalVerificationWithReason:(nullable NSString *)reason fallbackTitle:(nullable NSString *)fallbackTitle delegate:(id<WLBiologicalVerificationDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

/*
 
 *   记得在info.plist中添加 NSFaceIDUsageDescription 权限
 
 *   LAPolicyDeviceOwnerAuthenticationWithBiometrics：
        iOS8.0以上支持，只有生物校验功能
        生物校验授权使用，当设备不具有Touch ID / Face Id 功能，或者在系统设置中没有设置开启生物校验，授权将会失败。
        前三次生物校验失败，生物校验框不再弹出。再次重新进入验证，还有两次验证机会，如果还是验证失败，Touch ID（Face ID）被锁住不再继续弹出生物校验框。以后的每次验证都会因为生物验证被锁而失败

 *   LAPolicyDeviceOwnerAuthentication：
        iOS 9.0以上支持，包含生物校验与输入密码的验证方式
        生物校验和数字密码的授权使用，当生物校验可用且没有被锁定，授权后会进入生物校验。不然的话会进入数字密码验证的页面。当系统数字密码没有设置不可用的时候，授权失败。
        生物校验失败三次将弹出设备密码输入框，如果不进行密码输入。再次进来还可以有两次机会进行生物校验，如果都失败则Touch ID（Face ID）被锁住，以后每次进来验证都是调用系统的设备密码直至输入正确的设备密码才能重新使用生物校验
 
 *   Do not call this method in the reply block of evaluatePolicy:reply: because it could lead to a deadlock.
    （不要在 evaluatePolicy:localizedReason:reply: 方法的reply中调用 canEvaluatePolicy:error: 方法，会导致死锁）
 
 */
