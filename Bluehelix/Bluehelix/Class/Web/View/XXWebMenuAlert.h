//
//  XXWebMenuAlert.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXWebMenuAlert : UIView

@property (nonatomic, copy) void (^sureBlock)(void);
@property (nonatomic, copy) void (^cancelBlock)(void);

+ (void)showWithSureBlock:(void (^)(void))sureBlock;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
