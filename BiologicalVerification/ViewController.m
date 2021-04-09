//
//  ViewController.m
//  BiologicalVerification
//
//  Created by DuBenben on 2021/3/18.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import "ViewController.h"
#import "BiologicalVerificationVC.h"


@interface ViewController ()<WLBiologicalVerificationDelegate>

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)openBiologicalVerication:(UISwitch *)sender {
    
    //点击关闭
    if (!sender.isOn) {
        return;
    }
    
    //点击开启
    WLBiologicalVerificationType type = [[DWL_BiologicalVerification verification] canBiologicalVerificationWithDelegate:self];
    if (type == WLBiologicalVerificationNone) {
        sender.on = NO;

        NSLog(@"如果业务场景不需要区分到底是哪种错误类型，可以直接在这里写后续逻辑，此时可以对delegate参数传nil");
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BiologicalVerificationVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BV"];
            vc.type = type;
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
}

#pragma mark - WLBiologicalVerifivationDelegate

- (void)biologicalVerificationFailureWithType:(WLBiologicalVerificationType)type {
    NSLog(@"-------%ld", (long)type);
}

- (void)biologicalVerificationUserCancelWithType:(WLBiologicalVerificationType)type {
    NSLog(@"-------%ld", (long)type);
}

- (void)biologicalVerificationUserFallbackWithType:(WLBiologicalVerificationType)type {
    NSLog(@"-------%ld", (long)type);
}

- (void)biologicalVerificationSystemCancelWithType:(WLBiologicalVerificationType)type {
    NSLog(@"-------%ld", (long)type);
}

- (void)biologicalVerificationPasscodeNotSetWithType:(WLBiologicalVerificationType)type {
    NSLog(@"-------%ld", (long)type);
}

- (void)biologicalVerificationNotAvailableWithType:(WLBiologicalVerificationType)type {
    NSLog(@"-------%ld", (long)type);
}

- (void)biologicalVerificationNotEnrolledWithType:(WLBiologicalVerificationType)type {
    NSLog(@"-------%ld", (long)type);
}

- (void)biologicalVerificationLockoutWithType:(WLBiologicalVerificationType)type {
    NSLog(@"-------%ld", (long)type);
}

- (void)biologicalVerificationNotSupportWithType:(WLBiologicalVerificationType)type {
    NSLog(@"-------%ld", (long)type);
}

@end
