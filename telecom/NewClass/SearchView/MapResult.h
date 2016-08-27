//
//  MapResult.h
//  telecom
//
//  Created by Sundear on 15/12/29.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MapResult : NSObject

@property(nonatomic,strong)NSString *addressTitle;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *smx;
@property(nonatomic,strong)NSString *smy;
-(MapResult *)initWithDic:(NSDictionary *)dic;
+(MapResult *)MapWithDict:(NSDictionary *)dic;
@end
