//
//  XXVisitAddressAlert.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/9.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXVisitAddressAlert.h"

@interface XXVisitAddressAlert ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIImageView *screenShotImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) XXButton *okBtn;
@property (nonatomic, strong) XXButton *rejectBtn;

@end

@implementation XXVisitAddressAlert


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
    [self.contentView addSubview:self.screenShotImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.okBtn];
    [self.contentView addSubview:self.rejectBtn];
}

+ (void)showWithSureBlock:(void (^)(void))sureBlock rejectBlock:(void (^)(void))rejectBlock {
    
    XXVisitAddressAlert *alert = [[XXVisitAddressAlert alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    [alert buildUI];
    alert.sureBlock = sureBlock;
    alert.rejectBlock = rejectBlock;
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - 276;
    } completion:^(BOOL finished) {
       
    }];
}


+ (void)dismiss {
    XXVisitAddressAlert *view = (XXVisitAddressAlert *)[self currentView];
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
    if (self.rejectBlock) {
        self.rejectBlock();
    }
    [[self class] dismiss];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _backView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 276, kScreen_Width, 276)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIImageView *)screenShotImageView {
    if (_screenShotImageView == nil) {
        _screenShotImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width-64)/2, 24, 64, 64)];
        _screenShotImageView.image = [UIImage imageNamed:@"ScreenShot"];
    }
    return _screenShotImageView;
}

- (UIButton *)dismissBtn {
    if (_dismissBtn == nil ) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - K375(50), 0, K375(50), K375(50))];
        [_dismissBtn setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 94, kScreen_Width - 32, 24)];
        _titleLabel.text = LocalizedString(@"ABCC");
        _titleLabel.font = kFontBold(19);
        _titleLabel.textColor = kGray900NoChange;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 124, kScreen_Width - 32, 44)];
        _contentLabel.text = LocalizedString(@"VisitDescription");
        _contentLabel.font = kFont15;
        _contentLabel.textColor = kGray700;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _contentLabel;
}

- (XXButton *)rejectBtn {
    if (!_rejectBtn) {
        MJWeakSelf
        _rejectBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), self.contentView.height - kBtnHeight - 24, kScreen_Width/2 - K375(40)/2, kBtnHeight) title:LocalizedString(@"Reject") font:kFont(17) titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            if (weakSelf.sureBlock) {
                [[weakSelf class] dismiss];
                weakSelf.sureBlock();
            }
        }];
        _rejectBtn.backgroundColor = kGray200;
        _rejectBtn.layer.cornerRadius = kBtnBorderRadius;
        _rejectBtn.layer.masksToBounds = YES;
    }
    return _rejectBtn;
}

- (XXButton *)okBtn {
    if (!_okBtn) {
        MJWeakSelf
        _okBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width/2 + 4, self.contentView.height - kBtnHeight - 24, kScreen_Width/2 - K375(40)/2, kBtnHeight) title:LocalizedString(@"Sure") font:kFont(17) titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [[weakSelf class] dismiss];
        }];
        _okBtn.backgroundColor = kPrimaryMain;
        _okBtn.layer.cornerRadius = kBtnBorderRadius;
        _okBtn.layer.masksToBounds = YES;
    }
    return _okBtn;
}

@end

