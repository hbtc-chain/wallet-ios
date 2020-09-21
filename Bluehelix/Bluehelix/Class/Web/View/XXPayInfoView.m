//
//  XXPayInfoView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXPayInfoView.h"

@interface XXPayInfoView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIButton *keyBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) XXButton *okBtn;
@property (nonatomic, strong) NSMutableArray *labelArray;

@end

@implementation XXPayInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.keyBtn];
    [self.contentView addSubview:self.dismissBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.okBtn];
    [self buildPayInfoLabels];
    
    // TODO 测试
    self.amountLabel.text = @"1000 ETH";
//    XXLabel *label = self.labelArray[0];
}

- (void)buildPayInfoLabels {
    NSArray *titleArray = @[LocalizedString(@"PayInfo"),LocalizedString(@"ReceiveAddress"),LocalizedString(@"PayAddress"),LocalizedString(@"Gas")];
    CGFloat offsetY = 24;
    for (NSInteger i=0; i < titleArray.count; i ++) {
        
        XXLabel *leftLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), offsetY, K375(120), 32) text:titleArray[i] font:kFont15 textColor:kGray500];
        [self.scrollView addSubview:leftLabel];
        
        XXLabel *rightLabel = [XXLabel labelWithFrame:CGRectMake(K375(151), offsetY, K375(200),0) text:KUser.address font:kFont15 textColor:kGray900];
        rightLabel.numberOfLines = 0;
        [rightLabel sizeToFit];
        [rightLabel addClickCopyFunction];
        [self.scrollView addSubview:rightLabel];
        [self.labelArray addObject:rightLabel];
        
        offsetY += 48;
    }
}

+ (void)showWithSureBlock:(void (^)(void))sureBlock {
    
    XXPayInfoView *alert = [[XXPayInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    [alert buildUI];
    alert.sureBlock = sureBlock;
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - 552;
    } completion:^(BOOL finished) {
       
    }];
}

+ (void)dismiss {
    XXPayInfoView *view = (XXPayInfoView *)[self currentView];
    if (view) {
        [UIView animateWithDuration:0.25 animations:^{
            view.contentView.top = kScreen_Height;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                view.backView.alpha = 0;
                view.contentView.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }];
    }
}

+ (UIView *)currentView {
    for (UIView *view in [KWindow subviews]) {
        if ([view isKindOfClass:[self class]]) {
            return view;
        }
    }
    return nil;
}

- (void)okAction {
    if (self.sureBlock) {
        self.sureBlock();
    }
    [[self class] dismiss];
}

- (void)cancelAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [[self class] dismiss];
}

- (void)keyAction {
    
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _backView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 552, kScreen_Width, 552)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 184, self.contentView.width, self.contentView.height - 184)];
    }
    return _scrollView;
}

- (UIButton *)keyBtn {
    if (_keyBtn == nil ) {
        _keyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, K375(50), K375(50))];
        [_keyBtn setImage:[UIImage imageNamed:@"keyBtn"] forState:UIControlStateNormal];
        [_keyBtn addTarget:self action:@selector(keyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keyBtn;
}

- (UIButton *)dismissBtn {
    if (_dismissBtn == nil ) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - K375(50), 10, K375(50), K375(50))];
        [_dismissBtn setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 24, kScreen_Width - 136, 24)];
        _titleLabel.text = LocalizedString(@"PayDetail");
        _titleLabel.font = kFont(20);
        _titleLabel.textColor = kGray900NoChange;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 72, kScreen_Width - 32, 56)];
        _amountLabel.font = kNumberFontBold(30);
        _amountLabel.textColor = kGray900NoChange;
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}

- (XXButton *)okBtn {
    if (!_okBtn) {
        MJWeakSelf
        _okBtn = [XXButton buttonWithFrame:CGRectMake(16, self.contentView.height - kBtnHeight - 24, kScreen_Width - 32, kBtnHeight) title:LocalizedString(@"Sure") font:kFont(17) titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [[weakSelf class] dismiss];
        }];
        _okBtn.backgroundColor = kPrimaryMain;
        _okBtn.layer.cornerRadius = kBtnBorderRadius;
        _okBtn.layer.masksToBounds = YES;
    }
    return _okBtn;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [[NSMutableArray alloc] init];
    }
    return _labelArray;
}

@end
