//
//  GfqxModel.m
//  telecom
//
//  Created by liuyong on 16/3/3.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "GfqxModel.h"
#import "PglModel.h"
@implementation GfqxModel

+ (instancetype)ModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
         NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in _focList) {
            PglModel *model = [[PglModel alloc] initWithDic:dict];
            [tempArray addObject:model];
        }
        _focList = tempArray;

    }
    return self;
}


@end
