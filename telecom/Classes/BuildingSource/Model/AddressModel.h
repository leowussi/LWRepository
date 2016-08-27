//
//  AddressModel.h
//  telecom
//
//  Created by Sundear on 16/3/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
/**
"address": "地址点（XX路XX号）",
"road": "路",
"lane": "弄",
"number": "号"
}]
 <#Description#> *
 */

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *road;
@property(nonatomic,copy)NSString *lane;
@property(nonatomic,copy)NSString *gate;
+(instancetype)modelWithdic:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
