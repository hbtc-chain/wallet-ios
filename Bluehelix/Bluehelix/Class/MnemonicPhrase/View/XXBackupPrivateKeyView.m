//
//  XXBackupPrivateKeyView.m
//  Bluehelix
//
//  Created by BHEX on 2020/5/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXBackupPrivateKeyView.h"
#import "XYHNumbersLabel.h"

@interface XXBackupPrivateKeyView ()

@property (nonatomic, strong) XXLabel *tipLabel1;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel1;
@property (nonatomic, strong) XXLabel *tipLabel2;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel2;
@property (nonatomic, strong) XXLabel *tipLabel3;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel3;
@property (nonatomic, strong) UIView *textBackView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) XXButton *copyBtn;

@end

@implementation XXBackupPrivateKeyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tipLabel1];
        [self addSubview:self.contentLabel1];
        [self addSubview:self.tipLabel2];
        [self addSubview:self.contentLabel2];
        [self addSubview:self.tipLabel3];
        [self addSubview:self.contentLabel3];
        [self addSubview:self.textBackView];
        [self.textBackView addSubview:self.textView];
        [self addSubview:self.copyBtn];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
}

- (void)copyAction {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:self.text];
    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
    }];
    [alert showAlert];
}

- (XXLabel *)tipLabel1 {
    if (!_tipLabel1) {
        _tipLabel1 = [XXLabel labelWithFrame:CGRectMake(K375(24), 24, kScreen_Width - K375(48), 25) text:LocalizedString(@"BackupPrivateKeyTip1") font:kFontBold17 textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel1;
}

- (XYHNumbersLabel *)contentLabel1 {
    if (!_contentLabel1) {
        _contentLabel1 = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.tipLabel1.frame) + 4, kScreen_Width - K375(48), 0) font:kFont(15)];
        _contentLabel1.textColor = kGray500;
        [_contentLabel1 setText:LocalizedString(@"BackupPrivateKeyContent1") alignment:NSTextAlignmentLeft];
    }
    return _contentLabel1;
}

- (XXLabel *)tipLabel2 {
    if (!_tipLabel2) {
        _tipLabel2 = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.contentLabel1.frame) + 12, kScreen_Width - K375(48), 25) text:LocalizedString(@"BackupPrivateKeyTip2") font:kFontBold17 textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel2;
}

- (XYHNumbersLabel *)contentLabel2 {
    if (!_contentLabel2) {
        _contentLabel2 = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.tipLabel2.frame) + 4, kScreen_Width - K375(48), 0) font:kFont(15)];
        _contentLabel2.textColor = kGray500;
        [_contentLabel2 setText:LocalizedString(@"BackupPrivateKeyContent2") alignment:NSTextAlignmentLeft];
    }
    return _contentLabel2;
}

- (XXLabel *)tipLabel3 {
    if (!_tipLabel3) {
        _tipLabel3 = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.contentLabel2.frame) + 12, kScreen_Width - K375(48), 25) text:LocalizedString(@"BackupPrivateKeyTip3") font:kFontBold17 textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel3;
}

- (XYHNumbersLabel *)contentLabel3 {
    if (!_contentLabel3) {
        _contentLabel3 = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.tipLabel3.frame) + 4, kScreen_Width - K375(48), 0) font:kFont(15)];
        _contentLabel3.textColor = kGray500;
        [_contentLabel3 setText:LocalizedString(@"BackupPrivateKeyContent3") alignment:NSTextAlignmentLeft];
    }
    return _contentLabel3;
}

- (UIView *)textBackView {
    if (!_textBackView) {
        _textBackView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.contentLabel3.frame) + 24, kScreen_Width - K375(48), 72)];
        _textBackView.backgroundColor = kGray50;
        _textBackView.layer.cornerRadius = kBtnBorderRadius;
        _textBackView.layer.masksToBounds = YES;
    }
    return _textBackView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.textBackView.bounds];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = kFont(13);
        _textView.textColor = kGray700;
    }
    return _textView;
}

- (XXButton *)copyBtn {
    if (!_copyBtn) {
        MJWeakSelf
        _copyBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), self.height - 64, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"CopyPrivateKey") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf copyAction];
        }];
        _copyBtn.backgroundColor = kPrimaryMain;
        _copyBtn.layer.cornerRadius = kBtnBorderRadius;
        _copyBtn.layer.masksToBounds = YES;
    }
    return _copyBtn;
}

@end
