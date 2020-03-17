//
//  XXAccountManageVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAccountManageVC.h"
#import "XXAccountCell.h"
#import "XXAccountFooterView.h"

@interface XXAccountManageVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *itemsArray;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *iconArray;

@property (strong, nonatomic) XXAccountFooterView *footView;

@end

@implementation XXAccountManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.titleLabel.text = LocalizedString(@"AccountManage");
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return KUser.accounts.count;
//    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXAccountCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXUserHomeCell"];
    if (!cell) {
        cell = [[XXAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXAccountCell"];
    }
    [cell configData:KUser.accounts[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = KUser.accounts[indexPath.row];
    KUser.rootAccount = dic;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (KUser.accounts.count > 1) {
        return YES;
    } else {
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:KUser.accounts];
        NSDictionary *selectedDic = KUser.accounts[indexPath.row];
        if ([selectedDic[@"BHAddress"] isEqualToString:KUser.rootAccount[@"BHAddress"]]) {
            [array removeObjectAtIndex:indexPath.row];
            KUser.rootAccount = [array firstObject];
        } else {
            [array removeObjectAtIndex:indexPath.row];
        }
        KUser.accounts = array;
        [self.tableView reloadData];
    }
}

#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 80) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhite100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (XXAccountFooterView *)footView {
    if (!_footView) {
        _footView = [[XXAccountFooterView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, kScreen_Width, 80)];
    }
    return _footView;
}
@end
