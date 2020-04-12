//
//  XXWithdrawSpeedView.h
//  Bhex
//
//  Created by Bhex on 2019/12/18.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXWithdrawSpeedView : UIView

/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 滑块儿 */
@property (strong, nonatomic) UISlider *slider;

@end

NS_ASSUME_NONNULL_END
