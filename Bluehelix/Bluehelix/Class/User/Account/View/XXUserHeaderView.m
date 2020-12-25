
//  Created by Bhex on 2017/6/19.
//  Copyright © 2017年 Bhex. All rights reserved.
//

#import "XXUserHeaderView.h"
#import "XXAccountManageVC.h"
#import "XXAccountBtn.h"
#import "XXUserHeaderItemView.h"
#import "XXMessageCenterVC.h"
#import "XXUserNameView.h"
#import "XXWebViewController.h"

@interface XXUserHeaderView ()

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) XXButton *messageBtn;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) XXButton *copyButton;
@property (strong, nonatomic) UIImageView *editImageView;
@property (strong, nonatomic) XXUserHeaderItemView *leftItemView;
@property (strong, nonatomic) XXUserHeaderItemView *rightItemView;
@end

@implementation XXUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.backImageView];
        [self addSubview:self.messageBtn];
        [self addSubview:self.icon];
        [self addSubview:self.textField];
        [self addSubview:self.editImageView];
        [self addSubview:self.addressLabel];
        [self addSubview:self.copyButton];
        [self addSubview:self.leftItemView];
        [self addSubview:self.rightItemView];
    }
    return self;
}

- (void)setUnreadNum:(NSNumber *)unReadNum {
    if (unReadNum.intValue > 0) {
        [self.messageBtn setImage:[UIImage imageNamed:@"UserHeaderRedMessage"] forState:UIControlStateNormal];
    } else {
        [self.messageBtn setImage:[UIImage imageNamed:@"UserHeaderMessage"] forState:UIControlStateNormal];
    }
}

- (void)editAction {
    MJWeakSelf
    [XXUserNameView showWithSureBlock:^{
        weakSelf.textField.text = KUser.currentAccount.userName;
        CGFloat width = [NSString widthWithText:weakSelf.textField.text font:kFontBold(20)];
        weakSelf.textField.width = width > kScreen_Width - K375(48) - 80 ? kScreen_Width - K375(48) - 80 : width;
        weakSelf.editImageView.left = CGRectGetMaxX(weakSelf.textField.frame) + 8;
    }];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(224))];
        _backImageView.image = [UIImage imageNamed:@"userHeaderBack"];
    }
    return _backImageView;
}

- (XXButton *)messageBtn {
    if (!_messageBtn) {
        MJWeakSelf
        _messageBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 40, 46, 24, 24) block:^(UIButton *button) {
            XXMessageCenterVC *messageCenterVC = [[XXMessageCenterVC alloc] init];
            [weakSelf.viewController.navigationController pushViewController:messageCenterVC animated:YES];
        }];
        [_messageBtn setImage:[UIImage imageNamed:@"UserHeaderMessage"] forState:UIControlStateNormal];
    }
    return _messageBtn;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(K375(21), K375(76), 56, 56)];
        _icon.image = [UIImage imageNamed:@"headImage"];
    }
    return _icon;
}

- (UITextField *)textField {
    if (!_textField) {
        CGFloat width = [NSString widthWithText:KUser.currentAccount.userName font:kFontBold(20)];
        CGFloat showWidth = width > kScreen_Width - K375(48) - 80 ? kScreen_Width - K375(48) - 80 : width;
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 8, K375(80), showWidth, 25)];
        _textField.font = kFontBold(20);
        _textField.text = KUser.currentAccount.userName;
//        _textField.delegate = self;
        _textField.textColor = [UIColor whiteColor];
        _textField.enabled = NO;
    }
    return _textField;
}

- (UIImageView *)editImageView {
    if (!_editImageView) {
        _editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textField.frame) + 8,self.textField.top -2, self.textField.height, self.textField.height)];
        _editImageView.image = [UIImage imageNamed:@"editUserName"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editAction)];
        [_editImageView addGestureRecognizer:tap];
        _editImageView.userInteractionEnabled = YES;
    }
    return _editImageView;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:kAddressReplace(KUser.address) font:kFont12];
        CGFloat maxWidth = kScreen_Width - self.textField.left - 16 - 40;
        width = width > maxWidth ? maxWidth : width;
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(self.textField.left, CGRectGetMaxY(self.textField.frame), width, 20) font:kFont12 textColor:[UIColor whiteColor]];
        _addressLabel.text = kAddressReplace(KUser.address);
    }
    return _addressLabel;
}

- (XXButton *)copyButton {
    if (_copyButton == nil) {
        _copyButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame), self.addressLabel.top - 12, 40, 40) block:^(UIButton *button) {
            if (IsEmpty(KUser.address)) {
                Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopyFailed") duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            } else {
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:KUser.address];
                Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            }
        }];
        [_copyButton setImage:[UIImage imageNamed:@"paste"] forState:UIControlStateNormal];
    }
    return _copyButton;
}

- (XXUserHeaderItemView *)leftItemView {
    if (!_leftItemView) {
        _leftItemView = [[XXUserHeaderItemView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.addressLabel.frame) + 30, (kScreen_Width - K375(40))/2, 88)];
        _leftItemView.icon.image = [UIImage imageNamed:@"UserHeaderCoin"];
        _leftItemView.nameLabel.text = LocalizedString(@"TradeHistory");
        MJWeakSelf
        _leftItemView.block = ^{
            XXWebViewController *webVC = [[XXWebViewController alloc] init];
            if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"zh-"]) {
                webVC.urlString = [NSString stringWithFormat:@"%@%@%@%@",kServerUrl,@"/account/",KUser.address,@"?lang=zh-cn&type=transactions"];
            } else {
                webVC.urlString = [NSString stringWithFormat:@"%@%@%@%@",kServerUrl,@"/account/",KUser.address,@"?lang=zh-cn&type=transactions"];
            }
            [weakSelf.viewController.navigationController pushViewController:webVC animated:YES];
        };
    }
    return _leftItemView;
}

- (XXUserHeaderItemView *)rightItemView {
    if (!_rightItemView) {
        _rightItemView = [[XXUserHeaderItemView alloc] initWithFrame:CGRectMake(kScreen_Width/2 + 4, CGRectGetMaxY(self.addressLabel.frame) + 30, (kScreen_Width - K375(40))/2, 88)];
        _rightItemView.icon.image = [UIImage imageNamed:@"UserHeaderAccount"];
        _rightItemView.nameLabel.text =LocalizedString(@"AccountManage");
        MJWeakSelf
        _rightItemView.block = ^{
            XXAccountManageVC *accountVC = [[XXAccountManageVC alloc] init];
            [weakSelf.viewController.navigationController pushViewController:accountVC animated:YES];
        };
    }
    return _rightItemView;
}

@end
