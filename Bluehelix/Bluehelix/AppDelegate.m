//
//  AppDelegate.m
//  Bhex
//
//  Created by BHEX on 2018/6/10.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "AppDelegate.h"
#import "XXTabBarController.h"
#import "XXStartWalletVC.h"
#import "Account.h"
#import "SecureData.h"
#import "XXLoginVC.h"
#import "XXRepeatPasswordVC.h"
#import "AFNetworkReachabilityManager.h"
#import "XXVersionManager.h"
#import "SecurityHelper.h"
#import "XXSplashScreen.h"

@interface AppDelegate ()

/** 闪屏 */
@property (nonatomic, strong) XXSplashScreen *splashScreen;

@end

@implementation AppDelegate

#pragma mark - 1. 程序开始
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    KUser.shouldVerify = YES;
    [self AFNReachability];
    [[XXSqliteManager sharedSqlite] requestTokens];
    [[RatesManager shareRatesManager] loadDataOfRates];
    if (!KUser.isSettedNightType) {
        KUser.isNightType = KSystem.isDarkStyle;
    }
    [XXVersionManager checkVersion];
    KWindow.backgroundColor = [UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (KUser.address) {
        if (KUser.isFaceIDLockOpen || KUser.isTouchIDLockOpen) {
            self.window.rootViewController = [[XXTabBarController alloc] init];
        } else {
            XXLoginVC *loginVC = [[XXLoginVC alloc] init];
            XXNavigationController *loginNav = [[XXNavigationController alloc] initWithRootViewController:loginVC];
            self.window.rootViewController = loginNav;
        }
//        self.window.rootViewController = [[XXTabBarController alloc] init];
    } else {
        XXStartWalletVC *startVC = [[XXStartWalletVC alloc] init];
        XXNavigationController *startNav = [[XXNavigationController alloc] initWithRootViewController:startVC];
        self.window.rootViewController = startNav;
    }
    [self.window makeKeyAndVisible];
    [self.splashScreen showSplashScreen];
    return YES;
}

-(void)AFNReachability {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                KUser.netWorkStatus = @"unKnown";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                KUser.netWorkStatus = @"notReachable";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                KUser.netWorkStatus = @"WWAN";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetCome object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                KUser.netWorkStatus = @"WiFi";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetCome object:nil];
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

#pragma mark - 2. app从后台进入前台都会调用这个方法
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

#pragma mark - 3. app进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
}

#pragma mark - 4. 程序激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
}

#pragma mark - 5. 程序暂行
- (void)applicationWillResignActive:(UIApplication *)application {
    
    
}

#pragma mark - 6. 程序意外暂行
- (void)applicationWillTerminate:(UIApplication *)application {
    
    
}

- (XXSplashScreen *)splashScreen {
    if (!_splashScreen) {
        _splashScreen = [[XXSplashScreen alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    }
    return _splashScreen;
}
@end
