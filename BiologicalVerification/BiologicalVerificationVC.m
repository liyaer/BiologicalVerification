//
//  BiologicalVerificationVC.m
//  BiologicalVerification
//
//  Created by DuBenben on 2021/3/18.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import "BiologicalVerificationVC.h"


@interface BiologicalVerificationVC () <WLBiologicalVerificationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end


@implementation BiologicalVerificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //根据支持的验证类型，构造不同的UI界面
    if (_type == WLBiologicalVerificationTouchID) {
        [_btn setTitle:@"Touch ID verification" forState:UIControlStateNormal];
    } else if (_type == WLBiologicalVerificationFaceID) {
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

- (void)biologicalVerificationUserFallbackWithType:(WLBiologicalVerificationType)type {
    
    NSString *title;
    if (type == WLBiologicalVerificationTouchID) {
        title = @"Touch ID fallback clicked";
    } else if (type == WLBiologicalVerificationFaceID) {
        title = @"Face ID fallback clicked";
    } else {
        title = @"fallback clicked";
    }
    self.title = title;
}

- (void)biologicalVerificationFailureWithType:(WLBiologicalVerificationType)type {
    
    NSString *title;
    if (type == WLBiologicalVerificationTouchID) {
        title = @"Touch ID 认证连续三次失败";
    } else if (type == WLBiologicalVerificationFaceID) {
        title = @"Face ID 认证连续三次失败";
    } else {
        title = @"认证连续三次失败";
    }
    self.title = title;
}

- (void)biologicalVerificationLockoutWithType:(WLBiologicalVerificationType)type {
    
    NSString *title;
    if (type == WLBiologicalVerificationTouchID) {
        title = @"Touch ID Locked";
    } else if (type == WLBiologicalVerificationFaceID) {
        title = @"Face ID Locked";
    } else {
        title = @"Locked";
    }
    self.title = title;
}

@end
