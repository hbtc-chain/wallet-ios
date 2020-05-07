//
//  XXProposalDetailTableViewCell.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalDetailTableViewCell.h"

@implementation XXProposalDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.labelInfo];
        [self addSubview:self.labelValue];
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
        make.right.mas_equalTo(-24);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.labelInfo.mas_right).offset(8);
    }];
}

#pragma mark lazy load
- (XXLabel *)labelInfo{
    if (!_labelInfo) {
        _labelInfo = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont15 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _labelInfo;;
}
- (XXLabel *)labelValue{
    if (!_labelValue) {
        _labelValue = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont15 textColor:kGray900 alignment:NSTextAlignmentRight];;
        _labelValue.adjustsFontSizeToFitWidth = YES;
    }
    return _labelValue;;
}

@end
