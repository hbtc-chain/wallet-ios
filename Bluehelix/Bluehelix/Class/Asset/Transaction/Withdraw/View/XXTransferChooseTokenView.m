//
//  XXTransferChooseTokenView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferChooseTokenView.h"
#import "XXChooseTokenVC.h"
#import "XXTokenModel.h"

@implementation XXTransferChooseTokenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        [self addSubview:self.nameLabel];
        
        [self addSubview:self.banView];
        
        [self.banView addSubview:self.chooseTokenButton];
        
        [self.banView addSubview:self.textField];
        
    }
    return self;
}

- (void)chooseTokenAction {
    MJWeakSelf
    XXChooseTokenVC *vc = [[XXChooseTokenVC alloc] init];
    if (self.chain) {
        vc.chain = self.chain;
    }
    vc.changeSymbolBlock = ^(NSString * _Nonnull symbol) {
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:symbol];
        weakSelf.textField.text = [token.name uppercaseString];
        if (weakSelf.chooseTokenBlock) {
            weakSelf.chooseTokenBlock(symbol);
        }
    };
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 10, kScreen_Width - KSpacing*2, 24) font:kFont15 textColor:kGray];
    }
    return _nameLabel;
}

/** 背景图 */
- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nameLabel.frame) + 4, kScreen_Width - KSpacing*2, 48)];
        _banView.backgroundColor = kGray50;
        _banView.layer.cornerRadius = 4;
        _banView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTokenAction)];
        [_banView addGestureRecognizer:tap];
    }
    return _banView;
}

- (XXButton *)chooseTokenButton {
    if (_chooseTokenButton == nil) {
        MJWeakSelf
        _chooseTokenButton = [XXButton buttonWithFrame:CGRectMake(self.banView.width - K375(40), 0, K375(39.5), self.banView.height) block:^(UIButton *button) {
            [weakSelf chooseTokenAction];
        }];
        [_chooseTokenButton setImage:[UIImage textImageName:@"arrowdown"] forState:UIControlStateNormal];
    }
    return _chooseTokenButton;
}

/** 输入框 */
- (XXTextField *)textField {
    if (_textField == nil) {
        _textField = [[XXTextField alloc] initWithFrame:CGRectMake(K375(8), 0, self.banView.width - K375(56), self.banView.height)];
        _textField.textColor = kGray900;
        _textField.font = kFont15;
        _textField.placeholderColor = kGray500;
        _textField.enabled = NO;
    }
    return _textField;
}

@end
