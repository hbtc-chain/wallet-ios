//
//  XXDepositChooseTokenView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXDepositChooseTokenView.h"
#import "XXTokenModel.h"
#import <UIImageView+WebCache.h>
#import "XXChooseTokenVC.h"

@interface XXDepositChooseTokenView ()

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation XXDepositChooseTokenView
- (instancetype)initWithFrame:(CGRect)frame symbol:(NSString *)symbol
{
    self = [super initWithFrame:frame];
    if (self) {
        self.symbol = symbol;
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    [self addSubview:self.icon];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImageView];
    [self refreshUI];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseSymbol)];
    [self addGestureRecognizer:tap];
}

- (void)refreshUI {
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.symbol];
    self.titleLabel.text = [token.name uppercaseString];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:token.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
}

- (void)chooseSymbol {
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.symbol];
    MJWeakSelf
    XXChooseTokenVC *vc = [[XXChooseTokenVC alloc] init];
    vc.chain = token.chain;
    vc.changeSymbolBlock = ^(NSString * _Nonnull symbol) {
        weakSelf.symbol = symbol;
        [weakSelf refreshUI];
        if (weakSelf.changeSymbolBlock) {
            weakSelf.changeSymbolBlock(symbol);
        }
    };
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 控件
- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.height - 24)/2, 24, 24)];
    }
    return _icon;
}

- (XXLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 10, 0, self.width - 44, self.height) font:kFont14 textColor:[UIColor blackColor]];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 34, (self.height - 24)/2, 24, 24)];
        _arrowImageView.image = [UIImage imageNamed:@"downArrow"];
    }
    return _arrowImageView;
}
@end
