//
//  XXProposalDescriptionView.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalDescriptionView.h"

@implementation XXProposalDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        [self addSubview:self.nameLabel];
    
        [self addSubview:self.banView];
        
        [self.banView addSubview:self.unitLabel];
        
        [self.banView addSubview:self.textView];
        
        [self.banView addSubview:self.countLabel];
        
    }
    return self;
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/%ld%@", (unsigned long)textView.text.length,(long)MaxCount,LocalizedString(@"ProposalDescriptionMaxCountUnit")];
    if ( (unsigned long)textView.text.length > MaxCount) {
    // 对超出的部分进行剪切
        textView.text = [textView.text substringToIndex:MaxCount];
        self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld%@",(long)MaxCount,(long)MaxCount,LocalizedString(@"ProposalDescriptionMaxCountUnit")];
     }
}

#pragma mark lazy load
/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 10, kScreen_Width - KSpacing*2, 24) font:kFont15 textColor:kGray];
        //_nameLabel.text = LocalizedString(@"WithdrawAddress");
    }
    return _nameLabel;
}

/** 背景图 */
- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nameLabel.frame) + 4, kScreen_Width - KSpacing*2, 132)];
        _banView.backgroundColor = kGray50;
        _banView.layer.cornerRadius = 4;
        _banView.layer.masksToBounds = YES;
    }
    return _banView;
}

/** 单位标签 */
- (XXLabel *)unitLabel {
    if (_unitLabel == nil) {
        _unitLabel = [XXLabel labelWithFrame:CGRectMake(self.banView.width - K375(200), 0, K375(192), self.banView.height) font:kFont15 textColor:kGray500];
        _unitLabel.textAlignment = NSTextAlignmentRight;
    }
    return _unitLabel;
}

/** 输入框 */
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(K375(8), 0, self.banView.width -K375(16), self.banView.height)];
        _textView.textColor = kGray900;
        _textView.font = kFont15;
        _textView.delegate = self;
        _textView.textColor = kGray900;
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}
- (XXLabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.textView.frame) - 200, CGRectGetMaxY(self.textView.frame) - K375(16)-K375(8), 200, K375(16)) text:[NSString stringWithFormat:@"0/%ld%@",(long)MaxCount,LocalizedString(@"ProposalDescriptionMaxCountUnit")] font:kFont10 textColor:kGray200 alignment:NSTextAlignmentRight];
    }
    return _countLabel;
}

@end
