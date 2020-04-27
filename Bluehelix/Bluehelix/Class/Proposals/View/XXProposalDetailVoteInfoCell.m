//
//  XXProposalDetailVoteInfoCell.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalDetailVoteInfoCell.h"

@interface XXProposalDetailVoteInfoCell ()
@property (nonatomic, strong) XXLabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconimageView;
@property (nonatomic, strong) XXLabel *voteInfo;
@property (nonatomic, strong) XXLabel *voteValue;

@property (nonatomic, strong) UIImageView *iconimageView2;
@property (nonatomic, strong) XXLabel *voteInfo2;
@property (nonatomic, strong) XXLabel *voteValue2;

@property (nonatomic, strong) UIImageView *iconimageView3;
@property (nonatomic, strong) XXLabel *voteInfo3;
@property (nonatomic, strong) XXLabel *voteValue3;

@property (nonatomic, strong) UIImageView *iconimageView4;
@property (nonatomic, strong) XXLabel *voteInfo4;
@property (nonatomic, strong) XXLabel *voteValue4;

@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) NSMutableArray *valueArray;
@end
@implementation XXProposalDetailVoteInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.iconimageView];
        [self addSubview:self.voteInfo];
        [self addSubview:self.voteValue];
        
        [self addSubview:self.iconimageView2];
        [self addSubview:self.voteInfo2];
        [self addSubview:self.voteValue2];
        
        [self addSubview:self.iconimageView3];
        [self addSubview:self.voteInfo3];
        [self addSubview:self.voteValue3];
        
        [self addSubview:self.iconimageView4];
        [self addSubview:self.voteInfo4];
        [self addSubview:self.voteValue4];
        
        self.iconArray = [NSMutableArray arrayWithArray:@[self.iconimageView,self.iconimageView2,self.iconimageView3,self.iconimageView4]];
        self.infoArray = [NSMutableArray arrayWithArray:@[self.voteInfo,self.voteInfo2,self.voteInfo3,self.voteInfo4]];
        self.valueArray = [NSMutableArray arrayWithArray:@[self.voteValue,self.voteValue2,self.voteValue3,self.voteValue4]];
    }
    return self;
}
#pragma mark set/get
- (void)setProposalModel:(XXProposalModel *)proposalModel{
    _proposalModel = proposalModel;
    self.voteValue.text = KString(_proposalModel.result.yes);
    self.voteValue2.text = KString(_proposalModel.result.no);
    self.voteValue3.text = KString(_proposalModel.result.abstain);
    self.voteValue4.text = KString(_proposalModel.result.no_with_veto);
    
}
#pragma mark layout
- (void)layoutSubviews{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(24);
        make.height.mas_equalTo(40);
    }];
    [self.iconArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.height.width.mas_equalTo(20);
    }];
    [self.iconArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:12 leadSpacing:54 tailSpacing:22];
    
    [self.infoArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:48 tailSpacing:16];
    [self.infoArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.left.mas_equalTo(self.iconimageView.mas_right).offset(8);
    }];
    
    [self.valueArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:48 tailSpacing:16];
    [self.valueArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.right.mas_equalTo(-24);
    }];
}
#pragma mark lazy load

- (XXLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ProposalDetailVoteRatio") font:kFont15 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _titleLabel;;
}
//
- (UIImageView *)iconimageView{
    if (!_iconimageView) {
        _iconimageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconimageView.image =[UIImage imageNamed:@"vote_yes"];
    }
    return _iconimageView;;
}
- (XXLabel *)voteInfo{
    if (!_voteInfo) {
        _voteInfo = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ProposalDetailVoteYes") font:kFont15 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _voteInfo;
}
- (XXLabel *)voteValue{
    if (!_voteValue) {
        _voteValue = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont15 textColor:kGray900 alignment:NSTextAlignmentRight];
    }
    return _voteValue;
}
//
- (UIImageView *)iconimageView2{
    if (!_iconimageView2) {
        _iconimageView2 = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconimageView2.image =[UIImage imageNamed:@"vote_no"];
    }
    return _iconimageView2;
}
- (XXLabel *)voteInfo2{
    if (!_voteInfo2) {
        _voteInfo2 = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ProposalDetailVoteNo") font:kFont15 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _voteInfo2;
}
- (XXLabel *)voteValue2{
    if (!_voteValue2) {
        _voteValue2 = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont15 textColor:kGray900 alignment:NSTextAlignmentRight];
    }
    return _voteValue2;
}

//
- (UIImageView *)iconimageView3{
    if (!_iconimageView3) {
        _iconimageView3 = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconimageView3.image =[UIImage imageNamed:@"vote_abstain"];
    }
    return _iconimageView3;;
}
- (XXLabel *)voteInfo3{
    if (!_voteInfo3) {
        _voteInfo3 = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ProposalDetailVoteAbstain") font:kFont15 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _voteInfo3;
}
- (XXLabel *)voteValue3{
    if (!_voteValue3) {
        _voteValue3 = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont15 textColor:kGray900 alignment:NSTextAlignmentRight];
    }
    return _voteValue3;
}
//
- (UIImageView *)iconimageView4{
    if (!_iconimageView4) {
        _iconimageView4 = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconimageView4.image =[UIImage imageNamed:@"vote_noWithVeto"];
    }
    return _iconimageView4;;
}
- (XXLabel *)voteInfo4{
    if (!_voteInfo4) {
        _voteInfo4 = [XXLabel labelWithFrame:CGRectZero text:LocalizedString(@"ProposalDetailVoteNoWithVeto") font:kFont15 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _voteInfo4;
}
- (XXLabel *)voteValue4{
    if (!_voteValue4) {
        _voteValue4 = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFont15 textColor:kGray900 alignment:NSTextAlignmentRight];
    }
    return _voteValue4;
}

@end
