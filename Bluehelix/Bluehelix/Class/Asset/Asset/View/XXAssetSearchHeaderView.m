//
//  XXAssetSearchHeaderView.m
//  Bluehelix
//
//  Created by BHEX on 2020/04/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetSearchHeaderView.h"
@interface XXAssetSearchHeaderView()

/** 搜索图标 */
@property (strong, nonatomic) UIImageView *searchIconImageView;

@property (strong, nonatomic) UIView *searchBackView;
@end

@implementation XXAssetSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.searchBackView];
        [self.searchBackView addSubview:self.searchIconImageView];
        [self.searchBackView addSubview:self.searchTextField];
    }
    return self;
}

- (UIView *)searchBackView {
    if (_searchBackView == nil) {
        _searchBackView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), 0, kScreen_Width - K375(32), 32)];
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
        _searchTextField = [[XXTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchIconImageView.frame) + 4, 0, self.searchBackView.width - (CGRectGetMaxX(self.searchIconImageView.frame) + 10) - K375(15), self.searchBackView.height)];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchTextField.textColor = kGray900;
        _searchTextField.font = kFontBold18;
        _searchTextField.placeholder = LocalizedString(@"EnterTokenNameSearch");
        _searchTextField.placeholderColor = kGray500;
        _searchTextField.placeholderFont = kFont(15);
    }
    return _searchTextField;
}

@end
