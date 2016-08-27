 //
//  UploadData.m
//  telecom
//
//  Created by ZhongYun on 15-4-9.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "UploadData.h"
#import "JSON.h"

@interface UploadData()<NSURLConnectionDataDelegate>
{
    NSMutableData* recv_data;
    long long total_size;
}
@end

@implementation UploadData

- (void)send:(NSDictionary*)arg
{
    //self.respBlocker(RESP_WILL_SEND, nil);
    NSString* url_type = [arg objectForKey:URL_TYPE];
    if (!url_type) {
        //self.respBlocker(RESP_ERROR, nil);
        return;
    }
    
    NSString* optimestr = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSMutableDictionary* paras = [NSMutableDictionary dictionaryWithDictionary:arg];
    [paras removeObjectForKey:URL_TYPE];
    paras[@"accessToken"] = UGET(U_TOKEN);
    paras[@"operationTime"] = optimestr;
    NSString* jsonParam = id2json(paras);
    NSString* str_url = format(@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, url_type);
    str_url = format(@"%@?accessToken=%@&operationTime=%@", str_url, UGET(U_TOKEN), optimestr);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str_url]];
    [request setTimeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[jsonParam dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:format(@"%d", jsonParam.length) forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (conn) {
        total_size = 0;
        recv_data = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (recv_data != nil) {
        [recv_data release];
        recv_data =nil;
    }
    showAlert(@"发送出错");
    //self.respBlocker(RESP_ERROR, error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger status_code = ((NSHTTPURLResponse*)response).statusCode;
    if ((status_code / 100) != 2) {
        showAlert(@"发送失败");
        //self.respBlocker(RESP_FAILED, response);
    } else {
        //self.respBlocker(RESP_RESP, response);
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
    //CGFloat rate = (totalBytesWritten*100.0 / totalBytesExpectedToWrite);
    //self.respBlocker(RESP_PROGRESS, @(rate));
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString*respStr = [[[NSString alloc] initWithData:recv_data encoding:NSUTF8StringEncoding] autorelease];
    if (recv_data != nil) {
        [recv_data release];
        recv_data =nil;
    }
    //NSLog(@"resp: %@", respStr);
    id rsDict = [respStr JSONValue];
    self.respBlocker(rsDict);
}
@end
