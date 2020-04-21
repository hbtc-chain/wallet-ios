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
        self.transferView.amountView.currentlyAvailable = kAmountTrim(self.tokenModel.amount);
        self.transferView.feeView.textField.text = kMinFee;
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.tokenModel.symbol,LocalizedString(@"Withdraw")];
        [self.view addSubview:self.withdrawView];
        self.withdrawView.amountView.currentlyAvailable = kAmountTrim(self.tokenModel.amount);
        self.withdrawView.amountView.tokenModel = self.tokenModel;
        self.withdrawView.feeView.unitLabel.text = [kMainToken uppercaseString];
        self.withdrawFeeModel = [[XXSqliteManager sharedSqlite] withdrawFeeToken:self.tokenModel];
        self.withdrawView.chainFeeView.unitLabel.text = [self.withdrawFeeModel.symbol uppercaseString];
        self.withdrawView.chainFeeView.textField.text = self.tokenModel.withdrawal_fee;
        self.withdrawView.feeView.textField.text = kMinFee;
        
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
            weakSelf.text = text;
            [weakSelf requestTransfer];
           }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:@"请填写完整信息" duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}

/// 请求转账
- (void)requestTransfer {
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.transferView.amountView.textField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.transferView.feeView.textField.text];
    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.transferView.speedView.slider.value]];
    NSString *toAddress = self.transferView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.tokenModel.decimals)] stringValue];
    NSString *gas = [[[feeAmountDecimal decimalNumberByDividingBy:gasPriceDecimal] decimalNumberByDividingBy:kPrecisionDecimal_U] stringValue];

    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:gas feeDenom:self.tokenModel.symbol memo:@"" type:kMsgSend withdrawal_fee:@"" text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
}

/// 提币
- (void)withdrawVerify {
    if (self.withdrawView.addressView.textField.text.length && self.withdrawView.amountView.textField.text.length && self.withdrawView.feeView.textField.text.length) {
        MJWeakSelf
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            weakSelf.text = text;
            [weakSelf requestWithdraw];
           }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:@"请填写完整信息" duration:kAlertDuration completion:^{
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
    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.withdrawView.speedView.slider.value]]; //gas price
    NSDecimalNumber *chainFeeDecimal = [NSDecimalNumber decimalNumberWithString:self.withdrawView.chainFeeView.textField.text]; //跨链手续费
    NSString *toAddress = self.withdrawView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(mainToken.decimals)] stringValue];
    NSString *chainFeeAmount = [[chainFeeDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.withdrawFeeModel.decimals)] stringValue];
    NSString *gas = [[[feeAmountDecimal decimalNumberByDividingBy:gasPriceDecimal] decimalNumberByDividingBy:kPrecisionDecimal_U] stringValue];
    
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:gas feeDenom:kMainToken memo:@"" type:kMsgWithdrawal withdrawal_fee:chainFeeAmount text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
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
