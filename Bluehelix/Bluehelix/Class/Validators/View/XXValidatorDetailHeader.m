//
//  XXValidatorDetailHeader.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/17.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorDetailHeader.h"

@interface XXValidatorDetailHeader ()
@property (nonatomic, strong) XXLabel *validatorTitleLabel;
@property (nonatomic, strong) XXButton *validatorStatuesButton;
@end
@implementation XXValidatorDetailHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.validatorTitleLabel];
        [self addSubview:self.validatorStatuesButton];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.validatorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(self.validatorStatuesButton.mas_left);
        make.height.mas_greaterThanOrEqualTo(48);
        make.bottom.mas_equalTo(-16);
    }];
    [self.validatorStatuesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(32);
        make.width.mas_greaterThanOrEqualTo(64);
    }];
}
#pragma mark set/get
- (void)setValidOrInvalid:(NSString *)validOrInvalid{
    _validOrInvalid = validOrInvalid;
    if ([_validOrInvalid isEqualToString:@"1"]) {
        [self.validatorStatuesButton setTitle:LocalizedString(@"valid") forState:UIControlStateNormal];
        [self.validatorStatuesButton setImage:[UIImage imageNamed:@"Validator_valid"] forState:UIControlStateNormal];
    }else{
        [self.validatorStatuesButton setTitle:LocalizedString(@"invalid") forState:UIControlStateNormal];
        [self.validatorStatuesButton setImage:[UIImage imageNamed:@"Validator_invalid"] forState:UIControlStateNormal];
    }
}
- (void)setValidatorModel:(XXValidatorListModel *)validatorModel{
    _validatorModel = validatorModel;
    self.validatorTitleLabel.text = _validatorModel.validatorDescription.moniker;
}
#pragma mark lazy load
- (XXLabel *)validatorTitleLabel{
    if (!_validatorTitleLabel) {
        _validatorTitleLabel = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFontBold20 textColor:kDark100 alignment:NSTextAlignmentLeft];
        _validatorTitleLabel.numberOfLines = 0;
    }
    return _validatorTitleLabel;
}
- (XXButton*)validatorStatuesButton{
    if (!_validatorStatuesButton) {
        _validatorStatuesButton = [XXButton buttonWithFrame:CGRectZero title:@"" font:kFontBold13 titleColor:kGreen100 block:^(UIButton *button) {
            
        }];
        _validatorStatuesButton.layer.cornerRadius = 16;
    }
    return _validatorStatuesButton;;
}
@end
