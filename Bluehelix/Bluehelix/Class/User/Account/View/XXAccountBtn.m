//
//  XXAccountBtn.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAccountBtn.h"

@interface XXAccountBtn ()

@property (nonatomic, strong) UIImageView *customImageView;
@property (nonatomic, strong) UILabel *customLabel;
@property (nonatomic, copy) Block block;

@end

@implementation XXAccountBtn

- (instancetype)initWithFrame:(CGRect)frame block:(Block)block {
    CGFloat width = [NSString widthWithText:LocalizedString(@"AccountManage") font:kFont10];
    self = [super initWithFrame:CGRectMake(kScreen_Width - width - 36 - 16, frame.origin.y, width + 36, frame.size.height)];
    if (self) {
        self.block = block;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = kPrimaryLight;
    self.layer.cornerRadius = 12;
    [self addSubview:self.customImageView];
    [self addSubview:self.customLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction {
    if (self.block) {
        self.block();
    }
}

- (UIImageView *)customImageView {
    if (!_customImageView) {
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9,4,18,18)];
        _customImageView.image = [UIImage imageNamed:@"Me_setting"];
    }
    return _customImageView;
}

- (UILabel *)customLabel {
    if (!_customLabel) {
        _customLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.customImageView.frame) + 2, 0, self.width - 36, self.height)];
        _customLabel.textAlignment = NSTextAlignmentCenter;
        _customLabel.text = LocalizedString(@"AccountManage");
        _customLabel.font = kFont10;
        _customLabel.textColor = [UIColor whiteColor];
    }
    return _customLabel;
}

@end
