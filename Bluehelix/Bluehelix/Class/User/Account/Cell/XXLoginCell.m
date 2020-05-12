//
//  XXLoginCell.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXLoginCell.h"

@implementation XXLoginCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.nameLabel];
        [self addSubview:self.lineView];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, KLine_Height)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(0, 0, kScreen_Width, 48) text:@"" font:kFont13 textColor:kGray900 alignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
