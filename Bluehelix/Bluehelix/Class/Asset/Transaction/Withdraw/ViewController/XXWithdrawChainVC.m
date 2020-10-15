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

@interface XXWithdrawChainVC ()

/** 跨链地址视图 */
@property (strong, nonatomic) XXWithdrawChainView *chainView;

/** 提币按钮 */
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
    self.chainView.speedView.slider.maximumValue = [kSliderMaxFee floatValue];
    self.chainView.speedView.slider.minimumValue = [kSliderMinFee floatValue];
    self.chainView.speedView.slider.value = [kMinFee doubleValue];
    [self.view addSubview:self.withdrawButton];
}

- (void)withdrawButtonClick {
    if (self.chainView.feeView.textField.text.length <= 0) {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PleaseEnterFee") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
    MJWeakSelf
    [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
        [weakSelf requestWithdrawVerify:text];
    }];
}

- (void)requestWithdrawVerify:(NSString *)text {
    XXTokenModel *mainToken = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.chainView.feeView.textField.text];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(mainToken.decimals)] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:KUser.address amount:@"" denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:@"" feeDenom:kMainToken memo:@"" type:kMsgKeyGen withdrawal_fee:@"" text:text];
    _keyGenRequest = [[XXMsgRequest alloc] init];
    MJWeakSelf
    _keyGenRequest.msgSendSuccessBlock = ^{
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
        _chainView = [[XXWithdrawChainView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 90)];
        _chainView.feeView.textField.text = kMinFee;
        _chainView.speedView.nameLabel.text = LocalizedString(@"TransferSpeed");
    }
    return _chainView;
}

/** 提币按钮 */
- (XXButton *)withdrawButton {
    if (_withdrawButton == nil) {
        MJWeakSelf
        _withdrawButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 80, kScreen_Width - KSpacing*2, 42) title:LocalizedString(@"WithdrawChainAddress") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf withdrawButtonClick];
        }];
        _withdrawButton.backgroundColor = kPrimaryMain;
        _withdrawButton.layer.cornerRadius = kBtnBorderRadius;
        _withdrawButton.layer.masksToBounds = YES;
    }
    return _withdrawButton;
}

@end
