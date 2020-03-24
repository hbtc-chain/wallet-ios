//
//  XXMnemonicBtn.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/09.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMnemonicBtn.h"

@interface XXMnemonicBtn()

@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation XXMnemonicBtn

- (instancetype)initWithFrame:(CGRect)frame order:(NSString *)order dic:(NSDictionary *)dic  {
    if (self = [super initWithFrame:frame]) {
        self.dic = dic;
        self.order = order;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = kDark5;
    [self addSubview:self.orderLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.icon];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes)];
    [self addGestureRecognizer:tap];
}

- (void)reloadUI {
    self.orderLabel.hidden = NO;
    self.icon.hidden = YES;
    self.userInteractionEnabled = YES;
    if (self.state == MnemonicBtnType_Normal) {
        self.titleLabel.textColor = kDark100;
    } else if (self.state == MnemonicBtnType_Selected) {
        self.titleLabel.textColor = kDark20;
        self.orderLabel.hidden = YES;
        self.userInteractionEnabled = NO;
    } else if (self.state == MnemonicBtnType_Wrong) {
        self.titleLabel.textColor = kRed100;
        self.icon.hidden = NO;
    } else {
        
    }
}

- (void)tapGes {
    if (self.clickBlock) {
        self.clickBlock(self.dic,self);
    }
}

- (XXLabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel  = [XXLabel labelWithFrame:CGRectMake(5, 3, 100, 20) text:self.order font:kFont10 textColor:kDark80 alignment:NSTextAlignmentLeft];
    }
    return _orderLabel;
}

- (XXLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [XXLabel labelWithFrame:CGRectMake(0, self.height/7, self.width, self.height*5/7) text:self.dic[@"word"] font:kFont18 textColor:kDark100 alignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 20, 2, 18, 18)];
        _icon.image = [UIImage imageNamed:@"phraseDelete"];
        _icon.hidden = YES;
    }
    return _icon;
}

- (void)setState:(MnemonicBtnType)state {
    _state = state;
    [self reloadUI];
}
@end
