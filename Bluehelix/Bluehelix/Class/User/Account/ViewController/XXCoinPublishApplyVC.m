//
//  XXCoinPublishApplyVC.m
//  Bluehelix
//
//  Created by BHEX on 2020/5/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXCoinPublishApplyVC.h"
#import "XXCoinPublishApplyView.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXPasswordView.h"
#import "XXTokenModel.h"
#import "XXAssetSingleManager.h"

@interface XXCoinPublishApplyVC ()

/** 代币发行申请 */
@property (strong, nonatomic) XXCoinPublishApplyView *coinPublishView;

/** 提币按钮 */
@property (strong, nonatomic) XXButton *applyButton;

/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;

@property (strong, nonatomic) NSString *text;

@end

@implementation XXCoinPublishApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = LocalizedString(@"CoinPublishApply");
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.coinPublishView];
    self.coinPublishView.feeView.unitLabel.text = [kMainToken uppercaseString];
    self.coinPublishView.feeView.textField.text = kMinFee;
    self.coinPublishView.speedView.slider.maximumValue = [kSliderMaxFee floatValue];
    self.coinPublishView.speedView.slider.minimumValue = [kSliderMinFee floatValue];
    self.coinPublishView.speedView.slider.value = [kMinFee doubleValue];
    [self.view addSubview:self.applyButton];
}

- (void)apply {
    if(self.coinPublishView.addressView.textField.text.length && self.coinPublishView.nameView.textField.text.length && self.coinPublishView.amountView.textField.text.length && self.coinPublishView.precisionView.textField.text.length && self.coinPublishView.feeView.textField.text.length) {
        if (self.coinPublishView.precisionView.textField.text.intValue > 18) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"LeastPrecision") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        XXTokenModel *mainToken = [[XXAssetSingleManager sharedManager] assetTokenBySymbol:kMainToken];
        if (mainToken.amount.doubleValue < self.coinPublishView.feeView.textField.text.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        if (kIsQuickTextOpen) {
            self.text = kText;
            [self requestApply];
        } else {
            MJWeakSelf
            [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
                weakSelf.text = text;
                [weakSelf requestApply];
            }];
        }
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CompleteInfomation") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}

/// 请求提币
- (void)requestApply {
    NSString *precision = self.coinPublishView.precisionView.textField.text; //精度
    XXTokenModel *mainToken = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
    NSString *toAddress = self.coinPublishView.addressView.textField.text;
    NSString *symbol = [self.coinPublishView.nameView.textField.text lowercaseString];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.coinPublishView.amountView.textField.text]; //数量
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(precision.intValue)] stringValue];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.coinPublishView.feeView.textField.text]; //手续费
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(mainToken.decimals)] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] init];
    model.fromAddress = KUser.address;
    model.toAddress = toAddress;
    model.amount = amount;
    model.denom = symbol;
    model.feeAmount = feeAmount;
    model.feeGas = @"";
    model.feeDenom = kMainToken;
    model.type = kMsgNewToken;
    model.memo = @"";
    model.text = self.text;
    model.decimals = precision;
    [model buildMsgs];
    
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


- (XXCoinPublishApplyView *)coinPublishView {
    if (_coinPublishView == nil) {
        _coinPublishView = [[XXCoinPublishApplyView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 90)];
    }
    return _coinPublishView;
}

/** 提币按钮 */
- (XXButton *)applyButton {
    if (_applyButton == nil) {
        MJWeakSelf
        _applyButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 80, kScreen_Width - KSpacing*2, 42) title:LocalizedString(@"Apply") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf apply];
        }];
        _applyButton.backgroundColor = kPrimaryMain;
        _applyButton.layer.cornerRadius = kBtnBorderRadius;
        _applyButton.layer.masksToBounds = YES;
    }
    return _applyButton;
}

@end
