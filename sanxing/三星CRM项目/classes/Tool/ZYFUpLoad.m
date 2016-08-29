//
//  ZYFUpLoad.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/31.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFUpLoad.h"
#import "MBProgressHUD+MJ.h"
#import "CRMHelper.h"
#import "ZYFUrlTask.h"

#define HMFileBoundary @"heima"
#define HMNewLien @"\r\n"
#define HMEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]


@implementation ZYFUpLoad

+ (NSString *)MIMEType:(NSURL *)url
{
    // 1.创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 2.发送请求（返回响应）
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    // 3.获得MIMEType
    return response.MIMEType;
}

//- (void)upload
//{
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"task";
//    params[@"code"] = @"before";
//    //    params[@"id"] = self.cleanDefectSale.Id;
//    params[@"id"] = @"26D2223A-60E9-4F98-BEED-00007530709D";
//
//    //    // 文件数据
//    UIImage *image = [UIImage imageNamed:@"AppIcon"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//
//    [self upload:@"777.png" mimeType:@"image/png" fileData:imageData params:params];
//}

+ (void)upload:(NSString *)url  filename:(NSString *)filename mimeType:(NSString *)mimeType fileData:(NSData *)fileData params:(NSDictionary *)params success:(void (^)(NSData*))success failure:(void (^)(NSError *))failure

{
    
    // 1.请求路径
    NSURL *urlStr = [NSURL URLWithString:url];
    
    // 2.创建一个POST请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlStr];
    request.HTTPMethod = @"POST";
    
    // 3.设置请求体
    NSMutableData *body = [NSMutableData data];
    
    // 3.1.文件参数
    [body appendData:HMEncode(@"--")];
    [body appendData:HMEncode(HMFileBoundary)];
    [body appendData:HMEncode(HMNewLien)];
    
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"", filename];
    [body appendData:HMEncode(disposition)];
    [body appendData:HMEncode(HMNewLien)];
    
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@", mimeType];
    [body appendData:HMEncode(type)];
    [body appendData:HMEncode(HMNewLien)];
    
    [body appendData:HMEncode(HMNewLien)];
    [body appendData:fileData];
    [body appendData:HMEncode(HMNewLien)];
    
    // 3.2.非文件参数
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [body appendData:HMEncode(@"--")];
        [body appendData:HMEncode(HMFileBoundary)];
        [body appendData:HMEncode(HMNewLien)];
        
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", key];
        [body appendData:HMEncode(disposition)];
        [body appendData:HMEncode(HMNewLien)];
        
        [body appendData:HMEncode(HMNewLien)];
        [body appendData:HMEncode([obj description])];
        [body appendData:HMEncode(HMNewLien)];
    }];
    
    // 3.3.结束标记
    [body appendData:HMEncode(@"--")];
    [body appendData:HMEncode(HMFileBoundary)];
    [body appendData:HMEncode(@"--")];
    [body appendData:HMEncode(HMNewLien)];
    
    request.HTTPBody = body;
    
    // 4.设置请求头(告诉服务器这次传给你的是文件数据，告诉服务器现在发送的是一个文件上传请求)
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", HMFileBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // 5.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if ( data.length > 0 && connectionError == nil) {
            if (success) {
                success(data);
            }
        }else{
            if (failure) {
                failure(connectionError);
            }
        }
    }];
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSString *account = [ZYFUserDefaults objectForKey:ZYFAccountKey];
    NSString *passwd = [ZYFUserDefaults objectForKey:ZYFPwdKey];
    if ([challenge previousFailureCount] == 0) {
        [[challenge sender] useCredential:[NSURLCredential credentialWithUser:[@"auxgroup\\" stringByAppendingString:account] password:passwd persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

@end
