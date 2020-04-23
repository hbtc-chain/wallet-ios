//
//  XXServiceContentView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/4/21.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXServiceContentView.h"
#import "XYHNumbersLabel.h"

@interface XXServiceContentView ()

@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel;
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) XXButton *sureBtn;
@property (nonatomic, strong) XXButton *isAgreeButton;
@end

@implementation XXServiceContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.scrollView];
    [self addSubview:self.bottomView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.tipLabel];
    [self.scrollView addSubview:self.contentLabel];
    self.scrollView.contentSize = CGSizeMake(kScreen_Width, self.contentLabel.height + 96);
    [self.bottomView addSubview:self.isAgreeButton];
    [self.bottomView addSubview:self.sureBtn];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.height - 168)];
    }
    return _scrollView;
}

- (XXLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(0, 24, kScreen_Width, 32) text:LocalizedString(@"ServiceAgreement") font:kFont20 textColor:kGray900];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreen_Width, 24) text:LocalizedString(@"ServiceAgreementTip") font:kFont13 textColor:kGray500];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (XYHNumbersLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.tipLabel.frame) + K375(16), self.width - K375(48),0) font:kFont13];
        _contentLabel.textColor = kGray900;
        [_contentLabel setText:LocalizedString(@"ServiceContent") alignment:NSTextAlignmentLeft];
    }
    return _contentLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 168, kScreen_Width, 168)];
    }
    return _bottomView;
}

- (XXButton *)isAgreeButton {
    if (_isAgreeButton == nil) {
        MJWeakSelf
        _isAgreeButton = [XXButton buttonWithFrame:CGRectMake(K375(24), 10, kScreen_Width - K375(48), 30) block:^(UIButton *button) {
            weakSelf.isAgreeButton.selected = !weakSelf.isAgreeButton.selected;
            if (weakSelf.isAgreeButton.selected) {
                weakSelf.sureBtn.enabled = YES;
                weakSelf.sureBtn.backgroundColor = kPrimaryMain;
            } else {
                weakSelf.sureBtn.enabled = NO;
                weakSelf.sureBtn.backgroundColor = kBtnNotEnableColor;
            }
        }];
        [_isAgreeButton.titleLabel setFont:kFont13];
        _isAgreeButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        _isAgreeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_isAgreeButton setImage:[UIImage subTextImageName:@"unSelected"] forState:UIControlStateNormal];
        [_isAgreeButton setImage:[UIImage mainImageName:@"selected"] forState:UIControlStateSelected];
        _isAgreeButton.selected = KUser.agreeService;
        [_isAgreeButton setTitle:LocalizedString(@"ReadAndAgree") forState:UIControlStateNormal];
        _isAgreeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_isAgreeButton setTitleColor:kGray500 forState:UIControlStateNormal];
    }
    return _isAgreeButton;
}

- (XXButton *)sureBtn {
    if (!_sureBtn) {
        MJWeakSelf
        _sureBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.isAgreeButton.frame) + 10, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"Sure") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
                KUser.agreeService = YES;
                [weakSelf.viewController dismissViewControllerAnimated:YES completion:nil];
        }];
        _sureBtn.backgroundColor = KUser.agreeService ? kPrimaryMain : kBtnNotEnableColor;
        _sureBtn.layer.cornerRadius = kBtnBorderRadius;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.enabled = KUser.agreeService;
    }
    return _sureBtn;
}
@end
