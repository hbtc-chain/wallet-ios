//
//  XXUserHomeCell.h
//  Bhex
//
//  Created by BHEX on 2018/7/1.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXUserHomeCell : UITableViewCell

/** 名称 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 右箭头 */
@property (strong, nonatomic) UIImageView *rightIconImageView;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

@end
