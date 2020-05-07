//
//  XXAssetSearchView.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/03.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetSearchView.h"

@interface XXAssetSearchView()

/** 搜索图标 */
@property (strong, nonatomic) UIImageView *searchIconImageView;

@property (strong, nonatomic) UIView *searchBackView;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

@end

@implementation XXAssetSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.hidenSmallButton];
        [self addSubview:self.searchBackView];
        [self.searchBackView addSubview:self.searchIconImageView];
        [self.searchBackView addSubview:self.searchTextField];
        [self addSubview:self.lineView];
    }
    return self;
}

- (XXButton *)hidenSmallButton {
    if (_hidenSmallButton == nil) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"HideSmallCurrency") font:kFontBold(13)] + 24;
        MJWeakSelf
        _hidenSmallButton = [XXButton buttonWithFrame:CGRectMake(K375(14), 0, width, self.height) title:LocalizedString(@"HideSmallCurrency") font:kFontBold(13) titleColor:kPrimaryMain block:^(UIButton *button) {
            
            KUser.isHideSmallCoin = !KUser.isHideSmallCoin;
            button.selected = KUser.isHideSmallCoin;
            if (weakSelf.actionBlock) {
                weakSelf.actionBlock();
            }
        }];
        [_hidenSmallButton setImage:[UIImage subTextImageName:@"unSelected"] forState:UIControlStateNormal];
        [_hidenSmallButton setImage:[UIImage mainImageName:@"selected"] forState:UIControlStateSelected];
        
        [_hidenSmallButton setTitleColor:kGray500 forState:UIControlStateNormal];
        [_hidenSmallButton setTitleColor:kPrimaryMain forState:UIControlStateSelected];
        _hidenSmallButton.selected = KUser.isHideSmallCoin;
    }
    return _hidenSmallButton;
}

- (UIView *)searchBackView {
    if (_searchBackView == nil) {
        _searchBackView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width - 16 - 120, self.height/2 - 16, 120, 32)];
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
        _searchTextField = [[XXTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchIconImageView.frame) + 4, 8, self.searchBackView.width - (CGRectGetMaxX(self.searchIconImageView.frame) + 10) - K375(15), self.searchBackView.height - 16)];
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

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(K375(15), self.height - 1, kScreen_Width - K375(15), 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

@end
