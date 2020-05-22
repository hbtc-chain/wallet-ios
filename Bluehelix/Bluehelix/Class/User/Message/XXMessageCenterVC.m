//
//  XXMessageCenterVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/21.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMessageCenterVC.h"
#import "XXBackupSegmentView.h"
#import "XXTransferMessageView.h"

@interface XXMessageCenterVC ()

@property (nonatomic, strong) XXBackupSegmentView *toolBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XXTransferMessageView *transferView;

@end

@implementation XXMessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = LocalizedString(@"MessageCenter");
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.transferView];
}

- (XXBackupSegmentView*)toolBar {
    MJWeakSelf
    if (!_toolBar) {
        _toolBar = [[XXBackupSegmentView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, 40)];
        _toolBar.itemsArray = [NSMutableArray arrayWithArray:@[LocalizedString(@"TransferNotification"),LocalizedString(@"SystemMessage")]];
        _toolBar.ToolbarSelectCallBack = ^(NSInteger index) {
            if (index == 0) {
                [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            } else {
                [weakSelf.scrollView setContentOffset:CGPointMake(kScreen_Width, 0) animated:YES];
            }
        };
    }
    return _toolBar;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), kScreen_Width, kScreen_Height - CGRectGetMaxY(self.toolBar.frame))];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreen_Width*2, 0);
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (XXTransferMessageView *)transferView {
    if (_transferView == nil) {
        _transferView = [[XXTransferMessageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrollView.height)];
    }
    return _transferView;
}

@end
