//
//  XXAddressView.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAddressView.h"
#import "XXChooseLoginAccountView.h"

@interface XXAddressView ()

@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) UIImageView *downImageView;

@end

@implementation XXAddressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.addressLabel];
        if (KUser.accounts.count > 1) {
            [self addSubview:self.downImageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [self addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)tapAction {
    [XXChooseLoginAccountView showWithSureBlock:^{
        self.addressLabel.text = KUser.address;
        CGFloat width = [NSString widthWithText:KUser.address font:kFont(13)];
        self.addressLabel.frame = CGRectMake(kScreen_Width/2 - width/2, 0, width, self.height);
        if (self.sureBtnBlock) {
            self.sureBtnBlock();
        }
    }];
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:KUser.address font:kFont(13)];
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(kScreen_Width/2 - width/2, 0, width, self.height) text:KUser.address font:kFont(13) textColor:kGray900 alignment:NSTextAlignmentCenter];
    }
    return _addressLabel;
}

- (UIImageView *)downImageView {
    if (!_downImageView) {
        _downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame), 0, 24, 16)];
        _downImageView.image = [UIImage imageNamed:@"downArrow"];
    }
    return _downImageView;
}

@end
