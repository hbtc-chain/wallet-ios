//
//  XXSplashScreen.h
//  Bhex
//
//  Created by Bhex on 2019/11/17.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXSplashScreen : UIView

- (void)showSplashScreen;

/** <#备注#> */
@property (strong, nonatomic, nullable) void(^dismissBlock)(void);
@end

NS_ASSUME_NONNULL_END
