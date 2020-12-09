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
#import "XXDepositAlert.h"
#import "XXAssetSingleManager.h"
#import "XYHNumbersLabel.h"
#import "XXChooseTokenVC.h"
#import "XXWithdrawChainVC.h"

@interface XXDepositCoinVC ()

@property (nonatomic, strong) XXTokenModel *tokenModel;
@property (nonatomic, strong) XXButton *titleButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) XXButton *copyAddressBtn;
@property (nonatomic, strong) XXLabel *symbolLabel;
@property (nonatomic, strong) XXLabel *addressTitleLabel;
@property (nonatomic, strong) UIView *dashLineView;
@property (nonatomic, strong) XXButton *saveImageBtn; //保存图片
@property (nonatomic, strong) XXButton *changeChainBtn; //切换链地址
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) UIView *symbolBackView;
@property (nonatomic, strong) UIImageView *symbolImageView;
@property (nonatomic, strong) NSString *showAddress;
@property (nonatomic, strong) UILabel *tipContentLabel;
@property (nonatomic, strong) UIImageView *bottomLogo;

@end

@implementation XXDepositCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.symbol];
    [self buildUI];
}

#pragma mark UI
- (void)buildUI {
    self.titleLabel.hidden = YES;
    [self.navView addSubview:self.titleButton];
    self.leftButton.imageView.image = [UIImage imageNamed:@"white_back"];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.backView];
    [self.backView addSubview:self.symbolBackView];
    [self.symbolBackView addSubview:self.symbolImageView];
    [self.backView addSubview:self.symbolLabel];
    [self.backView addSubview:self.codeImageView];
    [self.backView addSubview:self.addressTitleLabel];
    [self.backView addSubview:self.changeChainBtn];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.saveImageBtn];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.copyAddressBtn];
    [self.backView addSubview:self.dashLineView];
    [self.scrollView addSubview:self.tipContentLabel];
    [self.scrollView addSubview:self.bottomLogo];
    [self reloadUI];
}

#pragma mark 刷新UI
- (void)reloadUI {
    [self setTitle];
    if (self.tokenModel.is_native) {
        self.changeChainBtn.hidden = YES;
        self.showAddress = KUser.address;
        self.symbolLabel.text = [NSString stringWithFormat:@"%@ %@",@"HBTC",LocalizedString(@"WalletAddress")];
        self.addressTitleLabel.text = [NSString stringWithFormat:@"%@ %@",@"HBTC",LocalizedString(@"WalletAddress")];
        [_changeChainBtn setTitle:LocalizedString(@"SwitchToChainAddress") forState:UIControlStateNormal];
    } else {
        self.changeChainBtn.hidden = NO;
        if (self.crossChainFlag) {
            self.showAddress = [[XXAssetSingleManager sharedManager] externalAddressBySymbol:self.tokenModel.symbol];
            self.symbolLabel.text = LocalizedString(@"CrossChainAddress");
            self.addressTitleLabel.text = [NSString stringWithFormat:@"%@%@",[self.tokenModel.chain uppercaseString],LocalizedString(@"WalletAddress")];
            [_changeChainBtn setTitle:LocalizedString(@"SwitchToMainAddress") forState:UIControlStateNormal];
            if (IsEmpty(self.showAddress)) {
                XXWithdrawChainVC *chainVC = [[XXWithdrawChainVC alloc] init];
                chainVC.tokenModel = self.tokenModel;
                [self.navigationController pushViewController:chainVC animated:YES];
            }
        } else {
            self.showAddress = KUser.address;
            self.symbolLabel.text = [NSString stringWithFormat:@"%@ %@",@"HBTC",LocalizedString(@"WalletAddress")];
            self.addressTitleLabel.text = [NSString stringWithFormat:@"%@ %@",@"HBTC",LocalizedString(@"WalletAddress")];
            [_changeChainBtn setTitle:LocalizedString(@"SwitchToChainAddress") forState:UIControlStateNormal];
        }
    }
    self.addressLabel.text = self.showAddress;
    self.codeImageView.image = [XCQrCodeTool createQrCodeWithContent:self.showAddress];
    [self.symbolImageView sd_setImageWithURL:[NSURL URLWithString:self.tokenModel.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    self.tipContentLabel.text = NSLocalizedFormatString(LocalizedString(@"LeastPayAmount"),[NSString stringWithFormat:@"%@%@",self.tokenModel.deposit_threshold,[self.tokenModel.name uppercaseString]]);
    [self configChainColor];
}

#pragma mark 事件 切换symbol
- (void)changeSymbol {
    MJWeakSelf
    XXChooseTokenVC *vc = [[XXChooseTokenVC alloc] init];
    vc.changeSymbolBlock = ^(NSString * _Nonnull symbol) {
        weakSelf.symbol = symbol;
        weakSelf.tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:symbol];
        [weakSelf reloadUI];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)configChainColor {
    UIColor *chainColor;
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        chainColor = kPrimaryMain;
    } else {
        if (!self.tokenModel.is_native && self.crossChainFlag) {
            chainColor = kGray;
        } else {
            chainColor = kGreen;
        }
    }
    self.navView.backgroundColor = chainColor;
    self.scrollView.backgroundColor = chainColor;
}

- (void)savePhoto {
    UIImageWriteToSavedPhotosAlbum(self.codeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"SavedToLibrary") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
    }
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

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 48)];
        _tipView.backgroundColor = KRGBA(52, 109, 116, 100);
    }
    return _tipView;
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(24, 3, kScreen_Width - 48, 0) text:LocalizedString(@"ChainTip") font:kFont13 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        _tipLabel.numberOfLines = 0;
        [_tipLabel sizeToFit];
        _tipView.frame = CGRectMake(0, 0, kScreen_Width, _tipLabel.frame.size.height + 6);
    }
    return _tipLabel;
}

- (UIView *)backView {
    if (!_backView) {
        CGFloat Y = K375(32);
        if (self.crossChainFlag) {
            Y += CGRectGetMaxY(self.tipView.frame);
        }
        _backView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), Y, kScreen_Width-K375(48), 400)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 8;
    }
    return _backView;
}

- (UIView *)symbolBackView {
    if (!_symbolBackView) {
        _symbolBackView = [[UIView alloc] initWithFrame:CGRectMake(self.backView.width/2 - K375(56)/2, -K375(28), K375(56), K375(56))];
        _symbolBackView.backgroundColor = [UIColor whiteColor];
        _symbolBackView.layer.cornerRadius = _symbolBackView.width/2;
        _symbolBackView.layer.masksToBounds = YES;
    }
    return _symbolBackView;
}

- (UIImageView *)symbolImageView {
    if (!_symbolImageView) {
        _symbolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.symbolBackView.width/2-K375(52)/2, self.symbolBackView.height/2-K375(52)/2, K375(52), K375(52))];
    }
    return _symbolImageView;
}

- (XXLabel *)symbolLabel {
    if (!_symbolLabel) {
        _symbolLabel = [XXLabel labelWithFrame:CGRectMake(0, 32, self.backView.width, 16) text:@"" font:kFont12 textColor:kGray500];
    }
    _symbolLabel.textAlignment = NSTextAlignmentCenter;
    return _symbolLabel;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.backView.width - 160)/2, 72, 160, 160)];
    }
    return _codeImageView;
}

- (XXLabel *)addressTitleLabel {
    if (!_addressTitleLabel) {
        _addressTitleLabel = [XXLabel labelWithFrame:CGRectMake(16, CGRectGetMaxY(self.codeImageView.frame) + 30, self.backView.width/2, 16) text:@"" font:kFont13 textColor:kGray700 alignment:NSTextAlignmentLeft];
    }
    return _addressTitleLabel;
}

- (XXButton *)changeChainBtn {
    if (!_changeChainBtn) {
        MJWeakSelf
        _changeChainBtn = [XXButton buttonWithFrame:CGRectMake(self.backView.width/2, CGRectGetMaxY(self.codeImageView.frame) + 30, self.backView.width/2, 16) block:^(UIButton *button) {
            weakSelf.crossChainFlag = !weakSelf.crossChainFlag;
            [weakSelf reloadUI];
        }];
        [_changeChainBtn setTitleColor:kPrimaryMain forState:UIControlStateNormal];
        [_changeChainBtn.titleLabel setFont:kFont13];
    }
    return _changeChainBtn;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(16, CGRectGetMaxY(self.addressTitleLabel.frame), self.backView.width - 32, 40) text:@"" font:kFont(13) textColor:kGray300];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.text = self.showAddress;
    }
    return _addressLabel;
}

- (UIView *)dashLineView {
    if (!_dashLineView) {
        _dashLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.height - 64, self.backView.width, 1)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:_dashLineView.bounds];
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(_dashLineView.frame) / 2, CGRectGetHeight(_dashLineView.frame))];
        [shapeLayer setFillColor:[UIColor clearColor].CGColor];
        [shapeLayer setStrokeColor:[kGray300 CGColor]];
        [shapeLayer setLineWidth:CGRectGetHeight(_dashLineView.frame)];
        [shapeLayer setLineJoin:kCALineJoinRound];
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:4], [NSNumber numberWithInt:2], nil]];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(_dashLineView.frame), 0);
        [shapeLayer setPath:path];
        CGPathRelease(path);
        [_dashLineView.layer addSublayer:shapeLayer];
    }
    return _dashLineView;
}

- (XXButton *)saveImageBtn {
    if (!_saveImageBtn) {
        MJWeakSelf
        _saveImageBtn = [XXButton buttonWithFrame:CGRectMake(0, self.backView.height - 64, self.backView.width/2, 64) title:LocalizedString(@"SaveImage") font:kFont17 titleColor:kPrimaryMain block:^(UIButton *button) {
            [weakSelf savePhoto];
        }];
    }
    return _saveImageBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.backView.width/2, self.backView.height - 44, 1, 24)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

- (XXButton *)copyAddressBtn {
    if (!_copyAddressBtn) {
        _copyAddressBtn = [XXButton buttonWithFrame:CGRectMake(self.backView.width/2, self.backView.height - 64, self.backView.width/2, 64) title:LocalizedString(@"CopyAddress") font:kFontBold(17) titleColor:kPrimaryMain block:^(UIButton *button) {
            if (self.showAddress.length > 0) {
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

- (UILabel *)tipContentLabel {
    if (_tipContentLabel ==nil) {
        _tipContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.backView.frame) + 16, kScreen_Width - K375(48), 23)];
        _tipContentLabel.font = kFont12;
        _tipContentLabel.textAlignment = NSTextAlignmentCenter;
        _tipContentLabel.textColor = [UIColor whiteColor];
    }
    return _tipContentLabel;
}

- (UIImageView *)bottomLogo {
    if (!_bottomLogo) {
        _bottomLogo = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 132)/2, CGRectGetMaxY(self.tipContentLabel.frame) + 60, 132, 16)];
        _bottomLogo.image = [UIImage imageNamed:@"deposit_logo"];
    }
    return _bottomLogo;
}

- (XXButton *)titleButton {
    if (_titleButton == nil) {
        MJWeakSelf
        _titleButton = [XXButton buttonWithFrame:CGRectMake(K375(64), kStatusBarHeight + 12, K375(247), kNavHeight - (kStatusBarHeight + 14)) block:^(UIButton *button) {
            [weakSelf changeSymbol];
        }];
        [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"whiteArrowDown"] forState:UIControlStateNormal];
        [self setTitle];
    }
    return _titleButton;
}

- (void)setTitle {
    NSString *name = self.crossChainFlag ? LocalizedString(@"Recharge") : LocalizedString(@"ReceiveMoney");
    NSString *text = [NSString stringWithFormat:@"%@ %@",[self.tokenModel.name uppercaseString],name];
    CGFloat width = [NSString widthWithText:text font:kFontBold17];
    [self.titleButton setTitle:text forState:UIControlStateNormal];
    [self.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.titleButton.imageView.bounds.size.width -2, 0, self.titleButton.imageView.bounds.size.width +2)];
    [self.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, width+2, 0, -width-2)];
}
@end
