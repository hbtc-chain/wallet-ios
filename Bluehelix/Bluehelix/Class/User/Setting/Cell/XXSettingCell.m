//
//  XXSettingCell.m
//  Bhex
//
//  Created by BHEX on 2018/7/25.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXSettingCell.h"
#import "XXTabBarController.h"
#import "XXSettingVC.h"

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

- (void)setupUI {
    
    [self.contentView addSubview:self.rightIconImageView];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeSwitch];
    [self.contentView addSubview:self.lineView];
}

- (void)switchAction:(UISwitch *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.isOn, self.indexCell);
    }
}

- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KLeftSpace_20, 0, 130, [XXSettingCell getCellHeight]) font:kFont15 textColor:kGray900];
    }
    return _nameLabel;
}

- (XXLabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [XXLabel labelWithFrame:CGRectMake(KLeftSpace_20 + 130, 0, kScreen_Width - KLeftSpace_20 - 162, [XXSettingCell getCellHeight]) font:kFont15 textColor:kGray500];
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

- (UISwitch *)typeSwitch {
    if (_typeSwitch == nil) {
        _typeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 70, 0, 0)];
        _typeSwitch.frame = CGRectMake(kScreen_Width - KLeftSpace_20 - _typeSwitch.width, ([XXSettingCell getCellHeight] - _typeSwitch.height)/2, _typeSwitch.width, _typeSwitch.height);
        //添加事件监听
        [_typeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
      
        //定制开关颜色UI
        _typeSwitch.backgroundColor = kGray100;
        _typeSwitch.layer.cornerRadius = _typeSwitch.height/2;
        _typeSwitch.layer.masksToBounds = YES;
        
        //tintColor 关状态下的背景颜色
//        _typeSwitch.tintColor = [UIColor clearColor];
        
        //onTintColor 开状态下的背景颜色
//        _typeSwitch.onTintColor = kPrimaryMain;
        _typeSwitch.onImage = [UIImage imageNamed:@"inMoney"];

        //thumbTintColor 滑块的背景颜色
//        _typeSwitch.thumbTintColor = kWhite100;
        
    }
    return _typeSwitch;
}

+ (CGFloat)getCellHeight {
    return K375(56);
}


@end
