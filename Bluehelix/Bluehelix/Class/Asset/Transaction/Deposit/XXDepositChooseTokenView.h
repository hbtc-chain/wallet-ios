//
//  XXDepositChooseTokenView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXDepositChooseTokenView : UIView

@property (nonatomic, copy) void (^changeSymbolBlock) (NSString *);

- (instancetype)initWithFrame:(CGRect)frame symbol:(NSString *)symbol;

@end

NS_ASSUME_NONNULL_END
