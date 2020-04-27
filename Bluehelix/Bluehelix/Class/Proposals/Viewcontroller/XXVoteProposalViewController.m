//
//  XXVoteProposalViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXVoteProposalViewController.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXPasswordView.h"
#import "XXTokenModel.h"

@interface XXVoteProposalViewController ()
/**提交按钮*/
@property (nonatomic, strong) XXButton *transferButton;
/**资产请求*/
@property (nonatomic, strong) XXAssetManager *assetManager;
/**资产数据*/
@property (nonatomic, strong) XXAssetModel *assetModel;

@property (strong, nonatomic) NSString *text;
/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;
@end

@implementation XXVoteProposalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self configAsset];
}
- (void)createUI{
    self.titleLabel.text = LocalizedString(@"VotingProposal");
    [self.view addSubview:self.addProposalView];
    [self.view addSubview:self.transferButton];
}
#pragma mark load data
- (void)configAsset {
    @weakify(self)
    
    self.assetManager.assetChangeBlock = ^{
        @strongify(self)
        [self refreshAssetAmount];
    };
}
#pragma mark 刷新资产
- (void)refreshAssetAmount{
    self.assetModel = [self.assetManager assetModel];
    for (XXTokenModel *tokenModel in self.assetModel.assets) {
        if ([[tokenModel.symbol uppercaseString] isEqualToString:[kMainToken uppercaseString]]) {
            [self.addProposalView refreshAssets:tokenModel];
            break;
        }
    }
}
#pragma mark 发起提案
- (void)transferVerify {
    @weakify(self)
    if (self.addProposalView.propotalTitleView.textField.text.length && self.addProposalView.proposalDescriptionView.textView.text.length&& self.addProposalView.amountView.textField.text.length && self.addProposalView.feeView.textField.text.length) {
        MJWeakSelf
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            @strongify(self)
            weakSelf.text = text;
            [self requestCreateProposal];
           }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PleaseFillAll") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}
/// 发起委托请求
- (void)requestCreateProposal {
    NSString *proposalTitle = self.addProposalView.propotalTitleView.textField.text;
    NSString *proposalDescription = self.addProposalView.proposalDescriptionView.textView.text;
    XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.addProposalView.amountView.textField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.addProposalView.feeView.textField.text];
    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.addProposalView.speedView.slider.value]];
    //NSString *toAddress = self.addProposalView.addressView.textField.text;
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
                                                         type:kMsgCreateProposal
                                                 proposalType:@"hbtcchain/gov/TextProposal"
                                                proposalTitle:proposalTitle
                                          proposalDescription:proposalDescription
                                                   proposalId:@""
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
#pragma mark lazy load
- (XXAddProposalView *)addProposalView {
    if (!_addProposalView ) {
        _addProposalView = [[XXAddProposalView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 64)];
        _addProposalView.scrollEnabled = YES;
        _addProposalView.showsVerticalScrollIndicator = YES;
    }
    return _addProposalView;
}
/** 按钮 */
- (XXButton *)transferButton {
    if (!_transferButton) {
        @weakify(self)
        _transferButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 64, kScreen_Width - KSpacing*2, 48) title:@"" font:kFontBold14 titleColor:kMainTextColor block:^(UIButton *button) {
            @strongify(self)
            [self transferVerify];
        }];
        _transferButton.backgroundColor = kPrimaryMain;
        _transferButton.layer.cornerRadius = 3;
        _transferButton.layer.masksToBounds = YES;
        [_transferButton setTitle:LocalizedString(@"ProposalButtonTitleSubmit") forState:UIControlStateNormal];
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
            [self refreshAssetAmount];
        };
    }
    return _assetManager;
}
@end
