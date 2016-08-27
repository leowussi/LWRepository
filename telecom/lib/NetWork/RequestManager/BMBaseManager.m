//
//  BMBaseManager.m
//  goal101
//
//  Created by zhangcc on 12-11-26.
//  Copyright (c) 2012年 BlueMobi. All rights reserved.
//

#import "BMBaseManager.h"
#import "SBJsonParser.h"
//#import "GDataXMLNode.h"
#import "NSString+SBJSON.h"
#import "DataHander.h"


@interface BMBaseManager ()

@end

@implementation BMBaseManager

- (id)init{
    self=[super init];
    if (self)
    {
        requestQueue = dispatch_queue_create("Httprequest.MyQueue", NULL);
    }
    return self;
}

-(void)dealloc
{
    if (request)
    {
        [request release];
        request = nil;
    }
    
    [super dealloc];
}
- (NSString*)paramValue:(NSDictionary*)dict
{
    NSArray *keyS = [dict allKeys];
    NSString *tempStr = @"?";
    for (int i = 0; i < [keyS count]; i++) {
        NSString *value = [dict objectForKey:[keyS objectAtIndex:i]];
        tempStr = [tempStr stringByAppendingFormat:@"%@=%@", [keyS objectAtIndex:i], value];
        if (i != [keyS count] - 1) {
            tempStr = [tempStr stringByAppendingString:@"&"];
        }
    }
    return tempStr;
}

#pragma mark -正常情况
- (void)postRequestWithAction:(NSString *)action
                      params:(NSDictionary *)params
                  hasSession:(BOOL)hasSession
                     success:(void (^)(id responseDic))success
                     failure:(void(^)(id errorString))failure
{
    [[DataHander sharedDataHander] showDlg];
    dispatch_block_t block = ^(void)
    {
        NSString *urlStr = [HOST_DOMAIN stringByAppendingString:action];
        NSLog(@"%@",urlStr);
        if (hasSession) {
            
        }
        NSURL *url = [NSURL URLWithString:urlStr];
        
        if (request)
        {
            [request release];
            request = nil;
        }
        request=[[ASIFormDataRequest alloc] initWithURL:url];
        [request setUseCookiePersistence:NO];
        [request setTimeOutSeconds:90];
        NSArray *keyS = [params allKeys];
        for (NSString *key in keyS) {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
        
        [request setCompletionBlock:^{
//            NSString *responseStr = [self deleteSpecialString:[request responseString]];
            
            NSString *responseStr = [request responseString];
            NSLog(@"语求的数据 == %@",responseStr);
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"(\"\")" withString:@""];
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            NSDictionary *postResult = [[request responseString] JSONValue];
            NSDictionary *postResult = [responseStr JSONValue];
            
            [[DataHander sharedDataHander] hideDlg];
//            if (postResult && [[postResult objectForKey:@"result"] intValue] == 1) {
//                success(postResult);
//            }
//            else{
//                failure([postResult objectForKey:@"error"]);
//            }
            success(postResult);
            
        }];
        [request setFailedBlock:^{
            [[DataHander sharedDataHander] hideDlg];
            [request clearDelegatesAndCancel];
            NSString *errorMsg = @"Network unavailable";
            failure(errorMsg);
            
        }];
        [request startAsynchronous]; //startAsynchronous
    };
    
    @try {
        dispatch_async(requestQueue, block);
    }
    @catch (NSException *exception) {
        
        NSLog(@"exception %@", exception);
    }
}
#pragma mark -不要提示的情况
- (void)postRequestWithActionLottery:(NSString *)action
                       params:(NSDictionary *)params
                   hasSession:(BOOL)hasSession
                      success:(void (^)(id responseDic))success
                      failure:(void(^)(id errorString))failure
{
//    [[DataHander sharedDataHander] showDlg];
    dispatch_block_t block = ^(void)
    {
        NSString *urlStr = [HOST_DOMAIN stringByAppendingString:action];
        if (hasSession) {
            
        }
        NSURL *url = [NSURL URLWithString:urlStr];
        if (request)
        {
            [request release];
            request = nil;
        }
        request=[[ASIFormDataRequest alloc] initWithURL:url];
        [request setUseCookiePersistence:NO];
        [request setTimeOutSeconds:90];
        NSArray *keyS = [params allKeys];
        for (NSString *key in keyS) {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
        
        [request setCompletionBlock:^{
            //            NSString *responseStr = [self deleteSpecialString:[request responseString]];
            NSString *responseStr = [request responseString];
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"(\"\")" withString:@""];
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            //            NSDictionary *postResult = [[request responseString] JSONValue];
            NSDictionary *postResult = [responseStr JSONValue];
            
//            [[DataHander sharedDataHander] hideDlg];
            //            if (postResult && [[postResult objectForKey:@"result"] intValue] == 1) {
            //                success(postResult);
            //            }
            //            else{
            //                failure([postResult objectForKey:@"error"]);
            //            }
            success(postResult);
            
        }];
        [request setFailedBlock:^{
            [[DataHander sharedDataHander] hideDlg];
            [request clearDelegatesAndCancel];
            NSString *errorMsg = @"Network unavailable";
            failure(errorMsg);
            
        }];
        [request startAsynchronous];
    };
    
    @try {
        dispatch_async(requestQueue, block);
    }
    @catch (NSException *exception) {
        
        NSLog(@"exception %@", exception);
    }
}
#pragma mark 
- (void)writeToFile:(NSString *)string
{
    // 目录列表
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // 根目录
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/test.txt", documentsDirectory];
    NSError *error = nil;
    [string writeToFile:path atomically:NO encoding:NSUnicodeStringEncoding error:&error];
}

//返回删除了特殊字符的字符串
//-(NSString *)deleteSpecialString:(NSString*)tempString
//{
//    
//   /*
//    (NSString *) $1 = 0x072be510 <?xml version="1.0" encoding="utf-8"?>
//    <string xmlns="http://tempuri.org/">{"result":"1","data":[{"User_Id":"32","User_Name":"nanq@bluemobi.cn"}]}</string>
//     服务器返回的数据格式是xml中包JSON,所以这里用到了XML解析
//    */
//    NSLog(@"%@",tempString);
//    NSError *error;
//    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:tempString options:0 error:&error];
//    NSString *jsonStr = [[xmlDoc rootElement] stringValue];
//    [xmlDoc release];
//    jsonStr = [[[[jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@"" ] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"<br>" withString:@""] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
//    
//    return jsonStr;
//}

@end
