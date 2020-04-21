//
//  BHChooseLanguageCell.m
//  Bhex
//
//  Created by Bhex on 2018/8/15.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "BHChooseLanguageCell.h"
#import "Masonry.h"

@interface BHChooseLanguageCell()


@end

@implementation BHChooseLanguageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = kViewBackgroundColor;
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@24);
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-27);
        make.centerY.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@24);
        make.height.equalTo(@1);
        make.bottom.equalTo(self);
        make.right.equalTo(@0);
    }];
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage mainImageName:@"selected"];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _arrowImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = kGray900;
        _leftLabel.font = kFont16;
    }
    return _leftLabel;
}

- (void)setLangeuageModel:(BHChooseLanguageModel *)langeuageModel {
    _leftLabel.text = langeuageModel.languageName;
    NSString *currentLanguage = [[LocalizeHelper sharedLocalSystem] getLanguageCode];
    _arrowImageView.hidden = ![langeuageModel.languageCode isEqualToString:currentLanguage];
}

+ (CGFloat)getCellHeight {
    return 56;
}

@end
