//
//  XXWithdrawChainView.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXWithdrawChainView.h"

@implementation XXWithdrawChainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    // 提币主视图
    [self addSubview:self.mainView];
    
    /** 手续费 */
    [self.mainView addSubview:self.feeView];
}

-(void)sliderValueChanged:(UISlider *)slider {
    self.feeView.textField.text = [NSString stringWithFormat:@"%.3f",slider.value];
}

/** 地址视图 */
- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.height)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

/** 手续费 */
- (XXWithdrawFeeView *)feeView {
    if (_feeView == nil) {
        _feeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, 20, kScreen_Width, 88)];
        _feeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _feeView.textField.enabled = NO;
    }
    return _feeView;
}

@end
