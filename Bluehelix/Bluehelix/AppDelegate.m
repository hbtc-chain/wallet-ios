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


#import <BTCBase58.h>
#import <CommonCrypto/CommonDigest.h>

#import "Account.h"
#import "SecureData.h"
@implementation AppDelegate

#pragma mark - 1. 程序开始
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    KWindow.backgroundColor = [UIColor whiteColor];
    
    XXStartWalletVC *startVC = [[XXStartWalletVC alloc] init];
    XXNavigationController *startNav = [[XXNavigationController alloc] initWithRootViewController:startVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = startNav;
    //    self.window.rootViewController = [[XXTabBarController alloc] init];
    [self.window makeKeyAndVisible];
//    [self createAcount];
    return YES;
}

- (void)createAcount {
    Account *account = [Account randomMnemonicAccount];
    [account encryptSecretStorageJSON:@"xxxxxfffff" callback:^(NSString *json) {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        //地址
        NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
        //私钥
        NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
        //助记词account.mnemonicPhrase
        //助记keyStore 就是json字符串
        
        //        block(addressStr,json,account.mnemonicPhrase,privateKeyStr);
    }];
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
