//
//  NetService.h
//  quanzhi
//
//  Created by ZhongYun on 14-1-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"

typedef void (^RespBlock)(id result);
typedef MKNKProgressBlock ProgBock;

BOOL checkNetwork(void);
BOOL isReachableViaWiFi(void);
BOOL isReachableViaWWAN(void);

BOOL httpGET1(NSDictionary* arg, RespBlock succ);
BOOL httpGET2(NSDictionary* arg, RespBlock succ, RespBlock fail);
BOOL httpGET3(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout);
BOOL httpGET1noPara(NSString* url, RespBlock succ);
/**
 *  基于AFN的网络封装get方法
 */
BOOL httpGETAFN(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout);

BOOL httpPOST(NSDictionary* arg, RespBlock succ, RespBlock fail);
BOOL httpPOST4(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout);

BOOL httpPOST1(NSDictionary* arg, RespBlock succ);
BOOL httpPOST2(NSDictionary* arg, RespBlock succ, RespBlock fail);
BOOL httpPOST3(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout);
/**
 *  基于AFN的网络封装post方法
 */
BOOL httpPOSTAFN(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout);


BOOL httpDown1(NSDictionary* arg, ProgBock prog, RespBlock succ);
BOOL httpDown2(NSDictionary* arg, ProgBock prog, RespBlock succ, RespBlock fail);
BOOL httpDown3(NSDictionary* arg, ProgBock prog, RespBlock succ, RespBlock fail, RespBlock timeout);


BOOL httpUp1(NSDictionary* arg, ProgBock prog, RespBlock succ);
BOOL httpUp2(NSDictionary* arg, ProgBock prog, RespBlock succ, RespBlock fail);
BOOL httpUp3(NSDictionary* arg, ProgBock prog, RespBlock succ, RespBlock fail, RespBlock timeout);

