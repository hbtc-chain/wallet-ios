//
//  XXSecurityAlertView.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/21.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSecurityAlertView.h"
#import "XYHNumbersLabel.h"

@interface XXSecurityAlertView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIImageView *screenShotImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) XXLabel *tipNamelabel;
@property (nonatomic, strong) XYHNumbersLabel *tipContentlabel;
@property (nonatomic, strong) XXButton *laterBtn;
@property (nonatomic, strong) XXButton *immediatelyBtn;

@end

@implementation XXSecurityAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.dismissBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.tipView];
    [self.tipView addSubview:self.tipNamelabel];
    [self.tipView addSubview:self.tipContentlabel];
    [self.contentView addSubview:self.laterBtn];
    [self.contentView addSubview:self.immediatelyBtn];
}
+ (void)showWithSureBlock:(void (^)(void))sureBlock {
    
    XXSecurityAlertView *alert = [[XXSecurityAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    [alert buildUI];
    alert.sureBlock = sureBlock;
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - 330;
    } completion:^(BOOL finished) {
       
    }];
}

+ (void)dismiss {
    XXSecurityAlertView *view = (XXSecurityAlertView *)[self currentView];
    if (view) {
        [UIView animateWithDuration:0.25 animations:^{
            view.contentView.top = kScreen_Height;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                view.backView.alpha = 0;
                view.contentView.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }];
    }
}

+ (UIView *)currentView {
    for (UIView *view in [KWindow subviews]) {
        if ([view isKindOfClass:[self class]]) {
            return view;
        }
    }
    return nil;
}

- (void)okAction {
    if (self.sureBlock) {
        self.sureBlock();
    }
    [[self class] dismiss];
}

- (void)cancelAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [[self class] dismiss];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [kGray900 colorWithAlphaComponent:0.6];
    }
    return _backView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 330, kScreen_Width, 330)];
        _contentView.backgroundColor = kWhiteColor;
    }
    return _contentView;
}

- (UIButton *)dismissBtn {
    if (_dismissBtn == nil ) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - K375(50), 0, K375(50), K375(50))];
        [_dismissBtn setImage:[UIImage textImageName:@"dismiss"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 24, kScreen_Width - 200, 24)];
        _titleLabel.text = LocalizedString(@"BackupSecurityTip");
        _titleLabel.font = kFontBold20;
        _titleLabel.textColor = kGray900;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(K375(16), 64, kScreen_Width - K375(32), 18)];
        _contentLabel.text = LocalizedString(@"BackupSecurityTip1");
        _contentLabel.font = kFont14;
        _contentLabel.textColor = kGray900;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.contentLabel.frame) + 8, kScreen_Width - K375(32), 150)];
        _tipView.layer.borderColor = [KLine_Color CGColor];
        _tipView.layer.borderWidth = 1;
        _tipView.layer.cornerRadius = kBtnBorderRadius;
        _tipView.layer.masksToBounds = YES;
    }
    return _tipView;
}

- (XXLabel *)tipNamelabel {
    if (!_tipNamelabel) {
        _tipNamelabel = [XXLabel labelWithFrame:CGRectMake(K375(16), K375(16), kScreen_Width - K375(64), 24) text:LocalizedString(@"BackupSecurityTip2") font:kFont(15) textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipNamelabel;
}

- (XYHNumbersLabel *)tipContentlabel {
    if (!_tipContentlabel) {
        _tipContentlabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipNamelabel.frame) + 10, kScreen_Width - K375(64), 0) font:kFont(15)];
        _tipContentlabel.textColor = kGray500;
        [_tipContentlabel setText:LocalizedString(@"BackupSecurityContent") alignment:NSTextAlignmentLeft];
    }
    return _tipContentlabel;
}

- (XXButton *)laterBtn {
    if (!_laterBtn) {
        MJWeakSelf
        _laterBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), self.contentView.height - kBtnHeight - 24, kScreen_Width/2 - K375(40)/2, kBtnHeight) title:LocalizedString(@"BackupLaterRemind") font:kFont(17) titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [[weakSelf class] dismiss];
        }];
        _laterBtn.backgroundColor = kGray200;
        _laterBtn.layer.cornerRadius = kBtnBorderRadius;
        _laterBtn.layer.masksToBounds = YES;
    }
    return _laterBtn;
}

- (XXButton *)immediatelyBtn {
    if (!_immediatelyBtn) {
        MJWeakSelf
        _immediatelyBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width/2 + 4, self.contentView.height - kBtnHeight - 24, kScreen_Width/2 - K375(40)/2, kBtnHeight) title:LocalizedString(@"BackupImmediately") font:kFont(17) titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            if (weakSelf.sureBlock) {
                [[weakSelf class] dismiss];
                weakSelf.sureBlock();
            }
        }];
        _immediatelyBtn.backgroundColor = kPrimaryMain;
        _immediatelyBtn.layer.cornerRadius = kBtnBorderRadius;
        _immediatelyBtn.layer.masksToBounds = YES;
    }
    return _immediatelyBtn;
}


@end
