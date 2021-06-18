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
#import "SetVC.h"
#import "LoginVC.h"


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
        [_btn setTitle:@"不支持生物验证" forState:UIControlStateNormal];
    }
}

- (IBAction)startBiologicalVerification:(id)sender {
    
    //开始验证
    [[DWL_BiologicalVerification verificationWithPolicy:WLPolicyDeviceOwnerAuthenticationWithBiometrics] startBiologicalVerificationWithFallbackTitle:@"输入密码登录" delegate:self];
}

#pragma mark - WLBiologicalVerifivationDelegate

- (void)biologicalVerificationSuccessWithType:(WLBiologicalVerificationType)type {
        
    SetVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Set"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)biologicalVerificationFailureWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationUserCancelWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {

    NSLog(@"%@：%@", [self class], errorString);
}

- (void)biologicalVerificationUserFallbackWithType:(WLBiologicalVerificationType)type errorString:(nonnull NSString *)errorString {
    
    NSLog(@"%@：%@", [self class], errorString);
    
    [self gotoPasswordLogin];
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

#pragma mark - 选择密码登录页面

- (IBAction)passwordLogin:(id)sender {
    
    [self gotoPasswordLogin];
}

- (void)gotoPasswordLogin {
    
    LoginVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LG"];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
