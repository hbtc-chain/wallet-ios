//
//  XXChooseTokenHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChooseTokenHeaderView.h"
@interface XXChooseTokenHeaderView ()
@property (nonatomic, strong) UIImageView *searchIconImageView;
@property (nonatomic, strong) UIView *searchBackView;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) XXButton *sortBtn;
@end
@implementation XXChooseTokenHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.searchBackView];
        [self.searchBackView addSubview:self.searchIconImageView];
        [self.searchBackView addSubview:self.searchTextField];
        [self addSubview:self.titleLabel];
        [self addSubview:self.sortBtn];
    }
    return self;
}

- (void)reloadSortBtnImage {
    if (KUser.tokenSortDes) {
        if (kIsNight) {
            [_sortBtn setImage:[UIImage imageNamed:@"sort_downNight"] forState:UIControlStateNormal];
        } else {
            [_sortBtn setImage:[UIImage imageNamed:@"sort_down"] forState:UIControlStateNormal];
        }
    } else {
        if (kIsNight) {
            [_sortBtn setImage:[UIImage imageNamed:@"sort_upNight"] forState:UIControlStateNormal];
        } else {
            [_sortBtn setImage:[UIImage imageNamed:@"sort_up"] forState:UIControlStateNormal];
        }
    }
}

- (UIView *)searchBackView {
    if (_searchBackView == nil) {
        _searchBackView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, kScreen_Width - 32, 48)];
        _searchBackView.backgroundColor = kGray50;
        _searchBackView.layer.cornerRadius = 4;
        _searchBackView.layer.masksToBounds = YES;
    }
    return _searchBackView;
}

- (UIImageView *)searchIconImageView {
    if (_searchIconImageView == nil) {
        _searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.searchBackView.height - 16) / 2, 16, 16)];
        _searchIconImageView.image = [UIImage subTextImageName:@"icon_search_0"];
    }
    return _searchIconImageView;
}

- (XXTextField *)searchTextField {
    if (_searchTextField == nil) {
        _searchTextField = [[XXTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchIconImageView.frame) + 4, 4, self.searchBackView.width - (CGRectGetMaxX(self.searchIconImageView.frame) + 10) - K375(15), self.searchBackView.height - 8)];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchTextField.textColor = kGray900;
        _searchTextField.font = kFontBold18;
        _searchTextField.placeholder = LocalizedString(@"SearchPairs");
        _searchTextField.placeholderColor = kGray500;
        _searchTextField.placeholderFont = kFont(15);
    }
    return _searchTextField;
}

- (XXLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(16, CGRectGetMaxY(self.searchBackView.frame) + 24, 100, 24) font:kFont15 textColor:kGray300];
        _titleLabel.text = LocalizedString(@"TokenNameTitle");
    }
    return _titleLabel;
}

- (XXButton *)sortBtn {
    if (_sortBtn == nil) {
        MJWeakSelf
        _sortBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 48, CGRectGetMaxY(self.searchBackView.frame) + 16, 32, 32) block:^(UIButton *button) {
            KUser.tokenSortDes = !KUser.tokenSortDes;
            [weakSelf reloadSortBtnImage];
            if (weakSelf.sortBlock) {
                weakSelf.sortBlock();
            }
        }];
        [self reloadSortBtnImage];
    }
    return _sortBtn;
}
@end
