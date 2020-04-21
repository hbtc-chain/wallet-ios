//
//  XXEmptyView.m
//  Bhex
//
//  Created by Bhex on 2018/8/17.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXEmptyView.h"

@implementation XXEmptyView

- (instancetype)initWithFrame:(CGRect)frame iamgeName:(NSString *)imageName alert:(NSString *)alert
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        
        [self addSubview:self.nameLabel];
        
        if (imageName) {
            UIImage *image = [UIImage imageNamed:imageName];
            if (image) {
                [self addSubview:self.iconImageView];
                self.iconImageView.image = image;
                self.nameLabel.frame = CGRectMake(K375(10), CGRectGetMaxY(self.iconImageView.frame) + 10, self.width - K375(20), 40);
            }
        }
        if (alert && alert.length > 0) {
            self.nameLabel.text = alert;
        }
    }
    return self;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - K375(48))/2, (self.height - K375(48) - 38)/2, K375(48), K375(48))];
    }
    return _iconImageView;
}

- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(10), CGRectGetMaxY(self.iconImageView.frame) + 16, self.width - K375(20), 22) text:LocalizedString(@"NoData") font:kFont15 textColor:kGray500 alignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}

@end
