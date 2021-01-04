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
#import "XXPasswordAlertView.h"
#import "XXTokenModel.h"
#import "XXAssetSingleManager.h"

@interface XXVoteProposalViewController ()
/**提交按钮*/
@property (nonatomic, strong) XXButton *transferButton;

/**资产数据*/
@property (nonatomic, strong) XXAssetModel *assetModel;

@property (strong, nonatomic) NSString *text;
/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;

/**资产模型*/
@property (nonatomic, strong) XXTokenModel *tokenModel;

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
    //    @weakify(self)
    //     [XXAssetSingleManager sharedManager].assetChangeBlock = ^{
    //        @strongify(self)
    //        [self refreshAssetAmount];
    //    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAssetAmount) name:kNotificationAssetRefresh object:nil];
}
#pragma mark 刷新资产
- (void)refreshAssetAmount{
    self.assetModel = [XXAssetSingleManager sharedManager].assetModel;
    for (XXTokenModel *tokenModel in self.assetModel.assets) {
        if ([[tokenModel.symbol uppercaseString] isEqualToString:[kMainToken uppercaseString]]) {
            self.tokenModel = tokenModel;
            [self.addProposalView refreshAssets:tokenModel];
            break;
        }
    }
}
#pragma mark 发起提案
- (void)transferVerify {
    if ([self.addProposalView.amountView.textField.text trimmingCharacters].doubleValue < 100000) {
        [MBProgressHUD showErrorMessage:LocalizedString(@"CreateProposalAmoutMustMoreTip")];
        return;
    }
    @weakify(self)
    if (self.addProposalView.propotalTitleView.textField.text.length && self.addProposalView.proposalDescriptionView.textView.text.length&& self.addProposalView.amountView.textField.text.length && self.addProposalView.feeView.textField.text.length) {
        
        NSDecimalNumber *feeAndQuantyDecimal =  [[NSDecimalNumber decimalNumberWithString:self.addProposalView.amountView.textField.text]decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:self.addProposalView.feeView.textField.text]];
        if (feeAndQuantyDecimal.doubleValue > self.tokenModel.amount.doubleValue) {
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"FeeNotEnough") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
            return;
        }
        if (kShowPassword) {
            [XXPasswordAlertView showWithSureBtnBlock:^{
                @strongify(self)
                [self requestCreateProposal];
            }];
        } else {
            [self requestCreateProposal];
        }
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
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initProposalMessageWithfrom:KUser.address
                                                           to:@""
                                                       amount:amount
                                                        denom:tokenModel.symbol
                                                    feeAmount:feeAmount
                                                       feeGas:@""
                                                     feeDenom:tokenModel.symbol
                                                         memo:tokenModel.symbol
                                                         type:kMsgCreateProposal
                                                 proposalType:@"hbtcchain/gov/TextProposal"
                                                proposalTitle:proposalTitle
                                          proposalDescription:proposalDescription
                                                   proposalId:@""
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
#pragma mark lazy load
- (XXAddProposalView *)addProposalView {
    if (!_addProposalView ) {
        _addProposalView = [[XXAddProposalView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 64 - 8)];
        _addProposalView.scrollEnabled = YES;
        _addProposalView.showsVerticalScrollIndicator = YES;
    }
    return _addProposalView;
}
/** 按钮 */
- (XXButton *)transferButton {
    if (!_transferButton) {
        @weakify(self)
        _transferButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 64- 8, kScreen_Width - KSpacing*2, 48) title:@"" font:kFontBold17 titleColor:kWhiteNoChange block:^(UIButton *button) {
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

@end
