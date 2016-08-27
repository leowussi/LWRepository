//
//  PglModel.m
//  telecom
//
//  Created by liuyong on 16/3/3.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "PglModel.h"

@implementation PglModel
//-(instancetype)initWithDict:(NSDictionary *)dic{
//    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dic];
//    }
//    return self;
//}
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.focFiberAvailable = dic[@"focFiberAvailable"];
         self.focFiberDestroy = dic[@"focFiberDestroy"];
        self.focFiberKeep = dic[@"focFiberKeep"];
        self.focFiberTackup = dic[@"focFiberTackup"];
        self.focFiberTotal = dic[@"focFiberTotal"];
        self.focId = dic[@"focId"];
        self.focName = dic[@"focName"];
        self.focRange = dic[@"focRange"];
        self.focType = dic[@"focType"];
        self.gId  = dic[@"gId"];
    }
    return self;
}
@end
