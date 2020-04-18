//
//  XXEmptyView.h
//  Bhex
//
//  Created by Bhex on 2018/8/17.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXEmptyView : UIView

- (instancetype)initWithFrame:(CGRect)frame iamgeName:(NSString *)imageName alert:(NSString *)alert;

/** 图标 */
@property (strong, nonatomic) UIImageView *iconImageView;

/** 标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

@end
