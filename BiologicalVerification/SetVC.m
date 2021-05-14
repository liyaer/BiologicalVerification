//
//  ViewController.m
//  BiologicalVerification
//
//  Created by DuBenben on 2021/3/18.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import "SetVC.h"
#import "DWL_BiologicalVerification.h"
#import "DWL_UserDefault.h"


@interface SetVC ()<WLBiologicalVerificationDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *bvEnable;

@end


@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([DWL_UserDefault integerForKey:biologicalVerificationTagKey] == WLBiologicalVerificationNone) {
        self.bvEnable.on = NO;
    } else {
        self.bvEnable.on = YES;
    }
}

- (IBAction)openBiologicalVerication:(UISwitch *)sender {
    
    //点击关闭
    if (!sender.isOn) {
        [DWL_UserDefault setInteger:WLBiologicalVerificationNone forKey:biologicalVerificationTagKey];
        return;
    }
    
    //点击开启
    WLBiologicalVerificationType type = [[DWL_BiologicalVerification verification] canBiologicalVerificationWithDelegate:self];
    if (type == WLBiologicalVerificationNone) {
        sender.on = NO;
        
        [DWL_UserDefault setInteger:WLBiologicalVerificationNone forKey:biologicalVerificationTagKey];

        NSLog(@"如果业务场景不需要区分到底是哪种错误类型，可以直接在这里写后续逻辑，此时可以对delegate参数传nil");
    } else {
        [DWL_UserDefault setInteger:type forKey:biologicalVerificationTagKey];
    }
}

#pragma mark - WLBiologicalVerifivationDelegate

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
