//
//  XXChainAddressView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/6.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainAddressView.h"
#import "XCQrCodeTool.h"
#import "XXTokenModel.h"
#import "XXAssetSingleManager.h"
#import <UIImageView+WebCache.h>
@interface XXChainAddressView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UIView *symbolBackView;
@property (nonatomic, strong) UIImageView *symbolImageView;
@property (nonatomic, strong) XXButton *copyAddressBtn;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) NSString *chain;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) XXTokenModel *token;
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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.codeImageView];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.copyAddressBtn];
    if (!IsEmpty(self.chain)) {
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.chain];
        [self.contentView addSubview:self.tipLabel];
        [self.symbolImageView sd_setImageWithURL:[NSURL URLWithString:token.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    } else {
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
        [self.symbolImageView sd_setImageWithURL:[NSURL URLWithString:token.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    }
}

+ (void)showMainAccountAddress {
    
    XXChainAddressView *alert = [[XXChainAddressView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    alert.address = KUser.address;
    [alert buildUI];
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - K375(460);
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)showWithChain:(NSString *)chain {
    
    XXChainAddressView *alert = [[XXChainAddressView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    alert.address = [[XXAssetSingleManager sharedManager] externalAddressBySymbol:chain];
    alert.chain = chain;
    [alert buildUI];
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - K375(460);
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - K375(460), kScreen_Width, K375(460))];
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

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(0, K375(46), kScreen_Width, 32) text:@"" font:kFont20 textColor:kGray900 alignment:NSTextAlignmentCenter];
        if (IsEmpty(_chain)) {
            _nameLabel.text = [NSString stringWithFormat:@"%@ %@",@"HBTC",LocalizedString(@"WalletAddress")];
        } else {
            _nameLabel.text = LocalizedString(@"CrossChainAddress");
        }
    }
    return _nameLabel;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(100), K375(100), kScreen_Width - K375(200), kScreen_Width - K375(200))];
        _codeImageView.image = [XCQrCodeTool createQrCodeWithContent:self.address];
    }
    return _codeImageView;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.codeImageView.frame), kScreen_Width, 40) text:@"" font:kFont(13) textColor:kGray500];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.text = self.address;
    }
    return _addressLabel;
}

- (XXButton *)copyAddressBtn {
    if (!_copyAddressBtn) {
        _copyAddressBtn = [XXButton buttonWithFrame:CGRectMake(K375(24), self.contentView.height - K375(138), kScreen_Width - K375(48), K375(56)) title:LocalizedString(@"ClickCopyAddress") font:kFontBold(17) titleColor:kPrimaryMain block:^(UIButton *button) {
            if (!IsEmpty(self.address)) {
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

- (XXLabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.copyAddressBtn.frame) + K375(24), kScreen_Width, 16) font:kFont13 textColor:kGray700];
        ;
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.chain];
        NSString *tip1 = LocalizedString(@"LeastPayAmountTip");
        NSString *tip2 = [NSString stringWithFormat:@"%@%@",token.deposit_threshold,[token.name uppercaseString]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",tip1,tip2]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kGray700 range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kPrimaryMain range:NSMakeRange(tip1.length, tip2.length)];
        _tipLabel.attributedText = attributedString;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

@end
