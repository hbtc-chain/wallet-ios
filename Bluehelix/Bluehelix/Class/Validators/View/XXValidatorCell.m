//
//  XXValidatorCell.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorCell.h"
@interface XXValidatorCell ()
@property (nonatomic, strong) UIView *shadowView;
/**验证人*/
@property (nonatomic, strong) XXLabel *validatorName;

@property (nonatomic, strong) UIImageView *validatorStatusImageview;
/**投票权*/
@property (nonatomic, strong) XXLabel *validatorVoteInfo;
@property (nonatomic, strong) XXLabel *validatorVoteValue;
/**自我委托比例*/
@property (nonatomic, strong) XXLabel *validatorDelegateNumberInfo;
@property (nonatomic, strong) XXLabel *validatorDelegateNumberValue;
/**佣金率*/
@property (nonatomic, strong) XXLabel *validatorCommissionRateInfo;
@property (nonatomic, strong) XXLabel *validatorCommissionRateValue;

@end
@implementation XXValidatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.shadowView];
        [self addSubview:self.validatorName];
        
        [self addSubview:self.validatorStatusImageview];
        
        [self addSubview:self.validatorVoteInfo];
        [self addSubview:self.validatorVoteValue];
        
        [self addSubview:self.validatorDelegateNumberInfo];
        [self addSubview:self.validatorDelegateNumberValue];
        
        [self addSubview:self.validatorCommissionRateInfo];
        [self addSubview:self.validatorCommissionRateValue];
    }
    return self;
}
- (void)loadData:(XXValidatorListModel*)model{
    self.validatorName.text = model.validatorDescription.moniker;
    self.validatorVoteValue.text = [NSString stringWithFormat:@"%@%@",model.voting_power_proportion,@"%"];
    self.validatorDelegateNumberValue.text = [NSString stringWithFormat:@"%@%@",model.self_delegate_proportion,@"%"];
    NSNumber *number = [NSNumber numberWithFloat:model.commission.rate.floatValue];
    self.validatorCommissionRateValue.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%.2f",number.floatValue],@"%"];
    if (model.status.intValue == 2) {
        self.validatorVoteValue.textColor = kMainLabelColor;
        self.validatorDelegateNumberValue.textColor = kMainLabelColor;
        self.validatorCommissionRateValue.textColor = kMainLabelColor;
        self.validatorStatusImageview.image = [UIImage imageNamed:@"Validator_valid"];

    } else {
        self.validatorVoteValue.textColor = kSubLabelColor;
        self.validatorDelegateNumberValue.textColor = kSubLabelColor;
        self.validatorCommissionRateValue.textColor = kSubLabelColor;
        self.validatorStatusImageview.image = [UIImage imageNamed:@"Validator_invalid"];
    }
}
#pragma mark layout
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-3);
    }];
    [self.validatorName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(21);
        make.height.mas_equalTo(32);
    }];
    [self.validatorStatusImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.top.mas_equalTo(21);
        make.height.width.mas_equalTo(16);
    }];
    //投票权
    [self.validatorVoteInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(self.validatorName.mas_bottom).offset(8);
        make.height.mas_equalTo(16);
    }];
    [self.validatorVoteValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.validatorVoteInfo);
        make.top.mas_equalTo(self.validatorVoteInfo.mas_bottom).offset(0);
        make.height.mas_equalTo(28);
    }];
    //自我委托
    [self.validatorDelegateNumberInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(-32);
        make.top.mas_equalTo(self.validatorName.mas_bottom).offset(8);
        make.height.mas_equalTo(16);
    }];
    [self.validatorDelegateNumberValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.validatorDelegateNumberInfo);
        make.top.mas_equalTo(self.validatorDelegateNumberInfo.mas_bottom).offset(0);
        make.height.mas_equalTo(28);
    }];
    //佣金率
    [self.validatorCommissionRateInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.top.mas_equalTo(self.validatorName.mas_bottom).offset(8);
        make.height.mas_equalTo(16);
    }];
    [self.validatorCommissionRateValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.validatorCommissionRateInfo);
        make.top.mas_equalTo(self.validatorCommissionRateInfo.mas_bottom).offset(0);
        make.height.mas_equalTo(28);
    }];
}

#pragma mark lazy load
- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectZero];
        //_shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        _shadowView = [[UIView alloc]initWithFrame:CGRectZero];
        _shadowView.clipsToBounds = NO;
        _shadowView.backgroundColor = kBackgroundLeverSecond;
        _shadowView.layer.cornerRadius = 10.0;
        _shadowView.layer.shadowColor = [kShadowColor CGColor];
        _shadowView.layer.shadowRadius = 6.0;
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 3);
    }
    return _shadowView;;
}
- (XXLabel*)validatorName{
    if (!_validatorName) {
        _validatorName = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFontBold17 textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _validatorName;;
}
- (UIImageView*)validatorStatusImageview{
    if (!_validatorStatusImageview) {
        _validatorStatusImageview = [[UIImageView alloc]initWithFrame:CGRectZero];
        _validatorStatusImageview.image = [UIImage imageNamed:@"Validator_invalid"];
    }
    return _validatorStatusImageview;;
}
//
- (XXLabel *)validatorVoteInfo{
    if (!_validatorVoteInfo) {
        _validatorVoteInfo = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ValidatorVote") font:kFont13 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _validatorVoteInfo;
}
- (XXLabel *)validatorVoteValue{
    if (!_validatorVoteValue) {
        _validatorVoteValue = [XXLabel labelWithFrame:CGRectZero text:@"" font:kNumberFont(15) textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _validatorVoteValue;
}
//
- (XXLabel *)validatorDelegateNumberInfo{
    if (!_validatorDelegateNumberInfo) {
        _validatorDelegateNumberInfo = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ValidatorDelegateNumber") font:kFont13 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _validatorDelegateNumberInfo;
}
- (XXLabel *)validatorDelegateNumberValue{
    if (!_validatorDelegateNumberValue) {
        _validatorDelegateNumberValue = [XXLabel labelWithFrame:CGRectZero text:@"" font:kNumberFont(15) textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _validatorDelegateNumberValue;
}
//
- (XXLabel *)validatorCommissionRateInfo{
    if (!_validatorCommissionRateInfo) {
        _validatorCommissionRateInfo = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ValidatorCommissionRate") font:kFont13 textColor:kGray500 alignment:NSTextAlignmentRight];
    }
    return _validatorCommissionRateInfo;
}
- (XXLabel *)validatorCommissionRateValue{
    if (!_validatorCommissionRateValue) {
        _validatorCommissionRateValue = [XXLabel labelWithFrame:CGRectZero text:@"" font:kNumberFont(15) textColor:kGray900 alignment:NSTextAlignmentRight];
    }
    return _validatorCommissionRateValue;
}
@end
