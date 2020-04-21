//
//  XXImportWayView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/4/20.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXImportWayView.h"

@interface XXImportWayView ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation XXImportWayView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName  {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        self.icon.image = [UIImage imageNamed:imageName];
        self.titleLabel.text = title;
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.icon];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrow];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, self.height - 32, self.height - 32)];
    }
    return _icon;
}

- (XXLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 20, 20, K375(200), self.height - 40) font:kFont(17) textColor:kGray900];
    }
    return _titleLabel;
}

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 60, 36, 24, 24)];
        _arrow.image = [UIImage imageNamed:@"chooseArrow"];
    }
    return _arrow;
}

@end
