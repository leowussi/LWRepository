//
//  OpenModel.m
//  telecom
//
//  Created by Sundear on 16/3/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "OpenModel.h"

#import "AddressModel.h"

@implementation OpenModel
+ (instancetype)OpenModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _gridCode = dict[@"gridCode"];
        _gridName = dict[@"gridName"];
        _addressList = dict[@"addressList"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in _addressList) {
            AddressModel *model = [AddressModel modelWithdic:dict];
            [tempArray addObject:model];
        }
        _addressList = tempArray;
    }
    return self;
}

@end
