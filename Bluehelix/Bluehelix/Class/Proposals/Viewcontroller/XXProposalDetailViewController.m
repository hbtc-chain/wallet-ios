//
//  XXProposalDetailViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalDetailViewController.h"
#import "XXPledgeViewController.h"
#import "XXVotingViewController.h"
#import "XXProposalDetailHeader.h"
#import "XXProposalDetailTableViewCell.h"
#import "XXProposalDetailVoteInfoCell.h"
#import "XXProposalDetailInfomationCell.h"
static NSString *kSectionHeader = @"XXProposalDetailHeader";
static NSString *kProposalDetailCell = @"ProposalDetailTableViewCell";
static NSString *kProposalDetailVoteInfoCell = @"ProposalDetailVoteInfoCell";
static NSString *kProposalDetailInfoCell = @"ProposalDetailInfomationCell";
@interface XXProposalDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *proposalDetailTableView;
@property (nonatomic, strong) XXProposalDetailHeader *detailHeader;
@property (nonatomic, strong) NSMutableArray *sectionFirstInfoArray;
@property (nonatomic, strong) NSMutableArray *sectionFirstValueArray;

/**底部按钮*/
@property (nonatomic, strong) XXButton *transferButton;
@property (nonatomic, assign) NSInteger sectionCount;
@end

@implementation XXProposalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //[self loadData];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestProposalDetail];
}
- (void)createUI{
    self.titleLabel.text = LocalizedString(@"ProposalNavgationTitleDetail");
    [self.view addSubview:self.proposalDetailTableView];
    [self.view addSubview:self.transferButton];
    [self layoutViews];
}
#pragma mark load Data
- (void)loadData{
    if (self.sectionFirstInfoArray) {
        [self.sectionFirstInfoArray removeAllObjects];
    }
    if (self.sectionFirstValueArray) {
        [self.sectionFirstValueArray removeAllObjects];
    }
    //section info
    NSArray *firstInfoArray= @[LocalizedString(@"ProposalDetailStatus"),LocalizedString(@"ProposalDetailIdentify"),LocalizedString(@"ProposalDetailType"),LocalizedString(@"ProposalDetailUser"),LocalizedString(@"ProposalDetailDate")];
    //section value
    NSArray *firstValueArray = @[KString(self.proposalModel.proposalId),KString(self.proposalModel.type),[NSString addressReplace:KString(self.proposalModel.proposer)],[NSString dateStringFromTimestampWithTimeTamp:[KString(self.proposalModel.submit_time) longLongValue]]];
    //已质押
    NSString *pledgedString = [NSString stringWithFormat:@"%@/%@%@",KString(self.proposalModel.total_deposit),KString(self.proposalModel.deposit_threshold),[kMainToken uppercaseString]];
    //投票结束时间
    NSString *voteEndtimeString = [NSString stringWithFormat:@"%@",[NSString dateStringFromTimestampWithTimeTamp:[self.proposalModel.deposit_end_time longLongValue]]];
    switch (self.proposalModel.proposalStatusType) {
        case XXProposalStatusTypeRaising:
        {
            //列表数据源
            self.sectionFirstInfoArray = [NSMutableArray arrayWithArray:firstInfoArray];
            [self.sectionFirstInfoArray addObject:LocalizedString(@"ProposalDetailHadPledge")];
            
            self.sectionFirstValueArray = [NSMutableArray array];
            NSAttributedString * attributedString = [[NSAttributedString alloc]initWithString:LocalizedString(@"ProposalRaising") attributes:@{NSForegroundColorAttributeName : kOrange100}];
            [self.sectionFirstValueArray addObject:attributedString];
            [self.sectionFirstValueArray addObjectsFromArray:firstValueArray];
            [self.sectionFirstValueArray addObject:pledgedString];
            //列表section 个数
            self.sectionCount = 2;
            //底部按钮文案
            [self.transferButton setTitle:LocalizedString(@"ProposalButtonTitlePledge") forState:UIControlStateNormal];
            self.transferButton.selected = NO;
            self.transferButton.userInteractionEnabled = YES;
        }
            break;
        case XXProposalStatusTypeVoting:
        {
            self.sectionFirstInfoArray = [NSMutableArray arrayWithArray:firstInfoArray];
            [self.sectionFirstInfoArray addObject:LocalizedString(@"ProposalDetailVoteEndDate")];
            
            self.sectionFirstValueArray = [NSMutableArray array];
            NSAttributedString * attributedString = [[NSAttributedString alloc]initWithString:LocalizedString(@"ProposalVoting") attributes:@{NSForegroundColorAttributeName : kPrimaryMain}];
            [self.sectionFirstValueArray addObject:attributedString];
            [self.sectionFirstValueArray addObjectsFromArray:firstValueArray];
            [self.sectionFirstValueArray addObject:voteEndtimeString];
            //列表section 个数
            self.sectionCount = 3;
            //底部按钮文案
            [self.transferButton setTitle:LocalizedString(@"ProposalButtonTitleVote") forState:UIControlStateNormal];
            self.transferButton.selected = NO;
            self.transferButton.userInteractionEnabled = YES;
        }
            break;
        case XXProposalStatusTypeVotePass:
        {
            self.sectionFirstInfoArray = [NSMutableArray arrayWithArray:firstInfoArray];
            [self.sectionFirstInfoArray addObject:LocalizedString(@"ProposalDetailVoteEndDate")];
            
            self.sectionFirstValueArray = [NSMutableArray array];
            NSAttributedString * attributedString = [[NSAttributedString alloc]initWithString:LocalizedString(@"ProposalVotePass") attributes:@{NSForegroundColorAttributeName : kGreen100}];
            [self.sectionFirstValueArray addObject:attributedString];
            [self.sectionFirstValueArray addObjectsFromArray:firstValueArray];
            [self.sectionFirstValueArray addObject:voteEndtimeString];
            //列表section 个数
            self.sectionCount = 3;
            //底部按钮文案
            [self.transferButton setTitle:LocalizedString(@"ProposalButtonTitleVote") forState:UIControlStateNormal];
            self.transferButton.selected = YES;
            self.transferButton.userInteractionEnabled = NO;
        }
            break;
        case XXProposalStatusTypeVoteReject:
        {
            self.sectionFirstInfoArray = [NSMutableArray arrayWithArray:firstInfoArray];
            [self.sectionFirstInfoArray addObject:LocalizedString(@"ProposalDetailVoteEndDate")];
            
            self.sectionFirstValueArray = [NSMutableArray array];
            NSAttributedString * attributedString = [[NSAttributedString alloc]initWithString:LocalizedString(@"ProposalVoteReject") attributes:@{NSForegroundColorAttributeName : kRed100}];
            [self.sectionFirstValueArray addObject:attributedString];
            [self.sectionFirstValueArray addObjectsFromArray:firstValueArray];
            [self.sectionFirstValueArray addObject:voteEndtimeString];
            //列表section 个数
            self.sectionCount = 3;
            //底部按钮文案
            [self.transferButton setTitle:LocalizedString(@"ProposalButtonTitleVote") forState:UIControlStateNormal];
            self.transferButton.selected = YES;
            self.transferButton.userInteractionEnabled = NO;
        }
            break;
        case XXProposalStatusTypeRaiseFailed:
        {
            self.sectionFirstInfoArray = [NSMutableArray arrayWithArray:firstInfoArray];
            [self.sectionFirstInfoArray addObject:LocalizedString(@"ProposalDetailHadPledge")];
            
            self.sectionFirstValueArray = [NSMutableArray array];
            NSAttributedString * attributedString = [[NSAttributedString alloc]initWithString:LocalizedString(@"ProposalRaiseFailed") attributes:@{NSForegroundColorAttributeName : kGray700}];
            [self.sectionFirstValueArray addObject:attributedString];
            [self.sectionFirstValueArray addObjectsFromArray:firstValueArray];
            [self.sectionFirstValueArray addObject:pledgedString];
            //列表section 个数
            self.sectionCount = 2;
            //底部按钮文案
            [self.transferButton setTitle:LocalizedString(@"ProposalButtonTitlePledge") forState:UIControlStateNormal];
            self.transferButton.selected = YES;
            self.transferButton.userInteractionEnabled = NO;
        }
            break;
        default:
            break;
    }

    [self.proposalDetailTableView reloadData];
}
#pragma mark 数据请求
- (void)requestProposalDetail {
    @weakify(self)
    NSString *path = [NSString stringWithFormat:@"/api/v1/proposals/%@",self.proposalModel.proposalId];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        @strongify(self)
        [self.proposalDetailTableView.mj_header endRefreshing];
        if (code == 0) {
            NSLog(@"%@",data);
            self.proposalModel = [XXProposalModel mj_objectWithKeyValues:data];
            [self loadData];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }];
}
#pragma mark aciton
- (void)transferButtonAction:(XXButton*)button{
    switch (self.proposalModel.proposalStatusType) {
        case XXProposalStatusTypeRaising:
        {
            XXPledgeViewController *pledgeViewController = [XXPledgeViewController new];
            pledgeViewController.proposalModel = self.proposalModel;
            [self.navigationController pushViewController:pledgeViewController animated:YES];
        }
            break;
        case XXProposalStatusTypeVoting:
        {
            XXVotingViewController *voting = [XXVotingViewController new];
            voting.proposalModel = self.proposalModel;
            [self.navigationController pushViewController:voting animated:YES];
        }
        break;
        default:
            break;
    }
}
#pragma mark layout
- (void)layoutViews{
//    [self.detailHeader mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kScreen_Width);
//        make.height.mas_greaterThanOrEqualTo(56);
//    }];
}
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.sectionFirstInfoArray.count;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.proposalDetailTableView.sectionHeaderHeight;
    }else{
        return CGFLOAT_MIN;;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.sectionCount -1) {
        return self.proposalDetailTableView.rowHeight;
    }
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
         self.detailHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeader];
         self.detailHeader.proposalModel = self.proposalModel;
         return self.detailHeader;
    }else{
        return [UIView new];;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == self.sectionCount -1 || self.sectionCount == 3) {
        //最后一行 和 投票相关状态没有分割线
        return [UIView new];
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 28)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(24, 16, kScreen_Width-24, 1)];
    lineView.backgroundColor = KLine_Color;
    [view addSubview:lineView];
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = kWhiteColor;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        return 32;
    }else if (indexPath.section == 1){
        return 192;
    } else{
        return 128;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XXProposalDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProposalDetailCell];
        if (!cell) {
            cell = [[XXProposalDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProposalDetailCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kWhiteColor;
        cell.labelInfo.text = self.sectionFirstInfoArray[indexPath.row];
        if (indexPath.row ==0) {
            cell.labelValue.attributedText = self.sectionFirstValueArray[indexPath.row];
        }else{
            cell.labelValue.text = self.sectionFirstValueArray[indexPath.row];
        }

        return cell;
    }else if (indexPath.section == 1 && self.sectionCount == 3){
        XXProposalDetailVoteInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProposalDetailVoteInfoCell];
        if (!cell) {
            cell = [[XXProposalDetailVoteInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProposalDetailVoteInfoCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kGray50;
        cell.proposalModel = self.proposalModel;
        return cell;
    } else{
        XXProposalDetailInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:kProposalDetailInfoCell];
        if (!cell) {
            cell = [[XXProposalDetailInfomationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProposalDetailInfoCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kWhiteColor;
        cell.detailLabelValue.text = self.proposalModel.proposalDescription;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark lazy load
- (UITableView *)proposalDetailTableView {
    if (_proposalDetailTableView == nil) {
        _proposalDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 64 - 8) style:UITableViewStylePlain];
        _proposalDetailTableView.dataSource = self;
        _proposalDetailTableView.delegate = self;
        _proposalDetailTableView.backgroundColor = kWhiteColor;
        _proposalDetailTableView.estimatedSectionHeaderHeight = 56;
        _proposalDetailTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _proposalDetailTableView.rowHeight = 28;
        _proposalDetailTableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _proposalDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _proposalDetailTableView.showsVerticalScrollIndicator = NO;
        [_proposalDetailTableView registerClass:[XXProposalDetailHeader class] forHeaderFooterViewReuseIdentifier:kSectionHeader];
        [_proposalDetailTableView registerClass:[XXProposalDetailTableViewCell class] forCellReuseIdentifier:kProposalDetailCell];
        [_proposalDetailTableView registerClass:[XXProposalDetailVoteInfoCell class] forCellReuseIdentifier:kProposalDetailVoteInfoCell];
        [_proposalDetailTableView registerClass:[XXProposalDetailInfomationCell class] forCellReuseIdentifier:kProposalDetailInfoCell];
        if (@available(iOS 11.0, *)) {
            _proposalDetailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        @weakify(self)
        _proposalDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
                [impactLight impactOccurred];
            }
            @strongify(self)
            [self requestProposalDetail];
           
        }];
    }
    return _proposalDetailTableView;
}
/** 按钮 */
- (XXButton *)transferButton {
    if (!_transferButton) {
        @weakify(self)
        _transferButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 64 -8 , kScreen_Width - KSpacing*2, 48) title:@"" font:kFontBold17 titleColor:kMainTextColor block:^(UIButton *button) {
            @strongify(self)
            [self transferButtonAction:self.transferButton];
        }];
        _transferButton.layer.cornerRadius = 3;
        _transferButton.layer.masksToBounds = YES;
        [_transferButton setBackgroundImage:[UIImage createImageWithColor:kPrimaryMain] forState:UIControlStateNormal ];
        [_transferButton setBackgroundImage:[UIImage createImageWithColor:kButtonDisableColor] forState:UIControlStateSelected];
        [_transferButton setTitleColor:kWhiteNoChange forState:UIControlStateNormal];
        [_transferButton setTitleColor:kMainTextColor forState: UIControlStateSelected];
    }
    return _transferButton;
}

@end
