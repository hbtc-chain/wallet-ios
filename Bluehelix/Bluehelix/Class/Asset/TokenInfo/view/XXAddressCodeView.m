//
//  XXAddressCodeView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAddressCodeView.h"

@interface XXAddressCodeView ()
@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation XXAddressCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    [self addSubview:self.addressLabel];
    [self addSubview:self.imageView];
}

- (void)setAddress:(NSString *)address {
    self.addressLabel.text = address;
    self.addressLabel.width = self.width - 35;
    self.imageView.frame = CGRectMake(self.width - 20, 3, 18, 18);
}

#pragma mark - 控件
- (XXLabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(10, 0, self.width - 10 -25, self.height) text:self.address font:kFont12 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 20, 3, 18, 18)];
        _imageView.image = [UIImage imageNamed:@"codeCircle"];
    }
    return _imageView;
}
@end
