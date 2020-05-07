//
//  XXValidatorsHomeViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorsHomeViewController.h"
#import "XXValidatorDetailViewController.h"
/**views*/
#import "XXValidatorCell.h"
#import "XXValidatorHeader.h"
#import "XXValidatorGripSectionHeader.h"
#import "XXEmptyView.h"
#import "XXFailureView.h"
/**models*/
#import "XXValidatorListModel.h"
static NSString *KValidatorsListReuseCell = @"validatorsListReuseCell";
static NSString *KValidatorGripSectionHeader = @"XXValidatorGripSectionHeader";
@interface XXValidatorsHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *validatorsListTableView;
/**汇总数据源*/
@property (nonatomic, strong) NSMutableArray *validatorsDataArray;
/**过滤数据源*/
@property (nonatomic, strong) NSMutableArray *filtValidatorsDataArray;
/**过滤数据源*/
/**tableview header*/
@property (nonatomic, strong) XXValidatorHeader *bigHeaderView;
/**section header*/
@property (nonatomic, strong) XXValidatorGripSectionHeader *sectionHeader;
/**无数据空白页面*/
@property (nonatomic, strong) XXEmptyView *emptyView;
/**无网络*/
@property (nonatomic, strong) XXFailureView *failureView;
/**有效或者无效*/
@property (nonatomic, copy) NSString *validOrInvalid;
/**是否在搜索*/
@property (nonatomic, assign) BOOL isFilting;
/**是否数据请求失败*/
@property (nonatomic, assign) BOOL isFailedNetworking;
@end

@implementation XXValidatorsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self layoutViews];
    self.validOrInvalid = @"1";
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.sectionHeader.searchView.searchTextField.text = @"";
}
#pragma mark UI
- (void)setupUI{
    self.leftButton.hidden = YES;
   // [self.rightButton setTitle:LocalizedString(@"ValidatorNewCreate") forState:UIControlStateNormal];
    [self.view addSubview:self.validatorsListTableView];
    self.validatorsListTableView.tableHeaderView = self.bigHeaderView;
    [self.bigHeaderView bringSubviewToFront:self.validatorsListTableView];
    
}
#pragma mark 数据
- (void)loadData{
    if (self.validatorsDataArray.count>0) {
        [self.validatorsDataArray removeAllObjects];
        [self.filtValidatorsDataArray removeAllObjects];
    }
    //还原输入框
    self.sectionHeader.searchView.searchTextField.text = @"";
    [self requestValidatorsList];
}
- (void)searchLoadData:(NSString*)inputSting{
    if (inputSting.length ==0) {
        self.isFilting = NO;
        [self.filtValidatorsDataArray removeAllObjects];
        [self.filtValidatorsDataArray addObjectsFromArray:self.validatorsDataArray];
        [self.validatorsListTableView reloadData];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (XXValidatorListModel*model in self.validatorsDataArray) {
        if ([[model.validatorDescription.moniker lowercaseString] containsString:[inputSting lowercaseString]]) {
            [tempArray addObject:model];
        }
    }
    self.isFilting = YES;
    [self.filtValidatorsDataArray removeAllObjects];
    [self.filtValidatorsDataArray addObjectsFromArray:tempArray];
    [self.validatorsListTableView reloadData];
}

#pragma mark 请求
/// 请求资产信息
- (void)requestValidatorsList {
    MJWeakSelf
    self.isFailedNetworking = NO;
    if (self.validatorsDataArray.count == 0) {
        //首次加载展示
        [MBProgressHUD showActivityMessageInView:@""];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.validOrInvalid forKey:@"valid"];
    NSString *path = [NSString stringWithFormat:@"/api/v1/validators"];
    [HttpManager getWithPath:path params:dic andBlock:^(id data, NSString *msg, NSInteger code) {
        [weakSelf.validatorsListTableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if (code == 0) {
            NSLog(@"%@",data);
            NSArray *listArray = [XXValidatorListModel mj_objectArrayWithKeyValuesArray:data];
            [self.validatorsDataArray addObjectsFromArray:listArray];
            [self.filtValidatorsDataArray addObjectsFromArray:listArray];
            [self.validatorsListTableView reloadData];
        } else {
            self.isFailedNetworking = YES;
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    if (scrollView.contentOffset.y >35) {
        self.titleLabel.text = LocalizedString(@"ValidatorTitle");
        //section header 背景
        if (scrollView.contentOffset.y >128) {
            self.sectionHeader.coverView.backgroundColor = kBackgroundLeverFirst;
        }else{
            self.sectionHeader.coverView.backgroundColor = [UIColor clearColor];
        }
    }else{
        self.sectionHeader.coverView.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = @"";
    }
}
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.validatorsDataArray.count == 0 ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isFilting ? self.filtValidatorsDataArray.count : self.validatorsDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        return 98;
    }else{
        if ([KUser.netWorkStatus isEqualToString:@"notReachable"] || self.isFailedNetworking) {
            return self.failureView.height;
        } else {
            return self.emptyView.height;
        }
    };
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        self.sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KValidatorGripSectionHeader];
        @weakify(self)
        self.sectionHeader.backgroundColor = kBackgroundLeverFirst;
        self.sectionHeader.selectValidOrInvalidCallBack = ^(NSInteger index) {
            @strongify(self)
            NSNumber *number = [NSNumber numberWithInteger:index];
            self.validOrInvalid = number.integerValue == 1 ? @"0" : @"1";
            [self loadData];
        };
        self.sectionHeader.textfieldValueChangeBlock = ^(NSString * _Nonnull textfiledText) {
            @strongify(self)
            [self searchLoadData:textfiledText];
        };
        return self.sectionHeader;
    }else {
        if (self.validatorsDataArray.count == 0) {
            if ([KUser.netWorkStatus isEqualToString:@"notReachable"] || self.isFailedNetworking) {
                return self.failureView;
            } else {
                return self.emptyView ;
            }
            return self.emptyView ;
        } else {
            return [UIView new];
        }
    }

}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXValidatorCell *cell = [tableView dequeueReusableCellWithIdentifier:KValidatorsListReuseCell];
    if (!cell) {
        cell = [[XXValidatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KValidatorsListReuseCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kBackgroundLeverFirst;
    XXValidatorListModel *model = self.isFilting ? self.filtValidatorsDataArray[indexPath.row] : self.validatorsDataArray[indexPath.row];
    cell.validOrInvalid = [self.validOrInvalid isEqualToString:@"1"] ? YES :NO;
    [cell loadData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXValidatorDetailViewController *detailValidator = [[XXValidatorDetailViewController alloc]init];
    detailValidator.validatorModel = self.isFilting ? self.filtValidatorsDataArray[indexPath.row] : self.validatorsDataArray[indexPath.row];
    detailValidator.validOrInvalid = self.validOrInvalid;
    [self.navigationController pushViewController:detailValidator animated:YES];
}
#pragma mark layout
- (void)layoutViews{

}
#pragma mark lazy load
- (UITableView *)validatorsListTableView {
    MJWeakSelf
    if (_validatorsListTableView == nil) {
        _validatorsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight -kTabbarHeight) style:UITableViewStylePlain];
        _validatorsListTableView.dataSource = self;
        _validatorsListTableView.delegate = self;
        _validatorsListTableView.backgroundColor = kWhiteColor;
        _validatorsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _validatorsListTableView.showsVerticalScrollIndicator = NO;
        [_validatorsListTableView registerClass:[XXValidatorCell class] forCellReuseIdentifier:KValidatorsListReuseCell];
        [_validatorsListTableView registerClass:[XXValidatorGripSectionHeader class] forHeaderFooterViewReuseIdentifier:KValidatorGripSectionHeader];
        if (@available(iOS 11.0, *)) {
            _validatorsListTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _validatorsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
    }
    return _validatorsListTableView;
}
- (XXValidatorHeader*)bigHeaderView{
    if (!_bigHeaderView) {
        _bigHeaderView = [[XXValidatorHeader alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 82)];
    }
    return _bigHeaderView;;
}
- (XXEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[XXEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(300)) iamgeName:@"noData" alert:LocalizedString(@"NoValidatorTip")];
    }
    return _emptyView;
}
- (XXFailureView *)failureView {
    if (_failureView == nil) {
        _failureView = [[XXFailureView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(300))];
        MJWeakSelf
        _failureView.reloadBlock = ^{
            [weakSelf loadData];
        };
    }
    return _failureView;
}
#pragma mark lazy load data
- (NSMutableArray *)validatorsDataArray{
    if (!_validatorsDataArray) {
        _validatorsDataArray = [NSMutableArray array];
    }
    return _validatorsDataArray;
}
- (NSMutableArray*)filtValidatorsDataArray{
    if (!_filtValidatorsDataArray) {
        _filtValidatorsDataArray = [NSMutableArray array];
    }
    return _filtValidatorsDataArray;
}
@end
