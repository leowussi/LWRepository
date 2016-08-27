//
//  UploadFile.h
//  telecom
//
//  Created by ZhongYun on 15-3-25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILE_PATH   @"FILE_PATH"

#define RESP_SUCCESS    1
#define RESP_FAILED     2
#define RESP_TIMEOUT    3
#define RESP_PROGRESS   4
#define RESP_ERROR      5
#define RESP_RESP       6
#define RESP_WILL_SEND  7

@protocol UploadFileDelegate <NSObject>

- (void)deliverResultFileId:(NSData *)receiveData;

@end

@interface UploadFiler : NSObject
@property(nonatomic,assign)id <UploadFileDelegate> delegate;
//@property (nonatomic,copy)void(^respBlocker)(int t, id v);
- (void)send:(NSDictionary*)arg;
@end
