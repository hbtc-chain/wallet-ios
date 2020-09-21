//
//  XXChainAddressView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/6.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainAddressView.h"
#import "XCQrCodeTool.h"

@interface XXChainAddressView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UIView *symbolBackView;
@property (nonatomic, strong) UIImageView *symbolImageView;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) XXButton *copyAddressBtn;
@property (nonatomic, strong) XXLabel *addressLabel;

@end

@implementation XXChainAddressView

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
    [self.contentView addSubview:self.symbolBackView];
    [self.symbolBackView addSubview:self.symbolImageView];
    [self.contentView addSubview:self.codeImageView];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.copyAddressBtn];
}
+ (void)showWithAddress:(NSString *)address {
    
    XXChainAddressView *alert = [[XXChainAddressView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    alert.address = address;
    [alert buildUI];
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - K375(400);
    } completion:^(BOOL finished) {
       
    }];
}

+ (void)dismiss {
    XXChainAddressView *view = (XXChainAddressView *)[self currentView];
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
    [[self class] dismiss];
}

- (void)cancelAction {
    [[self class] dismiss];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _backView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - K375(400), kScreen_Width, K375(400))];
        _contentView.backgroundColor = kWhiteColor;
        _contentView.layer.cornerRadius = 10;
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

- (UIView *)symbolBackView {
    if (!_symbolBackView) {
        _symbolBackView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - K375(72)/2, -K375(36), K375(72), K375(72))];
        _symbolBackView.backgroundColor = [UIColor whiteColor];
        _symbolBackView.layer.cornerRadius = _symbolBackView.width/2;
        _symbolBackView.layer.masksToBounds = YES;
    }
    return _symbolBackView;
}

- (UIImageView *)symbolImageView {
    if (!_symbolImageView) {
        _symbolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(4), K375(4), K375(64), K375(64))];
        [_symbolImageView setImage:[UIImage imageNamed:@"placeholderToken"]];
    }
    return _symbolImageView;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(100), K375(70), kScreen_Width - K375(200), kScreen_Width - K375(200))];
        _codeImageView.image = [XCQrCodeTool createQrCodeWithContent:self.address];
    }
    return _codeImageView;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.codeImageView.frame), kScreen_Width, 40) text:@"" font:kFont(13) textColor:[UIColor colorWithHexString:@"#0A1825"]];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.text = self.address;
    }
    return _addressLabel;
}

- (XXButton *)copyAddressBtn {
    if (!_copyAddressBtn) {
        _copyAddressBtn = [XXButton buttonWithFrame:CGRectMake(K375(24), self.contentView.height - K375(88), kScreen_Width - K375(48), K375(56)) title:LocalizedString(@"ClickCopyAddress") font:kFontBold(17) titleColor:kPrimaryMain block:^(UIButton *button) {
            if (KUser.address  > 0) {
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:self.address];
                Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            } else {
                Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopyFailed") duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            }
        }];
        _copyAddressBtn.layer.borderWidth = 1;
        _copyAddressBtn.layer.borderColor = [kPrimaryMain CGColor];
    }
    return _copyAddressBtn;
}

@end
