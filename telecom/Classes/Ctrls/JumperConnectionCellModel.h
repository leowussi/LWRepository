//
//  JumperConnectionCellModel.h
//  telecom
//
//  Created by SD0025A on 16/4/14.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@interface JumperConnectionCellModel : JSONModel
//cell
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *linkNo;
@property (nonatomic,copy) NSString *flag;
@property (nonatomic,copy) NSString *routeInfo;
@property (nonatomic,copy) NSString *startPortSpeed;
@property (nonatomic,copy) NSString *ddf;
@property (nonatomic,copy) NSString *endPortSpeed;
- (CGFloat)configHeight;

@end
