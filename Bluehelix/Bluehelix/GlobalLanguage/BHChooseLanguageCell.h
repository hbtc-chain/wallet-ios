//
//  BHChooseLanguageCell.h
//  Bhex
//
//  Created by Bhex on 2018/8/15.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHChooseLanguageModel.h"

@interface BHChooseLanguageCell : UITableViewCell

@property (nonatomic, strong) BHChooseLanguageModel *langeuageModel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIView *lineView;

@end
