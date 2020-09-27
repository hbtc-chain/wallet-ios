//
//  XXPayInfoView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXPayInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXPayInfoView : UIView

@property (nonatomic, copy) void (^sureBlock)(void);
@property (nonatomic, copy) void (^cancelBlock)(void);

+ (void)showWithSureBlock:(void (^)(void))sureBlock model:(XXPayInfoModel *)model;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
