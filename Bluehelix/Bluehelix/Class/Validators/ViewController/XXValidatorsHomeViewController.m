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
#import "XXValidatorHeaderView.h"
#import "XXAssetSingleManager.h"
#import "XXTokenModel.h"
#import "XXRewardView.h"
#import "XXPasswordView.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"

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
@property (nonatomic, strong) XXValidatorHeaderView *headerView;
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

@property (nonatomic, strong) NSArray *delegations; //委托列表

@property (nonatomic, strong) XXMsgRequest *msgRequest; //提取分红

@end

@implementation XXValidatorsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self layoutViews];
    self.validOrInvalid = @"1";
    [self loadData];
    [self refreshHeader];
    [self requestDelegations];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:kNotificationAssetRefresh object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.sectionHeader.searchView.searchTextField.text = @"";
}
#pragma mark UI
- (void)setupUI{
    self.titleLabel.text = LocalizedString(@"DelegateAndRelieve");
    [self.view addSubview:self.validatorsListTableView];
    self.validatorsListTableView.tableHeaderView = self.headerView;
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

/// 资产请求回来 刷新header
- (void)refreshHeader {
    XXAssetModel *assetModel = [[XXAssetModel alloc] init];
    for (XXTokenModel *tokenModel in [XXAssetSingleManager sharedManager].assetModel.assets) {
        if ([tokenModel.symbol isEqualToString:kMainToken]) {
            assetModel.amount = kAmountLongTrim(tokenModel.amount);
            assetModel.symbol = tokenModel.symbol;
        }
    }
    self.headerView.assetModel = assetModel;
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
//            NSLog(@"%@",data);
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

#pragma mark 请求委托地址列表
- (void)requestDelegations {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@/delegations",KUser.address];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            weakSelf.headerView.delegations = data;
        }
    }];
}

/// 提取分红
- (void)withdrawBonus {
    NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (NSDictionary *dic in self.delegations) {
        NSString *unclaimedReward = dic[@"unclaimed_reward"];
        NSDecimalNumber *unclaimedRewardDecimal = [NSDecimalNumber decimalNumberWithString:unclaimedReward];
        sum = [sum decimalNumberByAdding:unclaimedRewardDecimal];
    }
    NSString *content = NSLocalizedFormatString(LocalizedString(@"WithdrawMoneyContent"),sum.stringValue,kMinFee);
    MJWeakSelf
    [XXRewardView showWithTitle:LocalizedString(@"WithdrawMoney") icon:@"withdrawMoneyAlert" content:content sureBlock:^{
        if (kShowPassword) {
            [weakSelf requestWithdrawBonus:kText];
        } else {
            [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
                [weakSelf requestWithdrawBonus:text];
            }];
        }
    }];
}

/// 发送提取分红请求
- (void)requestWithdrawBonus:(NSString *)text {
    XXMsg *model = [[XXMsg alloc] initWithfrom:@"" to:@"" amount:@"" denom:kMainToken feeAmount:@"2000000000000000000" feeGas:@"2000000" feeDenom:kMainToken memo:@"" type:kMsgWithdrawalDelegationReward withdrawal_fee:@"" text:text];
    NSMutableArray *msgs = [NSMutableArray array];
    for (NSDictionary *dic in self.delegations) {
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"delegator_address"] = KUser.address;
        value[@"validator_address"] = dic[@"validator"];
        
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = kMsgWithdrawalDelegationReward;
        msg[@"value"] = value;
        [msgs addObject:msg];
    }
    model.msgs = msgs;
    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
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
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
//        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
//    }
//}
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
        _validatorsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
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
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
                [impactLight impactOccurred];
            }
            [weakSelf loadData];
        }];
    }
    return _validatorsListTableView;
}

- (XXValidatorHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XXValidatorHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 220)];
    }
    return _headerView;
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
