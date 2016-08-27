//
//  AttaFileDetailModel.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
/*"downloadLocation" : "/KBFault/DownloadFile.json?accessToken=F291B92FB411531C32E44EE3A79F7305D8107D853C08629D3F1F46214855BC7A&fileId=422",
 "fileId" : "422",
 "fileName" : "citylist.png",
 "fileSize" : "9760",
 "uploadTime" : "2015-04-07 16:59:49",
 "userName" : "秦怡"
*/

#import <Foundation/Foundation.h>

@interface AttaFileDetailModel : NSObject
@property (nonatomic,copy)NSString *downloadLocation;
@property (nonatomic,copy)NSString *fileId;
@property (nonatomic,copy)NSString *fileName;
@property (nonatomic,copy)NSString *fileSize;
@property (nonatomic,copy)NSString *uploadTime;
@property (nonatomic,copy)NSString *userName;
@end
