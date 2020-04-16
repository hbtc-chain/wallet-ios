//
//  XXValidarorDetailDelegateBar.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidarorDetailDelegateBar.h"
@interface XXValidarorDetailDelegateBar ()
@property (nonatomic, strong) XXButton *transferDelegateButton;

@property (nonatomic, strong) XXButton *relieveDelegateButton;

@property (nonatomic, strong) XXButton *delegateButton;

@property (nonatomic, strong) NSMutableArray *buttonsArray;

@end

@implementation XXValidarorDetailDelegateBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.transferDelegateButton];
        [self addSubview:self.relieveDelegateButton];
        [self addSubview:self.delegateButton];
        
        [self.buttonsArray addObject:self.transferDelegateButton];
        [self.buttonsArray addObject:self.relieveDelegateButton];
        [self.buttonsArray addObject:self.delegateButton];
    }
    return self;
}

#pragma mark layout
- (void)layoutSubviews{
    [self.buttonsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:8 leadSpacing:24 tailSpacing:24];
    [self.buttonsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(-16);
    }];
}
#pragma mark lazy load
- (XXButton*)transferDelegateButton{
    @weakify(self)
    if (!_transferDelegateButton ) {
        _transferDelegateButton = [XXButton buttonWithFrame:CGRectZero title:LocalizedString(@"TransferDelegate") font:kFont17 titleColor:kBlue100 block:^(UIButton *button) {
            @strongify(self)
            if (self.transferDelegateBlock) {
                self.transferDelegateBlock();
            }
        }];
        _transferDelegateButton.layer.cornerRadius = 6;
        _transferDelegateButton.layer.borderColor = [UIColor blueColor].CGColor;;
        _transferDelegateButton.layer.borderWidth = 2.0f;
    }
    return _transferDelegateButton;;
}

- (XXButton*)relieveDelegateButton{
    @weakify(self)
    if (!_relieveDelegateButton ) {
        _relieveDelegateButton = [XXButton buttonWithFrame:CGRectZero title:LocalizedString(@"RelieveDelegate") font:kFont17 titleColor:kBlue100 block:^(UIButton *button) {
             @strongify(self)
            if (self.relieveDelegateBlock) {
                self.relieveDelegateBlock();
            }
        }];
        _relieveDelegateButton.layer.cornerRadius = 6;
        _relieveDelegateButton.layer.borderColor = [UIColor blueColor].CGColor;
        _relieveDelegateButton.layer.borderWidth = 2.0f;
    }
    return _relieveDelegateButton;;
}
- (XXButton*)delegateButton{
    @weakify(self)
    if (!_delegateButton ) {
        _delegateButton = [XXButton buttonWithFrame:CGRectZero title:LocalizedString(@"Delegate") font:kFont17 titleColor:kBlue100 block:^(UIButton *button) {
             @strongify(self)
            if (self.delegateBlock) {
                self.delegateBlock();
            }
        }];
        _delegateButton.layer.cornerRadius = 6;
        _delegateButton.layer.borderColor = [UIColor blueColor].CGColor;
        _delegateButton.layer.borderWidth = 2.0f;
    }
    return _delegateButton;;
}
- (NSMutableArray*)buttonsArray{
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}
@end

//"TransferDelegate" = "转委托";
//"RelieveDelegate" = "解委托";
//"Delegate" = "委托";
