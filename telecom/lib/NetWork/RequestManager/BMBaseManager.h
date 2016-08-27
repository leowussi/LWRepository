//
//  BMBaseManager.h
//
//  Created by zhangcc on 12-11-26.
//  Copyright (c) 2012年 BlueMobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

#define HOST_DOMAIN @"http://202.102.72.31:88/"

//#define HOST_DOMAIN @"http://192.168.0.110:805/"

@interface BMBaseManager : NSObject
{   
    dispatch_queue_t requestQueue;
    __block ASIFormDataRequest* request;
}
/**
 *请求方法,进行与服务器的请求动作
 *@param    action   请求服务器的响应链接的最后一个字段
 *@param    params  请求服务器的具体参数:将参数和参数名封装为一个可变字典的格式
 *@param    success  请求成功时的处理block
 *@param    failure   请求失败时的处理block
 */
//-(ASIFormDataRequest*)returnRequest;

- (void)postRequestWithAction:(NSString *)action
                params:(NSDictionary *)params
                   hasSession:(BOOL)hasSession
                      success:(void (^)(id responseDic))success
                      failure:(void(^)(id errorString))failure;

- (void)postRequestWithOther:(NSString *)action
                       params:(NSDictionary *)params
                   hasSession:(BOOL)hasSession
                      success:(void (^)(id responseDic))success
                      failure:(void(^)(id errorString))failure;
- (void)postRequestWithActionLottery:(NSString *)action
                              params:(NSDictionary *)params
                          hasSession:(BOOL)hasSession
                             success:(void (^)(id responseDic))success
                             failure:(void(^)(id errorString))failure;

@end
