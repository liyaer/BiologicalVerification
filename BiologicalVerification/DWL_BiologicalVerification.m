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
    
    NSError *error;
    
    //检查设备是否支持生物验证，使用组合策略（优先使用LAPolicyDeviceOwnerAuthenticationWithBiometrics策略）
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        return [self canBiologicalVerification];
    } else if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        return [self canBiologicalVerification];
    } else {
        self.delegate = delegate;
        [self dealWithVerificationError:error type:WLBiologicalVerificationNone];
        return WLBiologicalVerificationNone;
    }
}

- (void)startBiologicalVerificationWithReason:(nullable NSString *)reason fallbackTitle:(nullable NSString *)fallbackTitle delegate:(id<WLBiologicalVerificationDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSError *error;
    
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [self showVerificationWithReason:reason fallbackTitle:fallbackTitle type:[self canBiologicalVerification] policy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
    } else if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [self showVerificationWithReason:reason fallbackTitle:fallbackTitle type:[self canBiologicalVerification] policy:LAPolicyDeviceOwnerAuthentication];
    } else {
        [self dealWithVerificationError:error type:WLBiologicalVerificationNone];
    }
}

#pragma mark - 封装方法调用集合

//返回设备支持的生物验证类型（确定设备支持生物验证后，方可调用）
- (WLBiologicalVerificationType)canBiologicalVerification {
    
    if (@available(iOS 11.0, *)) { //iOS11以上，需要区分当前设备支持哪种类型的生物验证
        
        if (_context.biometryType == LABiometryTypeFaceID) {
            return WLBiologicalVerificationFaceID;
        } else if (_context.biometryType == LABiometryTypeTouchID) {
            return WLBiologicalVerificationTouchID;
        } else {
            //理论上不会出现该情况
//            [self dealWithVerificationError:error type:WLBiologicalVerificationNone];
            return WLBiologicalVerificationNone;
        }
    } else { //iOS11以下，只支持 Touch ID 验证
        
        return WLBiologicalVerificationTouchID;
    }
}

//进行生物验证（确定设备支持生物验证后，方可调用）
- (void)showVerificationWithReason:(NSString *)reason fallbackTitle:(NSString *)fallbackTitle type:(WLBiologicalVerificationType)type policy:(LAPolicy)policy {
    
    reason = reason ? : ((type == WLBiologicalVerificationFaceID) ? @"请将人脸对准屏幕进行验证" : @"通过Home键验证手机已有指纹");
    
    _context.localizedFallbackTitle = fallbackTitle;
    
    [_context evaluatePolicy:policy localizedReason:reason reply:^(BOOL success, NSError * _Nullable error) {
        
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

//错误处理
- (void)dealWithVerificationError:(NSError *)error type:(WLBiologicalVerificationType)type {
    
    switch (error.code) {
            
        case LAErrorAuthenticationFailed: { // 验证失败
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationFailureWithType:errorString:)]) {
                
                NSString *errorString;
                if (type == WLBiologicalVerificationTouchID) {
                    errorString = @"Touch ID 验证连续三次失败";
                } else if (type == WLBiologicalVerificationFaceID) {
                    errorString = @"Face ID 验证连续三次失败";
                } else {
                    errorString = @"生物验证连续三次失败";
                }
                
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationFailureWithType:type errorString:errorString];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationFailureWithType:type errorString:errorString];
                    }];
                }
            }
        }
            break;
            
        case LAErrorUserCancel: {  // 用户取消验证
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationUserCancelWithType:errorString:)]) {
                
                NSString *errorString;
                if (type == WLBiologicalVerificationTouchID) {
                    errorString = @"您已主动取消 Touch ID 的验证";
                } else if (type == WLBiologicalVerificationFaceID) {
                    errorString = @"您已主动取消 Face ID 的验证";
                } else {
                    errorString = @"您已主动取消生物验证";
                }
                
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationUserCancelWithType:type errorString:errorString];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationUserCancelWithType:type errorString:errorString];
                    }];
                }
            }
        }
            break;
            
        case LAErrorUserFallback: { // 用户选择输入密码
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationUserFallbackWithType:errorString:)]) {
                
                NSString *errorString;
                if (type == WLBiologicalVerificationTouchID) {
                    errorString = @"Touch ID 验证过程中，用户选择输入密码";
                } else if (type == WLBiologicalVerificationFaceID) {
                    errorString = @"Face ID 验证过程中，用户选择输入密码";
                } else {
                    errorString = @"生物验证过程中，用户选择输入密码";
                }
                
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationUserFallbackWithType:type errorString:errorString];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationUserFallbackWithType:type errorString:errorString];
                    }];
                }
            }
        }
            break;
            
        case LAErrorSystemCancel: { // 系统取消验证，如其他APP切入
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationSystemCancelWithType:errorString:)]) {
                
                NSString *errorString;
                if (type == WLBiologicalVerificationTouchID) {
                    errorString = @"系统取消 Touch ID 的验证";
                } else if (type == WLBiologicalVerificationFaceID) {
                    errorString = @"系统取消 Face ID 的验证";
                } else {
                    errorString = @"系统取消生物验证";
                }
                
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationSystemCancelWithType:type errorString:errorString];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationSystemCancelWithType:type errorString:errorString];
                    }];
                }
            }
        }
            break;
            
        case LAErrorPasscodeNotSet: { // 设备未设置密码
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationPasscodeNotSetWithType:errorString:)]) {
                
                NSString *errorString;
                if (type == WLBiologicalVerificationTouchID) {
                    errorString = @"Touch ID 不可用，设备未设置密码";
                } else if (type == WLBiologicalVerificationFaceID) {
                    errorString = @"Face ID 不可用，设备未设置密码";
                } else {
                    errorString = @"生物验证不可用，设备未设置密码";
                }
                
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationPasscodeNotSetWithType:type errorString:errorString];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationPasscodeNotSetWithType:type errorString:errorString];
                    }];
                }
            }
        }
            break;
            
        case LAErrorTouchIDNotAvailable: { // 设备不支持生物验证
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationNotAvailableWithType:errorString:)]) {
                
                NSString *errorString;
                if (type == WLBiologicalVerificationTouchID) {
                    errorString = @"设备不支持 Touch ID";
                } else if (type == WLBiologicalVerificationFaceID) {
                    errorString = @"设备不支持 Face ID";
                } else {
                    errorString = @"设备不支持生物验证";
                }
                
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationNotAvailableWithType:type errorString:errorString];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationNotAvailableWithType:type errorString:errorString];
                    }];
                }
            }
        }
            break;
            
        case LAErrorTouchIDNotEnrolled: { // 设备未录入生物信息
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationNotEnrolledWithType:errorString:)]) {
                
                NSString *errorString;
                if (type == WLBiologicalVerificationTouchID) {
                    errorString = @"设备未录入 Touch ID";
                } else if (type == WLBiologicalVerificationFaceID) {
                    errorString = @"设备未录入 Face ID";
                } else {
                    errorString = @"设备未录入生物信息";
                }
                
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationNotEnrolledWithType:type errorString:errorString];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationNotEnrolledWithType:type errorString:errorString];
                    }];
                }
            }
        }
            break;
            
        case LAErrorTouchIDLockout: { // 验证失败次数超过最大限制，生物验证被锁定，需要用户输入设备密码来解锁
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationLockoutWithType:errorString:)]) {
                
                NSString *errorString;
                if (type == WLBiologicalVerificationTouchID) {
                    errorString = @"验证失败次数达到最大限制，Touch ID 被锁定，需要用户输入设备密码来解锁";
                } else if (type == WLBiologicalVerificationFaceID) {
                    errorString = @"验证失败次数达到最大限制，Face ID 被锁定，需要用户输入设备密码来解锁";
                } else {
                    errorString = @"验证失败次数达到最大限制，生物验证被锁定，需要用户输入设备密码来解锁";
                }
                
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationLockoutWithType:type errorString:errorString];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationLockoutWithType:type errorString:errorString];
                    }];
                    
//                    if (_onlyLAPolicyDeviceOwnerAuthenticationWithBiometrics) {
//                        [self verificationLockedOprationWithReason:@"+++++" fallbackTitle:_context.localizedFallbackTitle type:type];
//                    }
                }
            }
        }
            break;
            
        default: { // 其他情况（未一一列举完，用到什么在列举吧，暂时都归纳成不支持验证这一case）
            if ([self.delegate respondsToSelector:@selector(biologicalVerificationNotSupportWithType:errorString:)]) {
                
                NSString *errorString = @"其他情况（未一一列举完，用到什么在列举吧，暂时都归纳成不支持验证这一case）";
                
                if ([NSThread isMainThread]) {
                    [self.delegate biologicalVerificationNotSupportWithType:type errorString:errorString];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate biologicalVerificationNotSupportWithType:type errorString:errorString];
                    }];
                }
            }
        }
            break;
    }
}

////当生物验证失败5次，生物验证被锁（LAErrorTouchIDLockout）时调用
//- (void)verificationLockedOprationWithReason:(NSString *)reason fallbackTitle:(NSString *)fallbackTitle type:(WLBiologicalVerificationType)type {
//    
//    [_context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"++++++" reply:^(BOOL success, NSError * _Nullable error) {
//
//        if (success) {
//            
//            [self showVerificationWithReason:reason fallbackTitle:fallbackTitle type:type policy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
//        } else {
//            
//            [self dealWithVerificationError:error type:type];
//        }
//    }];
//}

#pragma mark - lazy load

- (LAContext *)context {
    
    if (!_context) {
        
        _context = [[LAContext alloc] init];
//        _context.localizedFallbackTitle = @"可自定义标题"; //设置@“”，不显示该选项；设置nil/不设置，该选项显示默认title
    }
    
    return _context;
}

@end
