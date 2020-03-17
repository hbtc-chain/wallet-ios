//
//  XXAccountCell.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAccountCell.h"

@interface XXAccountCell ()

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) XXLabel *nameLabel;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *checkView;

@end

@implementation XXAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhite100;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.checkView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = kViewBackgroundColor;
    self.lineView.backgroundColor = KLine_Color;
}

- (void)configData:(NSDictionary *)dic {
    self.nameLabel.text = dic[@"userName"];
    self.addressLabel.text = dic[@"BHAddress"];
    if ([dic[@"BHAddress"] isEqualToString:KUser.rootAccount[@"BHAddress"]]) {
        self.checkView.image = [UIImage imageNamed:@"checked"];
    } else {
        self.checkView.image = [UIImage imageNamed:@"unCheck"];
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 40, 40)];
        _icon.image = [UIImage imageNamed:@"CreateWalletSuccess"];
    }
    return _icon;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 12, 16, kScreen_Width - 72 - 34, 24) font:kFontBold(17) textColor:kDark100];
    }
    return _nameLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, 16) font:kFont12 textColor:kTipColor];
    }
    return _addressLabel;
}

- (UIImageView *)checkView {
    if (!_checkView) {
        _checkView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 34, [XXAccountCell getCellHeight]/2 - 18/2, 18, 18)];
        _checkView.image = [UIImage imageNamed:@"unCheck"];
    }
    return _checkView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.nameLabel.left, [XXAccountCell getCellHeight] - 1, kScreen_Width - self.nameLabel.left, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 72;
}

- (void)configIcon:(NSDictionary *)model {
    NSArray *colorArr = @[@"#54E19E",@"#66A3FF",@"#38a1e6",@"#E2C97F",@"#7887C5",@"#68B38F",@"#8B58DF",@"#66D0D7",@"#BEC65D",@"#F4934D"];
//    if (!IsEmpty(model.accountId)) {
//        NSString *lastNumStr =[model.accountId substringFromIndex:model.accountId.length - 1];
//        int colorIndex = lastNumStr.intValue % 10;
//        self.iconLabel.backgroundColor = [UIColor colorWithHexString:colorArr[colorIndex]];
//    }
//    if (!IsEmpty(model.nickName)) {
//        self.iconLabel.text = [model.nickName substringToIndex:1];
//    }
}

@end
