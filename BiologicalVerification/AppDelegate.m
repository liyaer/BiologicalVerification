//
//  AppDelegate.m
//  BiologicalVerification
//
//  Created by DuBenben on 2021/3/18.
//  Copyright © 2021 CNKI. All rights reserved.
//

#import "AppDelegate.h"
#import "DWL_UserDefault.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [self rootVC];
    [window makeKeyAndVisible];
    self.window = window;
    
    return YES;
}

- (UIViewController *)rootVC {
    
    NSString *vcIdentifier;
    if ([DWL_UserDefault integerForKey:biologicalVerificationTagKey]) {
        vcIdentifier = @"BV";
    } else {
        vcIdentifier = @"LG";
    }
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcIdentifier];
    return vc;
}

@end
