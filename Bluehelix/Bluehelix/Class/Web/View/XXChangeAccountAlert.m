//
//  XXChangeAccountAlert.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChangeAccountAlert.h"
#import "XXAccountCell.h"

@interface XXChangeAccountAlert ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXButton *cancelBtn;
@property (nonatomic, assign) CGFloat contentViewHeight;

@end

@implementation XXChangeAccountAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentViewHeight = 400;
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.cancelBtn];
}

+ (void)showWithSureBlock:(void (^)(void))sureBlock {
    
    XXChangeAccountAlert *alert = [[XXChangeAccountAlert alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
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
    XXChangeAccountAlert *view = (XXChangeAccountAlert *)[self currentView];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return KUser.accounts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXAccountCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXAccountCell"];
    if (!cell) {
        cell = [[XXAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXAccountCell"];
    }
    [cell configData:KUser.accounts[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XXAccountModel *model = KUser.accounts[indexPath.row];
    KUser.address = model.address;
    if (self.sureBlock) {
        self.sureBlock();
        [[self class] dismiss];
    }
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 248, kScreen_Width, self.contentViewHeight)];
        _contentView.backgroundColor = kWhiteColor;
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (XXLabel*)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(0, 16, kScreen_Width, 24) font:kFontBold(17) textColor:kGray900];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = LocalizedString(@"ChangeAccount");
    }
    return _titleLabel;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, kScreen_Width, self.contentViewHeight - 124) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight - 76, kScreen_Width, 8)];
        _lineView.backgroundColor = kGray50;
    }
    return _lineView;
}

- (XXButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [XXButton buttonWithFrame:CGRectMake(0, self.contentViewHeight - 68, kScreen_Width, 68) title:LocalizedString(@"Cancel") font:kFontBold(17) titleColor:kPrimaryMain block:^(UIButton *button) {
            [[self class] dismiss];
        }];
        _cancelBtn.backgroundColor = kWhiteColor;
    }
    return _cancelBtn;
}

@end
