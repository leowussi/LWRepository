//
//  SharePersonModel.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
/*"list" : [
 {
 "contact" : "",
 "userId" : "201722",
 "userName" : "w_whhx_zc"
 },
 {
 "contact" : "50303223",
 "userId" : "29193",
 "userName" : "高桥001"
 },
*/

#import <Foundation/Foundation.h>

@interface SharePersonModel : NSObject
@property (nonatomic,copy)NSString *contact;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *userName;
@end
