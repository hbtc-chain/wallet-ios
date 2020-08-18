//
//  XXFavoriteEditingCell.m
//  Bhex
//
//  Created by YiHeng on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXFavoriteEditingCell.h"

@interface XXFavoriteEditingCell ()

/** 是否选中图片 uncheck checked */
@property (strong, nonatomic, nullable) UIImageView *iconImageView;

/** 标签 */
@property (strong, nonatomic, nullable) XXLabel *nameLabel;

/** 指定按钮 */
@property (strong, nonatomic, nullable) XXButton *topButton;

@end

@implementation XXFavoriteEditingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUI];
        
        MJWeakSelf
        [self whenTapped:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(favoriteEditingCellDidSelectAtIndexPath:)]) {
                [weakSelf.delegate favoriteEditingCellDidSelectAtIndexPath:weakSelf.indexPath];
            }
        }];
    }
    return self;
}

#pragma mark - 1. 创建主界面
- (void)setupUI {
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.topButton];
}

- (void)setModel:(XXSymbolModel *)model {
    _model = model;
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":_model.baseTokenName, @"color":kDark100, @"font":kFontBold(16)};
    itemsArray[1] = @{@"string":[NSString stringWithFormat:@" / %@", _model.quoteTokenName], @"color":kDark50, @"font":kFontBold10};
    self.nameLabel.attributedText = [NSString mergeStrings:itemsArray];
    
    if (model.isSelect) {
        self.iconImageView.image = [UIImage mainImageName:@"checked"];
    } else {
        self.iconImageView.image = [UIImage subTextImageName:@"uncheck"];
    }
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    if (editing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = [UIImage subTextImageName:@"sort_editing"];
                    }
                }
            }
        }
    }
}
// 25.6667 13
+ (CGFloat)getCellHeight {
    return 56;
}

#pragma mark - || 懒加载
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-25, 15.5, 24, 24)];
    }
    return _iconImageView;
}

- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 8, 0, K375(200), 55) font:kFont16 textColor:kDark100];
    }
    return _nameLabel;
}

- (XXButton *)topButton {
    if (_topButton == nil) {
        MJWeakSelf
        _topButton = [XXButton buttonWithFrame:CGRectMake(K375(220) - 30, 0, 55, 55) block:^(UIButton *button) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(favoriteEditingCellDidTopAtIndexPath:)]) {
                [weakSelf.delegate favoriteEditingCellDidTopAtIndexPath:weakSelf.indexPath];
            }
        }];
        [_topButton setImage:[UIImage subTextImageName:@"toTop"] forState:UIControlStateNormal];
    }
    return _topButton;
}

@end
