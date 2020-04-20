//
//  XXDelegateTransferViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXDelegateTransferViewController.h"

#import "XXDelegateTransferView.h"
#import "XXTokenModel.h"
@interface XXDelegateTransferViewController ()
/**委托view*/
@property (nonatomic, strong) XXDelegateTransferView *delegateTransferView;
/**委托响应按钮*/
@property (nonatomic, strong) XXButton *transferButton;
/**资产数据*/
@property (nonatomic, strong) XXAssetModel *assetModel;
@end

@implementation XXDelegateTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self configAsset];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[XXAssetManager sharedManager] requestAsset];
}
- (void)createUI{
    switch (self.delegateNodeType) {
        case 0:
            self.titleLabel.text =  LocalizedString(@"Delegate");
            break;
        case 1:
            self.titleLabel.text =  LocalizedString(@"TransferDelegate");
            break;
            
        default:
            self.titleLabel.text = LocalizedString(@"RelieveDelegate");
            break;
    }
    [self.view addSubview:self.delegateTransferView];
    [self.view addSubview:self.transferButton];
    
}
- (void)configAsset {
    @weakify(self)
    XXAssetManager *assetManager = [XXAssetManager sharedManager];
    assetManager.assetChangeBlock = ^{
        @strongify(self)
        [self refreshDelegateAmount];
    };
}
#pragma mark 刷新资产
- (void)refreshDelegateAmount{
    self.assetModel = [[XXAssetManager sharedManager] assetModel];
    for (XXTokenModel *tokenModel in self.assetModel.assets) {
        if ([[tokenModel.symbol uppercaseString] isEqualToString:[kMainToken uppercaseString]]) {
            [self.delegateTransferView refreshAssets:tokenModel];
            break;
        }
    }
    
}
#pragma mark lazy load
- (XXDelegateTransferView *)delegateTransferView {
    if (!_delegateTransferView ) {
        _delegateTransferView = [[XXDelegateTransferView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 90)];
        _delegateTransferView.delegateNodeType = self.delegateNodeType;
    }
    return _delegateTransferView;
}
/** 按钮 */
- (XXButton *)transferButton {
    if (!_transferButton) {
        _transferButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 80, kScreen_Width - KSpacing*2, 42) title:@"" font:kFontBold14 titleColor:kMainTextColor block:^(UIButton *button) {
            
        }];
        _transferButton.backgroundColor = kBlue100;
        _transferButton.layer.cornerRadius = 3;
        _transferButton.layer.masksToBounds = YES;
        switch (self.delegateNodeType) {
            case 0:
                 [_transferButton setTitle:LocalizedString(@"Delegate") forState:UIControlStateNormal];
                break;
            case 1:
                 [_transferButton setTitle:LocalizedString(@"TransferDelegate") forState:UIControlStateNormal];
                break;
                
            default:
                 [_transferButton setTitle:LocalizedString(@"RelieveDelegate") forState:UIControlStateNormal];
                break;
        }

    }
    return _transferButton;
}
- (XXAssetModel*)assetModel{
    if (!_assetModel) {
        _assetModel = [[XXAssetModel alloc]init];
    }
    return _assetModel;
}
@end
