//
//  XXValidatorListModel.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XXValidatorDescription;
@class XXValidatorCommission;
@interface XXValidatorListModel : NSObject
@property (nonatomic, copy) NSString *operator_address;
@property (nonatomic, copy) NSString *voting_power;
@property (nonatomic, copy) NSString *all_voting_power;
@property (nonatomic, copy) NSString *voting_power_proportion;
@property (nonatomic, copy) NSString *self_delegate_amount;
@property (nonatomic, copy) NSString *last_voted_time;
@property (nonatomic, assign) BOOL jailed;
@property (nonatomic, copy) NSString *self_delegate_proportion;
@property (nonatomic, copy) NSString *up_time;
@property (nonatomic, strong) XXValidatorCommission *commission;
@property (nonatomic, strong) XXValidatorDescription *validatorDescription;

@end

@interface XXValidatorCommission : NSObject
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *max_rate;
@property (nonatomic, copy) NSString *max_change_rate;

@end

@interface XXValidatorDescription : NSObject
@property (nonatomic, copy) NSString *moniker;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *avator;
@end
NS_ASSUME_NONNULL_END
