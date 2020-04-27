//
//  XXPledgeViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXPledgeViewController.h"

#import "XXPledgeView.h"
#import "XXPasswordView.h"
#import "XXTokenModel.h"
#import "XXHadDelegateModel.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXAssetManager.h"

@interface XXPledgeViewController ()
/**view*/
@property (nonatomic, strong) XXPledgeView *pledgeView;
/**按钮*/
@property (nonatomic, strong) XXButton *transferButton;
/**资产数据*/
@property (nonatomic, strong) XXAssetModel *assetModel;
/**资产请求*/
@property (nonatomic, strong) XXAssetManager *assetManager;

@property (strong, nonatomic) NSString *text;

/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;

@end

@implementation XXPledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self configAsset];
}
- (void)createUI{
    self.titleLabel.text = LocalizedString(@"ProposalNavgationTitlePledge");
    [self.view addSubview:self.pledgeView];
    [self.view addSubview:self.transferButton];
}
#pragma mark load data
- (void)configAsset {
    @weakify(self)
    self.assetManager.assetChangeBlock = ^{
        @strongify(self)
        [self refreshPledgeAmount];
    };
}
#pragma mark 刷新资产
- (void)refreshPledgeAmount{
    self.assetModel = [self.assetManager assetModel];
    for (XXTokenModel *tokenModel in self.assetModel.assets) {
        if ([[tokenModel.symbol uppercaseString] isEqualToString:[kMainToken uppercaseString]]) {
            [self.pledgeView refreshAssets:tokenModel];
            break;
        }
    }
}
#pragma mark privity
- (void)transferVerify {
    @weakify(self)
    if (self.pledgeView.amountView.textField.text.length && self.pledgeView.feeView.textField.text.length) {
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            @strongify(self)
            self.text = text;
            [self requestPledge];
           }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PleaseFillAll") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}
/// 发起委托请求
- (void)requestPledge {
    XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.pledgeView.amountView.textField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.pledgeView.feeView.textField.text];
    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.pledgeView.speedView.slider.value]];
//    NSString *toAddress = self.pledgeView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *gas = [[[feeAmountDecimal decimalNumberByDividingBy:gasPriceDecimal] decimalNumberByDividingBy:kPrecisionDecimal_U] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initProposalMessageWithfrom:KUser.address
                                                              to:@""
                                                          amount:amount
                                                           denom:tokenModel.symbol
                                                       feeAmount:feeAmount
                                                          feeGas:gas
                                                        feeDenom:tokenModel.symbol
                                                            memo:tokenModel.symbol
                                                            type:kMsgPledge
                                                    proposalType:@""
                                                   proposalTitle:@""
                                              proposalDescription:@""
                                                    proposalId:self.proposalModel.proposalId
                                                  proposalOption:@""
                                                  withdrawal_fee:@""
                                                            text:self.text];
                    
                    
    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
    _msgRequest.msgSendSuccessBlock = ^{
        [MBProgressHUD hideHUD];
    };
    _msgRequest.msgSendFaildBlock = ^{
        [MBProgressHUD hideHUD];
    };
}
#pragma mark set/get

#pragma mark lazy load
- (XXPledgeView *)pledgeView {
    if (!_pledgeView ) {
        _pledgeView = [[XXPledgeView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 64)];
       // _delegateTransferView.delegateNodeType = self.delegateNodeType;
    }
    return _pledgeView;
}
/** 按钮 */
- (XXButton *)transferButton {
    if (!_transferButton) {
        MJWeakSelf
        _transferButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 64, kScreen_Width - KSpacing*2, 48) title:@"" font:kFontBold14 titleColor:kMainTextColor block:^(UIButton *button) {
            [weakSelf transferVerify];
        }];
        _transferButton.backgroundColor = kPrimaryMain;
        _transferButton.layer.cornerRadius = 3;
        _transferButton.layer.masksToBounds = YES;
        [_transferButton setTitle:LocalizedString(@"ProposalButtonTitlePledge") forState:UIControlStateNormal];

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
            [self refreshPledgeAmount];
        };
    }
    return _assetManager;
}
@end
