//
//  XXSettingCell.h
//  Bhex
//
//  Created by BHEX on 2018/7/25.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXSettingCell : UITableViewCell

/** 名称 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 值 */
@property (strong, nonatomic) XXLabel *valueLabel;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIImageView *rightIconImageView;

@end
