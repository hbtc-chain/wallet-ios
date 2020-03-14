//
//  AppDelegate+Category.m
//  Bhex
//
//  Created by Bhex on 2018/10/19.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "AppDelegate+Category.h"
#import "XXTabBarController.h"

@implementation AppDelegate (Category)

- (BaseViewController *)TopVC {
    XXTabBarController *tabBarVC = (XXTabBarController *)KWindow.rootViewController;
    UINavigationController *navigationController = tabBarVC.selectedViewController;
    BaseViewController *vc = (BaseViewController *)navigationController.visibleViewController;
    if ([vc isKindOfClass:[BaseViewController class]]) {
        return vc;
    } else if ([vc isKindOfClass:[UIAlertController class]]) {
        vc = (BaseViewController *)navigationController.topViewController;
        return vc;
    } else {
        return vc;
    }
}

+ (AppDelegate *)appDelegate {
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    return (AppDelegate*)delegate;
}

@end
