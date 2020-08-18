//
//  XXCurrentOrderView.h
//  Bhex
//
//  Created by BHEX on 2018/7/22.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXCurrentOrderView : UIView

/** 1. 撤销全部订单 */
- (void)allCancelButtonAction;

/** 2. 筛选 */
- (void)screenWithBaseToken:(NSString *)baseToken quoteToken:(NSString *)quoteToken side:(NSString *)side;
/** 初始化接口*/
//- (instancetype)initWithFrame:(CGRect)frame withType:(XXCoinTradeType)coinTradeType;
@end
