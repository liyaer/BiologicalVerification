//
//  LoginVC.m
//  BiologicalVerification
//
//  Created by DuBenben on 2021/5/7.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import "LoginVC.h"
#import "SetVC.h"


@interface LoginVC ()

@end


@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginAction:(id)sender {
    
    SetVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Set"];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
