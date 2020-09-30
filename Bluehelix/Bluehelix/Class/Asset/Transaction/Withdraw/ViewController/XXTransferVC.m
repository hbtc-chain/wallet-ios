//
//  XXTransferVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferVC.h"
#import "XXWithdrawView.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXTokenModel.h"
#import "XXTransferView.h"
#import "XXPasswordView.h"
#import "XXAssetSingleManager.h"

@interface XXTransferVC ()

/** 提币视图 */
@property (strong, nonatomic) XXWithdrawView *withdrawView;

/// 转账视图
@property (strong, nonatomic) XXTransferView *transferView;

/** 提币按钮 */
@property (strong, nonatomic) XXButton *withdrawButton;

/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;

/// 跨链提币 对应的手续费token （假如提的币是tusdt，但是因为tusdt的链式eth，所以扣的手续费是eth，精度也是eth的精度，但是手续费数量还是tusdt的数量withdralal_fee字段）
@property (strong, nonatomic) XXTokenModel *withdrawFeeModel;

@property (strong, nonatomic) NSString *text;

@property (nonatomic, strong) XXAssetSingleManager *assetManager; // 资产请求

@end

@implementation XXTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self refreshAsset];
}

- (void)refreshAsset {
    for (XXTokenModel *tokenModel in [XXAssetSingleManager sharedManager].assetModel.assets) {
        if ([tokenModel.symbol isEqualToString:self.tokenModel.symbol]) {
            self.tokenModel.amount = kAmountTrim(tokenModel.amount);
            self.tokenModel.symbol = self.tokenModel.symbol;
        }
    }
    if (self.InnerChain) {
        if (self.tokenModel.amount.floatValue) {
            self.transferView.amountView.currentlyAvailable = kAmountTrim(self.tokenModel.amount);
        } else {
            self.transferView.amountView.currentlyAvailable = @"0";
        }
    } else {
        if (self.tokenModel.amount.floatValue) {
            self.withdrawView.amountView.currentlyAvailable = kAmountTrim(self.tokenModel.amount);
        } else {
            self.withdrawView.amountView.currentlyAvailable = @"0";
        }
    }
}

- (void)setupUI {
    if (self.InnerChain) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",[self.tokenModel.symbol uppercaseString],LocalizedString(@"Transfer")];
        [self.view addSubview:self.transferView];
        if (self.tokenModel.amount.floatValue) {
            self.transferView.amountView.currentlyAvailable = kAmountTrim(self.tokenModel.amount);
        } else {
            self.transferView.amountView.currentlyAvailable = @"0";
        }
        self.transferView.feeView.textField.text = kMinFee;
        self.transferView.speedView.slider.maximumValue = [kSliderMaxFee floatValue];
        self.transferView.speedView.slider.minimumValue = [kSliderMinFee floatValue];
        self.transferView.speedView.slider.value = [kMinFee doubleValue];
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",[self.tokenModel.symbol uppercaseString],LocalizedString(@"Withdraw")];
        [self.view addSubview:self.withdrawView];
        if (self.tokenModel.amount.floatValue) {
            self.withdrawView.amountView.currentlyAvailable = kAmountTrim(self.tokenModel.amount);
        } else {
            self.withdrawView.amountView.currentlyAvailable = @"0";
        }
        self.withdrawView.amountView.tokenModel = self.tokenModel;
        self.withdrawView.feeView.unitLabel.text = [kMainToken uppercaseString];
        self.withdrawFeeModel = [[XXSqliteManager sharedSqlite] withdrawFeeToken:self.tokenModel];
        self.withdrawView.chainFeeView.unitLabel.text = [self.withdrawFeeModel.symbol uppercaseString];
        self.withdrawView.chainFeeView.textField.text = self.tokenModel.withdrawal_fee;
        self.withdrawView.feeView.textField.text = kMinFee;
        self.withdrawView.speedView.slider.maximumValue = [kSliderMaxFee floatValue];
        self.withdrawView.speedView.slider.minimumValue = [kSliderMinFee floatValue];
        self.withdrawView.speedView.slider.value = [kMinFee doubleValue];
    }
    [self.view addSubview:self.withdrawButton];
}

- (void)withdrawButtonClick {
    if (self.InnerChain) {
        [self transferVerify];
    } else {
        [self withdrawVerify];
    }
}

- (void)transferVerify {
    NSString *address = self.transferView.addressView.textField.text;
    if (self.transferView.addressView.textField.text.length && self.transferView.amountView.textField.text.length && self.transferView.feeView.textField.text.length) {
        NSString *pre = [address substringToIndex:3];
        if (![pre isEqualToString:@"HBC"]) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"AddressWrong") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.tokenModel.amount];
        NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.transferView.feeView.textField.text];
        NSString *availableAmount = [[amountDecimal decimalNumberBySubtracting:feeAmountDecimal] stringValue];
        if (self.transferView.amountView.textField.text.doubleValue > availableAmount.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"TransferErrorTip") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        if (self.tokenModel.amount.doubleValue < self.transferView.feeView.textField.text.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        MJWeakSelf
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            weakSelf.text = text;
            [weakSelf requestTransfer];
        }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CompleteInfomation") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}

/// 请求转账
- (void)requestTransfer {
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.transferView.amountView.textField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.transferView.feeView.textField.text];
    NSString *toAddress = self.transferView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.tokenModel.decimals)] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:@"" feeDenom:self.tokenModel.symbol memo:self.transferView.memoView.textField.text type:kMsgSend withdrawal_fee:@"" text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
    MJWeakSelf
    _msgRequest.msgSendSuccessBlock = ^{
        [MBProgressHUD hideHUD];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _msgRequest.msgSendFaildBlock = ^(NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
    };
    [_msgRequest sendMsg:model];
}

/// 提币
- (void)withdrawVerify {
    if (self.withdrawView.addressView.textField.text.length && self.withdrawView.amountView.textField.text.length && self.withdrawView.feeView.textField.text.length) {
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.tokenModel.amount];
        NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.withdrawView.chainFeeView.textField.text];
        NSString *availableAmount = [[amountDecimal decimalNumberBySubtracting:feeAmountDecimal] stringValue];
        if (self.withdrawView.amountView.textField.text.doubleValue > availableAmount.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"WithdrawErrorTip") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        if (self.tokenModel.amount.doubleValue < self.withdrawView.chainFeeView.textField.text.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"ChainFeeNotEnough") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        MJWeakSelf
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            weakSelf.text = text;
            [weakSelf requestWithdraw];
        }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CompleteInfomation") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}

/// 请求提币
- (void)requestWithdraw {
    XXTokenModel *mainToken = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.withdrawView.amountView.textField.text]; //数量
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.withdrawView.feeView.textField.text]; //交易手续费
    NSDecimalNumber *chainFeeDecimal = [NSDecimalNumber decimalNumberWithString:self.withdrawView.chainFeeView.textField.text]; //跨链手续费
    NSString *toAddress = self.withdrawView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(mainToken.decimals)] stringValue];
    NSString *chainFeeAmount = [[chainFeeDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.withdrawFeeModel.decimals)] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:@"" feeDenom:kMainToken memo:self.withdrawView.memoView.textField.text type:kMsgWithdrawal withdrawal_fee:chainFeeAmount text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
    MJWeakSelf
    _msgRequest.msgSendSuccessBlock = ^{
        [MBProgressHUD hideHUD];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _msgRequest.msgSendFaildBlock = ^(NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
    };
    [_msgRequest sendMsg:model];
}

#pragma mark - || 懒加载
/** 提币视图 */
- (XXWithdrawView *)withdrawView {
    if (_withdrawView == nil) {
        _withdrawView = [[XXWithdrawView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 90)];
    }
    return _withdrawView;
}

- (XXTransferView *)transferView {
    if (_transferView == nil) {
        _transferView = [[XXTransferView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 90)];
    }
    return _transferView;
}

/** 提币按钮 */
- (XXButton *)withdrawButton {
    if (_withdrawButton == nil) {
        MJWeakSelf
        _withdrawButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 80, kScreen_Width - KSpacing*2, 42) title:@"" font:kFontBold14 titleColor:kMainTextColor block:^(UIButton *button) {
            [weakSelf withdrawButtonClick];
        }];
        _withdrawButton.backgroundColor = kPrimaryMain;
        _withdrawButton.layer.cornerRadius = kBtnBorderRadius;
        _withdrawButton.layer.masksToBounds = YES;
        if (self.InnerChain) {
            [_withdrawButton setTitle:LocalizedString(@"Transfer") forState:UIControlStateNormal];
        } else {
            [_withdrawButton setTitle:LocalizedString(@"Withdraw") forState:UIControlStateNormal];
        }
    }
    return _withdrawButton;
}

@end
