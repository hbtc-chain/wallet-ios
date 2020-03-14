//
//  XYHUserInfoView.m
//  WanRenHui
//
//  Created by 徐义恒 on 2017/6/19.
//  Copyright © 2017年 gansbat. All rights reserved.
//

#import "XXUserHeaderView.h"

@interface XXUserHeaderView ()


/** 卡片 */
@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UIImageView *rightIconImageView;

/** uid */
@property (strong, nonatomic) XXLabel *UIDLabel;

/** 标签视图 */
@property (strong, nonatomic) UIView *markView;

/** 复制按钮 */
@property (strong, nonatomic) XXButton *coppButton;

/** <#mark#> */
@property (strong, nonatomic) NSMutableArray *buttonsArray;


@end

@implementation XXUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        self.backgroundColor = kViewBackgroundColor;
        [self addSubview:self.nikeLabel];
        [self addSubview:self.iconImageView];
        [self addSubview:self.UIDLabel];
        [self addSubview:self.markView];
        [self addSubview:self.coppButton];
        
        
        self.buttonsArray = [NSMutableArray array];
        NSMutableArray *imageNamesArray = [NSMutableArray array];
        NSMutableArray *namesArray = [NSMutableArray array];
  
        [imageNamesArray addObject:@"withdraw_0"];
        [namesArray addObject:LocalizedString(@"Deposit")];
        
        [imageNamesArray addObject:@"deposit_0"];
        [namesArray addObject:LocalizedString(@"Withdraw")];
        
//        if (KConfigure.isHaveOption || KConfigure.isHaveContract) {
//            [imageNamesArray addObject:@"transfer"];
//            [namesArray addObject:LocalizedString(@"TransferAssets")];
//        }
        CGFloat btnWidth = kScreen_Width / imageNamesArray.count;
        for (NSInteger i=0; i < imageNamesArray.count; i ++) {
            MJWeakSelf
            XXButton *itemButton = [XXButton buttonWithFrame:CGRectMake(btnWidth*i, 80, btnWidth, 104) block:^(UIButton *button) {
                [weakSelf buttonClick:button];
            }];
            itemButton.tag = i;
            [self.buttonsArray addObject:itemButton];
            [self addSubview:itemButton];
            
            UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake((itemButton.width - 48)/2.0, 16, 48, 48)];
            shadowView.backgroundColor = kViewBackgroundColor;
            shadowView.layer.cornerRadius = 24.0;
            shadowView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            shadowView.layer.shadowOpacity = 1;
//            shadowView.layer.shadowColor = (KUser.isNightType ? KRGBA(4,11.5,18,100) : kDark20).CGColor;
            shadowView.userInteractionEnabled = NO;
            [itemButton addSubview:shadowView];
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((shadowView.width - 24)/2.0, (shadowView.height - 24)/2.0, 24, 24)];
            iconImageView.image = [UIImage textImageName:imageNamesArray[i]];
            [shadowView addSubview:iconImageView];
            
            XXLabel *nameLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(shadowView.frame), itemButton.width, 32) text:namesArray[i] font:kFont14 textColor:kDark100 alignment:NSTextAlignmentCenter];
            [itemButton addSubview:nameLabel];
        }
    
        [self addSubview:self.rightIconImageView];
    }
    return self;
}

#pragma mark - 1. 按钮点击事件
- (void)buttonClick:(UIButton *)sender {
//    if (sender.tag == 0) {
//        if (KUser.isLogin) {
//            [XXDepositManager DepositWithBindPassword:^{
//                XXSearchCoinVC *vc = [[XXSearchCoinVC alloc] init];
//                vc.index = 0;
//                [self.viewController.navigationController pushViewController:vc animated:YES];
//            } failure:^{
//                [self alertSetPassword];
//            }];
//        } else {
//            MJWeakSelf
//            XXTabBarController *tabBarVC = (XXTabBarController *)KWindow.rootViewController;
//            [XXPush toLoginViewController:tabBarVC completeBlock:^{
//                XXSearchCoinVC *vc = [[XXSearchCoinVC alloc] init];
//                vc.index = 0;
//                [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
//            }];
//        }
//    } else if (sender.tag == 1) {
//        if (KUser.isLogin) {
//            XXSearchCoinVC *vc = [[XXSearchCoinVC alloc] init];
//            vc.index = 1;
//            [self.viewController.navigationController pushViewController:vc animated:YES];
//        } else {
//            MJWeakSelf
//            XXTabBarController *tabBarVC = (XXTabBarController *)KWindow.rootViewController;
//            [XXPush toLoginViewController:tabBarVC completeBlock:^{
//                XXSearchCoinVC *vc = [[XXSearchCoinVC alloc] init];
//                vc.index = 1;
//                [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
//            }];
//        }
//    } else {
//        if (KUser.isLogin) {
//            XXTransferAssetsVC *vc = [[XXTransferAssetsVC alloc] init];
//            if (KConfigure.isHaveContract) {
//                vc.indexType = 3;
//            }
//            [self.viewController.navigationController pushViewController:vc animated:YES];
//        } else {
//            MJWeakSelf
//            XXTabBarController *tabBarVC = (XXTabBarController *)KWindow.rootViewController;
//            [XXPush toLoginViewController:tabBarVC completeBlock:^{
//                XXTransferAssetsVC *vc = [[XXTransferAssetsVC alloc] init];
//                if (KConfigure.isHaveContract) {
//                    vc.indexType = 3;
//                }
//                [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
//            }];
//        }
//    }
}

- (void)alertSetPassword {
//    [XYHAlertView showAlertViewWithTitle:LocalizedString(@"LoginPasswordAlert") message:nil titlesArray:@[LocalizedString(@"QueDing")] andBlock:^(NSInteger index) {
//        if (index == 0) {
//            XXSettingPasswordVC *vc = [[XXSettingPasswordVC alloc] init];
//            [self.viewController.navigationController pushViewController:vc animated:YES];
//        }
//    }];
}

- (void)reloadMark:(NSArray *)marksArray {
    
//    [self.markView removeAllSubviews];
//
//    CGFloat left = 0;
//    for (NSInteger i=0; i < marksArray.count; i ++) {
//
//        NSDictionary *dict = marksArray[i];
//        NSString *textString = KString(dict[@"labelValue"]);
//        UIFont *labelFont = kFontBold10;
//        NSString *colorString = [dict[@"colorCode"] uppercaseString];
//        UIColor *labelColor = [UIColor colorWithHexString:colorString];
//        CGFloat labelWidth = [NSString widthWithText:textString font:labelFont] + 10;
//
//        if (left + labelWidth > self.markView.width) {
//            return;
//        }
//
//        XXLabel *markLabel = [XXLabel labelWithFrame:CGRectMake(left, 0, labelWidth, self.markView.height) text:textString font:labelFont textColor:labelColor alignment:NSTextAlignmentCenter];
//        markLabel.layer.cornerRadius = 3;
//        markLabel.layer.borderColor = labelColor.CGColor;
//        markLabel.layer.borderWidth = 1;
//        markLabel.layer.masksToBounds = YES;
//        [self.markView addSubview:markLabel];
//        left += (labelWidth + 8);
//    }
    
}

#pragma mark - || 懒加载

/** 头像 */
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(24), 8, 48, 48)];
//        _iconImageView.image = [UIImage imageNamed:KConfigure.isBHEX ? @"uerHeaser" : @"bhop_header"];
    }
    return _iconImageView;
}

/** 昵称 */
- (XXLabel *)nikeLabel {
    if (_nikeLabel == nil) {
        _nikeLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 8,  8, kScreen_Width - (CGRectGetMaxX(self.iconImageView.frame) + 18), 32) font:kFontBold24 textColor:kDark100];
    }
    return _nikeLabel;
}

/** uid */
- (XXLabel *)UIDLabel {
    if (_UIDLabel == nil) {
        _UIDLabel = [XXLabel labelWithFrame:CGRectMake(self.nikeLabel.left,  _nikeLabel.bottom, _nikeLabel.width, 16) font:kFont12 textColor:kDark50];
    }
    return _UIDLabel;
}

/** 标签 */
- (UIView *)markView {
    if (_markView == nil) {
        _markView = [[UIView alloc] initWithFrame:CGRectMake(self.nikeLabel.left, self.UIDLabel.bottom + 6, kScreen_Width - self.nikeLabel.left - KSpacing, 18)];
//        _markView.backgroundColor = kRed80;
    }
    return _markView;
}

/** 复制按钮 */
- (XXButton *)coppButton {
    if (_coppButton == nil) {
//        _coppButton = [XXButton buttonWithFrame:CGRectMake(0, self.UIDLabel.top - 12, 40, 40) block:^(UIButton *button) {
//            if (KUser.userId.length > 0 && KUser.isLogin) {
//                UIPasteboard *pab = [UIPasteboard generalPasteboard];
//                [pab setString:KUser.userId];
//                [MBProgressHUD showSuccessMessage:LocalizedString(@"CopySuccessfully")];
//            }
//        }];
//        [_coppButton setImage:[UIImage textImageName:@"paste"] forState:UIControlStateNormal];
//        _coppButton.hidden = YES;
    }
    return _coppButton;
}

- (UIImageView *)rightIconImageView {
    if (_rightIconImageView == nil) {
        _rightIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - K375(36), kNavHeight + 38, 8, 13)];
        _rightIconImageView.image = [UIImage subTextImageName:@"me_arrow"];
        _rightIconImageView.centerY = self.iconImageView.centerY;
    }
    return _rightIconImageView;
}

@end
