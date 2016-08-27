//
//  SelledPinelineInfoModel.m
//  telecom
//
//  Created by SD0025A on 16/5/20.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SelledPinelineInfoModel.h"

@implementation SelledPinelineInfoModel
+(JSONKeyMapper*)keyMapper
{
    //将字典中的key(description)转换为desc
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description":@"desc"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
