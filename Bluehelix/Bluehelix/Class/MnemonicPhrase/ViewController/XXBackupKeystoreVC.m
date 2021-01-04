//
//  XXBackupKeystoreVC.m
//  Bluehelix
//
//  Created by BHEX on 2020/5/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXBackupKeystoreVC.h"
#import "XXBackupSegmentView.h"
#import "XXBackupKeystoreView.h"
#import "XXBackupCodeView.h"

@interface XXBackupKeystoreVC ()

@property (nonatomic, strong) XXBackupSegmentView *toolBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XXBackupKeystoreView *keystoreView;
@property (nonatomic, strong) XXBackupCodeView *backupCodeView;

@end

@implementation XXBackupKeystoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"BackupKeystore");
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.keystoreView];
    [self.scrollView addSubview:self.backupCodeView];
    
    NSError *error = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[KUser.currentAccount.keystore dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
    [dic removeObjectForKey:@"mnemonicText"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingSortedKeys error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonKeystore = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    self.keystoreView.text = jsonKeystore;
    self.backupCodeView.text = jsonKeystore;
}

- (XXBackupSegmentView*)toolBar {
    MJWeakSelf
    if (!_toolBar) {
        _toolBar = [[XXBackupSegmentView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, 40)];
        _toolBar.itemsArray = [NSMutableArray arrayWithArray:@[LocalizedString(@"Keystore"),LocalizedString(@"QRCode")]];
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

- (XXBackupKeystoreView *)keystoreView {
    if (!_keystoreView) {
        _keystoreView = [[XXBackupKeystoreView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrollView.height)];
    }
    return _keystoreView;
}

- (XXBackupCodeView *)backupCodeView {
    if (!_backupCodeView) {
        _backupCodeView = [[XXBackupCodeView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, self.scrollView.height)];
    }
    return _backupCodeView;
}

@end
