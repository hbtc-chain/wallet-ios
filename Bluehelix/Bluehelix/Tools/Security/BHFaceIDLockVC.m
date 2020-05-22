//
//  BHFaceIDLockVC.m
//  Bhex
//
//  Created by Bhex on 2018/11/4.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "BHFaceIDLockVC.h"
#import "AppDelegate.h"
#import "XXTabBarController.h"
#import "YZAuthID.h"
#import "SecurityHelper.h"
#import "AppDelegate+Category.h"
#import "XXLoginVC.h"
#import "XXNavigationController.h"
#import "XXAddressView.h"

@interface BHFaceIDLockVC ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) XXLabel *userNameLabel;
@property (nonatomic, strong) XXAddressView *addressView;
@end

@implementation BHFaceIDLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = LocalizedString(@"Verify");
    [self.view setBackgroundColor:kWhiteColor];
    self.leftButton.hidden = YES;
    self.navView.backgroundColor = kWhiteColor;
    [self setupSameUI];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self faceIDVerify];
       });
}

- (void)faceIDVerify {
    if (!SecurityHelperSupportBiometricAuth) {
        [self closeBiometricAuth];
    } else if (![[SecurityHelper sharedSecurityHelper] biometricDataSame]) {
        [self closeBiometricAuth];
        //        KUser.showOpenBiometricAlert = YES;
    } else {
        MJWeakSelf;
        YZAuthID *authID = [[YZAuthID alloc] init];
        [authID yz_showAuthIDWithDescribe:nil block:^(YZAuthIDState state, NSError *error) {
            if (state == YZAuthIDStateSuccess) {
                [weakSelf faceIDAuthorize];
            } else if (state == YZAuthIDStateNotSupport) {
                [weakSelf pushLoginVC];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else if (state == YZAuthIDStateTouchIDNotSet) {
                [weakSelf pushLoginVC];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else if (state == YZAuthIDStateUserCancel) {
                if (!SecurityHelperSupportBiometricAuth) {
                    [self closeBiometricAuth];
                    //                    KUser.showOpenBiometricAlert = YES;
                } else {
                    
                }
            } else {
                
            }
        }];
    }
}

- (void)faceIDAuthorize {
    KUser.shouldVerify = NO;
    [AppDelegate appDelegate].window.rootViewController = [[XXTabBarController alloc] init];
}

- (void)closeBiometricAuth {
    KUser.isFaceIDLockOpen = NO;
    KUser.isTouchIDLockOpen = NO;
    [self performSelector:@selector(pushLoginVC) withObject:nil afterDelay:0.5];
}

- (void)pushLoginVC {
    XXLoginVC *vc = [XXLoginVC new];
    XXNavigationController *nav = [[XXNavigationController alloc] initWithRootViewController:vc];
    [AppDelegate appDelegate].window.rootViewController = nav;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KSystem statusBarSetUpWhiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KSystem statusBarSetUpDefault];
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    [self.view addSubview:self.icon];
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.addressView];
    
    // 解锁界面
    UIImageView *lockView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - K375(70)/2, kScreen_Height/2 - K375(70)/2, K375(70), K375(70))];
    if (SecurityHelperSupportFaceID) {
        lockView.image = [UIImage imageNamed:@"user_faceID"];
    } else {
        lockView.image = [UIImage imageNamed:@"user_touchID"];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceIDVerify)];
    [lockView addGestureRecognizer:tap];
    lockView.userInteractionEnabled = YES;
    [self.view addSubview:lockView];
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lockView.frame) + 24, kScreen_Width, 36)];
    if (SecurityHelperSupportFaceID) {
        alertLabel.text = LocalizedString(@"ClickToFaceIDUnlock");
    } else {
        alertLabel.text = LocalizedString(@"ClickOnFingerPrintToUnlock");
    }
    alertLabel.textColor = [UIColor colorWithHexString:@"#ACB5C3"];
    alertLabel.font = kFont15;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreen_Height - K375(60), kScreen_Width, 32)];
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [loginBtn setTitle:LocalizedString(@"FingerUnlockBottomText") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kPrimaryMain forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(pushLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - K375(56)/2, 112, K375(56), K375(56))];
        _icon.image = [UIImage imageNamed:@"headImage"];
    }
    return _icon;
}

- (XXLabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.icon.frame) + 8, kScreen_Width - K375(32), 18) text:KUser.currentAccount.userName font:kFont13 textColor:kGray500 alignment:NSTextAlignmentCenter];
    }
    return _userNameLabel;
}

- (XXAddressView *)addressView {
    if (!_addressView) {
        MJWeakSelf
        _addressView = [[XXAddressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userNameLabel.frame)+16, kScreen_Width, 18)];
        _addressView.sureBtnBlock = ^{
            weakSelf.userNameLabel.text = KUser.currentAccount.userName;
        };
    }
    return _addressView;
}
@end
