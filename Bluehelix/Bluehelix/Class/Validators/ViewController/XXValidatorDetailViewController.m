//
//  XXValidatorDetailViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorDetailViewController.h"

#import "XXValidarorDetailDelegateBar.h"
@interface XXValidatorDetailViewController ()
@property (nonatomic, strong) XXValidarorDetailDelegateBar *delegateBar;
@end

@implementation XXValidatorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.delegateBar];
    [self layoutViews];
}
#pragma mark layout
- (void)layoutViews{
    [self.delegateBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(72);
    }];
}
#pragma mark lazy load
- (XXValidarorDetailDelegateBar*)delegateBar{
    if (!_delegateBar) {
        _delegateBar = [[XXValidarorDetailDelegateBar alloc]initWithFrame:CGRectZero];
        _delegateBar.transferDelegateBlock = ^{
            
        };
        _delegateBar.relieveDelegateBlock = ^{
            
        };
        _delegateBar.delegateBlock = ^{
            
        };
    }
    return _delegateBar;;
}

@end
