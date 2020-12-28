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
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) XXButton *okBtn;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) XXPayInfoModel *model;
@property (nonatomic, assign) CGFloat contentViewHeight;
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
    [self.contentView addSubview:self.contentBackView];
    [self.contentView addSubview:self.dismissBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentBackView addSubview:self.okBtn];
    [self buildPayInfoLabels];
}

- (void)buildPayInfoLabels {
    CGFloat offsetY = 24;
    for (NSInteger i=0; i < self.model.titleArr.count; i ++) {
        
        XXLabel *leftLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), offsetY, K375(120), 32) text:self.model.titleArr[i] font:kFont14 textColor:kGray500];
        [self.contentBackView addSubview:leftLabel];
        
        XXLabel *rightLabel = [XXLabel labelWithFrame:CGRectMake(K375(151), offsetY, K375(200),32) text:self.model.valueArr[i] font:kFont14 textColor:kGray900];
        rightLabel.numberOfLines = 0;
        CGSize size = [rightLabel sizeThatFits:CGSizeMake(K375(200),32)];
        if (size.height < 32) {
            rightLabel.size = CGSizeMake(K375(200),32);
        } else {
            rightLabel.size = size;
        }
        [rightLabel addClickCopyFunction];
        [self.contentBackView addSubview:rightLabel];
        [self.labelArray addObject:rightLabel];
        
        offsetY += 48;
    }
}

+ (void)showWithSureBlock:(void (^)(void))sureBlock model:(XXPayInfoModel *)model {
    
    XXPayInfoView *alert = [[XXPayInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    alert.model = model;
    alert.contentViewHeight = 168 + 48*model.titleArr.count;
    [alert buildUI];
    alert.sureBlock = sureBlock;
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - alert.contentViewHeight;
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - self.contentViewHeight, kScreen_Width, self.contentViewHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
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

- (UIView *)contentBackView {
    if (_contentBackView == nil) {
        _contentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 24, self.contentView.width, self.contentViewHeight - CGRectGetMaxY(self.titleLabel.frame) - 24)];
        _contentBackView.backgroundColor = kGray50;
    }
    return _contentBackView;
}

- (XXButton *)okBtn {
    if (!_okBtn) {
        MJWeakSelf
        _okBtn = [XXButton buttonWithFrame:CGRectMake(16, self.contentBackView.height - kBtnHeight - 24, kScreen_Width - 32, kBtnHeight) title:LocalizedString(@"Sure") font:kFont(17) titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf okAction];
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
