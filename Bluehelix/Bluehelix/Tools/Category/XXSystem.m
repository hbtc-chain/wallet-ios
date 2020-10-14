//
//  XXSystem.m
//  Bhex
//
//  Created by Bhex on 2019/10/21.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXSystem.h"
//#import "XYHVersion.h"

@interface XXSystem ()

@property (strong, nonatomic, nullable) NSString *checksum;

@end

@implementation XXSystem
singleton_implementation(XXSystem)

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 登录通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData) name:Login_In_NotificationName object:nil];
//
//        // 登出通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAppConfig) name:Login_Out_NotificationName object:nil];
    }
    return self;
}

#pragma mark - 0. 收到登录通知
- (void)reloadRequestData {
//    [self requestAppConfig];
}

#pragma mark - 1. 获取是否夜色模式
- (BOOL)isDarkStyle {
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (mode == UIUserInterfaceStyleDark) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

#pragma mark - 2. 状态栏设置为白色
- (void)statusBarSetUpWhiteColor {
    
    if (self.isDarkStyle) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

#pragma mark - 3. 状态栏设置为黑色
- (void)statusBarSetUpDarkColor {
    if (self.isDarkStyle) {
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            
        }
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark - 4. 状态栏设置为默认色
- (void)statusBarSetUpDefault {
    if (KUser.isNightType) {
        [self statusBarSetUpWhiteColor];
    } else {
        [self statusBarSetUpDarkColor];
    }
}

#pragma mark - 5. 程序退出
- (void)applicationDropOut {
    
    self.isActive = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillResignActiveKey" object:nil];
    
    // 1. 关闭行情长连接
    [KQuoteSocket closeWebSocket];
    
    // 2. 关闭用户组长连接
    [KUserSocket closeWebSocket];
    
    // 4. 取消汇率刷新任务
    [[RatesManager shareRatesManager] cancelTimer];
    
    [self cancelTimer];
}

#pragma mark - 6. 程序激活
- (void)applicationActive {
    
    KSystem.isActive = YES;
    KQuoteSocket.isFirstOpen = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActiveKey" object:nil];
    
    [self requestAllConfigAndOpenSocket];
}

#pragma mark - 7. 连接socket 和 加载数据
- (void)requestAllConfigAndOpenSocket {
    
    // 1. 打开行情长连接
//    [KQuoteSocket openWebSocket];
//
//    // 2. 判断是否登录打开用户长连接
//    [KUserSocket openWebSocket];

    // 3. 加载汇率数据
    [[RatesManager shareRatesManager] loadDataOfRates];
    
    // 4. 加载App-Config
//    [self requestAppConfig];
    
    // 5. 加载自选列表
//    [KMarket loadDataOfFavoriteSymbols];

}

#pragma mark - 8. 加载App-Config
- (void)requestAppConfig {
    
    if (!self.isActive) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestAppConfig) object:nil];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    UIDevice *device = [UIDevice currentDevice];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"all";
    param[@"moduleTypes"] = @"1,2,4";
    param[@"lightModel"] = KUser.isNightType ? @(2) : @(1);
    param[@"app_id"] = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    param[@"app_version"] = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    param[@"device_type"] = @"ios";
    param[@"device_version"] = [NSString stringWithFormat:@"iOS %@",device.systemVersion];
    if (!IsEmpty(self.checksum)) {
        param[@"checksum"] = self.checksum;
    }
    MJWeakSelf
    [HttpManager ms_GetWithPath:@"basic/app_config" params:param andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0 && IsDict(data)) {
            [weakSelf didReceiveAppConfigData:data];
            if (weakSelf.isActive) {
                [weakSelf performSelector:@selector(requestAppConfig) withObject:nil afterDelay:180];
            }
        } else if (weakSelf.isActive) {
            [weakSelf performSelector:@selector(requestAppConfig) withObject:nil afterDelay:3];
        }
    }];
}

#pragma mark - 9. 收到AppConfig数据
- (void)didReceiveAppConfigData:(NSDictionary *)data {
    
    // 1. 更新checksum 检查是否需要更新
    self.checksum = KString(data[@"checksum"]);
    if (![data[@"updated"] boolValue]) {
        return;
    }
    
    // 2. 币币、合约、期权、杠杆传递更新数据
    [KMarket didReceiveConfigData:data];
    
    // 3. 九宫格、底部tabbar、homeLogo】数据
   
}

#pragma mark - 11. 取消定时
- (void)cancelTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
@end
