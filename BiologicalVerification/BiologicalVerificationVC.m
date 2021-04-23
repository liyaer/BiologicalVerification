//
//  BiologicalVerificationVC.m
//  BiologicalVerification
//
//  Created by DuBenben on 2021/3/18.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import "BiologicalVerificationVC.h"
#import "DWL_BiologicalVerification.h"
#import "DWL_UserDefault.h"


@interface BiologicalVerificationVC () <WLBiologicalVerificationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end


@implementation BiologicalVerificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //根据支持的验证类型，构造不同的UI界面
    WLBiologicalVerificationType type = [DWL_UserDefault integerForKey:biologicalVerificationTagKey];
    if (type == WLBiologicalVerificationTouchID) {
        [_btn setTitle:@"Touch ID verification" forState:UIControlStateNormal];
    } else if (type == WLBiologicalVerificationFaceID) {
        [_btn setTitle:@"Face ID verification" forState:UIControlStateNormal];
    } else {
        [_btn setTitle:@"biological verification" forState:UIControlStateNormal];
    }
}

- (IBAction)startBiologicalVerification:(id)sender {
    
    //开始验证
    [[DWL_BiologicalVerification verification] startBiologicalVerificationWithReason:nil fallbackTitle:nil delegate:self];
}

#pragma mark - WLBiologicalVerifivationDelegate

- (void)biologicalVerificationSuccessWithType:(WLBiologicalVerificationType)type {
    
    if (type == WLBiologicalVerificationFaceID) {
        self.title = @"FaceID 通过";
    } else {
        self.title = @"TouchID 通过";
    }
}

- (void)biologicalVerificationFailureWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationUserCancelWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {

    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationUserFallbackWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationSystemCancelWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationPasscodeNotSetWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationNotAvailableWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationNotEnrolledWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationLockoutWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationNotSupportWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
}

@end
