//
//  BMRequestManager.m
//  UnityLH
//
//  Created by apple on 13-5-28.
//  Copyright (c) 2013年 UnityLH. All rights reserved.
//

#import "BMRequestManager.h"

@implementation BMRequestManager

static BMRequestManager *requesteManager;

+ (BMRequestManager*)shareBMRequestManager
{
    @synchronized(self)
    {
        if (requesteManager == nil) {
            requesteManager = [[BMRequestManager alloc] init];
        }
    }
    return requesteManager;
}

-(void)cleanRequest
{
    [request clearDelegatesAndCancel];
}

//首页  /Advertisement/GetBondTransferList
-(void)homPage:(NSDictionary *)dataDic
        success:(void (^)(id responseDic))success
        failure:(void (^)(id errorString))failure
{
    NSString *interfaceName = @"/Advertisement/GetBondTransferList";
    [self postRequestWithAction:interfaceName params:dataDic hasSession:NO success:success failure:failure];
}




@end
