//
//  XXValidatorDetailViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorDetailViewController.h"
#import "XXDelegateTransferViewController.h"

#import "XXValidarorDetailDelegateBar.h"
#import "XXValidatorDetailHeader.h"
#import "XXValidatorDetailCell.h"
#import "XXValidatorDetailInfoCell.h"
static NSString *kSectionDetailHeader = @"XXValidatorDetailHeader";
static NSString *KValidatorDetailViewCell = @"ValidatorDetailView";
static NSString *KValidatorDetailInfoCell = @"ValidatorDetailInfoCell";
@interface XXValidatorDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *validatorsDetailTableView;
@property (nonatomic, strong) XXValidarorDetailDelegateBar *delegateBar;
@property (nonatomic, strong) XXValidatorDetailHeader *detailHeader;
@property (nonatomic, strong) NSArray *sectionFirstInfoArray;
@property (nonatomic, strong) NSArray *sectionSecondInfoArray;
@property (nonatomic, strong) NSArray *sectionFirstValueArray;
@property (nonatomic, strong) NSArray *sectionSectionValueArray;
@end

@implementation XXValidatorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)createUI{
    self.titleLabel.text = LocalizedString(@"ValidatorDetailTitle");
    [self.view addSubview:self.validatorsDetailTableView];
    [self.view addSubview:self.delegateBar];
    //self.validatorsDetailTableView.tableHeaderView = self.detailHeader;
    [self layoutViews];
}
- (void)loadData{

    self.sectionFirstInfoArray = @[LocalizedString(@"ValidatorVote"),LocalizedString(@"ValidatorDelegateNumber"),LocalizedString(@"ValidatorCommissionRate"),LocalizedString(@"ValidatorUpdateTime"),LocalizedString(@"ValidatorOnlineRatio"),LocalizedString(@"ValidatorCommissionMostLimit"),LocalizedString(@"ValidatorCommissionMostLimitPerDay")];
    self.sectionSecondInfoArray = @[LocalizedString(@"ValidatorAddress"),LocalizedString(@"ValidatorWebsite")];
    
    self.sectionFirstValueArray = @[[NSString stringWithFormat:@"%@ (%@%@)",KString(self.validatorModel.voting_power),KString(self.validatorModel.voting_power_proportion),@"%"],[NSString stringWithFormat:@"%@ (%@%@)",KString(self.validatorModel.self_delegate_amount),KString(self.validatorModel.self_delegate_proportion),@"%"],KString(self.validatorModel.up_time),[NSString stringWithFormat:@"%@%@",KString(self.validatorModel.commission.rate),@"%"],[NSString dateStringFromTimestampWithTimeTamp:[KString(self.validatorModel.last_voted_time) longLongValue]],[NSString stringWithFormat:@"%@%@",KString(self.validatorModel.commission.max_rate),@"%"],[NSString stringWithFormat:@"%@%@",KString(self.validatorModel.commission.max_change_rate),@"%"]];;
    self.sectionSectionValueArray = @[[NSString addressReplace:KString(self.validatorModel.operator_address)],KString(self.validatorModel.validatorDescription.website)];
    
    [self.validatorsDetailTableView reloadData];
    if ([self.validOrInvalid isEqualToString:@"1"]) {
        self.delegateBar.hidden = NO;
    }else{
        self.delegateBar.hidden = YES;
    }
}
#pragma mark layout
- (void)layoutViews{
    [self.delegateBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(72);
    }];
    //[self.validatorsDetailTableView setNeedsLayout];
}
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.sectionFirstInfoArray.count;
            break;
        case 1:
            return self.sectionSecondInfoArray.count;
            break;
        case 2:
            return 1;
            break;;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.validatorsDetailTableView.sectionHeaderHeight;
    }else{
        return CGFLOAT_MIN;;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
          self.detailHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionDetailHeader];
            self.detailHeader.validOrInvalid = self.validOrInvalid;
          self.detailHeader.validatorModel = self.validatorModel;
          return self.detailHeader;
     }else{
         return [UIView new];;
     }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return [UIView new];
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 28)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(24, 16, kScreen_Width-24, 1)];
    lineView.backgroundColor = KLine_Color;
    [view addSubview:lineView];
    return view;;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 32;
    }else{
        return 128;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        XXValidatorDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:KValidatorDetailViewCell];
        if (!cell) {
            cell = [[XXValidatorDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KValidatorDetailViewCell];
        }
        cell.validatorModel = self.validatorModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kWhiteColor;
        if (indexPath.section ==1 && indexPath.row ==0) {
            cell.hideDetailButton = NO;
        }else{
            cell.hideDetailButton =YES;
        }
        if (indexPath.section == 0) {
            cell.labelInfo.text = self.sectionFirstInfoArray[indexPath.row];
            cell.labelValue.text = self.sectionFirstValueArray[indexPath.row];
        }else{
            cell.labelInfo.text = self.sectionSecondInfoArray[indexPath.row];
            cell.labelValue.text = self.sectionSectionValueArray[indexPath.row];
        }
        
        return cell;
    }else{
        XXValidatorDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:KValidatorDetailInfoCell];
        if (!cell) {
            cell = [[XXValidatorDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KValidatorDetailInfoCell];
        }
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailLabelValue.text = self.validatorModel.validatorDescription.details;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark lazy load
- (UITableView *)validatorsDetailTableView {
    //@weakify(self)
    if (_validatorsDetailTableView == nil) {
        _validatorsDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _validatorsDetailTableView.dataSource = self;
        _validatorsDetailTableView.delegate = self;
        _validatorsDetailTableView.backgroundColor = kWhiteColor;
        _validatorsDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _validatorsDetailTableView.estimatedSectionHeaderHeight = 48;
        _validatorsDetailTableView.sectionHeaderHeight =  UITableViewAutomaticDimension;
        _validatorsDetailTableView.showsVerticalScrollIndicator = NO;
        [_validatorsDetailTableView registerClass:[XXValidatorDetailHeader class] forHeaderFooterViewReuseIdentifier:kSectionDetailHeader];
        [_validatorsDetailTableView registerClass:[XXValidatorDetailCell class] forCellReuseIdentifier:KValidatorDetailViewCell];
        [_validatorsDetailTableView registerClass:[XXValidatorDetailInfoCell class] forCellReuseIdentifier:KValidatorDetailInfoCell];
        if (@available(iOS 11.0, *)) {
            _validatorsDetailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _validatorsDetailTableView;
}
- (XXValidarorDetailDelegateBar*)delegateBar{
    @weakify(self)
    if (!_delegateBar) {
        _delegateBar = [[XXValidarorDetailDelegateBar alloc]initWithFrame:CGRectZero];
        _delegateBar.transferDelegateBlock = ^{
            @strongify(self)
            XXDelegateTransferViewController *delegateTransfer = [[XXDelegateTransferViewController alloc]init];
            delegateTransfer.delegateNodeType = XXDelegateNodeTypeTransfer;
            delegateTransfer.validatorModel = self.validatorModel;
            [self.navigationController pushViewController:delegateTransfer animated:YES];
        };
        _delegateBar.relieveDelegateBlock = ^{
            @strongify(self)
            XXDelegateTransferViewController *delegateTransfer = [[XXDelegateTransferViewController alloc]init];
            delegateTransfer.delegateNodeType = XXDelegateNodeTypeRelieve;
            delegateTransfer.validatorModel = self.validatorModel;
            [self.navigationController pushViewController:delegateTransfer animated:YES];
        };
        _delegateBar.delegateBlock = ^{
            @strongify(self)
            XXDelegateTransferViewController *delegateTransfer = [[XXDelegateTransferViewController alloc]init];
            delegateTransfer.delegateNodeType = XXDelegateNodeTypeAdd;
            delegateTransfer.validatorModel = self.validatorModel;
            [self.navigationController pushViewController:delegateTransfer animated:YES];
        };
    }
    return _delegateBar;;
}

@end
