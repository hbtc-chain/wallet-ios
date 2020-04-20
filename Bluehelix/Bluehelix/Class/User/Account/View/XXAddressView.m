//
//  XXAddressView.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAddressView.h"


@interface XXAddressView ()

@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) UIImageView *downImageView;

@end

@implementation XXAddressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhite100;
        [self addSubview:self.addressLabel];
        [self addSubview:self.downImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction {
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
       window.rootViewController = [UIViewController new];
       window.windowLevel = UIWindowLevelAlert + 1;
       
       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择账户" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

       for (NSInteger i=0; i < KUser.accounts.count; i ++) {

           XXAccountModel *model = KUser.accounts[i];
           
           UIAlertAction *action = [UIAlertAction actionWithTitle:model.address style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               KUser.address = model.address;
               self.addressLabel.text = KUser.address;
               if (self.sureBtnBlock) {
                   self.sureBtnBlock();
               }
                window.hidden = YES;
           }];
           [alert addAction:action];
       }
       
       UIAlertAction *action = [UIAlertAction actionWithTitle:LocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            window.hidden = YES;
       }];
//       [action setValue:ActionColor forKey:@"titleTextColor"];
       [alert addAction:action];
       
       // 修改字体大小
       UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
       [appearanceLabel setAppearanceFont:kFont(13)];
    
       [window makeKeyAndVisible];
       [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:KUser.address font:kFont(13)];
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(kScreen_Width/2 - width/2, 0, width, self.height) text:KUser.address font:kFont(13) textColor:kDark100 alignment:NSTextAlignmentCenter];
    }
    return _addressLabel;
}

- (UIImageView *)downImageView {
    if (!_downImageView) {
        _downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame), 0, 24, 16)];
        _downImageView.image = [UIImage imageNamed:@"downArrow"];
    }
    return _downImageView;
}

@end
