//
//  XXProposalGripSectionHeader.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalGripSectionHeader.h"

@implementation XXProposalGripSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.searchView];
    }
    return self;
}
#pragma mark
- (void)textFieldValueChange:(UITextField *)textField {
    //去空格
    textField.text = [textField.text trimmingCharacters];
    
    if (self.textfieldValueChangeBlock) {
        self.textfieldValueChangeBlock(textField.text);
    }
}
#pragma mark layout
- (void)layoutSubviews{
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(K375(16));
        make.right.mas_equalTo(-K375(16));
        make.height.mas_equalTo(32);
        make.bottom.mas_equalTo(-16);
    }];
}
#pragma mark lazy load
- (XXSearchBarView  *)searchView {
    if (!_searchView) {
        _searchView = [[XXSearchBarView alloc] initWithFrame:CGRectZero];
        _searchView.searchTextField.placeholder = LocalizedString(@"PleaseInputVoteName");
        [_searchView.searchTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchView;
}
@end
