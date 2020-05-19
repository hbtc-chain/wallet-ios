//
//  XXTransationSectionHeaderView.m
//  Bluehelix
//
//  Created by BHEX on 2020/4/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransationSectionHeaderView.h"

@interface XXTransationSectionHeaderView ()

@property (nonatomic, strong) UIView *lineView;


@end

@implementation XXTransationSectionHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
       if (self) {
           self.contentView.backgroundColor = kGray50;
           [self setupUI];
       }
       return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.valueLabel];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 40)];
        _lineView.backgroundColor = kPrimaryMain;
    }
    return _lineView;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), 0, 100, 40) font:kFontBold(17) textColor:kGray900];
    }
    return _nameLabel;
}

- (XXLabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [XXLabel labelWithFrame:CGRectMake(K375(24) + 100, 0, kScreen_Width - K375(48) - 100, 40) font:kNumberFont(17) textColor:kGray900];
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel;
}

@end
