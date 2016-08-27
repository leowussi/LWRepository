//
//  MySendSMS.h
//  telecom
//
//  Created by ZhongYun on 14-8-5.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySendSMS : NSObject
+ (MySendSMS*)shared;
+ (void)sendSMS:(id)params;
@end
