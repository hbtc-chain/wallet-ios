//
//  XXSearchBarView.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSearchBarView.h"

@implementation XXSearchBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kGray50;
        [self addSubview:self.searchIconImageView];
        [self addSubview:self.searchTextField];
    }
    return self;
}

#pragma mark layout
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.searchIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(K375(16));
        make.width.height.mas_equalTo(16);
        make.top.mas_equalTo(8);
    }];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.searchIconImageView.mas_right).offset(4);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(32);
    }];
}
#pragma mark lazy load
- (UIImageView *)searchIconImageView {
    if (_searchIconImageView == nil) {
        _searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
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
        _searchTextField.textColor = kGray900;
        _searchTextField.font = kFontBold18;
        _searchTextField.placeholder = LocalizedString(@"EnterTokenNameSearch");
        _searchTextField.placeholderColor = kGray500;
        _searchTextField.placeholderFont = kFont(15);
//        _searchTextField.backgroundColor = kGray50;
    }
    return _searchTextField;
}

@end
