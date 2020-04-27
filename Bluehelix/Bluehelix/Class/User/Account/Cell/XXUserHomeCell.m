//
//  XXUserHomeCell.m
//  Bhex
//
//  Created by BHEX on 2018/7/1.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXUserHomeCell.h"

@interface XXUserHomeCell ()

@end

@implementation XXUserHomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.contentView.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.rightIconImageView];
    [self.contentView addSubview:self.lineView];
}

- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), 16, kScreen_Width - K375(50), 24) font:kFont15 textColor:kGray900];
    }
    return _nameLabel;
}

- (XXLabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [XXLabel labelWithFrame:CGRectMake(kScreen_Width - K375(16) - 100, 16, 100, 24) font:kFont15 textColor:kGray500];
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel;
}

- (UIImageView *)rightIconImageView {
    if (_rightIconImageView == nil) {
        _rightIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - K375(36), ([XXUserHomeCell getCellHeight] - 24)/2, 24, 24)];
        _rightIconImageView.image = [UIImage subTextImageName:@"me_arrow"];
    }
    return _rightIconImageView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, [XXUserHomeCell getCellHeight] - 1, kScreen_Width, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}


+ (CGFloat)getCellHeight {
    return 57;
}

@end
