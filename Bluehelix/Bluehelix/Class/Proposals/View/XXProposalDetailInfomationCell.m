//
//  XXProposalDetailInfomationCell.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalDetailInfomationCell.h"

@implementation XXProposalDetailInfomationCell

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
        _detailLabelInfo = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ProposalDescripition") font:kFont13 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _detailLabelInfo;
}
- (UITextView *)detailLabelValue{
    if (!_detailLabelValue) {
        _detailLabelValue = [[UITextView alloc]initWithFrame:CGRectZero];
        _detailLabelValue.backgroundColor = kWhiteColor;
        _detailLabelValue.textAlignment = NSTextAlignmentLeft;
        _detailLabelValue.font = kFont15;
        _detailLabelValue.editable = NO;
        _detailLabelValue.textColor = kGray900;
        _detailLabelValue.scrollEnabled = NO;
    }
    return _detailLabelValue;;
}

@end
