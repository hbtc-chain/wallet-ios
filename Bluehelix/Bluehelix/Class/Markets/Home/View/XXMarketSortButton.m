//
//  XXMarketSortButton.m
//  Bhex
//
//  Created by Bhex on 2018/9/4.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXMarketSortButton.h"

@interface XXMarketSortButton ()

/** 图标 */
@property (strong, nonatomic) UIImageView *iconImageView;


@end

@implementation XXMarketSortButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        [self addSubview:self.nameLabel];
        [self addSubview:self.iconImageView];
    
        MJWeakSelf
        [self whenTapped:^{
            if (weakSelf.status == 0) {
                weakSelf.status = 1;
            } else if (weakSelf.status == 1) {
                weakSelf.status = 2;
            } else if (weakSelf.status == 2) {
                weakSelf.status = 1;
            }
            if (weakSelf.sortStatusBlock) {
                weakSelf.sortStatusBlock();
            }
        }];
    }
    return self;
}

- (void)setStatus:(NSInteger)status {
    _status = status;
    if (_status == 0) {
        _iconImageView.image = self.sortImage;
        self.shadowView.backgroundColor = kViewBackgroundColor;
        self.nameLabel.textColor = kDark50;
    } else if (_status == 1) {
        _iconImageView.image = self.sortDownImage;
        self.shadowView.backgroundColor = kBlue100;
        self.nameLabel.textColor = kMainTextColor;
    } else if (_status == 2) {
        _iconImageView.image = self.sortUpImage;
        self.shadowView.backgroundColor = kBlue100;
        self.nameLabel.textColor = kMainTextColor;
    }
}

- (void)setSortImage:(UIImage *)sortImage {
    _sortImage = sortImage;
    if (self.status == 0) {
        self.iconImageView.image = _sortImage;
        self.shadowView.backgroundColor = kViewBackgroundColor;
        self.nameLabel.textColor = kDark50;
    }
}

#pragma mark - || 懒加载
/** 标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(0, 0, self.width - 20, self.height) font:kFont10 textColor:kDark50];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

/** 图标 */
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), (self.height - 10)/2, 10, 10)];
    }
    return _iconImageView;
}

@end
