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
#import "XXAssetManager.h"

@interface XXDelegateTransferViewController ()
/**委托view*/
@property (nonatomic, strong) XXDelegateTransferView *delegateTransferView;
/**委托响应按钮*/
@property (nonatomic, strong) XXButton *transferButton;
/**资产数据*/
@property (nonatomic, strong) XXAssetModel *assetModel;
/**资产请求*/
@property (nonatomic, strong) XXAssetManager *assetManager;

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
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createUI{
    switch (self.delegateNodeType) {
        case 0:
            self.titleLabel.text =  LocalizedString(@"Delegate");
            [self.assetManager requestAsset];
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
    
}
- (void)loadDefaultData{
        
    switch (self.delegateNodeType) {
        case 0:
            self.delegateTransferView.addressView.textField.text = [NSString addressReplace:KString(_validatorModel.operator_address)];
            [self.assetManager requestAsset];
            break;
        case 1:
            
            break;
            
        default:
            self.delegateTransferView.addressView.textField.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"ValidatorRelieveToAddress"),[NSString addressReplace:KString(KUser.address)]];
            [self requestHadDelegatesList];
            break;
    }
}
#pragma mark load data
- (void)configAsset {
    @weakify(self)
    
    self.assetManager.assetChangeBlock = ^{
        @strongify(self)
        [self refreshDelegateAmount];
    };
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
        
        NSDecimalNumber *feeAndQuantyDecimal =  [[NSDecimalNumber decimalNumberWithString:self.delegateTransferView.amountView.textField.text]decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:self.delegateTransferView.feeView.textField.text]];
        switch (self.delegateNodeType) {
            case XXDelegateNodeTypeAdd:
                if (feeAndQuantyDecimal.doubleValue > self.tokenModel.amount.doubleValue) {
                    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
                    }];
                    [alert showAlert];
                    return;
                }
                break;
            case XXDelegateNodeTypeTransfer:
                 
                break;
            case XXDelegateNodeTypeRelieve:
                if (feeAndQuantyDecimal.doubleValue > self.hadDelegateModel.bonded.doubleValue) {
                    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
                    }];
                    [alert showAlert];
                    return;
                }
                break;
            default:
                 
                break;
        }
        
        
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
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.delegateTransferView.feeView.textField.text];
    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.delegateTransferView.speedView.slider.value]];
    NSString *toAddress = KString(self.validatorModel.operator_address);
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *gas = [[[feeAmountDecimal decimalNumberByDividingBy:gasPriceDecimal] decimalNumberByDividingBy:kPrecisionDecimal_U] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:tokenModel.symbol feeAmount:feeAmount feeGas:gas feeDenom:tokenModel.symbol memo:@"" type:kMsgDelegate withdrawal_fee:@"" text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
    _msgRequest.msgSendSuccessBlock = ^{
        [MBProgressHUD hideHUD];
    };
    _msgRequest.msgSendFaildBlock = ^{
        [MBProgressHUD hideHUD];
    };
}
/// 发起取消委托请求
- (void)requestRelieveDelegate {
    XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.delegateTransferView.amountView.textField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.delegateTransferView.feeView.textField.text];
    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.delegateTransferView.speedView.slider.value]];
    NSString *toAddress = self.validatorModel.operator_address;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *gas = [[[feeAmountDecimal decimalNumberByDividingBy:gasPriceDecimal] decimalNumberByDividingBy:kPrecisionDecimal_U] stringValue];

    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:toAddress amount:amount denom:tokenModel.symbol feeAmount:feeAmount feeGas:gas feeDenom:tokenModel.symbol memo:@"" type:kMsgUndelegate withdrawal_fee:@"" text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
    _msgRequest.msgSendSuccessBlock = ^{
        [MBProgressHUD hideHUD];
    };
    _msgRequest.msgSendFaildBlock = ^{
        [MBProgressHUD hideHUD];
    };
}


#pragma mark 刷新资产
- (void)refreshDelegateAmount{
    self.assetModel = [self.assetManager assetModel];
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

- (XXAssetManager *)assetManager {
    if (!_assetManager) {
        @weakify(self)
        _assetManager = [[XXAssetManager alloc] init];
        _assetManager.assetChangeBlock = ^{
            @strongify(self)
            [self refreshDelegateAmount];
        };
    }
    return _assetManager;
}
@end
