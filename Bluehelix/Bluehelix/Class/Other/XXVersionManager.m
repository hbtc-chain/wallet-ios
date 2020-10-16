//
//  XXVersionManager.m
//  Bluehelix
//
//  Created by BHEX on 2020/5/8.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXVersionManager.h"
#import "XXUpdateVersionView.h"

@implementation XXVersionManager

+ (void)checkVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    UIDevice *device = [UIDevice currentDevice];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"app_id"] = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    params[@"app_version"] = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    params[@"device_type"] = @"ios";
    params[@"device_version"] = [NSString stringWithFormat:@"iOS %@",device.systemVersion];
    
    [HttpManager getWithPath:@"/api/v1/app_version" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            BOOL needForceUpdate = [data[@"need_force_update"] boolValue];
            BOOL needUpdate = [data[@"need_update"] boolValue];
            NSString *downloadUrl = data[@"download_url"];
            NSString *content = KString(data[@"new_features"]);
            NSString *apkVersion = data[@"apk_version"];
            if (needForceUpdate) {
                [self needForceUpdateWithDownloadUrl:downloadUrl versionNum:apkVersion content:content];
            } else if (needUpdate) {
                [self needUpdateWithDownloadUrl:downloadUrl versionNum:apkVersion content:content];
            }
        }
    }];
}

+ (void)needForceUpdateWithDownloadUrl:(NSString *)downloadUrl versionNum:(NSString *)version content:(NSString *)content {
    [XXUpdateVersionView showWithUpdateVersionContent:content versionNum:version withSureBtnBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
    }];
}

+ (void)needUpdateWithDownloadUrl:(NSString *)downloadUrl versionNum:(NSString *)version content:(NSString *)content  {
    [XXUpdateVersionView showWithUpdateVersionContent:content versionNum:version withSureBtnBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
    } withCancelBtnBlock:^{
        
    }];
}

@end
