//
//  XXExchangeBtn.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXExchangeBtn.h"


@implementation XXExchangeBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.customImageView];
        [self addSubview:self.customLabel];
    }
    return self;
}

- (UIImageView *)customImageView {
    if (!_customImageView) {
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    }
    return _customImageView;
}

- (UILabel *)customLabel {
    if (!_customLabel) {
        _customLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.customImageView.frame) + 8, 0, self.width - self.customImageView.width - 8, self.height)];
        _customLabel.textAlignment = NSTextAlignmentLeft;
        _customLabel.font = kFont17;
        _customLabel.textColor = kGray900;
    }
    return _customLabel;
}

@end
