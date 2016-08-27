//
//  AddressModel.m
//  telecom
//
//  Created by Sundear on 16/3/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
+(instancetype)modelWithdic:(NSDictionary *)dict;
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dict];
        _lane = dict[@"lane"];
        _gate = dict[@"gate"];
        _road = dict[@"road"];
        _address = dict[@"address"];
    }
    return self;
}
@end
