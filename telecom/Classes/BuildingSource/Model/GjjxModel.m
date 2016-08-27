//
//  GjjxModel.m
//  telecom
//
//  Created by liuyong on 16/3/3.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "GjjxModel.h"
#import "PglModel.h"

#import "MJExtension.h"

@implementation GjjxModel
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
- (NSDictionary *)objectClassInArray
{
    return @{@"focList" : [PglModel class]};
}

@end
