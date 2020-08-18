//
//  XXTradeSectionHeaderView.m
//  Bhex
//
//  Created by BHEX on 2018/7/17.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXCoinTradeSectionHeaderView.h"
#import "XXOrderManagerVC.h"

@interface XXCoinTradeSectionHeaderView ()

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

@end

@implementation XXCoinTradeSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhite100;
        [self addSubview:self.lineView];
        [self addSubview:self.actionButton];
        [self addSubview:self.lowView];
    }
    return self;
}

#pragma mark - 2. 更多按钮点击事件
- (void)moreButtonClicked:(UIButton *)sender {
//    NSString *cancelAllString = self.coinTradeType == XXCoinTradeTypeNormal ? [NSString stringWithFormat:@"%@ %@", LocalizedString(@"CancelAllOrders"), KTrade.coinTradeModel.symbolName] : [NSString stringWithFormat:@"%@ %@", LocalizedString(@"CancelAllOrders"), KTrade.coinLeverTradeModel.symbolName];
//    MJWeakSelf
//    [XYHPickerView showPickerViewWithNamesArray:@[cancelAllString, LocalizedString(@"ViewAllOrders")] selectIndex:-1 Block:^(NSString *title, NSInteger index) {
//        if (index == 0) {
//            if (self.coinTradeType == XXCoinTradeTypeCoinLever) {
//                [self cancelAllLeverOrders];
//            }else{
//                [weakSelf cancelAllOrders];
//            }
//        } else {
//           [weakSelf viewAllOrders];
//        }
//    }];
}

#pragma mark - 3. 全部撤单
- (void)cancelAllOrders {
//    if (KUser.isLogin) {
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"account_id"] = KUser.defaultAccountId;
//        params[@"symbol_ids"] = KTrade.coinTradeModel.symbolId;
//        [HttpManager order_PostWithPath:@"order/batch_cancel" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//            if (code == 0) {
//                [MBProgressHUD showErrorMessage:LocalizedString(@"AllOrderCommit")];
//            } else {
//                [MBProgressHUD showErrorMessage:msg];
//            }
//        }];
//    } else {
//        [XXPush toLoginViewController:self.viewController];
//    }
}

- (void)viewAllOrders {
//    XXOrderManagerVC *vc = [[XXOrderManagerVC alloc] init];
//    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - || 懒加载
/** 分割线 */
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 8)];
        _lineView.backgroundColor = KBigLine_Color;
    }
    return _lineView;
}

/** 更多按钮 */
- (XXButton *)actionButton {
    if (_actionButton == nil) {
        MJWeakSelf
        _actionButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 70, CGRectGetMaxY(self.lineView.frame), 70, 56) block:^(UIButton *button) {
            [weakSelf moreButtonClicked:button];
        }];
        _actionButton.backgroundColor = kWhite100;
        [_actionButton setImage:[UIImage textImageName:@"moreActions_0"] forState:UIControlStateNormal];
    }
    return _actionButton;
}

/** 分割线 */
- (UIView *)lowView {
    if (_lowView == nil) {
        _lowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, kScreen_Width, 1)];
        _lowView.backgroundColor = KLine_Color;
    }
    return _lowView;
}
@end
