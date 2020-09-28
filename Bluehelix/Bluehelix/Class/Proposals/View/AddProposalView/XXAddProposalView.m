//
//  XXAddProposalView.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAddProposalView.h"
#import "XXTokenModel.h"

@interface XXAddProposalView ()
@property (nonatomic, strong) XXTokenModel *tokenModel;
@end
@implementation XXAddProposalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self setupUI];
        [self loadData];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    self.contentSize = CGSizeMake(0, 800);
    // 提币主视图
    [self addSubview:self.mainView];
    
    /** 标题  */
    [self.mainView addSubview:self.propotalTitleView];
    
    /**提案类型*/
    [self.mainView addSubview:self.propotalTypeSelectView];
    
    /**描述*/
    [self.mainView addSubview:self.proposalDescriptionView];
    
    /** 质押数量 */
    [self.mainView addSubview:self.amountView];
    
    /**实际委托数量*/
    //[self.mainView addSubview:self.trueAmountView];

    /** 手续费 */
    [self.mainView addSubview:self.feeView];

    /** 加速视图 */
//    [self.mainView addSubview:self.speedView];

    /** 提示语视图 */
    [self.mainView addSubview:self.tipView];
}

- (void)refreshAssets:(XXTokenModel*)tokenModel{
    self.tokenModel = tokenModel;

    self.amountView.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"ValidatorAvilable"),self.tokenModel.amount,[kMainToken uppercaseString]];
    self.feeView.textField.text = kMinFee;
}
- (void)loadData{

}
#pragma mark lazy load
/** 地址视图 */
- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.height)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

/**提案标题*/
- (XXProposalNormalView *)propotalTitleView {
    if (_propotalTitleView == nil) {
        _propotalTitleView = [[XXProposalNormalView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 96)];
        _propotalTitleView.textField.placeholder = LocalizedString(@"PleaseInputProposalTitle");
        _propotalTitleView.nameLabel.text = LocalizedString(@"ProposalTitle");
        _propotalTitleView.selectButton.hidden = YES;
    }
    return _propotalTitleView;
}
/**提案类型*/
- (XXProposalNormalView *)propotalTypeSelectView {
    if (_propotalTypeSelectView == nil) {
        _propotalTypeSelectView = [[XXProposalNormalView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.propotalTitleView.frame), kScreen_Width, 96)];
        _propotalTypeSelectView.textField.placeholder = LocalizedString(@"PleaseSelectProposalType");
        _propotalTypeSelectView.nameLabel.text = LocalizedString(@"ProposalType");
        _propotalTypeSelectView.selectButton.hidden = YES;
        _propotalTypeSelectView.textField.text = LocalizedString(@"ProposalTypeWord");
        _propotalTypeSelectView.textField.enabled = NO;
    }
    return _propotalTypeSelectView;
}

- (XXProposalDescriptionView*)proposalDescriptionView{
    if (_proposalDescriptionView == nil) {
        _proposalDescriptionView = [[XXProposalDescriptionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.propotalTypeSelectView.frame), kScreen_Width, 180)];
        _proposalDescriptionView.nameLabel.text = LocalizedString(@"ProposalDescripition");
    }
    return _proposalDescriptionView;;
}
/** 质押数量 */
- (XXTransferAmountView *)amountView {
    if (_amountView == nil) {
        _amountView = [[XXTransferAmountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.proposalDescriptionView.frame), kScreen_Width, 110)];
        _amountView.userInteractionEnabled = YES;
        _amountView.nameLabel.text = LocalizedString(@"ProposalPledgeAmount");
        [_amountView.allButton setTitle:[kMainToken uppercaseString] forState:UIControlStateNormal];
        [_amountView.allButton setTitleColor:kGray500 forState:UIControlStateNormal];
        _amountView.allButton.userInteractionEnabled = NO;
        _amountView.textField.placeholder = @"";
        _amountView.allButtonActionBlock = ^{
            
        };
    }
    return _amountView;
}

/** 手续费 */
- (XXWithdrawFeeView *)feeView {
    if (_feeView == nil) {
        _feeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.amountView.frame), kScreen_Width, 96)];
        //_feeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _feeView.textField.enabled = YES;
        _feeView.unitLabel.text = [kMainToken uppercaseString];
    }
    return _feeView;
}

/** 提币加速视图 */
- (XXWithdrawSpeedView *)speedView {
    if (_speedView == nil) {
        _speedView = [[XXWithdrawSpeedView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feeView.frame), kScreen_Width, 72)];
        _speedView.nameLabel.text = LocalizedString(@"TransferSpeed");
//        [_speedView.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _speedView;
}

/** 提示语视图 */
- (XXWithdrawTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [[XXWithdrawTipView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.speedView.frame), kScreen_Width, 10)];
    }
    return _tipView;
}

@end
