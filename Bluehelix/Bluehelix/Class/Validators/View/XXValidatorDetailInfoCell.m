//
//  XXValidatorDetailInfoCell.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/17.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorDetailInfoCell.h"

@implementation XXValidatorDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.detailLabelInfo];
        [self addSubview:self.detailLabelValue];
    }
    return self;
}
- (void)layoutSubviews{
    [self.detailLabelInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(24);
        make.height.mas_equalTo(32);
    }];
    [self.detailLabelValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabelInfo.mas_bottom);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(-8);
    }];
}
#pragma mark lazy load
- (XXLabel*)detailLabelInfo{
    if (!_detailLabelInfo) {
        _detailLabelInfo = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ValidatorDetailInfo") font:kFont13 textColor:kSubLabelColor alignment:NSTextAlignmentLeft];
    }
    return _detailLabelInfo;
}
- (XXLabel *)detailLabelValue{
    if (!_detailLabelValue) {
        _detailLabelValue = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont13 textColor:kMainLabelColor alignment:NSTextAlignmentLeft];
        _detailLabelValue.numberOfLines = 0;
        _detailLabelValue.backgroundColor = kWhiteColor;
    }
    return _detailLabelValue;;
}
@end
