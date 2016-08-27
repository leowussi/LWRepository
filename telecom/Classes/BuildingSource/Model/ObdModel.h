//
//  ObdModel.h
//  telecom
//
//  Created by liuyong on 16/3/3.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObdModel : NSObject
@property (nonatomic,copy)NSString *searchResult;
@property (nonatomic,copy)NSString *obdId;
@property (nonatomic,copy)NSString *obdName;
@property (nonatomic,copy)NSString *obdCode;
@property (nonatomic,copy)NSString *obdRegion;
@property (nonatomic,copy)NSString *obdSite;
@property (nonatomic,copy)NSString *obdRoom;
@property (nonatomic,copy)NSString *obdRoomAddress;
@property (nonatomic,copy)NSString *obdType;
@property (nonatomic,copy)NSString *obdManufacturer;
@property (nonatomic,copy)NSString *obdSubType;
@property (nonatomic,copy)NSString *obdGrade;
@property (nonatomic,copy)NSString *obdPortTotal;
@property (nonatomic,copy)NSString *obdPortAvailable;
@property (nonatomic,copy)NSString *obdPortTackup;
@property (nonatomic,copy)NSString *obdPortKeep;
@property (nonatomic,copy)NSString *obdRange;
@property(nonatomic,assign)CGFloat height;
@end
