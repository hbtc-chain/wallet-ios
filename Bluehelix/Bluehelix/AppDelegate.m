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

@implementation AppDelegate

#pragma mark - 1. 程序开始
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    if (!IsEmpty(KUser.localPhraseString)) { //通过助记词导入创建
//           account = [Account accountWithMnemonicPhrase:KUser.localPhraseString];
//       } else if (!IsEmpty(KUser.localPrivateKey)) { //通过私钥导入创建
//           SecureData * data = [SecureData secureDataWithHexString:KUser.localPrivateKey];
//           account = [Account accountWithPrivateKey:data.data];
//       } else {
//           account = [Account randomMnemonicAccount];
//       }
    
     SecureData * data = [SecureData secureDataWithHexString:@"abcde234234234234"];
     Account *account = [Account accountWithPrivateKey:data.data];
    
    KWindow.backgroundColor = [UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (KUser.rootAccount) {
        XXLoginVC *loginVC = [[XXLoginVC alloc] init];
        self.window.rootViewController = loginVC;
//        self.window.rootViewController = [[XXTabBarController alloc] init];
    } else {
        XXStartWalletVC *startVC = [[XXStartWalletVC alloc] init];
        XXNavigationController *startNav = [[XXNavigationController alloc] initWithRootViewController:startVC];
        self.window.rootViewController = startNav;
    }
    [self.window makeKeyAndVisible];
    return YES;
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
@end
