//
//  XXAccountCell.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAccountCell.h"


@interface XXAccountCell ()

//@property (strong, nonatomic) XXLabel *icon;
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
        self.backgroundColor = kWhiteColor;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.checkView];
    [self.contentView addSubview:self.lineView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = kViewBackgroundColor;
}

- (void)configData:(XXAccountModel *)model {
    self.nameLabel.text = model.userName;
    self.addressLabel.text = kAddressReplace(model.address);
    if ([model.address isEqualToString:KUser.address]) {
        self.checkView.image = [UIImage imageNamed:@"checked"];
    } else {
        self.checkView.image = [UIImage imageNamed:@"unCheck"];
    }
//    [self configIcon:model];
}

//- (XXLabel *)icon {
//    if (!_icon) {
//        _icon = [XXLabel labelWithFrame:CGRectMake(16, 16, 40, 40) text:@"" font:kFont14 textColor:kWhiteColor alignment:NSTextAlignmentCenter cornerRadius:20];
//    }
//    return _icon;
//}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 40, 40)];
        _icon.image = [UIImage imageNamed:@"AssetUserHead"];
        _icon.layer.cornerRadius = 20;
    }
    return _icon;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 12, 16, kScreen_Width - 72 - 34, 24) font:kFontBold(17) textColor:kGray900];
    }
    return _nameLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, 16) font:kFont12 textColor:kGray500];
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

//- (void)configIcon:(XXAccountModel *)model{
//    NSArray *colorArr = @[@"#54E19E",@"#66A3FF",@"#38a1e6",@"#E2C97F",@"#7887C5",@"#68B38F",@"#8B58DF",@"#66D0D7",@"#BEC65D",@"#F4934D"];
//    if (!IsEmpty(model.userName)) {
//        NSString *lastNumStr =[model.userName substringFromIndex:[model.userName length] - 1];
//        int colorIndex = lastNumStr.intValue % 10;
//        self.icon.backgroundColor = [UIColor colorWithHexString:colorArr[colorIndex]];
//    }
//    if (!IsEmpty(model.userName)) {
//        self.icon.text = [model.userName substringToIndex:1];
//    }
//}

@end
