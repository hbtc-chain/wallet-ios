//
//  XXDepositCoinVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/06.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXDepositCrossVC.h"
#import "XCQrCodeTool.h"
#import "XXTokenModel.h"
#import <UIImageView+WebCache.h>
#import "XXDepositAlert.h"
#import "XXAssetSingleManager.h"
#import "XYHNumbersLabel.h"
#import "XXChooseTokenVC.h"
#import "XXWithdrawChainVC.h"
#import "XXDepositChooseTokenView.h"
#import "XXCrossDepositAlert.h"

@interface XXDepositCrossVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XXLabel *depositTitleLabel;// 充值标题
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
@property (nonatomic, strong) XXLabel *tipTitleLabel;
@property (nonatomic, strong) XXLabel *minDepositLabel;
@property (nonatomic, strong) XXButton *recordBtn; //跨链充值入账费 提示
@property (nonatomic, strong) XXDepositChooseTokenView *chooseTokenView;

@end

@implementation XXDepositCrossVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.symbol = self.chain;
    [self buildUI];
}

#pragma mark UI
- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ChainReceiveMoney");
    self.leftButton.imageView.image = [UIImage imageNamed:@"white_back"];
    self.navView.backgroundColor = kPrimaryMain;
    self.scrollView.backgroundColor = kPrimaryMain;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.depositTitleLabel];
    [self.scrollView addSubview:self.chooseTokenView];
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
    [self.scrollView addSubview:self.tipTitleLabel];
    [self.scrollView addSubview:self.minDepositLabel];
    [self.scrollView addSubview:self.recordBtn];
    [self refreshUI];
}

#pragma mark 切换symbol 刷新UI
- (void)refreshUI {
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.symbol];
    self.minDepositLabel.text = [NSString stringWithFormat:@"%@%@: %@ %@",[token.name uppercaseString],LocalizedString(@"MinDepositAmount"),token.deposit_threshold,[token.name uppercaseString]];
    NSString *recordText = [NSString stringWithFormat:@"%@: %@ %@",LocalizedString(@"CrossDepositFee"),token.collect_fee,[token.chain uppercaseString]];
    [self.recordBtn setTitle:recordText forState:UIControlStateNormal];
    [self.recordBtn setImage:[UIImage imageNamed:@"deposit_question"] forState:UIControlStateNormal];
    CGFloat width = [NSString widthWithText:recordText font:kFont13];
    [self.recordBtn setImageEdgeInsets:UIEdgeInsetsMake(2, width + 4, 0, -width-4)];
    [self.recordBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.recordBtn.imageView.width, 0, self.recordBtn.imageView.width)];
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

- (XXLabel *)depositTitleLabel {
    if (!_depositTitleLabel) {
        _depositTitleLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), K375(32), kScreen_Width-K375(48), 24) text:LocalizedString(@"DepositToken") font:kFont14 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    }
    return _depositTitleLabel;
}

- (XXDepositChooseTokenView *)chooseTokenView {
    if (!_chooseTokenView) {
        _chooseTokenView = [[XXDepositChooseTokenView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.depositTitleLabel.frame) + 8, kScreen_Width - K375(48), 48) symbol:self.chain];
        _chooseTokenView.backgroundColor = [UIColor whiteColor];
        _chooseTokenView.layer.cornerRadius = 8;
        MJWeakSelf
        _chooseTokenView.changeSymbolBlock = ^(NSString * symbol) {
            weakSelf.symbol = symbol;
            [weakSelf refreshUI];
        };
    }
    return _chooseTokenView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.chooseTokenView.frame) + 8, kScreen_Width-K375(48), 392)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 8;
    }
    return _backView;
}

- (XXLabel *)symbolLabel {
    if (!_symbolLabel) {
        _symbolLabel = [XXLabel labelWithFrame:CGRectMake(0, 24, self.backView.width, 16) text:LocalizedString(@"CrossChainAddress") font:kFont17 textColor:[UIColor blackColor]];
    }
    _symbolLabel.textAlignment = NSTextAlignmentCenter;
    return _symbolLabel;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        NSString *address = [[XXAssetSingleManager sharedManager] externalAddressBySymbol:self.chain];
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.backView.width - 168)/2, 64, 168, 168)];
        _codeImageView.image = [XCQrCodeTool createQrCodeWithContent:address];
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
        NSString *address = [[XXAssetSingleManager sharedManager] externalAddressBySymbol:self.chain];
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(16, CGRectGetMaxY(self.addressTitleLabel.frame) + 16, self.backView.width - 32, 48) text:address font:kFont(13) textColor:kGray700];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.numberOfLines = 0;
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
            NSString *address = [[XXAssetSingleManager sharedManager] externalAddressBySymbol:self.chain];
            if (!IsEmpty(address)) {
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:address];
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

- (XXLabel *)tipTitleLabel {
    if (_tipTitleLabel == nil) {
        _tipTitleLabel = [XXLabel labelWithFrame:CGRectMake(K375(32), CGRectGetMaxY(self.backView.frame) + 24, kScreen_Width - K375(64), 20) text:LocalizedString(@"Tip") font:kFont13 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    }
    return _tipTitleLabel;
}

- (XXLabel *)minDepositLabel {
    if (_minDepositLabel == nil) {
        _minDepositLabel = [XXLabel labelWithFrame:CGRectMake(K375(32), CGRectGetMaxY(self.tipTitleLabel.frame), kScreen_Width - K375(64), 20) text:@"" font:kFont13 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    }
    return _minDepositLabel;
}

- (XXButton *)recordBtn {
    if (_recordBtn == nil) {
        _recordBtn = [XXButton buttonWithFrame:CGRectMake(K375(32), CGRectGetMaxY(self.minDepositLabel.frame), kScreen_Width - K375(64), 20) block:^(UIButton *button) {
            [XXCrossDepositAlert show];
        }];
        [_recordBtn.titleLabel setFont:kFont13];
        [_recordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _recordBtn;
}
@end
