//
//  XXValidatorGripSectionHeader.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorGripSectionHeader.h"
@interface XXValidatorGripSectionHeader ()
@property (nonatomic, strong) UIView *lineView;
@end
@implementation XXValidatorGripSectionHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kWhite100;
        [self addSubview:self.validatorToolBar];
        [self addSubview:self.lineView];
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
    [self.validatorToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.validatorToolBar.mas_bottom);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(16);
        make.left.mas_equalTo(K375(16));
        make.right.mas_equalTo(-K375(16));
        make.height.mas_equalTo(32);
        make.bottom.mas_equalTo(-6);
    }];
}
#pragma mark lazy load
- (XXValidatorToolBar*)validatorToolBar{
    MJWeakSelf
    if (!_validatorToolBar) {
        _validatorToolBar = [[XXValidatorToolBar alloc]initWithFrame:CGRectZero];
        _validatorToolBar.itemsArray = [NSMutableArray arrayWithArray:@[LocalizedString(@"valid"),LocalizedString(@"invalid")]];
        _validatorToolBar.ToolbarSelectCallBack = ^(NSInteger index) {
            if (weakSelf.selectValidOrInvalidCallBack) {
                weakSelf.selectValidOrInvalidCallBack(index);
            }
        };
    }
    return _validatorToolBar;
}
- (UIView*)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = kSeparateLineColor;
    }
    return _lineView;
}
- (XXSearchBarView  *)searchView {
    if (!_searchView) {
        _searchView = [[XXSearchBarView alloc] initWithFrame:CGRectZero];
        _searchView.searchTextField.placeholder = LocalizedString(@"PleaseInputValidatorName");
        [_searchView.searchTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchView;
}
@end
