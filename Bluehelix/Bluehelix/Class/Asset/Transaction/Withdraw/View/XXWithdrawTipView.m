//
//  XXWithdrawTipView.m
//  Bhex
//
//  Created by Bhex on 2019/12/18.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXWithdrawTipView.h"

@interface XXWithdrawTipView ()


@end

@implementation XXWithdrawTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.alertLabel];
    }
    return self;
}


/**
 *改变字符串中所有数字的颜色
 */
- (void)setRichNumberWithLabel:(UILabel*)label attributedString:(NSMutableAttributedString *)attributedString {
    
   
}
 
 
/**
 *此方法是用来判断一个字符串是不是整型.
 *如果传进的字符串是一个字符,可以用来判断它是不是数字
 */
- (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}


/** 提示标签 */
- (XYHNumbersLabel *)alertLabel {
    if (_alertLabel == nil) {
        _alertLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(KSpacing, 10, kScreen_Width - KSpacing*2, 20) font:kFont14];
        _alertLabel.textColor = kGray500;
    }
    return _alertLabel;
}

@end
