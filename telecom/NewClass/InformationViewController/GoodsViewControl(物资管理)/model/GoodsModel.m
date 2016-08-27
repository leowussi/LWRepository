//
//  GoodsModel.m
//  telecom
//
//  Created by Sundear on 16/4/6.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
-(instancetype)initWithDic:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
