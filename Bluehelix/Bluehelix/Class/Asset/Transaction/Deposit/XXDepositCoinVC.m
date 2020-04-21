//
//  XXDepositCoinVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/06.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXDepositCoinVC.h"
#import "XCQrCodeTool.h"
#import "XXTokenModel.h"
#import <UIImageView+WebCache.h>

@interface XXDepositCoinVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topBackImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) XXButton *copyAddressBtn;
@property (nonatomic, strong) XXLabel *symbolLabel;
@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) UIView *symbolBackView;
@property (nonatomic, strong) UIImageView *symbolImageView;
@property (nonatomic, strong) NSString *showAddress;

@end

@implementation XXDepositCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showAlert];
    [self buildUI];
}

- (void)showAlert {
    NSString *message;
    if (self.InnerChain) {
        self.showAddress = KUser.address;
        message = LocalizedString(@"DepositTip");
    } else {
        message = LocalizedString(@"ChainDepositTip");
        self.showAddress = self.tokenModel.external_address;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalizedString(@"Tip") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:LocalizedString(@"ShowAddress") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ReceiveMoney");
    self.titleLabel.textColor = kWhiteColor;
    self.leftButton.imageView.image = [UIImage imageNamed:@"white_back"];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.topBackImageView];
    [self.scrollView addSubview:self.bottomImageView];
    [self.topBackImageView addSubview:self.codeImageView];
    [self.topBackImageView addSubview:self.symbolBackView];
    [self.symbolBackView addSubview:self.symbolImageView];
    [self.bottomImageView addSubview:self.copyAddressBtn];
    [self.topBackImageView addSubview:self.symbolLabel];
    [self.topBackImageView addSubview:self.addressLabel];
    [self configChainColor];
}

- (void)configChainColor {
    UIColor *chainColor;
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        chainColor = kPrimaryMain;
    } else {
        if (!self.tokenModel.is_native && !self.InnerChain) {
            chainColor = kGray;
        } else {
            chainColor = kGreen;
        }
    }
    self.navView.backgroundColor = chainColor;
    self.scrollView.backgroundColor = chainColor;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight)];
        _scrollView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIImageView *)topBackImageView {
    if (!_topBackImageView) {
        _topBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(24), K375(40), kScreen_Width-K375(48), kScreen_Width-K375(48))];
        _topBackImageView.image = [UIImage imageNamed:@"depositTopBack"];
    }
    return _topBackImageView;
}

- (UIView *)symbolBackView {
    if (!_symbolBackView) {
        _symbolBackView = [[UIView alloc] initWithFrame:CGRectMake(self.topBackImageView.width/2 - K375(56)/2, -K375(28), K375(60), K375(60))];
        _symbolBackView.backgroundColor = kWhiteColor;
        _symbolBackView.layer.cornerRadius = _symbolBackView.width/2;
        _symbolBackView.layer.masksToBounds = YES;
    }
    return _symbolBackView;
}

- (UIImageView *)symbolImageView {
    if (!_symbolImageView) {
        _symbolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.symbolBackView.width/2-K375(56)/2, self.symbolBackView.height/2-K375(56)/2, K375(56), K375(56))];
        [_symbolImageView sd_setImageWithURL:[NSURL URLWithString:self.tokenModel.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    }
    return _symbolImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.topBackImageView.frame), kScreen_Width-K375(48), K375(72))];
        _bottomImageView.image = [UIImage imageNamed:@"depositBottomBack"];
        _bottomImageView.userInteractionEnabled = YES;
    }
    return _bottomImageView;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(73), K375(81), self.topBackImageView.width - K375(146), self.topBackImageView.width - K375(146))];
        _codeImageView.image = [XCQrCodeTool createQrCodeWithContent:self.showAddress];
    }
    return _codeImageView;
}

- (XXLabel *)symbolLabel {
    if (!_symbolLabel) {
        _symbolLabel = [XXLabel labelWithFrame:CGRectMake(0, K375(32), self.topBackImageView.width, 24) text:[NSString stringWithFormat:@"%@%@",self.tokenModel.symbol,LocalizedString(@"WalletAddress")] font:kFontBold18 textColor:kGray900];
    }
    _symbolLabel.textAlignment = NSTextAlignmentCenter;
    return _symbolLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.codeImageView.frame), self.topBackImageView.width, self.topBackImageView.height - CGRectGetMaxY(self.codeImageView.frame)) text:@"" font:kFont(13) textColor:kGray900];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.text = self.showAddress;
    }
    return _addressLabel;
}

- (XXButton *)copyAddressBtn {
    if (!_copyAddressBtn) {
        _copyAddressBtn = [XXButton buttonWithFrame:CGRectMake(5, 2, self.bottomImageView.width - 10, self.bottomImageView.height - 4) title:LocalizedString(@"CopyAddress") font:kFont(17) titleColor:kPrimaryMain block:^(UIButton *button) {
            if (KUser.address  > 0) {
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:self.showAddress];
                Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            } else {
                Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopyFailed") duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            }
        }];
    }
    return _copyAddressBtn;
}

@end
