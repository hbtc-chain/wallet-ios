//
//  XXBackupPrivateKeyVC.m
//  Bluehelix
//
//  Created by BHEX on 2020/5/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXBackupPrivateKeyVC.h"
#import "XXBackupSegmentView.h"
#import "XXBackupPrivateKeyView.h"
#import "XXBackupCodeView.h"

@interface XXBackupPrivateKeyVC ()

@property (nonatomic, strong) XXBackupSegmentView *toolBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XXBackupPrivateKeyView *privateKeyView;
@property (nonatomic, strong) XXBackupCodeView *backupCodeView;

@end

@implementation XXBackupPrivateKeyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setValue:@"" forPasteboardType:UIPasteboardNameGeneral];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"BackupPrivateKey");
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.privateKeyView];
    [self.scrollView addSubview:self.backupCodeView];
    self.privateKeyView.text = self.text;
    self.backupCodeView.text = self.text;
}

- (XXBackupSegmentView*)toolBar {
    MJWeakSelf
    if (!_toolBar) {
        _toolBar = [[XXBackupSegmentView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, 40)];
        _toolBar.itemsArray = [NSMutableArray arrayWithArray:@[LocalizedString(@"PrivateKey"),LocalizedString(@"QRCode")]];
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

- (XXBackupPrivateKeyView *)privateKeyView {
    if (!_privateKeyView) {
        _privateKeyView = [[XXBackupPrivateKeyView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrollView.height)];
    }
    return _privateKeyView;
}

- (XXBackupCodeView *)backupCodeView {
    if (!_backupCodeView) {
        _backupCodeView = [[XXBackupCodeView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, self.scrollView.height)];
    }
    return _backupCodeView;
}

@end
