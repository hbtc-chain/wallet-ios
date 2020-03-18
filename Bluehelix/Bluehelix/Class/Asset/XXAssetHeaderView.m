//
//  XXAssetHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetHeaderView.h"

@interface XXAssetHeaderView ()

@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) XXLabel *nameLabel;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) XXLabel *logoLabel;
@property (strong, nonatomic) XXButton *copyButton;
@end

@implementation XXAssetHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhite100;
        [self addSubview:self.backImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.copyButton];
        [self addSubview:self.logoLabel];
    }
    return self;
}

- (XXLabel *)logoLabel {
    if (!_logoLabel) {
        CGFloat top = BH_IS_IPHONE_X ? 40 : 30;
        _logoLabel = [XXLabel labelWithFrame:CGRectMake(0, top, kScreen_Width, 25) font:kFontBold(13) textColor:kWhite100];
        _logoLabel.text = LocalizedString(@"logoName");
        _logoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _logoLabel;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(224))];
        _backImageView.image = [UIImage imageNamed:@"assetHeaderBack"];
    }
    return _backImageView;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), K375(64), kScreen_Width - K375(90), 40) font:kFontBold(30) textColor:kWhite100];
        _nameLabel.text = LocalizedString(@"Asset");
    }
    return _nameLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:KUser.rootAccount[@"BHAddress"] font:kFont12];
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(self.nameLabel.left, CGRectGetMaxY(self.nameLabel.frame), width, 20) font:kFont12 textColor:kWhite80];
        _addressLabel.text = KUser.rootAccount[@"BHAddress"];
    }
    return _addressLabel;
}

- (XXButton *)copyButton {
    if (_copyButton == nil) {
        _copyButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame), self.addressLabel.top - 12, 40, 40) block:^(UIButton *button) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:KUser.rootAccount[@"BHAddress"]];
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }];
        [_copyButton setImage:[UIImage imageNamed:@"paste"] forState:UIControlStateNormal];
    }
    return _copyButton;
}

@end
