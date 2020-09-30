//
//  XXDelegateTransferView.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXDelegateTransferView.h"
#import "XXTokenModel.h"

@interface XXDelegateTransferView ()
/**委托数据模型*/
@property (nonatomic, strong) XXTokenModel *tokenModel;
/**撤销委托数据模型*/
@property (nonatomic, strong) XXHadDelegateModel *hadDelegateModel;
@end
@implementation XXDelegateTransferView

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
    self.contentSize = CGSizeMake(0, 700);
    // 提币主视图
    [self addSubview:self.mainView];
    /**提示文案*/
    [self.mainView addSubview:self.transferTipView];
    /** 地址  */
    [self.mainView addSubview:self.addressView];
    
    /** 委托数量 */
    [self.mainView addSubview:self.amountView];
    
    /**实际委托数量*/
    //[self.mainView addSubview:self.trueAmountView];

    /** 手续费 */
    [self.mainView addSubview:self.feeView];

    /** 加速视图 */
    [self.mainView addSubview:self.speedView];

    /** 提示语视图 */
    [self.mainView addSubview:self.tipView];
}

- (void)loadData{
    switch (self.delegateNodeType) {
        case 0:
            self.addressView.textField.text = KUser.address;
            self.amountView.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"ValidatorAvilable"),@"--",[kMainToken uppercaseString]];
            break;
        case 1:
            self.amountView.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"ValidatorAvilableTransfer"),@"--",[kMainToken uppercaseString]];
            break;
            
        default:
            self.addressView.textField.text = KUser.address;
            self.amountView.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"ValidatorAvilableRelieve"),@"--",[kMainToken uppercaseString]];
            break;
    }
}
- (void)refreshAssets:(XXTokenModel*)tokenModel{
    self.tokenModel = tokenModel;
    switch (self.delegateNodeType) {
        case XXDelegateNodeTypeAdd:
            self.amountView.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"ValidatorAvilable"),self.tokenModel.amount,[kMainToken uppercaseString]];
            self.feeView.textField.text = kMinFee;
            break;
        case XXDelegateNodeTypeTransfer:
            self.amountView.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"ValidatorAvilableTransfer"),self.tokenModel.amount,[kMainToken uppercaseString]];
            self.feeView.textField.text = kMinFee;
            break;
        case XXDelegateNodeTypeRelieve:

        break;
        default:
            
            break;
    }
}
- (void)refreshRelieveAssets:(XXHadDelegateModel*)hadDelegateModel {
    self.hadDelegateModel = hadDelegateModel;
    self.amountView.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"ValidatorAvilableRelieve"),hadDelegateModel.bonded,[kMainToken uppercaseString]];
    self.feeView.textField.text = kMinFee;
}
- (void)reloadTransferData{
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.tokenModel.amount];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.feeView.textField.text];
    NSString *availableAmount = [[amountDecimal decimalNumberBySubtracting:feeAmountDecimal] stringValue];
    switch (self.delegateNodeType) {
        case XXDelegateNodeTypeAdd:
            self.amountView.textField.text = availableAmount;
            break;
        case XXDelegateNodeTypeTransfer:
            self.amountView.textField.text = availableAmount;
            break;
        case XXDelegateNodeTypeRelieve:
            self.amountView.textField.text = [NSString stringWithFormat:@"%@",KString(self.hadDelegateModel.bonded)];
                   
            break;
        break;
        default:
            
            break;
    }
}

#pragma mark set/get
- (void)setDelegateNodeType:(XXDelegateNodeType)delegateNodeType{
    _delegateNodeType = delegateNodeType;
    switch (self.delegateNodeType) {
        case 0:
            self.addressView.nameLabel.text =  LocalizedString(@"DelegateTo");
            self.amountView.nameLabel.text = [NSString stringWithFormat:@"%@%@",LocalizedString(@"Delegate"),LocalizedString(@"ValidatorDelegateAmount")];
            self.addressView.selectAddressButton.hidden = YES;
            break;
        case 1:
             self.addressView.nameLabel.text =  LocalizedString(@"DelegateFrom");
             self.amountView.nameLabel.text = [NSString stringWithFormat:@"%@%@",LocalizedString(@"TransferDelegate"),LocalizedString(@"ValidatorDelegateAmount")];
            self.addressView.selectAddressButton.hidden = NO;
            break;
            
        default:
             self.addressView.nameLabel.text =  LocalizedString(@"DelegateRelieveTo");
            self.amountView.nameLabel.text = [NSString stringWithFormat:@"%@%@",LocalizedString(@"RelieveDelegate"),LocalizedString(@"ValidatorDelegateAmount")];
            self.addressView.selectAddressButton.hidden = YES;
            break;
    }

}

-(void)sliderValueChanged:(UISlider *)slider {
    self.feeView.textField.text = [NSString stringWithFormat:@"%.3f",slider.value];
}

#pragma mark lazy load
/** 地址视图 */
- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 500)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}
- (XXTransferTipView *)transferTipView {
    if (_transferTipView == nil) {
        _transferTipView = [[XXTransferTipView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 136)];
    }
    return _transferTipView;
}
- (XXDelegateAddressView *)addressView {
    if (_addressView == nil) {
        _addressView = [[XXDelegateAddressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.transferTipView.frame), kScreen_Width, 96)];
        _addressView.textField.placeholder = LocalizedString(@"PleaseSelectValidator");
        _addressView.textField.enabled = NO;
    }
    return _addressView;
}

/** 委托数量 */
- (XXTransferAmountView *)amountView {
    @weakify(self)
    if (_amountView == nil) {
        _amountView = [[XXTransferAmountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame), kScreen_Width, 110)];
        _amountView.textField.enabled = YES;
        [_amountView.allButton setTitle:LocalizedString(@"DelegateAll") forState:UIControlStateNormal];
        _amountView.textField.placeholder = @"";
        _amountView.allButtonActionBlock = ^{
            @strongify(self)
            [self reloadTransferData];
        };
    }
    return _amountView;
}
///** 实际委托数量 */
//- (XXWithdrawFeeView *)trueAmountView {
//    if (_trueAmountView == nil) {
//        _trueAmountView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.amountView.frame), kScreen_Width, 96)];
//        _trueAmountView.nameLabel.text = LocalizedString(@"DelegateTrueAmount");
//        _trueAmountView.textField.enabled = NO;
//        _trueAmountView.unitLabel.text = [kMainToken uppercaseString];
//    }
//    return _trueAmountView;
//}

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
        [_speedView.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
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
