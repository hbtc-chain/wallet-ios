//
//  XXNoticeView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXNoticeView.h"
#import "GYRollingNoticeView.h"
#import "XXWebViewController.h"

@interface XXNoticeView ()<GYRollingNoticeViewDelegate, GYRollingNoticeViewDataSource>
{
    GYRollingNoticeView *_noticeView;
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *icon; //类型图标
@property (nonatomic, strong) XXButton *closeBtn;
@end

@implementation XXNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.closeBtn];
    _noticeView = [[GYRollingNoticeView alloc]initWithFrame:CGRectMake(38, 0, self.contentView.width - 80, self.contentView.height)];
    _noticeView.dataSource = self;
    _noticeView.delegate = self;
    [self.contentView addSubview:_noticeView];
    [_noticeView registerClass:[GYNoticeViewCell class] forCellReuseIdentifier:@"GYNoticeViewCell"];
    [_noticeView reloadDataAndStartRoll];
}

- (void)reloadData:(NSArray *)data {
    self.data = data;
    if (data.count) {
        [_noticeView reloadDataAndStartRoll];
    }
}

- (NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView
{
    return self.data.count;
}
- (__kindof GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index
{
    GYNoticeViewCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"GYNoticeViewCell"];
    MJWeakSelf
    cell.closeBlock = ^{
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
    };
    if (self.data.count >0) {
        NSDictionary *dic = self.data[index];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", dic[@"text"]];
//        NSNumber *type = dic[@"type"];
//        if (type.intValue == 1) {
//            cell.icon.image = [UIImage imageNamed:@"notice_warning"];
//            cell.contentView.backgroundColor = [kPriceFall colorWithAlphaComponent:0.1];
//            cell.icon.backgroundColor = [kPriceFall colorWithAlphaComponent:0.15];
//        } else if (type.intValue == 2) {
//            cell.icon.image = [UIImage imageNamed:@"notice_notice"];
//            cell.contentView.backgroundColor = [kPrimaryMain colorWithAlphaComponent:0.1];
//            cell.icon.backgroundColor = [kPrimaryMain colorWithAlphaComponent:0.15];
//        } else if (type.intValue == 3) {
//            cell.icon.image = [UIImage imageNamed:@"notice_activity"];
//            cell.contentView.backgroundColor = [kPriceRise colorWithAlphaComponent:0.1];
//            cell.icon.backgroundColor = [kPriceRise colorWithAlphaComponent:0.15];
//        } else if (type.intValue == 4) {
//            cell.icon.image = [UIImage imageNamed:@"notice_tip"];
//            cell.contentView.backgroundColor = [[UIColor colorWithHexString:@"FF922E"] colorWithAlphaComponent:0.1];
//            cell.icon.backgroundColor = [[UIColor colorWithHexString:@"FF922E"] colorWithAlphaComponent:0.15];
//        }
    } else {
        cell.textLabel.text = @" ";
    }
    return cell;
}

- (void)didClickRollingNoticeView:(GYRollingNoticeView *)rollingView forIndex:(NSUInteger)index
{
    if (self.data.count) {
        NSDictionary *dic = self.data[index];
        if ( !IsEmpty(dic) && !IsEmpty(dic[@"jump_url"])) {
            XXWebViewController *webVC = [[XXWebViewController alloc] init];
            webVC.urlString = dic[@"jump_url"];
            webVC.navTitle = dic[@"text"];
            [self.viewController.navigationController pushViewController:webVC animated:YES];
        }
    }
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, kScreen_Width - 32, 40)];
        _contentView.backgroundColor = kWhite100;
        _contentView.layer.cornerRadius = 6;
    }
    return _contentView;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 24, 24)];
        _icon.image = [UIImage imageNamed:@"notice_notice"];
    }
    return _icon;
}

- (XXButton *)closeBtn {
    if (_closeBtn == nil) {
        MJWeakSelf
        _closeBtn = [XXButton buttonWithFrame:CGRectMake(self.contentView.width - 36, 12, 16, 16) block:^(UIButton *button) {
            KUser.closeNoticeFlag = YES;
            if (weakSelf.closeBlock) {
                weakSelf.closeBlock();
            }
        }];
        [_closeBtn setImage:[UIImage textImageName:@"dismiss"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

@end
