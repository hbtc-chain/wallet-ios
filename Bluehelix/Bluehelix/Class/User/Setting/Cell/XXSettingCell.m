//
//  XXSettingCell.m
//  Bhex
//
//  Created by BHEX on 2018/7/25.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXSettingCell.h"

@interface XXSettingCell ()


@end


@implementation XXSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        
        [self setupUI];
        
    }
    return self;
}

#pragma mark - 1. 创建主界面
- (void)setupUI {
    
    [self.contentView addSubview:self.rightIconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.lineView];
}

#pragma mark - || 懒加载
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KLeftSpace_20, 0, 150, [XXSettingCell getCellHeight]) font:kFont16 textColor:kDark100];
    }
    return _nameLabel;
}

- (XXLabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [XXLabel labelWithFrame:CGRectMake(kScreen_Width - 148, 0, 100, [XXSettingCell getCellHeight]) font:kFont12 textColor:kDark50];
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(KLeftSpace_20, [XXSettingCell getCellHeight] - KLine_Height, kScreen_Width - KLeftSpace_20, KLine_Height)];
    }
    return _lineView;
}

- (UIImageView *)rightIconImageView {
    if (_rightIconImageView == nil) {
        _rightIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 32, ([XXSettingCell getCellHeight] - 13)/2, 8, 13)];
        _rightIconImageView.image = [UIImage subTextImageName:@"me_arrow"];
    }
    return _rightIconImageView;
}

+ (CGFloat)getCellHeight {
    return K375(56);
}


@end
