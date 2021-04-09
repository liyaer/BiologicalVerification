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
- (void)biologicalVerificationFailureWithType:(WLBiologicalVerificationType)type;
- (void)biologicalVerificationUserCancelWithType:(WLBiologicalVerificationType)type;
- (void)biologicalVerificationUserFallbackWithType:(WLBiologicalVerificationType)type;
- (void)biologicalVerificationSystemCancelWithType:(WLBiologicalVerificationType)type;
- (void)biologicalVerificationPasscodeNotSetWithType:(WLBiologicalVerificationType)type;
- (void)biologicalVerificationNotAvailableWithType:(WLBiologicalVerificationType)type;
- (void)biologicalVerificationNotEnrolledWithType:(WLBiologicalVerificationType)type;
- (void)biologicalVerificationLockoutWithType:(WLBiologicalVerificationType)type;
- (void)biologicalVerificationNotSupportWithType:(WLBiologicalVerificationType)type;

@end


@interface DWL_BiologicalVerification : NSObject

+ (instancetype)verification;

//检查支持何种类型的生物验证
- (WLBiologicalVerificationType)canBiologicalVerificationWithDelegate:(nullable id<WLBiologicalVerificationDelegate>)delegate;

//开始进行生物验证
- (void)startBiologicalVerificationWithReason:(nullable NSString *)reason fallbackTitle:(nullable NSString *)fallbackTitle delegate:(id<WLBiologicalVerificationDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
