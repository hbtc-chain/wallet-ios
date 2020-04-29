//
//  XXProposalTableViewCell.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalTableViewCell.h"
@interface XXProposalTableViewCell ()
/**背景阴影*/
@property (nonatomic, strong) UIView *backShadowView;
/**提案状态图标*/
@property (nonatomic, strong) UIImageView *proposalStatusImageview;
/**提案状态*/
@property (nonatomic, strong) XXLabel *statusLabel;
/**分割线*/
@property (nonatomic, strong) UIView *lineView;
/**提案编号*/
@property (nonatomic, strong) XXLabel *proposalIDLabel;
/**提案标题*/
@property (nonatomic, strong) XXLabel *proposalTitleLabel;
/**提案详情*/
@property (nonatomic, strong) XXLabel *proposalDescription;
/**查看详情*/
@property (nonatomic, strong) XXButton *proposalDetalButton;
@end
@implementation XXProposalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.backShadowView];
        [self addSubview:self.proposalStatusImageview];
        [self addSubview:self.statusLabel];
        [self addSubview:self.lineView];
        [self addSubview:self.proposalIDLabel];
        [self addSubview:self.proposalTitleLabel];
        [self addSubview:self.proposalDescription];
        [self addSubview:self.proposalDetalButton];
    }
    return self;
}
#pragma mark Load Data
- (void)loadDataWithModel:(XXProposalModel*)proposalModel{
    switch (proposalModel.proposalStatusType) {
  
        case XXProposalStatusTypeRaising:
            self.proposalStatusImageview.image = [UIImage imageNamed:@"proposal_status_raising"];
            self.statusLabel.text = LocalizedString(@"ProposalRaising");
            self.statusLabel.textColor = kOrange100;
        break;
        case XXProposalStatusTypeVoting:
            self.proposalStatusImageview.image = [UIImage imageNamed:@"proposal_status_voting"];
            self.statusLabel.text = LocalizedString(@"ProposalVoting");
            self.statusLabel.textColor = kPrimaryMain;
        break;
        case XXProposalStatusTypeVotePass:
            self.proposalStatusImageview.image = [UIImage imageNamed:@"proposal_status_vote_pass"];
            self.statusLabel.text = LocalizedString(@"ProposalVotePass");
            self.statusLabel.textColor = kGreen100;
        break;
        case XXProposalStatusTypeVoteReject:
            self.proposalStatusImageview.image = [UIImage imageNamed:@"proposal_status_vote_reject"];
            self.statusLabel.text = LocalizedString(@"ProposalVoteReject");
            self.statusLabel.textColor = kRed100;
        break;
        case XXProposalStatusTypeRaiseFailed:
            self.proposalStatusImageview.image = [UIImage imageNamed:@"proposal_status_raise_failed"];
            self.statusLabel.text = LocalizedString(@"ProposalRaiseFailed");
            self.statusLabel.textColor = kGray500;
        break;
        default:
            break;
    }
    self.proposalIDLabel.text = [NSString stringWithFormat:@"ID-%@",proposalModel.proposalId];
    self.proposalTitleLabel.text = proposalModel.title;
    self.proposalDescription.text = proposalModel.proposalDescription;
    [self layoutIfNeeded];
}

#pragma mark layout
- (void)layoutSubviews{
    [self.backShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-12);
    }];
    [self.proposalStatusImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.left.mas_equalTo(32);
        make.width.height.mas_equalTo(20);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.proposalStatusImageview.mas_right).offset(8);
        make.centerY.mas_equalTo(self.proposalStatusImageview.mas_centerY);
        
    }];
    [self.proposalIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.centerY.mas_equalTo(self.proposalStatusImageview.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.proposalStatusImageview.mas_bottom).offset(12);
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    [self.proposalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(8);
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-32);
        make.height.mas_greaterThanOrEqualTo(32);
    }];
    [self.proposalDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.proposalTitleLabel.mas_bottom);
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-32);
        make.height.mas_greaterThanOrEqualTo(24);
        make.height.mas_lessThanOrEqualTo(64);
    }];
    [self.proposalDetalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.proposalDescription.mas_bottom).offset(8);
        make.right.mas_equalTo(-32);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(28);
        make.bottom.mas_equalTo(self.backShadowView.mas_bottom).offset(-16);
    }];
}
#pragma mark lazy load
- (UIView *)backShadowView{
    if (!_backShadowView) {
        _backShadowView = [[UIView alloc]initWithFrame:CGRectZero];
        _backShadowView.clipsToBounds = NO;
        _backShadowView.backgroundColor = kViewBackgroundColor;
        _backShadowView.layer.cornerRadius = 10.0;
        _backShadowView.layer.shadowColor = [kShadowColor CGColor];
        _backShadowView.layer.shadowRadius = 6.0;
        _backShadowView.layer.shadowOpacity = 1;
        _backShadowView.layer.shadowOffset = CGSizeMake(0, 3);
    }
    return _backShadowView;
}

- (UIImageView *)proposalStatusImageview{
    if (!_proposalStatusImageview) {
        _proposalStatusImageview = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _proposalStatusImageview;
}
- (XXLabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont15 textColor:kMainLabelColor alignment:NSTextAlignmentLeft];
    }
    return _statusLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}
- (XXLabel *)proposalIDLabel{
    if (!_proposalIDLabel) {
        _proposalIDLabel = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont15 textColor:kSubLabelColor alignment:NSTextAlignmentRight];
    }
    return _proposalIDLabel;;
}
- (XXLabel *)proposalTitleLabel{
    if (!_proposalTitleLabel) {
        _proposalTitleLabel = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFontBold17 textColor:kMainLabelColor alignment:NSTextAlignmentLeft];
        _proposalTitleLabel.numberOfLines = 0;
    }
    return _proposalTitleLabel;;
}
- (XXLabel *)proposalDescription{
    if (!_proposalDescription) {
        _proposalDescription = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont13 textColor:kSubLabelColor alignment:NSTextAlignmentLeft];
        _proposalDescription.numberOfLines = 0;
    }
    return _proposalDescription;
}
- (XXButton*)proposalDetalButton{
    if (!_proposalDetalButton) {
        _proposalDetalButton = [XXButton buttonWithFrame:CGRectZero title:LocalizedString(@"ProposalDetailButton") font:kFontBold13 titleColor:kPrimaryMain block:^(UIButton *button) {
            
        }];
        _proposalDetalButton.userInteractionEnabled = NO;
        _proposalDetalButton.layer.cornerRadius = 12;
        _proposalDetalButton.layer.borderWidth = 1.0;
        _proposalDetalButton.layer.borderColor = [UIColor colorWithHexString:@"#3375E0"].CGColor;
    }
    return _proposalDetalButton;
}
@end
