//
//  XXChainHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/3.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainHeaderView.h"
#import "XXChainAddressView.h"
#import "XXAssetSingleManager.h"
#import "XXWithdrawChainVC.h"
#import "XXTokenModel.h"
#import "XXAddNewAssetVC.h"
#import "XXChainAddressView.h"
#import "XXWithdrawChainVC.h"

@interface XXChainHeaderView ()

@property (nonatomic, strong) UIView *topBackView;
@property (nonatomic, strong) UIView *bottomBackView;
@property (nonatomic, strong) XXLabel *chainNameLabel;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) XXButton *addTokenBtn; //添加币种
@property (nonatomic, copy) NSString *chainAddress; //跨链地址
@property (nonatomic, strong) XXButton *chainBtn; //链展示

@end

@implementation XXChainHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = kWhiteColor;
    [self addSubview:self.topBackView];
    [self addSubview:self.bottomBackView];
    [self.topBackView addSubview:self.chainNameLabel];
    [self.topBackView addSubview:self.chainBtn];
    [self.bottomBackView addSubview:self.titleLabel];
    [self.bottomBackView addSubview:self.addTokenBtn];
}

- (void)setChain:(NSString *)chain {
    _chain = chain;
    self.chainAddress = [[XXAssetSingleManager sharedManager] externalAddressBySymbol:chain];
    self.chainNameLabel.text = [chain uppercaseString];
    [self setChainButtonTitle];
}

// 更新跨链地址展示
- (void)setChainButtonTitle {
    if (IsEmpty(self.chain) || [self.chain isEqualToString:kMainToken]) {
        [self.chainBtn setTitle:[NSString addressShortReplace:KUser.address] forState:UIControlStateNormal];
    } else {
        if (IsEmpty(self.chainAddress)) {
            [self.chainBtn setTitle:LocalizedString(@"CreateChainAddress") forState:UIControlStateNormal];
        } else {
            [self.chainBtn setTitle:[NSString addressShortReplace:self.chainAddress] forState:UIControlStateNormal];
        }
    }
}

- (void)setChainAddress:(NSString *)chainAddress {
    _chainAddress = chainAddress;
}

- (void)chainAction {
    if (IsEmpty(self.chain) || [self.chain isEqualToString:kMainToken]) {
        [XXChainAddressView showMainAccountAddress];
    } else {
        if (IsEmpty(self.chainAddress)) {
            XXWithdrawChainVC *chain = [[XXWithdrawChainVC alloc] init];
            chain.tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.chain];
            [self.viewController.navigationController pushViewController:chain animated:YES];
        } else {
            [XXChainAddressView showWithChain:self.chain];
        }
    }
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), 0, self.width - K375(32), 72)];
        _topBackView.backgroundColor = kPrimaryMain;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_topBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _topBackView.bounds;
        maskLayer.path = maskPath.CGPath;
        _topBackView.layer.mask = maskLayer;
    }
    return _topBackView;
}

- (UIView *)bottomBackView {
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBackView.frame), self.width, 60)];
        _bottomBackView.backgroundColor = kWhite100;
    }
    return _bottomBackView;
}

- (XXLabel *)chainNameLabel {
    if (!_chainNameLabel) {
        _chainNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), 20, kScreen_Width, 24) font:kFont20 textColor:[UIColor whiteColor]];
    }
    return _chainNameLabel;
}

- (XXButton *)chainBtn {
    if (!_chainBtn) {
        MJWeakSelf
        _chainBtn = [XXButton buttonWithFrame:CGRectMake(self.topBackView.width - 160, 20, 140, 24) block:^(UIButton *button) {
            [weakSelf chainAction];
        }];
        [_chainBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _chainBtn.backgroundColor = [kGray900 colorWithAlphaComponent:0.2];
        _chainBtn.layer.cornerRadius = 10;
        [_chainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chainBtn.titleLabel setFont:kFont12];
        [self setChainButtonTitle];
    }
    return _chainBtn;
}

- (XXLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), 20, 100, 24) font:kFont14 textColor:kGray900];
        _titleLabel.text = @"Token";
    }
    return _titleLabel;
}

- (XXButton *)addTokenBtn {
    if (!_addTokenBtn) {
        _addTokenBtn = [XXButton buttonWithFrame:CGRectMake(self.bottomBackView.width - 100, 24, 60, 20) title:LocalizedString(@"AddToken") font:kFont13 titleColor:kPrimaryMain block:^(UIButton *button) {
            XXAddNewAssetVC *addVC = [[XXAddNewAssetVC alloc] init];
            addVC.chain = self.chain;
            [self.viewController.navigationController pushViewController:addVC animated:YES];
        }];
        [_addTokenBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _addTokenBtn.backgroundColor = kGray100;
        _addTokenBtn.layer.cornerRadius = 10;
    }
    return _addTokenBtn;
}
@end
