//
//  XXProposalDetailHeader.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalDetailHeader.h"
@interface XXProposalDetailHeader ()
@property (nonatomic, strong) XXLabel *TitleLabel;
@end

@implementation XXProposalDetailHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.TitleLabel];
    }
    return self;
}
#pragma mark layout
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_greaterThanOrEqualTo(48);
        make.bottom.mas_equalTo(-16);
    }];
}
#pragma mark set/get
- (void)setProposalModel:(XXProposalModel *)proposalModel{
    _proposalModel = proposalModel;
    self.TitleLabel.text = _proposalModel.title;
}
#pragma mark lazy load
- (XXLabel *)TitleLabel{
    if (!_TitleLabel) {
        _TitleLabel = [XXLabel labelWithFrame:CGRectZero text:@"" font:kFontBold20 textColor:kGray900 alignment:NSTextAlignmentLeft];
        _TitleLabel.numberOfLines = 0;
    }
    return _TitleLabel;
}
@end
