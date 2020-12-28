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

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) XXButton *copyAddressBtn;
@property (nonatomic, strong) XXLabel *symbolLabel;
@property (nonatomic, strong) XXLabel *addressTitleLabel;
@property (nonatomic, strong) UIView *dashLineView;
@property (nonatomic, strong) XXButton *saveImageBtn; //保存图片
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) UIView *symbolBackView;
@property (nonatomic, strong) UIImageView *symbolImageView;
@property (nonatomic, strong) XYHNumbersLabel *tipContentLabel;

@end

@implementation XXDepositCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

#pragma mark UI
- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ReceiveMoney");
    self.leftButton.imageView.image = [UIImage imageNamed:@"white_back"];
    self.navView.backgroundColor = kPrimaryMain;
    self.scrollView.backgroundColor = kPrimaryMain;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.backView];
    [self.backView addSubview:self.symbolBackView];
    [self.symbolBackView addSubview:self.symbolImageView];
    [self.backView addSubview:self.symbolLabel];
    [self.backView addSubview:self.codeImageView];
    [self.backView addSubview:self.addressTitleLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.saveImageBtn];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.copyAddressBtn];
    [self.backView addSubview:self.dashLineView];
    [self.scrollView addSubview:self.tipContentLabel];
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

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), K375(32), kScreen_Width-K375(48), 416)];
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
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
        [_symbolImageView sd_setImageWithURL:[NSURL URLWithString:token.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    }
    return _symbolImageView;
}

- (XXLabel *)symbolLabel {
    if (!_symbolLabel) {
        _symbolLabel = [XXLabel labelWithFrame:CGRectMake(0, 48, self.backView.width, 16) text:[NSString stringWithFormat:@"HBTC %@",LocalizedString(@"DepositChainAddress")] font:kFont17 textColor:[UIColor blackColor]];
    }
    _symbolLabel.textAlignment = NSTextAlignmentCenter;
    return _symbolLabel;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.backView.width - 168)/2, 88, 168, 168)];
        _codeImageView.image = [XCQrCodeTool createQrCodeWithContent:KUser.address];
    }
    return _codeImageView;
}

- (XXLabel *)addressTitleLabel {
    if (!_addressTitleLabel) {
        _addressTitleLabel = [XXLabel labelWithFrame:CGRectMake(16, CGRectGetMaxY(self.codeImageView.frame) + 16, self.backView.width - 32, 16) text:LocalizedString(@"PayToMe") font:kFont13 textColor:kGray700 alignment:NSTextAlignmentCenter];
    }
    return _addressTitleLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(16, CGRectGetMaxY(self.addressTitleLabel.frame) + 16, self.backView.width - 32, 24) text:KUser.address font:kFont(13) textColor:kGray700];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
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
        [shapeLayer setStrokeColor:[[UIColor colorWithHexString:@"#E7ECF4"] CGColor]];
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
        _saveImageBtn = [XXButton buttonWithFrame:CGRectMake(0, self.backView.height - 64, self.backView.width/2, 64) title:LocalizedString(@"SaveQRCode") font:kFontBold(17) titleColor:kPrimaryMain block:^(UIButton *button) {
            [weakSelf savePhoto];
        }];
    }
    return _saveImageBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.backView.width/2, self.backView.height - 44, 1, 24)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF4"];
    }
    return _lineView;
}

- (XXButton *)copyAddressBtn {
    if (!_copyAddressBtn) {
        _copyAddressBtn = [XXButton buttonWithFrame:CGRectMake(self.backView.width/2, self.backView.height - 64, self.backView.width/2, 64) title:LocalizedString(@"CopyAddress") font:kFontBold(17) titleColor:kPrimaryMain block:^(UIButton *button) {
            if (KUser.address.length > 0) {
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:KUser.address];
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

- (XYHNumbersLabel *)tipContentLabel {
    if (_tipContentLabel ==nil) {
        _tipContentLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(32), CGRectGetMaxY(self.backView.frame) + 24, kScreen_Width - K375(64), 0) font:kFont(13)];
        [_tipContentLabel setText:LocalizedString(@"DepositTipContent") alignment:NSTextAlignmentLeft];
        _tipContentLabel.textColor = [UIColor whiteColor];
    }
    return _tipContentLabel;
}

@end
