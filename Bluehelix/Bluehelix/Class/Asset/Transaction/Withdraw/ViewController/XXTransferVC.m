//
//  XXTransferVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferVC.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXTokenModel.h"
#import "XXTransferView.h"
#import "XXPasswordAlertView.h"
#import "XXAssetSingleManager.h"
#import "XXChooseTokenVC.h"

@interface XXTransferVC ()

@property (nonatomic, strong) XXButton *titleButton;

@property (nonatomic, strong) XXTokenModel *tokenModel;

/// 转账视图
@property (strong, nonatomic) XXTransferView *transferView;

/** 提币按钮 */
@property (strong, nonatomic) XXButton *transferButton;

/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;

@property (strong, nonatomic) NSString *text;

@property (nonatomic, strong) XXAssetSingleManager *assetManager; // 资产请求

@end

@implementation XXTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.symbol];
    [self setupUI];
    [self refreshAsset];
}

#pragma mark 资产 刷新
- (void)refreshAsset {
    for (XXTokenModel *tokenModel in [XXAssetSingleManager sharedManager].assetModel.assets) {
        if ([tokenModel.symbol isEqualToString:self.tokenModel.symbol]) {
            self.tokenModel.amount = kAmountLongTrim(tokenModel.amount);
            self.tokenModel.symbol = self.tokenModel.symbol;
        }
    }
    if (self.tokenModel.amount.floatValue) {
        self.transferView.amountView.currentlyAvailable = kAmountLongTrim(self.tokenModel.amount);
    } else {
        self.transferView.amountView.currentlyAvailable = @"0";
    }
}

#pragma mark UI
- (void)setupUI {
    self.titleLabel.text = LocalizedString(@"Transfer");
    [self.view addSubview:self.transferView];
    if (self.tokenModel.amount.floatValue) {
        self.transferView.amountView.currentlyAvailable = kAmountLongTrim(self.tokenModel.amount);
    } else {
        self.transferView.amountView.currentlyAvailable = @"0";
    }
    self.transferView.amountView.tokenLabel.text = [self.tokenModel.name uppercaseString];
    self.transferView.feeView.textField.text = [XXUserData sharedUserData].showFee;
    self.transferView.chooseTokenView.textField.text = [self.tokenModel.name uppercaseString];
    [self.view addSubview:self.transferButton];
}

#pragma mark 更换token后 刷新
- (void)reloadUI {
    [self refreshAsset];
    self.transferView.amountView.tokenLabel.text = [self.tokenModel.name uppercaseString];
}

#pragma mark 事件 转账
- (void)transferVerify {
    NSString *address = self.transferView.addressView.textField.text;
    if (self.transferView.addressView.textField.text.length && self.transferView.amountView.textField.text.length && self.transferView.feeView.textField.text.length) {
        //                NSString *pre = [address substringToIndex:3];
        //                if (![pre isEqualToString:@"HBC"]) {
        //                    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"AddressWrong") duration:kAlertDuration completion:^{
        //                    }];
        //                    [alert showAlert];
        //                    return;
        //                }
        if ([address isEqualToString:KUser.address]) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"TransferToSelf") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        NSString *availableAmount;
        if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
            if (self.tokenModel.amount <= 0) {
                Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"TransferErrorTip") duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
                return;
            }
            NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.tokenModel.amount];
            NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.transferView.feeView.textField.text];
            availableAmount = [[amountDecimal decimalNumberBySubtracting:feeAmountDecimal] stringValue];
            if (availableAmount.doubleValue < 0) {
                availableAmount = kAmountLongTrim(amountDecimal.stringValue);
            }
        } else {
            availableAmount = self.tokenModel.amount;
        }
        if (self.transferView.amountView.textField.text.doubleValue > availableAmount.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"TransferErrorTip") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        XXTokenModel *mainToken = [[XXAssetSingleManager sharedManager] assetTokenBySymbol:kMainToken];
        if (mainToken.amount.doubleValue < self.transferView.feeView.textField.text.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        if (kShowPassword) {
            MJWeakSelf
            [XXPasswordAlertView showWithSureBtnBlock:^() {
                [weakSelf requestTransfer];
            }];
        } else {
            [self requestTransfer];
        }
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CompleteInfomation") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}

#pragma mark 网络请求 转账
- (void)requestTransfer {
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.transferView.amountView.textField.text];
    NSString *toAddress = self.transferView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.tokenModel.decimals)] stringValue];
    NSString *feeAmount = [XXUserData sharedUserData].fee;
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:@"" feeDenom:kMainToken memo:@"" type:kMsgSend withdrawal_fee:@""];
    _msgRequest = [[XXMsgRequest alloc] init];
    MJWeakSelf
    _msgRequest.msgSendSuccessBlock = ^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _msgRequest.msgSendFaildBlock = ^(NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
    };
    [_msgRequest sendMsg:model];
}

#pragma mark - || 懒加载
/// 转账视图
- (XXTransferView *)transferView {
    if (_transferView == nil) {
        _transferView = [[XXTransferView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 90)];
        MJWeakSelf
        _transferView.chooseTokenView.chooseTokenBlock = ^(NSString * symbol) {
            weakSelf.symbol = symbol;
            weakSelf.tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:symbol];
            [weakSelf reloadUI];
        };
        _transferView.amountView.allButtonActionBlock = ^{
            NSDecimalNumber *availableDecimal = [NSDecimalNumber decimalNumberWithString:weakSelf.tokenModel.amount];
            if ([weakSelf.tokenModel.symbol isEqualToString:kMainToken]) {
                NSDecimalNumber *feeDecimal = [NSDecimalNumber decimalNumberWithString:weakSelf.transferView.feeView.textField.text];
                NSDecimalNumber *resultDecimal = [availableDecimal decimalNumberBySubtracting:feeDecimal];
                if (resultDecimal.doubleValue > 0) {
                    weakSelf.transferView.amountView.textField.text = kAmountLongTrim(resultDecimal.stringValue);
                } else {
                    weakSelf.transferView.amountView.textField.text = kAmountLongTrim(availableDecimal.stringValue);
                }
            } else {
                weakSelf.transferView.amountView.textField.text = kAmountLongTrim(availableDecimal.stringValue);
            }
        };
    }
    return _transferView;
}

/** 转账按钮 */
- (XXButton *)transferButton {
    if (_transferButton == nil) {
        MJWeakSelf
        _transferButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 80, kScreen_Width - KSpacing*2, 42) title:@"" font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf transferVerify];
        }];
        _transferButton.backgroundColor = kPrimaryMain;
        _transferButton.layer.cornerRadius = kBtnBorderRadius;
        _transferButton.layer.masksToBounds = YES;
        [_transferButton setTitle:LocalizedString(@"TransferConfirm") forState:UIControlStateNormal];
    }
    return _transferButton;
}

@end
