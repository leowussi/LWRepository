//
//  ZYFUpLoad.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/31.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYFUpLoad : NSObject <NSURLConnectionDelegate>

+ (NSString *)MIMEType:(NSURL *)url;

+ (void)upload:(NSString *)url filename:(NSString *)filename mimeType:(NSString *)mimeType fileData:(NSData *)fileData params:(NSDictionary *)params success:(void (^)(NSData*))success failure:(void (^)(NSError *))failure;



@end
