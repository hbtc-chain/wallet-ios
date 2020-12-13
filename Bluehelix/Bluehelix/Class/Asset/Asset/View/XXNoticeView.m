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
    _noticeView = [[GYRollingNoticeView alloc]initWithFrame:self.bounds];
    _noticeView.dataSource = self;
    _noticeView.delegate = self;
    [self addSubview:_noticeView];
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
    if (self.data.count >0) {
        NSDictionary *dic = self.data[index];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", dic[@"text"]];
        NSNumber *type = dic[@"type"];
        if (type.intValue == 1) {
            cell.icon.image = [UIImage imageNamed:@"notice_warning"];
            cell.contentView.backgroundColor = [kPriceFall colorWithAlphaComponent:0.1];
            cell.icon.backgroundColor = [kPriceFall colorWithAlphaComponent:0.15];
        } else if (type.intValue == 2) {
            cell.icon.image = [UIImage imageNamed:@"notice_notice"];
            cell.contentView.backgroundColor = [kPrimaryMain colorWithAlphaComponent:0.1];
            cell.icon.backgroundColor = [kPrimaryMain colorWithAlphaComponent:0.15];
        } else if (type.intValue == 3) {
            cell.icon.image = [UIImage imageNamed:@"notice_activity"];
            cell.contentView.backgroundColor = [kPriceRise colorWithAlphaComponent:0.1];
            cell.icon.backgroundColor = [kPriceRise colorWithAlphaComponent:0.15];
        } else if (type.intValue == 4) {
            cell.icon.image = [UIImage imageNamed:@"notice_tip"];
            cell.contentView.backgroundColor = [[UIColor colorWithHexString:@"FF922E"] colorWithAlphaComponent:0.1];
            cell.icon.backgroundColor = [[UIColor colorWithHexString:@"FF922E"] colorWithAlphaComponent:0.15];
        }
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
