//
//  XXTransferDetailVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferDetailVC.h"
#import "XXTransferHeaderView.h"
#import "XXTransactionDetailCell.h"
#import "XXMsgSendModel.h"
#import "XXMsgDepositModel.h"
#import "XXMsgWithdrawalModel.h"
#import "XXMsgKeyGenModel.h"
#import "XXTokenModel.h"
#import "XXTransationSectionHeaderView.h"
#import "XXMsgDelegateModel.h"
#import "XXCoinModel.h"

@interface XXTransactionCellModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;
@end

@implementation XXTransactionCellModel
@end

@interface XXTransactionSectionModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;
@end

@implementation XXTransactionSectionModel
@end


@interface XXTransferDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXTransferHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@end

@implementation XXTransferDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellArray = [NSMutableArray array];
    self.sectionArray = [NSMutableArray array];
    [self configDic];
    [self buildUI];
}

- (void)buildUI {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableHeaderView.height = self.headerView.height;
}

#pragma mark 转账
- (void)msgSendModel:(NSDictionary *)value {
    XXMsgSendModel *model = [XXMsgSendModel mj_objectWithKeyValues:value];
    NSDictionary *amount = [model.amount firstObject];
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:amount[@"denom"]];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:amount[@"amount"]]; //数量
    NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
    XXTransactionSectionModel *sectionModel = [[XXTransactionSectionModel alloc] init];
    sectionModel.name = LocalizedString(@"Transfer");
    if ([model.from_address isEqualToString:KUser.address]) {
        sectionModel.value = [NSString stringWithFormat:@"-%@ %@",amountStr,[amount[@"denom"] uppercaseString]];
    } else {
        sectionModel.value = [NSString stringWithFormat:@"+%@ %@",amountStr,[amount[@"denom"] uppercaseString]];
    }
    [self.sectionArray addObject:sectionModel];
    NSMutableArray *cellData = [NSMutableArray array];
    XXTransactionCellModel *cellModel = [[XXTransactionCellModel alloc] init];
    cellModel.name = LocalizedString(@"From");
    cellModel.value = model.from_address;
    [cellData addObject:cellModel];
    XXTransactionCellModel *cellModel1 = [[XXTransactionCellModel alloc] init];
    cellModel1.name = LocalizedString(@"To");
    cellModel1.value = model.to_address;
    [cellData addObject:cellModel1];
    [self.cellArray addObject:cellData];
    self.titleLabel.text = LocalizedString(@"Transfer");
}

#pragma mark 提币
- (void)msgWithdrawModel:(NSDictionary *)value {
    XXMsgWithdrawalModel *model = [XXMsgWithdrawalModel mj_objectWithKeyValues:value];
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.symbol];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:model.amount]; //数量
    NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
    XXTransactionSectionModel *sectionModel = [[XXTransactionSectionModel alloc] init];
    sectionModel.name = LocalizedString(@"ChainWithdrawal");
    sectionModel.value = [NSString stringWithFormat:@"-%@",amountStr];
    [self.sectionArray addObject:sectionModel];
    NSMutableArray *cellData = [NSMutableArray array];
    XXTransactionCellModel *cellModel = [[XXTransactionCellModel alloc] init];
    cellModel.name = LocalizedString(@"From");
    cellModel.value = model.from_cu;
    [cellData addObject:cellModel];
    XXTransactionCellModel *cellModel1 = [[XXTransactionCellModel alloc] init];
    cellModel1.name = LocalizedString(@"To");
    cellModel1.value = model.to_multi_sign_address;
    [cellData addObject:cellModel1];
    [self.cellArray addObject:cellData];
    self.titleLabel.text = LocalizedString(@"ChainWithdrawal");
}

#pragma mark 跨链充值
- (void)msgDeposit:(NSDictionary *)value {
    XXMsgDepositModel *model = [XXMsgDepositModel mj_objectWithKeyValues:value];
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.symbol];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:model.amount]; //数量
    NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
    XXTransactionSectionModel *sectionModel = [[XXTransactionSectionModel alloc] init];
    sectionModel.name = LocalizedString(@"ChainDeposit");
    sectionModel.value = [NSString stringWithFormat:@"+%@",amountStr];
    [self.sectionArray addObject:sectionModel];
    NSMutableArray *cellData = [NSMutableArray array];
    XXTransactionCellModel *cellModel = [[XXTransactionCellModel alloc] init];
    cellModel.name = LocalizedString(@"From");
    cellModel.value = model.from_cu;
    [cellData addObject:cellModel];
    XXTransactionCellModel *cellModel1 = [[XXTransactionCellModel alloc] init];
    cellModel1.name = LocalizedString(@"To");
    cellModel1.value = model.to_cu;
    [cellData addObject:cellModel1];
    [self.cellArray addObject:cellData];
    self.titleLabel.text = LocalizedString(@"ChainDeposit");
}

#pragma mark 委托
- (void)msgDelegate:(NSDictionary *)value {
    XXMsgDelegateModel *model = [XXMsgDelegateModel mj_objectWithKeyValues:value];
    XXCoinModel *coin = model.amount;
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:coin.denom];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:coin.amount]; //数量
    NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
    XXTransactionSectionModel *sectionModel = [[XXTransactionSectionModel alloc] init];
    sectionModel.name = LocalizedString(@"Delegate");
    sectionModel.value = [NSString stringWithFormat:@"-%@ %@",amountStr,[coin.denom uppercaseString]];
    [self.sectionArray addObject:sectionModel];
    NSMutableArray *cellData = [NSMutableArray array];
    XXTransactionCellModel *cellModel = [[XXTransactionCellModel alloc] init];
    cellModel.name = LocalizedString(@"Delegator");
    cellModel.value = model.delegator_address;
    [cellData addObject:cellModel];
    XXTransactionCellModel *cellModel1 = [[XXTransactionCellModel alloc] init];
    cellModel1.name = LocalizedString(@"Validator");
    cellModel1.value = model.validator_address;
    [cellData addObject:cellModel1];
    [self.cellArray addObject:cellData];
    self.titleLabel.text = LocalizedString(@"Delegate");
}

#pragma mark 提取收益
- (void)msgWithdrawReward:(NSDictionary *)value {
    XXTransactionSectionModel *sectionModel = [[XXTransactionSectionModel alloc] init];
    sectionModel.name = LocalizedString(@"WithdrawMoney");
    sectionModel.value = @"";
    [self.sectionArray addObject:sectionModel];
    XXMsgDelegateModel *model = [XXMsgDelegateModel mj_objectWithKeyValues:value];
    NSMutableArray *cellData = [NSMutableArray array];
    XXTransactionCellModel *cellModel = [[XXTransactionCellModel alloc] init];
    cellModel.name = LocalizedString(@"Delegator");
    cellModel.value = model.delegator_address;
    [cellData addObject:cellModel];
    XXTransactionCellModel *cellModel1 = [[XXTransactionCellModel alloc] init];
    cellModel1.name = LocalizedString(@"Validator");
    cellModel1.value = model.validator_address;
    [cellData addObject:cellModel1];
    [self.cellArray addObject:cellData];
    self.titleLabel.text = LocalizedString(@"WithdrawMoney");
}

- (void)configDic {
    NSArray *activities = self.dic[@"activities"];
    for (NSDictionary *dic in activities) {
        NSString *type = dic[@"type"];
        NSDictionary *value = dic[@"value"];
        if ([type isEqualToString:kMsgSend]) {
            [self msgSendModel:value];
        } else if ([type isEqualToString:kMsgDelegate]) {
            [self msgDelegate:value];
        } else if ([type isEqualToString:kMsgUndelegate]) {
            self.titleLabel.text = LocalizedString(@"TransferDelegate");
        } else if ([type isEqualToString:kMsgKeyGen]) {
            self.titleLabel.text = LocalizedString(@"ChainAddress");
        } else if ([type isEqualToString:kMsgDeposit]) {
            [self msgDeposit:value];
        } else if ([type isEqualToString:kMsgWithdrawal]) {
            [self msgWithdrawModel:value];
        } else if([type isEqualToString:kMsgWithdrawalDelegationReward]) {
            [self msgWithdrawReward:value];
        } else {}
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.cellArray[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXTransactionDetailCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XXTransactionSectionModel *model = self.sectionArray[section];
    XXTransationSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XXTransationSectionHeaderView"];
    sectionHeaderView.nameLabel.text = model.name;
    sectionHeaderView.valueLabel.text = model.value;
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXTransactionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXTransactionDetailCell"];
    if (!cell) {
        cell = [[XXTransactionDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXTransactionDetailCell"];
    }
    NSArray *arr = self.cellArray[indexPath.section];
    XXTransactionCellModel *model = arr[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.valueLabel.text = model.value;
    cell.backgroundColor = kWhiteColor;
    return cell;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[XXTransationSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"XXTransationSectionHeaderView"];
    }
    return _tableView;
}

- (XXTransferHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XXTransferHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) data:self.dic];
    }
    return _headerView;
}

@end
