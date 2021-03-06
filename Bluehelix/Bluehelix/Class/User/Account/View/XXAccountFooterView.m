//
//  XXAccountFooterView.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAccountFooterView.h"
#import "XXImportWalletVC.h"
#import "XXCreateWalletVC.h"

@interface XXAccountFooterView ()

@property (nonatomic, strong) XXButton *leftBtn;
@property (nonatomic, strong) XXButton *rightBtn;

@end

@implementation XXAccountFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
    }
    return self;
}

- (XXButton *)leftBtn {
    if (!_leftBtn) {
        MJWeakSelf
        _leftBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), self.height/2 - kBtnHeight/2, self.width/2 - K375(40)/2, kBtnHeight) title:LocalizedString(@"ImportWallet") font:kFont(17) titleColor:kPrimaryMain block:^(UIButton *button) {
            XXImportWalletVC *importVC = [[XXImportWalletVC alloc] init];
            [weakSelf.viewController.navigationController pushViewController:importVC animated:YES];
        }];
        _leftBtn.layer.borderColor = [kPrimaryMain CGColor];
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.backgroundColor = kWhiteColor;
        _leftBtn.layer.cornerRadius = kBtnBorderRadius;
        _leftBtn.layer.masksToBounds = YES;
    }
    return _leftBtn;
}

- (XXButton *)rightBtn {
    if (!_rightBtn) {
        MJWeakSelf
        _rightBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width/2 + K375(4), self.height/2 - kBtnHeight/2, self.width/2 - K375(40)/2, kBtnHeight) title:LocalizedString(@"CreateWallet") font:kFont(17) titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            XXCreateWalletVC *createVC = [[XXCreateWalletVC alloc] init];
            [weakSelf.viewController.navigationController pushViewController:createVC animated:YES];
        }];
        _rightBtn.layer.borderColor = [kPrimaryMain CGColor];
        _rightBtn.layer.borderWidth = 1;
        _rightBtn.backgroundColor = kPrimaryMain;
        _rightBtn.layer.cornerRadius = kBtnBorderRadius;
        _rightBtn.layer.masksToBounds = YES;
    }
    return _rightBtn;
}

@end
