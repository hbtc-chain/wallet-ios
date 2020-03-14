//
//  AppDelegate+Category.h
//  Bhex
//
//  Created by Bhex on 2018/10/19.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Category)
- (BaseViewController *)TopVC;
+ (AppDelegate *)appDelegate;
@end

NS_ASSUME_NONNULL_END
