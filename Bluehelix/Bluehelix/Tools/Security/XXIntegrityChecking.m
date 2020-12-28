//
//  XXIntegrityChecking.m
//  Bhex
//
//  Created by 袁振 on 2019/11/11.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXIntegrityChecking.h"
#import "XYHAlertView.h"

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

static XXIntegrityChecking *_sharedManager = nil;
@implementation XXIntegrityChecking

+ (XXIntegrityChecking *)sharedIntegrityHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[XXIntegrityChecking alloc] init];
    });
    return _sharedManager;
}

- (void)jailBreak {
    BOOL isJailBreak = NO;
    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            isJailBreak = YES;
        }
    }
    if (!isJailBreak) {
        return;
    }
    [XYHAlertView showNoCancelAlertViewWithTitle:LocalizedString(@"Tip") message:LocalizedString(@"RootTip") titlesArray:@[LocalizedString(@"No"),LocalizedString(@"Yes")] andBlock:^(NSInteger index) {
        if (index == 0) {
            exit(0);
        }
    }];
}

+ (void)checkJailBreak {
    [self sharedIntegrityHelper];
    [_sharedManager jailBreak];
}

+ (void)checkVPN {
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSLog(@"\n%@",proxies);
    NSDictionary *settings = proxies[0];
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]) {
        NSLog(@"没设置代理");
    } else {
        [XYHAlertView showNoCancelAlertViewWithTitle:LocalizedString(@"Tip") message:LocalizedString(@"VPNTip") titlesArray:@[LocalizedString(@"No"),LocalizedString(@"Yes")] andBlock:^(NSInteger index) {
            if (index == 0) {
                exit(0);
            }
        }];
    }
}

@end
