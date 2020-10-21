//
//  XXTestAssertTipView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/10/21.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTestAssertTipView.h"


@interface XXTestAssertTipView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, assign) CGFloat height;

@end

@implementation XXTestAssertTipView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.height = [NSString heightWithText:LocalizedString(@"TestNetCoinTip") font:kFont13 width:kScreen_Width - K375(92)];
    [self addSubview:self.backView];
    [self.backView addSubview:self.tipLabel];
    [self.backView addSubview:self.tipImageView];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), 2, kScreen_Width - K375(32), self.height + 10)];
        _backView.backgroundColor = KRGBA(252, 224, 230, 100);
        _backView.layer.cornerRadius = 10;
    }
    return _backView;
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(12), (_backView.height - 24)/2, 24, 24)];
        _tipImageView.image = [UIImage imageNamed:@"testCoinTip"];
    }
    return _tipImageView;
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(44), 5, self.backView.width - K375(60), self.height) text:LocalizedString(@"TestNetCoinTip") font:kFont13 textColor:[UIColor colorWithHexString:@"#ED3756"] alignment:NSTextAlignmentLeft];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

@end
