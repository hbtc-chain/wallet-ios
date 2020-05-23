//
//  XXUserNameView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/5/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXUserNameView : UIView

@property (nonatomic, copy) void (^sureBlock)(void);
+ (void)showWithSureBlock:(void (^)(void))sureBlock;

@end

NS_ASSUME_NONNULL_END
