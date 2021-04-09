//
//  BiologicalVerifivation.m
//  BiologicalVerification
//
//  Created by DuBenben on 2021/3/18.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import "DWL_BiologicalVerification.h"
#import <LocalAuthentication/LocalAuthentication.h>


@interface DWL_BiologicalVerification ()

@property (nonatomic, weak) id<WLBiologicalVerificationDelegate> delegate;
@property (nonatomic, strong) LAContext *context;

@end


@implementation DWL_BiologicalVerification

+ (instancetype)verification {
    
    return [[self alloc] init];
}

- (WLBiologicalVerificationType)canBiologicalVerificationWithDelegate:(nullable id<WLBiologicalVerificationDelegate>)delegate {

    self.delegate = delegate;
    
    NSError *error;
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) { //当前机型是否支持生物验证
        if (@available(iOS 11.0, *)) { //iOS11以上，需要区分当前设备支持哪种类型的生物验证
            if (_context.biometryType == LABiometryTypeFaceID) {
                return WLBiologicalVerificationFaceID;
            } else if (_context.biometryType == LABiometryTypeTouchID) {
                return WLBiologicalVerificationTouchID;
            } else { //理论上不会出现该情况
                [self dealWithVerificationError:error type:WLBiologicalVerificationNone];
                return WLBiologicalVerificationNone;
            }
        } else { //iOS11以下，只支持 Touch ID 验证
            return WLBiologicalVerificationTouchID;
        }
    } else {
        [self dealWithVerificationError:error type:WLBiologicalVerificationNone];
        return WLBiologicalVerificationNone;
    }
}

- (void)startBiologicalVerificationWithReason:(nullable NSString *)reason fallbackTitle:(nullable NSString *)fallbackTitle delegate:(id<WLBiologicalVerificationDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSError *error;
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) { //当前机型是否支持生物验证
        if (@available(iOS 11.0, *)) { //iOS11以上，需要区分当前设备支持哪种类型的生物验证
            if (_context.biometryType == LABiometryTypeFaceID) {
                [self showVerificationWithReason:reason fallbackTitle:fallbackTitle type:WLBiologicalVerificationFaceID];
            } else if (_context.biometryType == LABiometryTypeTouchID) {
                [self showVerificationWithReason:reason fallbackTitle:fallbackTitle type:WLBiologicalVerificationTouchID];
            } else { //理论上不会出现该情况
                [self dealWithVerificationError:error type:WLBiologicalVerificationNone];
            }
        } else { //iOS11以下，只支持 Touch ID 验证
            [self showVerificationWithReason:reason fallbackTitle:fallbackTitle type:WLBiologicalVerificationTouchID];
        }
    } else {
        [self dealWithVerificationError:error type:WLBiologicalVerificationNone];
    }
}

- (void)showVerificationWithReason:(NSString *)reason fallbackTitle:(NSString *)fallbackTitle type:(WLBiologicalVerificationType)type {
    
    reason = reason ? : ((type == WLBiologicalVerificationFaceID) ? @"面容 ID+++++++" : @"Touch ID+++++++");
    
    _context.localizedFallbackTitle = fallbackTitle;
    
    [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationSuccessWithType:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate biologicalVerificationSuccessWithType:type];
                });
            }
        } else {
            [self dealWithVerificationError:error type:type];
        }
    }];
}

- (void)dealWithVerificationError:(NSError *)error type:(WLBiologicalVerificationType)type {
    
    switch (error.code) {
        case LAErrorAuthenticationFailed: { // 验证失败
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationFailureWithType:)]) {
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationFailureWithType:type];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationFailureWithType:type];
                    }];
                }
                
                if (type == WLBiologicalVerificationTouchID) {
                    NSLog(@"Touch ID验证失败");
                } else if (type == WLBiologicalVerificationFaceID) {
                    NSLog(@"Face ID验证失败");
                } else {
                    NSLog(@"生物验证失败"); 可以考虑用机型辅助判断支持那种类型;string也返回出去
                }
            }
        }
            break;
        case LAErrorUserCancel: {  // 用户取消验证
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationUserCancelWithType:)]) {
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationUserCancelWithType:type];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationUserCancelWithType:type];
                    }];
                }
                
                if (type == WLBiologicalVerificationTouchID) {
                    NSLog(@"用户取消Touch ID验证");
                } else if (type == WLBiologicalVerificationFaceID) {
                    NSLog(@"用户取消Face ID验证");
                } else {
                    NSLog(@"用户取消生物验证");
                }
            }
        }
            break;
        case LAErrorUserFallback: { // 用户选择输入密码
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationUserFallbackWithType:)]) {
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationUserFallbackWithType:type];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationUserFallbackWithType:type];
                    }];
                }
                
                if (type == WLBiologicalVerificationTouchID) {
                    NSLog(@"Touch ID验证过程中，用户选择输入密码");
                } else if (type == WLBiologicalVerificationFaceID) {
                    NSLog(@"Face ID验证过程中，用户选择输入密码");
                } else {
                    NSLog(@"生物验证过程中，用户选择输入密码");
                }
            }
        }
            break;
        case LAErrorSystemCancel: { // 系统取消验证，如其他APP切入
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationSystemCancelWithType:)]) {
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationSystemCancelWithType:type];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationSystemCancelWithType:type];
                    }];
                }
                
                if (type == WLBiologicalVerificationTouchID) {
                    NSLog(@"系统取消Touch ID验证");
                } else if (type == WLBiologicalVerificationFaceID) {
                    NSLog(@"系统取消Face ID验证");
                } else {
                    NSLog(@"系统取消生物验证");
                }
            }
        }
            break;
        case LAErrorPasscodeNotSet: { // 设备未设置密码
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationPasscodeNotSetWithType:)]) {
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationPasscodeNotSetWithType:type];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationPasscodeNotSetWithType:type];
                    }];
                }
                
                if (type == WLBiologicalVerificationTouchID) {
                    NSLog(@"Touch ID不可用，设备未设置密码");
                } else if (type == WLBiologicalVerificationFaceID) {
                    NSLog(@"Face ID不可用，设备未设置密码");
                } else {
                    NSLog(@"生物验证不可用，设备未设置密码");
                }
            }
        }
            break;
        case LAErrorTouchIDNotAvailable: { // 设备不支持生物验证
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationNotAvailableWithType:)]) {
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationNotAvailableWithType:type];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationNotAvailableWithType:type];
                    }];
                }
                
                if (type == WLBiologicalVerificationTouchID) {
                    NSLog(@"设备不支持Touch ID");
                } else if (type == WLBiologicalVerificationFaceID) {
                    NSLog(@"设备不支持Face ID");
                } else {
                    NSLog(@"设备不支持生物验证");
                }
            }
        }
            break;
        case LAErrorTouchIDNotEnrolled: { // 设备未录入生物信息
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationNotEnrolledWithType:)]) {
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationNotEnrolledWithType:type];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationNotEnrolledWithType:type];
                    }];
                }
                
                if (type == WLBiologicalVerificationTouchID) {
                    NSLog(@"设备未录入Touch ID");
                } else if (type == WLBiologicalVerificationFaceID) {
                    NSLog(@"设备未录入Face ID");
                } else {
                    NSLog(@"设备未录入生物信息");
                }
            }
        }
            break;
        case LAErrorTouchIDLockout: { // 验证失败次数超过最大限制，生物验证被锁定，需要用户输入设备密码来解锁
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationLockoutWithType:)]) {
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationLockoutWithType:type];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationLockoutWithType:type];
                    }];
                }
                
                if (type == WLBiologicalVerificationTouchID) {
                    NSLog(@"验证失败次数达到最大限制，Touch ID被锁定，需要用户输入设备密码来解锁");
                } else if (type == WLBiologicalVerificationFaceID) {
                    NSLog(@"验证失败次数达到最大限制，Face ID被锁定，需要用户输入设备密码来解锁");
                } else {
                    NSLog(@"验证失败次数达到最大限制，生物验证被锁定，需要用户输入设备密码来解锁");
                }
            }
        }
            break;
        default: { // 其他情况（未一一列举完，用到什么在列举吧，暂时都归纳成不支持验证这一case）
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationNotSupportWithType:)]) {
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationNotSupportWithType:type];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationNotSupportWithType:type];
                    }];
                }
                
                NSLog(@"其他情况（未一一列举完，用到什么在列举吧，暂时都归纳成不支持验证这一case）");
            }
        }
            break;
    }
}

#pragma mark - lazy load

- (LAContext *)context {
    
    if (!_context) {
        
        _context = [[LAContext alloc] init];
//        _context.localizedFallbackTitle = @"可自定义标题"; //设置@“”，不显示该选项；设置nil/不设置，该选项显示默认title
    }
    
    return _context;
}

@end
