//
//  XXWithdrawSpeedView.m
//  Bhex
//
//  Created by Bhex on 2019/12/18.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXWithdrawSpeedView.h"

@implementation XXWithdrawSpeedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self addSubview:self.nameLabel];
        
        [self addSubview:self.slider];
    }
    return self;
}

#pragma mark - || 懒加载
/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 10, kScreen_Width - KSpacing*2, 24) font:kFont15 textColor:kGray];
    }
    return _nameLabel;
}

/** 滑块儿 */
- (UISlider *)slider {
    if (_slider == nil) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(KSpacing , CGRectGetMaxY(self.nameLabel.frame) + 22, kScreen_Width - KSpacing * 2, 16)];
        _slider.minimumTrackTintColor = kPrimaryMain;
        _slider.maximumTrackTintColor = kGray100;
        _slider.thumbTintColor = kPrimaryMain;
//        [_slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    }
    return _slider;
}
@end
