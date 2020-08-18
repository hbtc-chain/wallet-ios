//
//  XXMarketSearchCell.m
//  Bhex
//
//  Created by BHEX on 2018/7/1.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXMarketSearchCell.h"

@interface XXMarketSearchCell ()

/** 名称 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 收藏按钮 */
@property (strong, nonatomic) UIButton *saveButton;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

@end

@implementation XXMarketSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.saveButton];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)setModel:(XXSymbolModel *)model {
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ / %@", model.baseTokenName, model.quoteTokenName];
    self.saveButton.selected = _model.favorite;
}

#pragma mark - 6. 收藏按钮点击事件
- (void)saveButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    sender.selected = !sender.selected;
//    if (KUser.isLogin) {
//        MJWeakSelf
//        if (sender.selected) {
//            [HttpManager user_PostWithPath:@"user/favorite/create" params:@{@"exchange_id":self.model.exchangeId, @"symbol_id":self.model.symbolId} andBlock:^(id data, NSString *msg, NSInteger code) {
//                sender.enabled = YES;
//                if (code == 0) {
//                    [MBProgressHUD showSuccessMessage:LocalizedString(@"AddFavoritesSucceeded")];
//                    [KMarket addFavoriteSymbolId:weakSelf.model.symbolId];
//                } else {
//                    sender.selected = !sender.selected;
//                    [MBProgressHUD showErrorMessage:msg];
//                }
//            }];
//        } else {
//            [HttpManager user_PostWithPath:@"user/favorite/cancel" params:@{@"exchange_id":self.model.exchangeId, @"symbol_id":self.model.symbolId} andBlock:^(id data, NSString *msg, NSInteger code) {
//                sender.enabled = YES;
//                if (code == 0) {
//                    [MBProgressHUD showSuccessMessage:LocalizedString(@"CancelFavoritesSucceeded")];
//                    [KMarket cancelFavoriteSymbolId:weakSelf.model.symbolId];
//                } else {
//                    sender.selected = !sender.selected;
//                    [MBProgressHUD showErrorMessage:msg];
//                }
//            }];
//        }
//    } else {
//        sender.enabled = YES;
//        if (sender.selected) {
//            [KMarket addFavoriteSymbolId:self.model.symbolId];
//        } else {
//            [KMarket cancelFavoriteSymbolId:self.model.symbolId];
//        }
//    }
}

#pragma mark - || 懒加载
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), 0, K375(136), [XXMarketSearchCell getCellHeight]) text:@"" font:kFontBold14 textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}


- (UIButton *)saveButton {
    if (_saveButton == nil) {
        
        CGFloat width = KSpacing * 2 + 24;
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - width, 0, width, [XXMarketSearchCell getCellHeight])];
        [_saveButton setImage:[UIImage subTextImageName:@"save_0"] forState:UIControlStateNormal];
        [_saveButton setImage:[UIImage mainImageName:@"save_select"] forState:UIControlStateSelected];
        [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), [XXMarketSearchCell getCellHeight] - 1, kScreen_Width - K375(24), 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 50;
}

@end
