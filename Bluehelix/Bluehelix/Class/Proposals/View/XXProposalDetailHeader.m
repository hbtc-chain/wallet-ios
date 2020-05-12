//
//  XXProposalDetailHeader.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalDetailHeader.h"
@interface XXProposalDetailHeader ()
@property (nonatomic, strong) UIView *headBackgroundView;
@property (nonatomic, strong) XXLabel *TitleLabel;
@end

@implementation XXProposalDetailHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.headBackgroundView];
        [self addSubview:self.TitleLabel];
        [self layoutViews];
    }
    return self;
}

#pragma mark layout
- (void)layoutViews{
    [super layoutSubviews];
    [self.headBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    [self.TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_greaterThanOrEqualTo(32);
        make.bottom.mas_equalTo(-16);
    }];
}
#pragma mark set/get
- (void)setProposalModel:(XXProposalModel *)proposalModel{
    _proposalModel = proposalModel;
    self.TitleLabel.text = _proposalModel.title;
}
#pragma mark lazy load
- (UIView *)headBackgroundView{
    if (!_headBackgroundView) {
        _headBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        _headBackgroundView.backgroundColor = kBackgroundLeverFirst;
    }
    return _headBackgroundView;
}

- (XXLabel *)TitleLabel{
    if (!_TitleLabel) {
        _TitleLabel = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFontBold20 textColor:kGray900 alignment:NSTextAlignmentLeft];
        _TitleLabel.numberOfLines = 0;
    }
    return _TitleLabel;
}
@end
