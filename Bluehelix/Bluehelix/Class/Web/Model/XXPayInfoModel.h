//
//  XXPayInfoModel.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXPayInfoModel : NSObject

- (id)initWithData:(id)data;
+ (NSString *)analysisSymbol:(id)data; //判断是否需要网络获取新token

@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, copy) NSMutableArray *valueArr;

@end

NS_ASSUME_NONNULL_END
