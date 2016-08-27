//
//  CableConnectorInfoModel.h
//  telecom
//
//  Created by liuyong on 15/11/11.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CableConnectorInfoModel : NSObject
@property (nonatomic,assign)NSInteger rackId;
@property (nonatomic,copy)NSString *rackName;
@property (nonatomic,copy)NSString *roomName;
@property (nonatomic,copy)NSString *roomAddress;
@property (nonatomic,assign)NSInteger count;
@end
