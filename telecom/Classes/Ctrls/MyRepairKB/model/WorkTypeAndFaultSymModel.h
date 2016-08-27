//
//  WorkTypeAndFaultSymModel.h
//  telecom
//
//  Created by liuyong on 15/8/10.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkTypeAndFaultSymModel : NSObject
@property (nonatomic,copy)NSString *nuId;
@property (nonatomic,copy)NSString *specId;
@property (nonatomic,copy)NSString *specName;
@property (nonatomic,copy)NSString *workTypeId;
@property (nonatomic,copy)NSString *workTypeName;
@end

@interface FaultSymModel : NSObject
@property (nonatomic,copy)NSString *faultSymId;
@property (nonatomic,copy)NSString *faultSymDes;
@property (nonatomic,copy)NSString *workTypeId;
@end
