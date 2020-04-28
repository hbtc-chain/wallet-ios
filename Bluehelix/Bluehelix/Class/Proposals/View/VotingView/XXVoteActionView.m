//
//  XXVoteActionView.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXVoteActionView.h"
@interface XXVoteActionView ()
@property (nonatomic, strong) XXLabel *voteTitleLabel;

@property (nonatomic, strong) NSMutableArray *buttonArray;

//选中的item
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation XXVoteActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.voteTitleLabel];
    }
    return self;
}

- (void)setItemsArray:(NSMutableArray *)itemsArray {
    _itemsArray = itemsArray;
    if (_itemsArray.count == 0) {
        return;
    }
    for (NSInteger i=0; i < _itemsArray.count; i ++) {
        //button 实例
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = CGRectMake(16, 28 + i * 48 + 8 * (i +1), kScreen_Width -32, 48);
        [itemButton setTitle:_itemsArray[i] forState:UIControlStateNormal];
        [itemButton setTitleColor:kGray700 forState:UIControlStateNormal];
        [itemButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [itemButton setBackgroundImage:[UIImage createImageWithColor:kGray50] forState:UIControlStateNormal];
        itemButton.tag = i;
        [itemButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        itemButton.titleLabel.font = kFontBold17;
        itemButton.layer.masksToBounds = YES;
        itemButton.layer.cornerRadius = 4.0f;
        itemButton.adjustsImageWhenHighlighted = NO;
        switch (i) {
            case 0:
                [itemButton setImage:[UIImage imageNamed:@"vote_yes"] forState:UIControlStateNormal];
                [itemButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                break;
            case 1:
                [itemButton setImage:[UIImage imageNamed:@"vote_no"] forState:UIControlStateNormal];
                [itemButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                break;
            case 2:
                [itemButton setImage:[UIImage imageNamed:@"vote_abstain"] forState:UIControlStateNormal];
                [itemButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                break;
            case 3:
                [itemButton setImage:[UIImage imageNamed:@"vote_noWithVeto"] forState:UIControlStateNormal];
                [itemButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                break;
            default:
                break;
        }
        //imageview 偏移量
        itemButton.imageEdgeInsets =  UIEdgeInsetsMake(0, -(itemButton.imageView.frame.origin.x ) +16 , 0, itemButton.imageView.frame.origin.x - 16);
        [self.buttonArray addObject:itemButton];
        [self addSubview:itemButton];
    }
}
- (void)buttonAction:(UIButton*)sender{
    if (sender == self.selectedButton) {
         [self cancelSelected];//取消选中状态
        return;
    }
    self.selectedButton = sender;
    [self cancelSelected];//取消选中状态
    NSString *voteString;
    switch (sender.tag) {
        case 0:
            voteString = @"Yes";
            break;
        case 1:
            voteString = @"No";
            break;
        case 2:
            voteString = @"Abstain";
            break;
        case 3:
            voteString = @"NoWithVeto";
            break;
        default:
            break;
    }
    //选中回调
    if (self.voteCallBlock) {
        self.voteCallBlock(voteString);
    }
}
- (void)cancelSelected{
    for (int i = 0; i<self.buttonArray.count; i++) {
        UIButton *button = self.buttonArray[i];
        if ([self.selectedButton isEqual:button]) {
            button.selected= YES;
            switch (i) {
                case 0:
                    [button setBackgroundImage:[UIImage createImageWithColor:kGreen100] forState:UIControlStateSelected];
                    break;
                case 1:
                    [button setBackgroundImage:[UIImage createImageWithColor:kRed100] forState:UIControlStateSelected];
                    break;
                case 2:
                    [button setBackgroundImage:[UIImage createImageWithColor:kGray] forState:UIControlStateSelected];
                    break;
                case 3:
                    [button setBackgroundImage:[UIImage createImageWithColor:kPrimaryMain] forState:UIControlStateSelected];
                    break;
                default:
                    break;
            }
        }else{
            button.selected = NO;
            [button setBackgroundImage:[UIImage createImageWithColor:kGray50] forState:UIControlStateNormal];
        }
    }
}

#pragma mark lazy load
- (XXLabel *)voteTitleLabel{
    if (!_voteTitleLabel) {
        _voteTitleLabel = [XXLabel labelWithFrame:CGRectMake(16, 0, 120, 20) text:LocalizedString(@"ProposalButtonTitleVote") font:kFont15 textColor:kGray700 alignment:NSTextAlignmentLeft];
    }
    return _voteTitleLabel;
}
- (NSMutableArray*)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
@end
