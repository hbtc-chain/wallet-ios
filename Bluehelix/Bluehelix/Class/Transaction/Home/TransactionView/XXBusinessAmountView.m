//
//  XXBusinessNumberView.m
//  Bhex
//
//  Created by BHEX on 2018/7/4.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXBusinessAmountView.h"

@interface XXBusinessAmountView () <UITextFieldDelegate>


@end

@implementation XXBusinessAmountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        [self addSubview:self.tokenNameLabel];
        [self addSubview:self.textField];
        
        MJWeakSelf
        [self whenTapped:^{
            
        }];
    }
    return self;
}


#pragma mark - || 懒加载
/** 输入框 */
- (XXFloadtTextField *)textField {
    if (_textField == nil) {
        _textField = [[XXFloadtTextField alloc] initWithFrame:CGRectMake(K375(8), 0, self.width - K375(45), self.height)];
        _textField.textColor = kDark100;
        _textField.font = kFontBold14;
        _textField.delegate = self;
        _textField.placeholder = LocalizedString(@"Amount");
        _textField.placeholderColor = kDark50;
    }
    return _textField;
}

- (XXLabel *)tokenNameLabel {
    if (_tokenNameLabel == nil) {
        _tokenNameLabel = [XXLabel labelWithFrame:CGRectMake(self.width - K375(88), 0, K375(80), self.height) text:@"" font:kFont14 textColor:kDark50 alignment:NSTextAlignmentRight];
    }
    return _tokenNameLabel;
}
@end
