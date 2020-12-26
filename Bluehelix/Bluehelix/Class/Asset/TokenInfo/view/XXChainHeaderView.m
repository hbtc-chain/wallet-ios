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
#import "XXTokenModel.h"
#import "XXAddNewAssetVC.h"
#import "XXAddressCodeView.h"
#import "XXPasswordView.h"
#import "XXWithdrawChainVC.h"
#import <UIImageView+WebCache.h>

@interface XXChainHeaderView ()

@property (nonatomic, strong) UIImageView *logoIcon;
@property (nonatomic, strong) XXLabel *chainNameLabel;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXButton *addTokenBtn; //添加币种
@property (nonatomic, strong) XXLabel *addressLabel; //链展示
@property (nonatomic, copy) NSString *chainAddress; //跨链地址

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
    [self addSubview:self.logoIcon];
    [self addSubview:self.chainNameLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.addTokenBtn];
}

- (void)setChain:(NSString *)chain {
    _chain = chain;
    if ([chain isEqualToString:kMainToken]) {
        self.chainNameLabel.text = [NSString stringWithFormat:@"HBTC %@",LocalizedString(@"DepositChainAddress")];
    } else {
        self.chainNameLabel.text = LocalizedString(@"WithdrawChainTitle");
    }
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:chain];
    [self.logoIcon sd_setImageWithURL:[NSURL URLWithString:token.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    self.chainAddress = [[XXAssetSingleManager sharedManager] externalAddressBySymbol:chain];
    [self setChainButtonTitle];
}

// 更新跨链地址展示
- (void)setChainButtonTitle {
    if (IsEmpty(self.chain) || [self.chain isEqualToString:kMainToken]) {
        CGFloat width = [NSString widthWithText:[NSString addressShortReplace:KUser.address] font:kFont12] + 20;
        self.addressLabel.frame = CGRectMake((self.width - width)/2, CGRectGetMaxY(self.chainNameLabel.frame) + 13, width, 24);
        self.addressLabel.text = [NSString addressShortReplace:KUser.address];
    } else {
        if (IsEmpty(self.chainAddress)) {
            CGFloat width = [NSString widthWithText:LocalizedString(@"CreateChainAddress") font:kFont12] + 20;
            self.addressLabel.frame = CGRectMake((self.width - width)/2, CGRectGetMaxY(self.chainNameLabel.frame) + 13, width, 24);
            self.addressLabel.text = LocalizedString(@"CreateChainAddress");
        } else {
            CGFloat width = [NSString widthWithText:[NSString addressShortReplace:KUser.address] font:kFont12] + 20;
            self.addressLabel.frame = CGRectMake((self.width - width)/2, CGRectGetMaxY(self.chainNameLabel.frame) + 13, width, 24);
            self.addressLabel.text = [NSString addressShortReplace:self.chainAddress];
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

- (UIImageView *)logoIcon {
    if (_logoIcon == nil) {
        _logoIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 48)/2, 0, 48, 48)];
    }
    return _logoIcon;
}

- (XXLabel *)chainNameLabel {
    if (!_chainNameLabel) {
        _chainNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.logoIcon.frame) + 16, self.width - K375(32), 24) font:kFont14 textColor:kGray700];
        _chainNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _chainNameLabel;
}

- (XXLabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[XXLabel alloc] initWithFrame:CGRectMake((self.width - 140)/2, CGRectGetMaxY(self.chainNameLabel.frame) + 13, 140, 24)];
        _addressLabel.font = kFont12;
        _addressLabel.textColor = kGray500;
        _addressLabel.backgroundColor = [kGray500 colorWithAlphaComponent:0.2];
        _addressLabel.layer.cornerRadius = 10;
        _addressLabel.layer.masksToBounds = YES;
        _addressLabel.userInteractionEnabled = YES;
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chainAction)];
        [_addressLabel addGestureRecognizer:tap];
    }
    return _addressLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressLabel.frame) + 24, self.width, 8)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

- (XXLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.lineView.frame) + 16, 100, 24) font:kFont14 textColor:kGray900];
        _titleLabel.text = LocalizedString(@"Token");
    }
    return _titleLabel;
}

- (XXButton *)addTokenBtn {
    if (!_addTokenBtn) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"AddToken") font:kFont13];
        _addTokenBtn = [XXButton buttonWithFrame:CGRectMake(self.width - 100, CGRectGetMaxY(self.lineView.frame) + 18, width + 40 , 20) title:LocalizedString(@"AddToken") font:kFont13 titleColor:kPrimaryMain block:^(UIButton *button) {
            XXAddNewAssetVC *addVC = [[XXAddNewAssetVC alloc] init];
            addVC.chain = self.chain;
            [self.viewController.navigationController pushViewController:addVC animated:YES];
        }];
        [_addTokenBtn setImage:[UIImage imageNamed:@"addTokenIcon"] forState:UIControlStateNormal];
        [_addTokenBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
        [_addTokenBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _addTokenBtn.backgroundColor = kGray100;
        _addTokenBtn.layer.cornerRadius = 10;
    }
    return _addTokenBtn;
}
@end
