//
//  ResourceGroup.h
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceGroup : NSObject


@property (nonatomic,assign)BOOL isExp;
@property (nonatomic,retain)NSMutableArray *dataArray;

@property (nonatomic,retain)NSString *rackId;
@property (nonatomic,retain)NSString *roomName;
@property (nonatomic,retain)NSString *resourceNumber;
@property (nonatomic,retain)NSString *shelfNumber;
@property (nonatomic,retain)NSString *rackNumber;

//纠正rackID
@property (nonatomic,retain)NSString *rack_id;

@end
