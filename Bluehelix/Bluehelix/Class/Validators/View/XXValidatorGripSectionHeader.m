//
//  XXValidatorGripSectionHeader.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorGripSectionHeader.h"
@interface XXValidatorGripSectionHeader ()
@property (nonatomic, strong) UIView *searchBackgroundView;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation XXValidatorGripSectionHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kBackgroundLeverFirst;
        [self addSubview:self.coverView];
        [self addSubview:self.searchBackgroundView];
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
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.searchBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.lineView.mas_bottom);
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
        //_validatorToolBar.backgroundColor = kBackgroundLeverFirst;
        _validatorToolBar.itemsArray = [NSMutableArray arrayWithArray:@[LocalizedString(@"valid"),LocalizedString(@"invalid")]];
        _validatorToolBar.ToolbarSelectCallBack = ^(NSInteger index) {
            if (weakSelf.selectValidOrInvalidCallBack) {
                weakSelf.selectValidOrInvalidCallBack(index);
            }
        };
    }
    return _validatorToolBar;
}
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectZero];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}
- (UIView*)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = kSeparateLineColor;
    }
    return _lineView;
}
- (UIView *)searchBackgroundView{
    if (!_searchBackgroundView) {
        _searchBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        _searchBackgroundView.backgroundColor = kBackgroundLeverFirst;
    }
    return _searchBackgroundView;;
}
- (XXSearchBarView  *)searchView {
    if (!_searchView) {
        _searchView = [[XXSearchBarView alloc] initWithFrame:CGRectZero];
        _searchView.searchTextField.placeholder = LocalizedString(@"PleaseInputValidatorName");
        [_searchView.searchTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged | UIControlEventEditingDidEnd];
    }
    return _searchView;
}
@end
