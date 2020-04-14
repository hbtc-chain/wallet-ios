//
//  XXTransferVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferVC.h"
#import "XXWithdrawView.h"
#import "XXTransactionModel.h"
#import "XXTransactionRequest.h"
#import "XXTokenModel.h"
#import "XXTransferView.h"
#import "XXPasswordView.h"

@interface XXTransferVC ()

/** 提币视图 */
@property (strong, nonatomic) XXWithdrawView *withdrawView;

/// 转账视图
@property (strong, nonatomic) XXTransferView *transferView;

/** 提币按钮 */
@property (strong, nonatomic) XXButton *withdrawButton;

/// 交易请求
@property (strong, nonatomic) XXTransactionRequest *transactionRequest;

@end

@implementation XXTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    if (self.InnerChain) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.tokenModel.symbol,LocalizedString(@"Transfer")];
        [self.view addSubview:self.transferView];
        self.transferView.amountView.currentlyAvailable = self.tokenModel.amount;
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.tokenModel.symbol,LocalizedString(@"Withdraw")];
        [self.view addSubview:self.withdrawView];
        self.withdrawView.amountView.currentlyAvailable = self.tokenModel.amount;
        self.withdrawView.feeView.unitLabel.text = [self.tokenModel.symbol uppercaseString];
        self.withdrawView.receivedView.unitLabel.text = [self.tokenModel.symbol uppercaseString];
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
    if (self.transferView.addressView.textField.text.length && self.transferView.amountView.textField.text.length && self.transferView.feeView.textField.text.length) {
        MJWeakSelf
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            [weakSelf requestTransfer];
           }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:@"请填写完整信息" duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}

- (void)requestTransfer {
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.transferView.amountView.textField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.transferView.feeView.textField.text];
    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.transferView.speedView.slider.value]];
    NSString *toAddress = self.transferView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimal] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimal] stringValue];
    NSString *gas = [[[feeAmountDecimal decimalNumberByDividingBy:gasPriceDecimal] decimalNumberByDividingBy:kPrecisionDecimal_U] stringValue];
    
    XXTransactionModel *model = [[XXTransactionModel alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:gas feeDenom:self.tokenModel.symbol memo:@""];
    _transactionRequest = [[XXTransactionRequest alloc] init];
    [_transactionRequest sendMsg:model];
}

- (void)withdrawVerify {
    if (self.withdrawView.addressView.textField.text.length && self.withdrawView.amountView.textField.text.length && self.withdrawView.feeView.textField.text.length) {
        MJWeakSelf
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            [weakSelf requestTransfer];
           }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:@"请填写完整信息" duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}

- (void)requestWithdraw {
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.withdrawView.amountView.textField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.withdrawView.feeView.textField.text];
    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.withdrawView.speedView.slider.value]];
    NSString *toAddress = self.withdrawView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimal] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimal] stringValue];
    NSString *gas = [[[feeAmountDecimal decimalNumberByDividingBy:gasPriceDecimal] decimalNumberByDividingBy:kPrecisionDecimal_U] stringValue];
    
    XXTransactionModel *model = [[XXTransactionModel alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:gas feeDenom:self.tokenModel.symbol memo:@""];
    _transactionRequest = [[XXTransactionRequest alloc] init];
    [_transactionRequest sendMsg:model];
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
        _withdrawButton.backgroundColor = kBlue100;
        _withdrawButton.layer.cornerRadius = 3;
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
