//
//  XXCoinPublishNameView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXCoinPublishNameView.h"

@implementation XXCoinPublishNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self addSubview:self.nameLabel];
                
        [self addSubview:self.banView];
        
        [self.banView addSubview:self.textField];
                        
    }
    return self;
}

/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 16, kScreen_Width - KSpacing*2, 24) font:kFont15 textColor:kGray];
    }
    return _nameLabel;
}

/** 背景图 */
- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nameLabel.frame) + 4, kScreen_Width - KSpacing*2, 48)];
        _banView.backgroundColor = kGray50;
        _banView.layer.cornerRadius = 4;
        _banView.layer.masksToBounds = YES;
    }
    return _banView;
}

/** 输入框 */
- (XXTextField *)textField {
    if (_textField == nil) {
        _textField = [[XXTextField alloc] initWithFrame:CGRectMake(K375(8), 0, self.banView.width - K375(8), self.banView.height)];
        _textField.textColor = kGray900;
        _textField.font = kFont15;
        _textField.placeholderColor = kGray500;
    }
    return _textField;
}

@end
