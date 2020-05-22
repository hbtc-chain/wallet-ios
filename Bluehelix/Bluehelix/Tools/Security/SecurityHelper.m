//
//  SecurityHelper.m
//  Bhex
//
//  Created by Bhex on 2018/8/13.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "SecurityHelper.h"
#import "AppDelegate.h"
#import "XXTabBarController.h"
#import "XXNavigationController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "YZAuthID.h"
#import "BHFaceIDLockVC.h"
#import "XXLoginVC.h"
@interface SecurityHelper()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SecurityHelper
static SecurityHelper *_sharedManager;
+ (SecurityHelper *)sharedSecurityHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[SecurityHelper alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        KUser.shouldVerify = NO;
    }
    return self;
}

/**
 跳转安全验证
 */
- (void)showSecurityVerify {
            [self faceIDVerify];
            return;
}

- (void)faceIDVerify {
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
    } else {
        if (@available(iOS 11.0, *)) {
            if (authError.code == LAErrorBiometryLockout) {

            } else if (authError.code == LAErrorBiometryNotAvailable) {
                [self pushLoginVC];
                return;
            } else {
                [self pushLoginVC];
                return;
            }
        }
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    XXTabBarController * tab = (XXTabBarController *)delegate.window.rootViewController;
    BHFaceIDLockVC *lockVC = [[BHFaceIDLockVC alloc] init];
    XXNavigationController *nav = [[XXNavigationController alloc] initWithRootViewController:lockVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [tab.selectedViewController presentViewController:nav animated:YES completion:nil];
}

- (void)pushLoginVC {
    XXLoginVC *loginVC = [[XXLoginVC alloc] init];
    XXNavigationController *loginNav = [[XXNavigationController alloc] initWithRootViewController:loginVC];
    KWindow.rootViewController = loginNav;
}

- (BOOL)supportFaceID {
    if ([BHUserDefaults boolForKey:@"BHSupportFaceID"]) {
        return YES;
    }
    if (@available(iOS 11.0, *)) {
        LAContext *context = [[LAContext alloc] init];
        [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
        BOOL support = (context.biometryType == LABiometryTypeFaceID);
        [BHUserDefaults setBool:support forKey:@"BHSupportFaceID"];
        return support;
    }
    return NO;
}

- (BOOL)supportTouchID {
    if ([BHUserDefaults boolForKey:@"BHSupportTouchID"]) {
        return YES;
    }
    LAContext* context = [[LAContext alloc] init];
    BOOL canEvaluate = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    if (canEvaluate && [self supportFaceID] == NO) {
        [BHUserDefaults setBool:YES forKey:@"BHSupportTouchID"];
        return YES;
    }
    return NO;
}

- (BOOL)supportBiometricAuth {
    LAContext* context = [[LAContext alloc] init];
    BOOL canEvaluate = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    return canEvaluate;
}

- (BOOL)biometricDataSame {
    LAContext* context = [[LAContext alloc] init];
    [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    NSData *biometricData = context.evaluatedPolicyDomainState;
    NSData *historyBiometricData = [BHUserDefaults objectForKey:@"BHBiometricData"];
    return [biometricData isEqual:historyBiometricData];
}

- (void)saveBiometricData {
    LAContext* context = [[LAContext alloc] init];
    [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    NSData *biometricData = context.evaluatedPolicyDomainState;
    [BHUserDefaults setObject:biometricData forKey:@"BHBiometricData"];
}

@end
