//
//  XXValidatorHeader.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorHeader.h"

@implementation XXValidatorHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.headerBackgroundImageview];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.headerBackgroundImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(8);
        make.width.height.mas_equalTo(148);
    }];
}
#pragma mark lazy load

- (XXLabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ValidatorTitle") font:kFontBold(30) textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _titleLabel;;
}
- (UIImageView*)headerBackgroundImageview{
    if (!_headerBackgroundImageview) {
        _headerBackgroundImageview = [[UIImageView alloc]initWithFrame:CGRectZero];
        _headerBackgroundImageview.image = [UIImage imageNamed:@"validator_head_background"];
    }
    return _headerBackgroundImageview;
}

@end
