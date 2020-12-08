//
//  XXWithdrawChainVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXWithdrawChainVC.h"
#import "XXWithdrawChainView.h"
#import "XXMsg.h"
#import "XXTokenModel.h"
#import "XXPasswordView.h"
#import "XXMsgRequest.h"
#import "XXAssetSingleManager.h"

@interface XXWithdrawChainVC ()

/** 生成跨链地址视图 */
@property (strong, nonatomic) XXWithdrawChainView *chainView;

/** 生成跨链地址按钮 */
@property (strong, nonatomic) XXButton *withdrawButton;

/// 跨链地址生成 请求
@property (strong, nonatomic) XXMsgRequest *keyGenRequest;

@end

@implementation XXWithdrawChainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.titleLabel.text = LocalizedString(@"WithdrawChainAddress");
    [self.view addSubview:self.chainView];
    self.chainView.feeView.unitLabel.text = [kMainToken uppercaseString];
    [self.view addSubview:self.withdrawButton];
}

- (void)withdrawButtonClick {
    if (self.chainView.feeView.textField.text.length <= 0) {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PleaseEnterFee") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
    XXTokenModel *tokenModel = [[XXAssetSingleManager sharedManager] assetTokenBySymbol:kMainToken];
    if (tokenModel.amount.doubleValue < self.chainView.feeView.textField.text.doubleValue) {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
    if (kShowPassword) {
        [self requestWithdrawVerify:kText];
    } else {
        MJWeakSelf
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            [weakSelf requestWithdrawVerify:text];
        }];
    }
}

- (void)requestWithdrawVerify:(NSString *)text {
    NSString *feeAmount = [XXUserData sharedUserData].fee;
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:KUser.address amount:@"" denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:@"" feeDenom:kMainToken memo:@"" type:kMsgKeyGen withdrawal_fee:@"" text:text];
    _keyGenRequest = [[XXMsgRequest alloc] init];
    MJWeakSelf
    _keyGenRequest.msgSendSuccessBlock = ^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _keyGenRequest.msgSendFaildBlock = ^(NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
    };
    [_keyGenRequest sendMsg:model];
}

/** 提币视图 */
- (XXWithdrawChainView *)chainView {
    if (_chainView == nil) {
        _chainView = [[XXWithdrawChainView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, 108)];
        _chainView.feeView.textField.text = [XXUserData sharedUserData].showFee;
    }
    return _chainView;
}

/** 提币按钮 */
- (XXButton *)withdrawButton {
    if (_withdrawButton == nil) {
        MJWeakSelf
        _withdrawButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.chainView.frame) + 30, kScreen_Width - KSpacing*2, 48) title:LocalizedString(@"WithdrawChainAddress") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf withdrawButtonClick];
        }];
        _withdrawButton.backgroundColor = kPrimaryMain;
        _withdrawButton.layer.cornerRadius = kBtnBorderRadius;
        _withdrawButton.layer.masksToBounds = YES;
    }
    return _withdrawButton;
}

@end
