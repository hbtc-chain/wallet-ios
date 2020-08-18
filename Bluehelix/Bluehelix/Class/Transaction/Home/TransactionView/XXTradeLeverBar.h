//
//  XXTradeLeverBar.h
//  Bhex
//
//  Created by xu Lance on 2020/5/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XXRiskRatioButtonAction) (UIButton *action);
typedef void(^XXBorrowOrReturnButtonActionBlock) (UIButton *action);
@interface XXTradeLeverBar : UIView
/**风险率按钮点击事件*/
@property (nonatomic, copy) XXRiskRatioButtonAction riskRatioButtonActionBlock;
/**借币/还币按钮事件*/
@property (nonatomic, copy) XXBorrowOrReturnButtonActionBlock XXBorrowOrReturnButtonActionBlock;


@property (nonatomic, strong) XXLabel *riskRatioLabel;

@property (nonatomic, strong) UIImageView *riskRatioDetailImage;

@end

NS_ASSUME_NONNULL_END
