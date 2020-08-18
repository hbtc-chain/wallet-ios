//
//  XXOrderDetailVC.m
//  Bhex
//
//  Created by BHEX on 2018/7/24.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXOrderDetailVC.h"
#import "XXOrderDetailHeaderView.h"
#import "XXOrderDetailCell.h"

@interface XXOrderDetailVC () <UITableViewDataSource, UITableViewDelegate>

/** 模型数组 */
@property (strong, nonatomic) NSMutableArray *modelsArray;

/** 表头 */
@property (strong, nonatomic) XXOrderDetailHeaderView *headView;

/** 表视图 */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation XXOrderDetailVC
static NSString *identifir = @"XXOrderDetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = LocalizedString(@"TransactionDetails");
    
    [self setupUI];
    
    [self loadDataOfOrderInfos];
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
}

#pragma mark - 2. 加载数据
- (void)loadDataOfOrderInfos {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *httpName = @"";
    if (self.type == SymbolTypeCoin) {
        params[@"account_id"] = self.coinModel.accountId;
        params[@"order_id"] = self.coinModel.orderId;
        httpName = @"order/match_info";
    } else if (self.type == SymbolTypeOption) {
        params[@"account_id"] = self.optionModel.accountId;
        params[@"order_id"] = self.optionModel.orderId;
        httpName = @"option/order/match_info";
    } else if (self.type == SymbolTypeCoinMargin){
        params[@"order_id"] = self.coinModel.orderId;
        params[@"limit"] = @(20);
        httpName = @"v1/margin/order/match_info";
    } else {
        return;
    }
 
    [MBProgressHUD showActivityMessageInWindow:@""];
//    [HttpManager order_GetWithPath:httpName params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//        [MBProgressHUD hideHUD];
//        if (code == 0) {
//            self.modelsArray = [XXOrderInfoModel mj_objectArrayWithKeyValuesArray:data];
//            [self.tableView reloadData];
//        } else {
//            [MBProgressHUD showErrorMessage:msg];
//        }
//    }];
}

#pragma mark - 3. <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXOrderDetailCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XXOrderInfoModel *model = self.modelsArray[indexPath.row];
    model.indexType = self.type;
    cell.model = model;
    return cell;
}

#pragma mark - 4. 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (offY > kNavShadowHeight) {
        self.navView.layer.shadowOpacity = 1;
    } else {
        self.navView.layer.shadowOpacity = offY/kNavShadowHeight;
    }
}

#pragma mark - || 懒加载
/** 表头 */
- (XXOrderDetailHeaderView *)headView {
    if (_headView == nil) {
        _headView = [[XXOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
        if (self.type == SymbolTypeCoin && self.coinModel) {
            _headView.coinModel = self.coinModel;
        } else if (self.type == SymbolTypeOption && self.optionModel) {
            _headView.optionModel = self.optionModel;
        } else if (self.type == SymbolTypeCoinMargin &&self.coinModel){
            _headView.coinModel = self.coinModel;
        }
    }
    return _headView;
}

/** 表视图 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XXOrderDetailCell class] forCellReuseIdentifier:identifir];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
@end
