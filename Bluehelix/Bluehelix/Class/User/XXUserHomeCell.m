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
        
        self.backgroundColor = kWhite100;
      
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 创建主界面
- (void)setupUI {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.rightIconImageView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.leftIconImageView];
}


#pragma mark - || 懒加载
- (XXButton *)leftIconImageView {
    if (_leftIconImageView == nil) {
        _leftIconImageView = [[XXButton alloc] initWithFrame:CGRectMake(K375(32) - 12, ([XXUserHomeCell getCellHeight] - 48)/2, 48, 48)];
        _leftIconImageView.userInteractionEnabled = NO;
    }
    return _leftIconImageView;
}

- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(72), 16, K375(249), 24) font:kFont16 textColor:kDark100];
    }
    return _nameLabel;
}

- (XXLabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [XXLabel labelWithFrame:CGRectMake(K375(104), 16, K375(224), 24) text:@"" font:kFont12 textColor:kDark50 alignment:NSTextAlignmentRight];
    }
    return _valueLabel;
}


- (UIImageView *)rightIconImageView {
    if (_rightIconImageView == nil) {
        _rightIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - K375(36), ([XXUserHomeCell getCellHeight] - 13)/2, 8, 13)];
        _rightIconImageView.image = [UIImage subTextImageName:@"me_arrow"];
    }
    return _rightIconImageView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(K375(71), [XXUserHomeCell getCellHeight] - 1, kScreen_Width - K375(71), 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}


+ (CGFloat)getCellHeight {
    return 57;
}

@end
