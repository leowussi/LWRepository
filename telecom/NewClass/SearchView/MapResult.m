//
//  MapResult.m
//  telecom
//
//  Created by Sundear on 15/12/29.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "MapResult.h"

@implementation MapResult
+(MapResult *)MapWithDict:(NSDictionary *)dic{
    return [[MapResult alloc]initWithDic:dic];
}
-(MapResult *)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.addressTitle=dic[@"address"];
        self.smx = dic[@"smx"];
        self.smy = dic[@"smy"];
        self.type = dic[@"type"];
    }
    return self;
}
@end
