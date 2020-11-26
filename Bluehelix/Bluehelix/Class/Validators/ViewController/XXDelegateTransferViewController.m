//
//  XXDelegateTransferViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXDelegateTransferViewController.h"

#import "XXDelegateTransferView.h"
#import "XXPasswordView.h"
#import "XXTokenModel.h"
#import "XXHadDelegateModel.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXAssetSingleManager.h"

@interface XXDelegateTransferViewController ()
/**委托view*/
@property (nonatomic, strong) XXDelegateTransferView *delegateTransferView;
/**委托响应按钮*/
@property (nonatomic, strong) XXButton *transferButton;
/**资产数据*/
@property (nonatomic, strong) XXAssetModel *assetModel;

@property (strong, nonatomic) NSString *text;
/**资产模型*/
@property (nonatomic, strong) XXTokenModel *tokenModel;
/**已经委托模型*/
@property (nonatomic, strong) XXHadDelegateModel *hadDelegateModel;

/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;
@end

@implementation XXDelegateTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadDefaultData];
    [self refreshDelegateAmount];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createUI{
    switch (self.delegateNodeType) {
        case 0:
            self.titleLabel.text =  LocalizedString(@"Delegate");
            break;
        case 1:
            self.titleLabel.text =  LocalizedString(@"TransferDelegate");
            break;
            
        default:
            self.titleLabel.text = LocalizedString(@"RelieveDelegate");
            [self requestHadDelegatesList];
            break;
    }
    [self.view addSubview:self.delegateTransferView];
    [self.view addSubview:self.transferButton];
    self.delegateTransferView.feeView.textField.text = [XXUserData sharedUserData].showFee;
}
- (void)loadDefaultData{
    
    switch (self.delegateNodeType) {
        case 0:
            self.delegateTransferView.addressView.textField.text = [NSString addressReplace:KString(_validatorModel.operator_address)];
            break;
        case 1:
            
            break;
            
        default:
            self.delegateTransferView.addressView.textField.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"ValidatorRelieveToAddress"),[NSString addressReplace:KString(KUser.address)]];
            [self requestHadDelegatesList];
            break;
    }
}

- (void)requestHadDelegatesList {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@/delegations",KUser.address];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSLog(@"%@",data);
            NSArray *listArray = [XXHadDelegateModel mj_objectArrayWithKeyValuesArray:data];
            [weakSelf refreshRelieveDelegate:listArray];
        } else {
            
        }
    }];
}
#pragma mark privity
- (void)transferVerify {
    if (self.delegateTransferView.addressView.textField.text.length && self.delegateTransferView.amountView.textField.text.length && self.delegateTransferView.feeView.textField.text.length) {
        XXTokenModel *mainToken = [[XXAssetSingleManager sharedManager] assetTokenBySymbol:kMainToken];
        NSString *availableAmountStr;
           if (mainToken.amount.doubleValue > 0) {
               NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:mainToken.amount];
               NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.delegateTransferView.feeView.textField.text];
               NSDecimalNumber *availableDecimal = [amountDecimal decimalNumberBySubtracting:feeAmountDecimal];
               if (availableDecimal.doubleValue > 0) {
                   availableAmountStr = kAmountLongTrim(availableDecimal.stringValue);
               } else {
                   availableAmountStr = kAmountLongTrim(amountDecimal.stringValue);
               }
           } else {
               availableAmountStr = @"0";
           }
        switch (self.delegateNodeType) {
            case XXDelegateNodeTypeAdd:
                if (self.delegateTransferView.amountView.textField.text.doubleValue > availableAmountStr.doubleValue) {
                    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"DelegateError") duration:kAlertDuration completion:^{
                    }];
                    [alert showAlert];
                    return;
                }
                if (mainToken.amount.doubleValue < self.delegateTransferView.feeView.textField.text.doubleValue) {
                    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
                    }];
                    [alert showAlert];
                    return;
                }
                break;
            case XXDelegateNodeTypeTransfer:
                
                break;
            case XXDelegateNodeTypeRelieve:
                if (self.delegateTransferView.amountView.textField.text.doubleValue > self.hadDelegateModel.bonded.doubleValue) {
                    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"RelieveDelegateError") duration:kAlertDuration completion:^{
                    }];
                    [alert showAlert];
                    return;
                }
                if (mainToken.amount.doubleValue < self.delegateTransferView.feeView.textField.text.doubleValue) {
                    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
                    }];
                    [alert showAlert];
                    return;
                }
                break;
            default:
                
                break;
        }
        if (kIsQuickTextOpen) {
            self.text = kText;
            switch (self.delegateNodeType) {
                case XXDelegateNodeTypeAdd:
                    [self requestDelegate];
                    break;
                case XXDelegateNodeTypeTransfer:
                    break;
                case XXDelegateNodeTypeRelieve:
                    [self requestRelieveDelegate];
                    break;
                default:
                    break;
            }
        } else {
            MJWeakSelf
            [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
                weakSelf.text = text;
                switch (self.delegateNodeType) {
                    case XXDelegateNodeTypeAdd:
                        [weakSelf requestDelegate];
                        break;
                    case XXDelegateNodeTypeTransfer:
                        break;
                    case XXDelegateNodeTypeRelieve:
                        [weakSelf requestRelieveDelegate];
                        break;
                    default:
                        break;
                }
            }];
        }
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PleaseFillAll") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}
/// 发起委托请求
- (void)requestDelegate {
    XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.delegateTransferView.amountView.textField.text];
    NSString *toAddress = KString(self.validatorModel.operator_address);
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [XXUserData sharedUserData].fee;
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:tokenModel.symbol feeAmount:feeAmount feeGas:@"" feeDenom:tokenModel.symbol memo:@"" type:kMsgDelegate withdrawal_fee:@"" text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
    MJWeakSelf
    _msgRequest.msgSendSuccessBlock = ^(id  _Nonnull responseObject) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD hideHUD];
    };
    _msgRequest.msgSendFaildBlock = ^(NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
    };
}
/// 发起取消委托请求
- (void)requestRelieveDelegate {
    XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.delegateTransferView.amountView.textField.text];
    NSString *toAddress = self.validatorModel.operator_address;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [XXUserData sharedUserData].fee;
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:tokenModel.symbol feeAmount:feeAmount feeGas:@"" feeDenom:tokenModel.symbol memo:@"" type:kMsgUndelegate withdrawal_fee:@"" text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
    MJWeakSelf
    _msgRequest.msgSendSuccessBlock = ^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _msgRequest.msgSendFaildBlock = ^(NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
    };
}


#pragma mark 刷新资产
- (void)refreshDelegateAmount{
    self.assetModel = [XXAssetSingleManager sharedManager].assetModel;
    for (XXTokenModel *tokenModel in self.assetModel.assets) {
        if ([[tokenModel.symbol uppercaseString] isEqualToString:[kMainToken uppercaseString]]) {
            self.tokenModel = tokenModel;
            [self.delegateTransferView refreshAssets:tokenModel];
            break;
        }
    }
}
//解委托
- (void)refreshRelieveDelegate:(NSArray *)array{
    for (XXHadDelegateModel *hadDelegateModel in array) {
        if ([hadDelegateModel.validator isEqualToString:self.validatorModel.operator_address]) {
            self.hadDelegateModel = hadDelegateModel;
            [self.delegateTransferView refreshRelieveAssets:hadDelegateModel];
            break;
        }
    }
}
#pragma mark set/get
- (void)setValidatorModel:(XXValidatorListModel *)validatorModel{
    _validatorModel = validatorModel;
}
#pragma mark lazy load
- (XXDelegateTransferView *)delegateTransferView {
    if (!_delegateTransferView ) {
        _delegateTransferView = [[XXDelegateTransferView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 64 - 8)];
        _delegateTransferView.delegateNodeType = self.delegateNodeType;
    }
    return _delegateTransferView;
}
/** 按钮 */
- (XXButton *)transferButton {
    if (!_transferButton) {
        MJWeakSelf
        _transferButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 64- 8, kScreen_Width - KSpacing*2, 48) title:@"" font:kFontBold17 titleColor:kWhiteNoChange block:^(UIButton *button) {
            [weakSelf transferVerify];
        }];
        _transferButton.backgroundColor = kPrimaryMain;
        _transferButton.layer.cornerRadius = 3;
        _transferButton.layer.masksToBounds = YES;
        switch (self.delegateNodeType) {
            case 0:
                [_transferButton setTitle:LocalizedString(@"Delegate") forState:UIControlStateNormal];
                break;
            case 1:
                [_transferButton setTitle:LocalizedString(@"TransferDelegate") forState:UIControlStateNormal];
                break;
                
            default:
                [_transferButton setTitle:LocalizedString(@"RelieveDelegate") forState:UIControlStateNormal];
                break;
        }
        
    }
    return _transferButton;
}
- (XXAssetModel*)assetModel{
    if (!_assetModel) {
        _assetModel = [[XXAssetModel alloc]init];
    }
    return _assetModel;
}
@end
