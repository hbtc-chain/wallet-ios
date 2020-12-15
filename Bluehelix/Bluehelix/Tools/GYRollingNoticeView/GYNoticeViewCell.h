//
//  GYNoticeViewCell.h
//  RollingNotice
//
//  Created by qm on 2017/12/4.
//  Copyright © 2017年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>

// 调试cell内存地址log
static BOOL GYRollingDebugLog = NO;

@interface GYNoticeViewCell : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *icon; //类型图标
@property (nonatomic, strong) XXButton *closeBtn;
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, copy) void (^closeBlock) (void);
//@property (nonatomic, assign) CGFloat textLabelLeading;
//@property (nonatomic, assign) CGFloat textLabelTrailing;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
@end
