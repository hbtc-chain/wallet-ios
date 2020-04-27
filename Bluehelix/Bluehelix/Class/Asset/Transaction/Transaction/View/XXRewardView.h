//
//  XXRewardView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXRewardView : UIView

+ (void)showWithTitle:(NSString *)title icon:(NSString *)icon content:(NSString *)content sureBlock:(void (^)(void))sureBlock;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
