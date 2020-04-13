//
//  XXAddAssetCell.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/03.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAddAssetCell.h"
#import "XXTokenModel.h"
#import <UIImageView+WebCache.h>

@interface XXAddAssetCell ()

/// 图标
@property (nonatomic, strong) UIImageView *iconView;

/// 币名
@property (nonatomic, strong) XXLabel *coinNameLabel;

/// 是否开启
@property (nonatomic, strong) UISwitch *mySwitch;

/// 币种
@property (nonatomic, strong) XXTokenModel *model;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation XXAddAssetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kViewBackgroundColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.coinNameLabel];
    [self.contentView addSubview:self.mySwitch];
    [self.contentView addSubview:self.lineView];
}

- (void)configData:(XXTokenModel *)model {
    self.model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    self.coinNameLabel.text = model.symbol;
    BOOL isOn = NO;
    
    if (!IsEmpty(KUser.currentAccount.symbols)) {
        NSArray *symbols = [KUser.currentAccount.symbols componentsSeparatedByString:@","];
       isOn = [symbols containsObject:model.symbol];
    }
    [self.mySwitch setOn:isOn];
}

- (void)switchAction:(UISwitch *)sender {
    if (sender.isOn) {
        [[XXSqliteManager sharedSqlite] insertSymbol:self.model.symbol];
    } else {
        [[XXSqliteManager sharedSqlite] deleteSymbol:self.model.symbol];
    }
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(16), 16, 40, 40)];
    }
    return _iconView;
}

- (XXLabel *)coinNameLabel {
    if (_coinNameLabel == nil) {
        _coinNameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 12, 24, 100, 24) text:@"" font:kFontBold(17) textColor:kDark100];
    }
    return _coinNameLabel;
}

- (UISwitch *)mySwitch {
    if (_mySwitch == nil) {
        _mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreen_Width - K375(16) - 51, ([[self class] getCellHeight] - 31)/2, _mySwitch.width, _mySwitch.height)];
        [_mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _mySwitch.on = NO;
        _mySwitch.backgroundColor = kDark10;
        _mySwitch.layer.cornerRadius = _mySwitch.height/2;
        _mySwitch.layer.masksToBounds = YES;
        _mySwitch.tintColor = [UIColor clearColor];
        _mySwitch.onTintColor = kBlue100;
        _mySwitch.thumbTintColor = [UIColor whiteColor];
    }
    return _mySwitch;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.coinNameLabel.left, [[self class] getCellHeight] - 1, kScreen_Width - K375(15), 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 72;
}

@end
