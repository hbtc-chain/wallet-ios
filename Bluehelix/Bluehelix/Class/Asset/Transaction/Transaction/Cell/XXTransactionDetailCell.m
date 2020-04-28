//
//  XXTransactionDetailCell.m
//  Bluehelix
//
//  Created by 袁振 on 2020/4/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransactionDetailCell.h"

@interface XXTransactionDetailCell ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation XXTransactionDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kViewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.lineView];
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(24, 12, kScreen_Width - 48, 24) text:@"" font:kFont13 textColor:kGray500];
    }
    return _nameLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 48, 32, 24, 24)];
        _icon.image = [UIImage imageNamed:@"ValidatorPaste"];
    }
    return _icon;
}

- (XXLabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [XXLabel labelWithFrame:CGRectMake(24, CGRectGetMaxY(self.nameLabel.frame), kScreen_Width - 48 - 24, 24) text:@"" font:kFont13 textColor:kGray900];
        [_valueLabel addClickCopyFunction];
    }
    return _valueLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, [XXTransactionDetailCell getCellHeight] - 1, kScreen_Width, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+(CGFloat)getCellHeight {
    return 72;
}

@end
