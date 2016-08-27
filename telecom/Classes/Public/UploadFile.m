//
//  UploadFile.m
//  telecom
//
//  Created by ZhongYun on 15-3-25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "UploadFile.h"
#define OPEN_DEBUG  0

@interface UploadFile()<NSURLConnectionDataDelegate>
{
    NSMutableData* recv_data;
    long long total_size;
}
@end

@implementation UploadFile

- (void)send:(NSDictionary*)arg
{
    self.respBlocker(RESP_WILL_SEND, nil);
    NSString* url_type = [arg objectForKey:URL_TYPE];
    if (!url_type) {
        self.respBlocker(RESP_ERROR, nil);
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
        [recv_data release];
        recv_data =nil;
    }
    self.respBlocker(RESP_ERROR, error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger status_code = ((NSHTTPURLResponse*)response).statusCode;
    if ((status_code / 100) != 2) {
        self.respBlocker(RESP_FAILED, response);
    } else {
        self.respBlocker(RESP_RESP, response);
    }
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
    self.respBlocker(RESP_PROGRESS, @(rate));
#if OPEN_DEBUG
    NSLog(@"%f%%", rate);
#endif
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString*respStr = [[[NSString alloc] initWithData:recv_data encoding:NSUTF8StringEncoding] autorelease];
#if OPEN_DEBUG
    NSLog(@"resp: %@", respStr);
#endif
    
    if (recv_data != nil) {
        [recv_data release];
        recv_data =nil;
    }
    self.respBlocker(RESP_SUCCESS, respStr);
}


@end
