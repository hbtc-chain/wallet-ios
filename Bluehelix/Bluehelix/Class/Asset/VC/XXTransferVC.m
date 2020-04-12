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


@interface XXTransferVC ()

/** 提币视图 */
@property (strong, nonatomic) XXWithdrawView *withdrawView;

/** 提币按钮 */
@property (strong, nonatomic) XXButton *withdrawButton;

@property (strong, nonatomic) XXTransactionRequest *transactionRequest;
@end

@implementation XXTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.tokenModel.symbol,LocalizedString(@"Withdraw")];
    
    [self.view addSubview:self.withdrawView];
    self.withdrawView.amountView.currentlyAvailable = self.tokenModel.amount;
    
    [self.view addSubview:self.withdrawButton];
}

#pragma mark - 2. 提币按钮点击事件
- (void)withdrawButtonClick {
    if (self.withdrawView.addressView.textField.text.length && self.withdrawView.amountView.textField.text.length && self.withdrawView.feeView.textField.text.length && self.withdrawView.receivedView.textField.text.length) {
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
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:@"请填写完整信息" duration:kAlertDuration completion:^{
                          }];
               [alert showAlert];
               return;
    }
}

#pragma mark - || 懒加载
/** 提币视图 */
- (XXWithdrawView *)withdrawView {
    if (_withdrawView == nil) {
        _withdrawView = [[XXWithdrawView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 90)];
    }
    return _withdrawView;
}

/** 提币按钮 */
- (XXButton *)withdrawButton {
    if (_withdrawButton == nil) {
        MJWeakSelf
        _withdrawButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 80, kScreen_Width - KSpacing*2, 42) title:LocalizedString(@"Withdraw") font:kFontBold14 titleColor:kMainTextColor block:^(UIButton *button) {
            [weakSelf withdrawButtonClick];
        }];
        _withdrawButton.backgroundColor = kBlue100;
        _withdrawButton.layer.cornerRadius = 3;
        _withdrawButton.layer.masksToBounds = YES;
    }
    return _withdrawButton;
}

@end
