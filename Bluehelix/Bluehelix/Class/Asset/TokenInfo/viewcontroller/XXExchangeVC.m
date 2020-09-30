//
//  XXExchangeVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXExchangeVC.h"
#import "XXExchangeView.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXPasswordView.h"
#import "XXTokenModel.h"

@interface XXExchangeVC ()

@property (nonatomic, strong) XXExchangeView *backView;
/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *swapToken;

@end

@implementation XXExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = LocalizedString(@"Exchange");
    self.swapToken = @"btc";
    [self.view addSubview:self.backView];
    [self.backView setToken:self.swapToken];
}

- (void)swapVerify {
    if (!IsEmpty(self.backView.leftField.text)) {
        MJWeakSelf
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            weakSelf.text = text;
            [weakSelf requestSwap];
        }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CompleteInfomation") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}

- (void)requestSwap {
    XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:@"btc"];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.backView.leftField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:kMinFee];
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:@"cbtc" amount:amount denom:self.swapToken feeAmount:feeAmount feeGas:@"" feeDenom:kMainToken memo:@"" type:kMsgMappingSwap withdrawal_fee:@"" text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
    MJWeakSelf
    [MBProgressHUD showActivityMessageInView:@""];
    _msgRequest.msgSendSuccessBlock = ^{
        [MBProgressHUD hideHUD];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _msgRequest.msgSendFaildBlock = ^(NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
    };
    [_msgRequest sendMsg:model];
}

- (XXExchangeView *)backView {
    if (!_backView) {
        MJWeakSelf
        _backView = [[XXExchangeView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight)];
        _backView.sureBlock = ^(BOOL mainTokenFlag) {
            if (mainTokenFlag) {
                weakSelf.swapToken = @"btc";
            } else {
                weakSelf.swapToken = @"cbtc";
            }
            [weakSelf swapVerify];
        };
    }
    return _backView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
