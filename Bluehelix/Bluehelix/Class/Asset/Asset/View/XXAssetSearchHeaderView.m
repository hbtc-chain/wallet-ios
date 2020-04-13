//
//  XXAssetSearchHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/04/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetSearchHeaderView.h"
@interface XXAssetSearchHeaderView()

/** 搜索图标 */
@property (strong, nonatomic) UIImageView *searchIconImageView;

@end

@implementation XXAssetSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhite100;
        [self addSubview:self.searchIconImageView];
        [self addSubview:self.searchTextField];
    }
    return self;
}

- (UIImageView *)searchIconImageView {
    if (_searchIconImageView == nil) {
        _searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(16), (self.height - 24) / 2, 24, 24)];
        _searchIconImageView.image = [UIImage subTextImageName:@"icon_search_0"];
    }
    return _searchIconImageView;
}

- (XXTextField *)searchTextField {
    if (_searchTextField == nil) {
        _searchTextField = [[XXTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchIconImageView.frame) + 8, 0, kScreen_Width - (CGRectGetMaxX(self.searchIconImageView.frame) + 10) - K375(15), self.height)];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchTextField.textColor = kDark100;
        _searchTextField.font = kFontBold18;
        _searchTextField.placeholder = LocalizedString(@"EnterTokenNameSearch");
        _searchTextField.placeholderColor = kTipColor;
        _searchTextField.placeholderFont = kFont(15);
//        _searchTextField.backgroundColor = kFieldBackColor;
    }
    return _searchTextField;
}

@end
