//
//  XXMainChainHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/10/2.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMainChainHeaderView.h"
#import "XXChainAddressView.h"
#import "XXAssetSingleManager.h"
#import "XXWithdrawChainVC.h"
#import "XXTokenModel.h"

@interface XXMainChainHeaderView ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) XXLabel *chainNameLabel;
@property (strong, nonatomic) XXLabel *testLabel;
//@property (strong, nonatomic) XXLabel *titleAddressLabel;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) XXButton *copyButton;
@property (strong, nonatomic) XXButton *codeBtn;
@property (strong, nonatomic) XXButton *getTestCoinBtn;

@end

@implementation XXMainChainHeaderView

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
    [self addSubview:self.backView];
    [self.backView addSubview:self.chainNameLabel];
    [self.backView addSubview:self.testLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.copyButton];
    [self.backView addSubview:self.codeBtn];
    [self.backView addSubview:self.getTestCoinBtn];
}

- (void)requestGetTestCoin:(NSString *)denom {
    NSString *path = [NSString stringWithFormat:@"%@%@%@%@",@"/api/v1/cus/",KUser.address,@"/send_test_token?denom=",denom];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
           Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"GetTestCoinSuccess") duration:kAlertDuration completion:^{
           }];
           [alert showAlert];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, kScreen_Width - 32, self.height)];
        _backView.layer.cornerRadius = 10;
        _backView.backgroundColor = kPrimaryMain;
    }
    return _backView;
}

- (XXLabel *)chainNameLabel {
    if (!_chainNameLabel) {
        _chainNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), 16, 45, 42) font:kFont20 textColor:[UIColor whiteColor]];
        _chainNameLabel.text = [kMainToken uppercaseString];
    }
    return _chainNameLabel;
}

- (XXLabel *)testLabel {
    if (!_testLabel) {
        _testLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.chainNameLabel.frame), 22, 80, 32) font:kFont13 textColor:[UIColor whiteColor]];
        _testLabel.text = @"(Testnet)";
    }
    return _testLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:[NSString addressShortReplace:KUser.address] font:kFont13];
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.chainNameLabel.frame) + 6, width, 24) font:kFont13 textColor:[UIColor whiteColor]];
        _addressLabel.text = [NSString addressShortReplace:KUser.address];
    }
    return _addressLabel;
}

- (XXButton *)copyButton {
    if (_copyButton == nil) {
        _copyButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame) + 10, self.addressLabel.top, 24, 24) block:^(UIButton *button) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:KUser.address];
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }];
        [_copyButton setImage:[UIImage imageNamed:@"copyCircle"] forState:UIControlStateNormal];
    }
    return _copyButton;
}

- (XXButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.copyButton.frame) + 10, self.addressLabel.top, 24, 24) block:^(UIButton *button) {
            [XXChainAddressView showMainAccountAddress];
        }];
        [_codeBtn setImage:[UIImage imageNamed:@"codeCircle"] forState:UIControlStateNormal];
    }
    return _codeBtn;
}

- (XXButton *)getTestCoinBtn {
    if (!_getTestCoinBtn) {
        MJWeakSelf
        CGFloat width = [NSString widthWithText:LocalizedString(@"GetTestCoin") font:kFont12] + 8;
        CGFloat top = self.addressLabel.top;
        CGFloat left = CGRectGetMaxX(self.codeBtn.frame) + 16;
        if (width + CGRectGetMaxX(self.codeBtn.frame) + 32 > self.backView.width) {
            top = self.testLabel.top + 3;
            left = CGRectGetMaxX(self.testLabel.frame);
        }
        _getTestCoinBtn = [XXButton buttonWithFrame:CGRectMake(left, top, width, 26) block:^(UIButton *button) {
            [weakSelf requestGetTestCoin:@"hbc"];
            [weakSelf requestGetTestCoin:@"kiwi"];
        }];
        _getTestCoinBtn.layer.cornerRadius = 13;
        [_getTestCoinBtn setTitle:LocalizedString(@"GetTestCoin") forState:UIControlStateNormal];
        _getTestCoinBtn.backgroundColor = [UIColor whiteColor];
        [_getTestCoinBtn setTitleColor:kPrimaryMain forState:UIControlStateNormal];
        _getTestCoinBtn.titleLabel.font = kFont12;
        [_getTestCoinBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    return _getTestCoinBtn;
}

@end
