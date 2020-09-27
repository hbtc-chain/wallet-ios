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
#import "SecurityHelper.h"
#import "XXSplashScreen.h"
#import "BHFaceIDLockVC.h"
#import <WebKit/WebKit.h>
#import <Bugly/Bugly.h>
@interface AppDelegate ()

/** 闪屏 */
@property (nonatomic, strong) XXSplashScreen *splashScreen;
@property (strong, nonatomic, nullable) WKWebView *webView;

@end

@implementation AppDelegate

#pragma mark - 1. 程序开始
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Bugly startWithAppId:kBuglyID];
    [self registerWebViewUserAgent];
    KUser.shouldVerify = YES;
    [self AFNReachability];
    [[XXSqliteManager sharedSqlite] requestTokens];
//    [[RatesManager shareRatesManager] loadDataOfRates];
    if (!KUser.isSettedNightType) {
        KUser.isNightType = KSystem.isDarkStyle;
    }
    KWindow.backgroundColor = [UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[XXTabBarController alloc] init];
//    if (KUser.address) {
//        if (KUser.isFaceIDLockOpen || KUser.isTouchIDLockOpen) {
//            self.window.rootViewController = [[BHFaceIDLockVC alloc] init];
//        } else {
//            XXLoginVC *loginVC = [[XXLoginVC alloc] init];
//            XXNavigationController *loginNav = [[XXNavigationController alloc] initWithRootViewController:loginVC];
//            self.window.rootViewController = loginNav;
//        }
//    } else {
//        XXStartWalletVC *startVC = [[XXStartWalletVC alloc] init];
//        XXNavigationController *startNav = [[XXNavigationController alloc] initWithRootViewController:startVC];
//        self.window.rootViewController = startNav;
//    }
    [self.window makeKeyAndVisible];
    [self.splashScreen showSplashScreen];
    [KMarket readCachedDataOfMarket];
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
    [KSystem applicationActive];
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

- (void)registerWebViewUserAgent {
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable oldUserAgent, NSError * _Nullable error) {
        if (![oldUserAgent isKindOfClass:[NSString class]] || ((NSString *)oldUserAgent).length == 0) {
            oldUserAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 13_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148";
        }
        NSString *newAgent = [NSString stringWithFormat:@"hbtcchainwallet %@;",oldUserAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }];
}

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [WKWebView new];
    }
    return _webView;
}
@end
