
//  Created by Bhex on 2017/6/19.
//  Copyright © 2017年 Bhex. All rights reserved.
//

#import "XXUserHeaderView.h"
#import "XXAccountManageVC.h"
#import "XXAccountBtn.h"

@interface XXUserHeaderView ()

@property (strong, nonatomic) XXLabel *icon;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) XXAccountBtn *manageBtn;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) XXButton *copyButton;

@end

@implementation XXUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhite100;
        [self addSubview:self.backImageView];
        [self addSubview:self.manageBtn];
        [self addSubview:self.icon];
        [self addSubview:self.textField];
        [self addSubview:self.addressLabel];
        [self addSubview:self.copyButton];
        [self configIcon];
    }
    return self;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(224))];
        _backImageView.image = [UIImage imageNamed:@"userHeaderBack"];
    }
    return _backImageView;
}

- (XXAccountBtn *)manageBtn {
    if (!_manageBtn) {
        MJWeakSelf;
        _manageBtn = [[XXAccountBtn alloc] initWithFrame:CGRectMake(00, 46, 0, 26) block:^{
            XXAccountManageVC *accountVC = [[XXAccountManageVC alloc] init];
            [weakSelf.viewController.navigationController pushViewController:accountVC animated:YES];
        }];
    }
    return _manageBtn;
}

- (XXLabel *)icon {
    if (!_icon) {
        _icon = [XXLabel labelWithFrame:CGRectMake(K375(21), K375(66), 56, 56) text:@"" font:kFont14 textColor:kWhite100 alignment:NSTextAlignmentCenter cornerRadius:28];
    }
    return _icon;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 8, K375(70), 100, 25)];
        _textField.text = KUser.currentAccount.userName;
        _textField.textColor = kWhite100;
    }
    return _textField;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:KUser.address font:kFont12];
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(self.textField.left, CGRectGetMaxY(self.textField.frame), width, 20) font:kFont12 textColor:kWhite80];
        _addressLabel.text = KUser.address;
    }
    return _addressLabel;
}

- (XXButton *)copyButton {
    if (_copyButton == nil) {
        _copyButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame), self.addressLabel.top - 12, 40, 40) block:^(UIButton *button) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:KUser.address];
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }];
        [_copyButton setImage:[UIImage imageNamed:@"paste"] forState:UIControlStateNormal];
    }
    return _copyButton;
}

- (void)configIcon{
    NSArray *colorArr = @[@"#54E19E",@"#66A3FF",@"#38a1e6",@"#E2C97F",@"#7887C5",@"#68B38F",@"#8B58DF",@"#66D0D7",@"#BEC65D",@"#F4934D"];
    if (!IsEmpty(KUser.currentAccount.userName)) {
        NSString *lastNumStr =[KUser.currentAccount.userName substringFromIndex:[KUser.currentAccount.userName length] - 1];
        int colorIndex = lastNumStr.intValue % 10;
        self.icon.backgroundColor = [UIColor colorWithHexString:colorArr[colorIndex]];
    }
    if (!IsEmpty(KUser.currentAccount.userName)) {
        self.icon.text = [KUser.currentAccount.userName substringToIndex:1];
    }
}

@end
