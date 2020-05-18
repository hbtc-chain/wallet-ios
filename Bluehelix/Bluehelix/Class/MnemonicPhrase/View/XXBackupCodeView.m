//
//  XXBackupCodeView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXBackupCodeView.h"
#import "XYHNumbersLabel.h"
#import "XCQrCodeTool.h"

@interface XXBackupCodeView ()

@property (nonatomic, strong) XXLabel *tipLabel1;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel1;
@property (nonatomic, strong) XXLabel *tipLabel2;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel2;
@property (nonatomic, strong) UIView *codeBackView;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UIImageView *hideImageView;
@property (nonatomic, strong) XXButton *showBtn;

@end

@implementation XXBackupCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tipLabel1];
        [self addSubview:self.contentLabel1];
        [self addSubview:self.tipLabel2];
        [self addSubview:self.contentLabel2];
        [self addSubview:self.codeBackView];
        [self.codeBackView addSubview:self.hideImageView];
        [self.codeBackView addSubview:self.showBtn];
        [self.codeBackView addSubview:self.codeImageView];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _codeImageView.image = [XCQrCodeTool createQrCodeWithContent:text];
}

- (XXLabel *)tipLabel1 {
    if (!_tipLabel1) {
        _tipLabel1 = [XXLabel labelWithFrame:CGRectMake(K375(24), 24, kScreen_Width - K375(48), 25) text:LocalizedString(@"BackupCodeTip1") font:kFontBold17 textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel1;
}

- (XYHNumbersLabel *)contentLabel1 {
    if (!_contentLabel1) {
        _contentLabel1 = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.tipLabel1.frame) + 4, kScreen_Width - K375(48), 0) font:kFont(15)];
        _contentLabel1.textColor = kGray500;
        [_contentLabel1 setText:LocalizedString(@"BackupCodeContent1") alignment:NSTextAlignmentLeft];
    }
    return _contentLabel1;
}

- (XXLabel *)tipLabel2 {
    if (!_tipLabel2) {
        _tipLabel2 = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.contentLabel1.frame) + 12, kScreen_Width - K375(48), 25) text:LocalizedString(@"BackupCodeTip2") font:kFontBold17 textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel2;
}

- (XYHNumbersLabel *)contentLabel2 {
    if (!_contentLabel2) {
        _contentLabel2 = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.tipLabel2.frame) + 4, kScreen_Width - K375(48), 0) font:kFont(15)];
        _contentLabel2.textColor = kGray500;
        [_contentLabel2 setText:LocalizedString(@"BackupCodeContent2") alignment:NSTextAlignmentLeft];
    }
    return _contentLabel2;
}

- (UIView *)codeBackView {
    if (!_codeBackView) {
        _codeBackView = [[UIView alloc] initWithFrame:CGRectMake(K375(55), CGRectGetMaxY(self.contentLabel2.frame) + 24, kScreen_Width-K375(110), kScreen_Width-K375(110))];
        _codeBackView.backgroundColor = kGray50;
    }
    return _codeBackView;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(41), K375(41), self.codeBackView.width - K375(82), self.codeBackView.width - K375(82))];
        _codeImageView.hidden = YES;
    }
    return _codeImageView;
}

- (UIImageView *)hideImageView {
    if (!_hideImageView) {
        _hideImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.codeBackView.width - 72)/2, 72, 72, 72)];
        _hideImageView.image = [UIImage imageNamed:@"hideCodeImage"];
    }
    return _hideImageView;
}

- (XXButton *)showBtn {
    if (!_showBtn) {
        MJWeakSelf
        _showBtn = [XXButton buttonWithFrame:CGRectMake(K375(72), self.codeBackView.height - K375(96), self.codeBackView.width - K375(144), 44) title:LocalizedString(@"ShowCode") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            weakSelf.showBtn.hidden = YES;
            weakSelf.hideImageView.hidden = YES;
            weakSelf.codeImageView.hidden = NO;
        }];
        _showBtn.backgroundColor = kPrimaryMain;
        _showBtn.layer.cornerRadius = kBtnBorderRadius;
        _showBtn.layer.masksToBounds = YES;
    }
    return _showBtn;
}

@end
