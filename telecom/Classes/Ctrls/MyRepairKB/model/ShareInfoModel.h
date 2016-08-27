//
//  ShareInfoModel.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
/*
 "detail" : {
 "currentUserId" : "201722",
 "currentUserName" : "w_whhx_zc"
 },
 "list" : [
 {
 "commentId" : "643",
 "content" : "ghhjjb:bbbbbbbb",
 "fileCount" : "0",
 "time" : "2015-04-20 10:48:02",
 "userId" : "秦怡"
 },
 */

#import <Foundation/Foundation.h>

@interface ShareInfoModel : NSObject
@property (nonatomic,copy)NSString *currentUserId;
@property (nonatomic,copy)NSString *currentUserName;

@property (nonatomic,copy)NSString *commentId;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *fileCount;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *userId;
@end
