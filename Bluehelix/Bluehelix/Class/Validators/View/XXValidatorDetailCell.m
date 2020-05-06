//
//  XXValidatorDetailCell.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/17.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorDetailCell.h"

@implementation XXValidatorDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.labelInfo];
        [self addSubview:self.labelValue];
        [self addSubview:self.rightDetailButton];
    }
    return self;;
}

#pragma mark layout
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.labelInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.height.mas_equalTo(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(56);
    }];
    [self.labelValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightDetailButton.mas_left).mas_equalTo(-8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.labelInfo.mas_right).offset(8);
    }];
    [self.rightDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.height.width.mas_equalTo(24);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark set/get
- (void)setHideDetailButton:(BOOL)hideDetailButton{
    _hideDetailButton = hideDetailButton;
    if (_hideDetailButton) {
        [self.rightDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.1);
            make.height.mas_equalTo(24);
            make.right.mas_equalTo(24);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        self.rightDetailButton.hidden = YES;
        [self.labelValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-24);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.labelInfo.mas_right).offset(8);
        }];
    }else{
        self.rightDetailButton.hidden = NO;
        [self.labelValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rightDetailButton.mas_left).mas_equalTo(-8);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.labelInfo.mas_right).offset(8);
        }];
        [self.rightDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-24);
            make.height.width.mas_equalTo(24);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }

}
#pragma mark lazy load
- (XXLabel *)labelInfo{
    if (!_labelInfo) {
        _labelInfo = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont13 textColor:kSubLabelColor alignment:NSTextAlignmentLeft];
    }
    return _labelInfo;;
}
- (XXLabel *)labelValue{
    if (!_labelValue) {
        _labelValue = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont13 textColor:kMainLabelColor alignment:NSTextAlignmentRight];;
        _labelValue.adjustsFontSizeToFitWidth = YES;
    }
    return _labelValue;;
}
- (XXButton*)rightDetailButton{
    @weakify(self)
    if (!_rightDetailButton) {
        _rightDetailButton = [XXButton buttonWithFrame:CGRectZero title:@"" font:kFont13 titleColor:kMainLabelColor block:^(UIButton *button) {
            @strongify(self)
            
            if (self.labelValue.text.length > 0) {
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:self.validatorModel.operator_address];
                [MBProgressHUD showSuccessMessage:LocalizedString(@"CopySuccessfully")];
            }
        }];
        [_rightDetailButton setImage:[UIImage imageNamed:@"ValidatorPaste"] forState:UIControlStateNormal] ;
    }
    return _rightDetailButton;
}
@end
