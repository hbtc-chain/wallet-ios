//
//  XXWithdrawVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/6.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXWithdrawVC.h"
#import "XXWithdrawView.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXTokenModel.h"
#import "XXPasswordAlertView.h"
#import "XXAssetSingleManager.h"
#import "XXChooseTokenVC.h"

@interface XXWithdrawVC ()

@property (nonatomic, strong) XXTokenModel *tokenModel;

/** 提币视图 */
@property (strong, nonatomic) XXWithdrawView *withdrawView;

/** 提币按钮 */
@property (strong, nonatomic) XXButton *withdrawButton;

/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;

/// 跨链提币 对应的手续费token （假如提的币是tusdt，但是因为tusdt的链式eth，所以扣的手续费是eth，精度也是eth的精度，但是手续费数量还是tusdt的数量withdralal_fee字段）
@property (strong, nonatomic) XXTokenModel *withdrawFeeModel;

@property (strong, nonatomic) NSString *text;

@property (nonatomic, strong) XXAssetSingleManager *assetManager; // 资产请求

@end

@implementation XXWithdrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.symbol];
    [self setupUI];
    [self refreshAsset];
}

#pragma mark 资产刷新
- (void)refreshAsset {
    for (XXTokenModel *tokenModel in [XXAssetSingleManager sharedManager].assetModel.assets) {
        if ([tokenModel.symbol isEqualToString:self.tokenModel.symbol]) {
            self.tokenModel.amount = kAmountLongTrim(tokenModel.amount);
            self.tokenModel.symbol = self.tokenModel.symbol;
        }
    }
    if (self.tokenModel.amount.floatValue) {
        self.withdrawView.amountView.currentlyAvailable = kAmountLongTrim(self.tokenModel.amount);
    } else {
        self.withdrawView.amountView.currentlyAvailable = @"0";
    }
}

#pragma mark UI
- (void)setupUI {
    [self requestTokens];
    self.titleLabel.text = LocalizedString(@"ChainPayMoney");
    [self.view addSubview:self.withdrawView];
    if (self.tokenModel.amount.floatValue) {
        self.withdrawView.amountView.currentlyAvailable = kAmountLongTrim(self.tokenModel.amount);
    } else {
        self.withdrawView.amountView.currentlyAvailable = @"0";
    }
    self.withdrawView.amountView.tokenModel = self.tokenModel;
    self.withdrawView.amountView.tokenLabel.text = [self.tokenModel.name uppercaseString];
    self.withdrawView.feeView.unitLabel.text = [kMainToken uppercaseString];
    self.withdrawFeeModel = [[XXSqliteManager sharedSqlite] withdrawFeeToken:self.tokenModel];
    self.withdrawView.chainFeeView.unitLabel.text = [self.withdrawFeeModel.name uppercaseString];
    self.withdrawView.chainFeeView.textField.text = self.tokenModel.withdrawal_fee;
    self.withdrawView.feeView.textField.text = [XXUserData sharedUserData].showFee;
    self.withdrawView.chooseTokenView.textField.text = [self.tokenModel.name uppercaseString];
    [self.view addSubview:self.withdrawButton];
}

#pragma mark 更换token后 刷新
- (void)reloadUI {
    [self refreshAsset];
    self.withdrawView.amountView.tokenModel = self.tokenModel;
    self.withdrawView.amountView.tokenLabel.text = [self.tokenModel.name uppercaseString];
    self.withdrawFeeModel = [[XXSqliteManager sharedSqlite] withdrawFeeToken:self.tokenModel];
    self.withdrawView.chainFeeView.unitLabel.text = [self.withdrawFeeModel.name uppercaseString];
    self.withdrawView.chainFeeView.textField.text = self.tokenModel.withdrawal_fee;
}

#pragma mark 事件 提币验证
- (void)withdrawVerify {
    if (self.withdrawView.addressView.textField.text.length && self.withdrawView.amountView.textField.text.length && self.withdrawView.feeView.textField.text.length) {
        if (self.withdrawView.amountView.textField.text.doubleValue > self.tokenModel.amount.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"WithdrawErrorTip") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        XXTokenModel *chainFeeTokenModel = [[XXAssetSingleManager sharedManager] assetTokenBySymbol:self.withdrawFeeModel.symbol];
        if (chainFeeTokenModel.amount.doubleValue < self.withdrawView.chainFeeView.textField.text.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"ChainFeeNotEnough") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        if (self.withdrawView.chainFeeView.textField.text.doubleValue < self.tokenModel.withdrawal_fee.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:[NSString stringWithFormat:@"%@%@%@",LocalizedString(@"WithdrawChainFeeLess"),self.tokenModel.withdrawal_fee,[self.withdrawFeeModel.name uppercaseString]] duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        if (kShowPassword) {
            MJWeakSelf
            [XXPasswordAlertView showWithSureBtnBlock:^{
                [weakSelf requestWithdraw];
            }];
        } else {
            [self requestWithdraw];
            
        }
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CompleteInfomation") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}
#pragma mark 网络请求 提币手续费
//提币手续费withdraw_fee会有更新 需要每次进来保持最新的
- (void)requestTokens {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/tokens/%@",self.symbol];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            weakSelf.withdrawFeeModel = [XXTokenModel mj_objectWithKeyValues:data];
            weakSelf.withdrawView.chainFeeView.textField.text = weakSelf.tokenModel.withdrawal_fee;
        }
    }];
}

#pragma mark 网络请求 提币
- (void)requestWithdraw {
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.withdrawView.amountView.textField.text]; //数量
    NSDecimalNumber *chainFeeDecimal = [NSDecimalNumber decimalNumberWithString:self.withdrawView.chainFeeView.textField.text]; //跨链手续费
    NSString *toAddress = self.withdrawView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.tokenModel.decimals)] stringValue];
    NSString *feeAmount = [XXUserData sharedUserData].fee;
    NSString *chainFeeAmount = [[chainFeeDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(self.withdrawFeeModel.decimals)] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:self.tokenModel.symbol feeAmount:feeAmount feeGas:@"" feeDenom:kMainToken memo:@"" type:kMsgWithdrawal withdrawal_fee:chainFeeAmount];
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
/** 提币视图 */
- (XXWithdrawView *)withdrawView {
    if (_withdrawView == nil) {
        _withdrawView = [[XXWithdrawView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 90)];
        MJWeakSelf
        _withdrawView.chooseTokenView.chain = self.tokenModel.chain;
        _withdrawView.chooseTokenView.chooseTokenBlock = ^(NSString * symbol) {
            weakSelf.symbol = symbol;
            weakSelf.tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:symbol];
            [weakSelf reloadUI];
        };
        _withdrawView.amountView.allButtonActionBlock = ^{
            NSDecimalNumber *availableDecimal = [NSDecimalNumber decimalNumberWithString:weakSelf.tokenModel.amount];
            if ([weakSelf.tokenModel.chain isEqualToString:weakSelf.tokenModel.symbol]) {
                NSDecimalNumber *withdrawFeeDecimal = [NSDecimalNumber decimalNumberWithString:weakSelf.tokenModel.withdrawal_fee];
                NSDecimalNumber *resultDecimal = [availableDecimal decimalNumberBySubtracting:withdrawFeeDecimal];
                if (resultDecimal.doubleValue > 0) {
                    weakSelf.withdrawView.amountView.textField.text = kAmountLongTrim(resultDecimal.stringValue);
                } else {
                    weakSelf.withdrawView.amountView.textField.text = kAmountLongTrim(availableDecimal.stringValue);
                }
            } else {
                weakSelf.withdrawView.amountView.textField.text = kAmountLongTrim(availableDecimal.stringValue);
            }
        };
    }
    return _withdrawView;
}

/** 提币按钮 */
- (XXButton *)withdrawButton {
    if (_withdrawButton == nil) {
        MJWeakSelf
        _withdrawButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 80, kScreen_Width - KSpacing*2, 42) title:@"" font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf withdrawVerify];
        }];
        _withdrawButton.backgroundColor = kPrimaryMain;
        _withdrawButton.layer.cornerRadius = kBtnBorderRadius;
        _withdrawButton.layer.masksToBounds = YES;
        [_withdrawButton setTitle:LocalizedString(@"WithdrawConfirm") forState:UIControlStateNormal];
    }
    return _withdrawButton;
}
@end
