//
//  XXMessageSegmentButton.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMessageSegmentButton.h"

@implementation XXMessageSegmentButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
    }
    return self;
}

- (void)setLeftLabelText:(NSString *)text {
    self.leftLabel.text = text;
}

- (void)setRightLabelText:(NSString *)text {
    self.rightLabel.text = text;
    self.rightLabel.hidden = NO;
}

- (void)layoutSubviews{

    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(self);
        make.width.mas_greaterThanOrEqualTo(16);
        make.left.mas_equalTo(self.leftLabel.mas_right).with.offset(2);
    }];
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.font = kFont15;
        _leftLabel.textColor = kGray500;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.font = kFont10;
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.backgroundColor = kRed100;
        _rightLabel.layer.cornerRadius = 8;
        _rightLabel.layer.masksToBounds = YES;
        _rightLabel.hidden = YES;
    }
    return _rightLabel;
}

@end
