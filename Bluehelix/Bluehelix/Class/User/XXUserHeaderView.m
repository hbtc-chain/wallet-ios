
//  Created by 袁振 on 2017/6/19.
//  Copyright © 2017年 Bhex. All rights reserved.
//

#import "XXUserHeaderView.h"
#import "XXAccountManageVC.h"

@interface XXUserHeaderView ()

@property (strong, nonatomic) XXLabel *icon;
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
        [self addSubview:self.icon];
        [self addSubview:self.textField];
        [self addSubview:self.addressLabel];
        [self configIcon];
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

- (XXLabel *)icon {
    if (!_icon) {
        _icon = [XXLabel labelWithFrame:CGRectMake(K375(21), K375(66), 56, 56) text:@"" font:kFont14 textColor:kWhite100 alignment:NSTextAlignmentCenter cornerRadius:28];
    }
    return _icon;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 8, K375(70), 100, 25)];
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

- (void)configIcon{
    NSArray *colorArr = @[@"#54E19E",@"#66A3FF",@"#38a1e6",@"#E2C97F",@"#7887C5",@"#68B38F",@"#8B58DF",@"#66D0D7",@"#BEC65D",@"#F4934D"];
    if (!IsEmpty(KUser.rootAccount[@"userName"])) {
        NSString *lastNumStr =[KUser.rootAccount[@"userName"] substringFromIndex:[KUser.rootAccount[@"userName"] length] - 1];
        int colorIndex = lastNumStr.intValue % 10;
        self.icon.backgroundColor = [UIColor colorWithHexString:colorArr[colorIndex]];
    }
    if (!IsEmpty(KUser.rootAccount[@"userName"])) {
        self.icon.text = [KUser.rootAccount[@"userName"] substringToIndex:1];
    }
}

@end
