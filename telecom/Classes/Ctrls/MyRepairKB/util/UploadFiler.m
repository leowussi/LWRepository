//
//  UploadFile.m
//  telecom
//
//  Created by ZhongYun on 15-3-25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "UploadFiler.h"
#define OPEN_DEBUG  1

@interface UploadFiler()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
//    NSURLConnection *_conn;
    NSMutableData* recv_data;
    long long total_size;
}
@end

@implementation UploadFiler

- (void)send:(NSDictionary*)arg
{

    NSString* url_type = [arg objectForKey:URL_TYPE];
    if (!url_type) {
        return;
    }
    
    NSMutableDictionary* paras = [NSMutableDictionary dictionaryWithDictionary:arg];
    paras[@"accessToken"] = UGET(U_TOKEN);
    paras[@"operationTime"] = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");

    NSString* str_param = [self getUrlParams:paras];
    NSString* str_url = format(@"http://%@/%@/%@.json?%@", ADDR_IP, ADDR_DIR, url_type, str_param);
    
    int file_size = [[[[NSFileManager defaultManager] attributesOfItemAtPath:
                       paras[FILE_PATH] error:NULL] objectForKey:NSFileSize] intValue];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str_url]];
    [request setTimeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBodyStream:[NSInputStream inputStreamWithFileAtPath:paras[FILE_PATH]]];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setValue:format(@"%d", file_size) forHTTPHeaderField:@"Content-Length"];
    
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (conn) {
        total_size = 0;
        recv_data = [[NSMutableData alloc] init];
        
    }
}

- (NSString*)getUrlParams:(NSDictionary*)param
{
    NSMutableArray* list = [NSMutableArray array];
    for (NSString* key in [param allKeys]) {
        if (!([key isEqualToString:FILE_PATH] || [key isEqualToString:URL_TYPE])) {
            [list addObject:format(@"%@=%@", key, param[key])];
        }
    }
    return [list componentsJoinedByString:@"&"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (recv_data != nil) {
        recv_data =nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger status_code = ((NSHTTPURLResponse*)response).statusCode;
    if ((status_code / 100) != 2) {
//        self.respBlocker(RESP_FAILED, response);
    } else {
//        self.respBlocker(RESP_RESP, response);
    }
    [recv_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [recv_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    CGFloat rate = (totalBytesWritten*100.0 / totalBytesExpectedToWrite);
//    self.respBlocker(RESP_PROGRESS, @(rate));
#if OPEN_DEBUG
    NSLog(@"%f%%", rate);
#endif
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.delegate) {
        [self.delegate deliverResultFileId:recv_data];
    }
}


@end
