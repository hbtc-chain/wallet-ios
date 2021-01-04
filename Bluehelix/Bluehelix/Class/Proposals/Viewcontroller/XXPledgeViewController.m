//
//  XXPledgeViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXPledgeViewController.h"

#import "XXPledgeView.h"
#import "XXPasswordAlertView.h"
#import "XXTokenModel.h"
#import "XXHadDelegateModel.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXAssetSingleManager.h"

@interface XXPledgeViewController ()
/**view*/
@property (nonatomic, strong) XXPledgeView *pledgeView;
/**按钮*/
@property (nonatomic, strong) XXButton *transferButton;
/**资产数据*/
@property (nonatomic, strong) XXAssetModel *assetModel;

@property (strong, nonatomic) NSString *text;

/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;
/**币资产模型*/
@property (nonatomic, strong) XXTokenModel *tokenModel;

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
    //    @weakify(self)
    //     [XXAssetSingleManager sharedManager].assetChangeBlock = ^{
    //        @strongify(self)
    //        [self refreshPledgeAmount];
    //    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPledgeAmount) name:kNotificationAssetRefresh object:nil];
}
#pragma mark 刷新资产
- (void)refreshPledgeAmount{
    self.assetModel = [XXAssetSingleManager sharedManager].assetModel;
    for (XXTokenModel *tokenModel in self.assetModel.assets) {
        if ([[tokenModel.symbol uppercaseString] isEqualToString:[kMainToken uppercaseString]]) {
            self.tokenModel = tokenModel;
            [self.pledgeView refreshAssets:tokenModel];
            break;
        }
    }
}
#pragma mark privity
- (void)transferVerify {
    @weakify(self)
    if (self.pledgeView.amountView.textField.text.length && self.pledgeView.feeView.textField.text.length) {
        if (self.pledgeView.feeView.textField.text.doubleValue > self.tokenModel.amount.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        if (kShowPassword) {
            [XXPasswordAlertView showWithSureBtnBlock:^{
                @strongify(self)
                [self requestPledge];
            }];
        } else {
            [self requestPledge];
        }
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
    //    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.pledgeView.speedView.slider.value]];
    //    NSString *toAddress = self.pledgeView.addressView.textField.text;
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    //    NSString *gas = [[[feeAmountDecimal decimalNumberByDividingBy:gasPriceDecimal] decimalNumberByDividingBy:kPrecisionDecimal_U] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initProposalMessageWithfrom:KUser.address
                                                           to:@""
                                                       amount:amount
                                                        denom:tokenModel.symbol
                                                    feeAmount:feeAmount
                                                       feeGas:@""
                                                     feeDenom:tokenModel.symbol
                                                         memo:tokenModel.symbol
                                                         type:kMsgPledge
                                                 proposalType:@""
                                                proposalTitle:@""
                                          proposalDescription:@""
                                                   proposalId:self.proposalModel.proposalId
                                               proposalOption:@""
                                               withdrawal_fee:@""];
    
    
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
#pragma mark set/get

#pragma mark lazy load
- (XXPledgeView *)pledgeView {
    if (!_pledgeView ) {
        _pledgeView = [[XXPledgeView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 64 - 8)];
        // _delegateTransferView.delegateNodeType = self.delegateNodeType;
    }
    return _pledgeView;
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
@end
