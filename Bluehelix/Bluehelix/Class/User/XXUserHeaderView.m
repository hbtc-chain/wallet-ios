
//  Created by 袁振 on 2017/6/19.
//  Copyright © 2017年 Bhex. All rights reserved.
//

#import "XXUserHeaderView.h"
#import "XXAccountManageVC.h"

@interface XXUserHeaderView ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) XXButton *manageBtn;

@end

@implementation XXUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBlue100;
        [self addSubview:self.manageBtn];
        [self addSubview:self.iconImageView];
        [self addSubview:self.textField];
        [self addSubview:self.addressLabel];
    }
    return self;
}

- (XXButton *)manageBtn {
    if (!_manageBtn) {
        MJWeakSelf;
        _manageBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 100, 46, 60, 26) title:LocalizedString(@"AccountManage") font:kFont10 titleColor:kWhite80 block:^(UIButton *button) {
            XXAccountManageVC *accountVC = [[XXAccountManageVC alloc] init];
            [weakSelf.viewController.navigationController pushViewController:accountVC animated:YES];
        }];
    }
    return _manageBtn;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(21), K375(66), 56, 56)];
        _iconImageView.image = [UIImage imageNamed:@"CreateWalletSuccess"];
    }
    return _iconImageView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame), K375(70), 100, 25)];
        _textField.text = KUser.rootAccount[@"userName"];
        _textField.textColor = kWhite100;
    }
    return _textField;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(self.textField.left, CGRectGetMaxY(self.textField.frame), kScreen_Width - K375(90), 20) font:kFont12 textColor:kWhite80];
        _addressLabel.text = KUser.rootAccount[@"BHAddress"];
    }
    return _addressLabel;
}

@end
