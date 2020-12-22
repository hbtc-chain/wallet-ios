//
//  XXAboutUsHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/21.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAboutUsHeaderView.h"

@interface XXAboutUsHeaderView ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXLabel *versionLabel;

@end

@implementation XXAboutUsHeaderView

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
    [self addSubview:self.icon];
    [self addSubview:self.nameLabel];
    [self addSubview:self.versionLabel];
}

#pragma mark - 控件
- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2 - 50, 40, 100, 100)];
        _icon.image = [UIImage imageNamed:@"logo120"];
    }
    return _icon;
}

- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.icon.frame) + 15, self.width, 20) text:LocalizedString(@"logoName") font:kFont14 textColor:kGray900 alignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}

- (XXLabel *)versionLabel {
    if (_versionLabel == nil) {
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
        NSString *buildVersion = [info objectForKey:@"CFBundleVersion"];
        _versionLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame) + 15, self.width, 20) text:[NSString stringWithFormat:@"v%@_%@",version,buildVersion] font:kFont14 textColor:kGray500 alignment:NSTextAlignmentCenter];
    }
    return _versionLabel;
}

@end
