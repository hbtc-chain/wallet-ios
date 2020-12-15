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
#import "XXPasswordAlertView.h"
#import "XXTokenModel.h"

@interface XXExchangeVC ()

@property (nonatomic, strong) XXExchangeView *backView;
/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;

@property (nonatomic, copy) NSString *text;

@end

@implementation XXExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = LocalizedString(@"Exchange");
    [self.view addSubview:self.backView];
    XXMappingModel *model = [[XXSqliteManager sharedSqlite] mappingModelBySymbol:self.swapToken];
    if (model) {
        [self.backView setMappingModel:model];
    } else {
        [self.backView setMappingModel:[XXSqliteManager sharedSqlite].mappingTokens.firstObject];
    }
}

- (void)swapVerify {
    if (!IsEmpty(self.backView.topField.text)) {
        if (kShowPassword) {
            MJWeakSelf
            [XXPasswordAlertView showWithSureBtnBlock:^(NSString * _Nonnull text) {
                weakSelf.text = text;
                [weakSelf requestSwap];
            }];
        } else {
            self.text = kText;
            [self requestSwap];
        }
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CompleteInfomation") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}

- (void)requestSwap {
    XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.backView.mappingModel.target_symbol];
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.backView.topField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:kMinFee];
    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    XXMsg *model = [[XXMsg alloc] initWithfrom:KUser.address to:self.backView.mappingModel.issue_symbol amount:amount denom:self.backView.mappingModel.target_symbol feeAmount:feeAmount feeGas:@"" feeDenom:kMainToken memo:@"" type:kMsgMappingSwap withdrawal_fee:@"" text:self.text];
    _msgRequest = [[XXMsgRequest alloc] init];
    MJWeakSelf
    [MBProgressHUD showActivityMessageInView:@""];
    _msgRequest.msgSendSuccessBlock = ^(id  _Nonnull responseObject) {
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
        _backView.sureBlock = ^{
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
