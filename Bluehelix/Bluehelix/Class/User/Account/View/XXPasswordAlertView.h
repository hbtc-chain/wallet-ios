//
//  XXPasswordAlertView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/1.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXPasswordAlertView : UIView

@property (nonatomic, copy) void (^sureBtnBlock)(void);

+ (void)showWithSureBtnBlock:(void (^)(void))sureBtnBlock;

@end

NS_ASSUME_NONNULL_END
