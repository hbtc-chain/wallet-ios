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
    self.titleLabel.text = LocalizedString(@"CreateCrossDepositAddress");
    [self.view addSubview:self.chainView];
    [self.view addSubview:self.withdrawButton];
    self.chainView.tipView.tipTextView.text = NSLocalizedFormatString(LocalizedString(@"CreateChainAddressTip"), kApp_Name);
    self.chainView.createFeeLabel.text = [NSString stringWithFormat:@"%@ %@",self.tokenModel.open_fee,[kMainToken uppercaseString]];
    self.chainView.feeLabel.text = [NSString stringWithFormat:@"%@ %@",[XXUserData sharedUserData].showFee,[kMainToken uppercaseString]];
}

- (void)withdrawButtonClick {
    XXTokenModel *tokenModel = [[XXAssetSingleManager sharedManager] assetTokenBySymbol:kMainToken];
    if (tokenModel.amount.doubleValue < [XXUserData sharedUserData].showFee.doubleValue) {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
    if (kShowPassword) {
        MJWeakSelf
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            [weakSelf requestWithdrawVerify:text];
        }];
    } else {
        [self requestWithdrawVerify:kText];
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
        _chainView = [[XXWithdrawChainView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, 400)];
    }
    return _chainView;
}

/** 提币按钮 */
- (XXButton *)withdrawButton {
    if (_withdrawButton == nil) {
        MJWeakSelf
        _withdrawButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, self.view.height - 80, kScreen_Width - KSpacing*2, 48) title:LocalizedString(@"CreateConfim") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf withdrawButtonClick];
        }];
        _withdrawButton.backgroundColor = kPrimaryMain;
        _withdrawButton.layer.cornerRadius = kBtnBorderRadius;
        _withdrawButton.layer.masksToBounds = YES;
    }
    return _withdrawButton;
}

@end
