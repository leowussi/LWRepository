//
//  CRMHelper.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/17.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "CRMHelper.h"
#import "AFNetworking.h"
#import "Reachability.h"

@implementation CRMHelper

+ (NSString*) createFilePathWithFileName:(NSString*)fileName;
{
    // 获取应用的Documents路径
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    return [NSString stringWithFormat:@"%@/%@"
            , documentsDirectory,fileName];
    
}

//当前网络是否可用
+ (BOOL) isEnableNetWork {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

//讲带有汉字的中文字符串转化为合法的url字符串
+ (NSString *)translateRegularUrlWithString:(NSString *)chineseString
{
    return [[chineseString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]copy];
}



@end
