//
//  XXTransferTipView.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferTipView.h"
@interface XXTransferTipView ()
@property (nonatomic, strong) UIView *tipBackgroundView;
@property (nonatomic, strong) UITextView *tipTextView;
@end
@implementation XXTransferTipView

#pragma mark lazy load

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tipBackgroundView];
        [self.tipBackgroundView addSubview:self.tipTextView];
    }
    return self;
}

#pragma mark lazy load
- (UIView *)tipBackgroundView{
    if (!_tipBackgroundView) {
        _tipBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(16, 16, kScreen_Width- 32, 120)];
        _tipBackgroundView.layer.cornerRadius = 10.0f;
        _tipBackgroundView.layer.borderWidth = 1.0f;
        _tipBackgroundView.layer.borderColor = [kGray100 CGColor];
    }
    return _tipBackgroundView;
}
- (UITextView *)tipTextView{
    if (!_tipTextView) {
        _tipTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 16, CGRectGetWidth(self.tipBackgroundView.frame) -20, CGRectGetHeight(self.tipBackgroundView.frame)- 32)];
        _tipTextView.backgroundColor = kWhiteColor;
        _tipTextView.font = kFont15;
        _tipTextView.textColor = kGray700;
        _tipTextView.text = LocalizedString(@"TransferTopTipMessage");
        _tipTextView.editable = NO;
    }
    return _tipTextView;
}
@end
