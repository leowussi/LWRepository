//
//  PanelModel.h
//  telecom
//
//  Created by liuyong on 15/11/13.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PanelModel : NSObject
@property (nonatomic,assign)NSInteger     connectorStartNo;
@property (nonatomic,assign)NSInteger     fiberEndNo;
@property (nonatomic,assign)NSInteger     fiberStartNo;
@property (nonatomic,assign)NSInteger     connectorEndNo;
@property (nonatomic,copy)  NSString      *panelNo;
@property (nonatomic,copy)  NSString      *cableName;
@property (nonatomic,assign)NSInteger     panelId;
@property (nonatomic,copy)  NSString      *fiberDir;
@property (nonatomic,strong)NSMutableArray *connectors;
@end

@interface ConnectorsModel : NSObject
@property (nonatomic,copy)   NSString   *assocStatus;
@property (nonatomic,copy)   NSString   *abName;
@property (nonatomic,assign) NSInteger  fiberNo;
@property (nonatomic,copy)   NSString   *connInfo;
@property (nonatomic,copy)   NSString   *cableName;
@property (nonatomic,assign) NSString   *panelNo;
@property (nonatomic,copy)   NSString   *portId;
@property (nonatomic,assign) NSString   *connectorNo;
@property (nonatomic,assign) NSInteger  panelId;
@property (nonatomic,copy)   NSString   *jumpConnInfo;
@property (nonatomic,copy)   NSString   *portInfo;
@property (nonatomic,copy)   NSString   *serviceStatus;
@property (nonatomic,copy)   NSString   *rowNo;
@property (nonatomic,copy)   NSString   *colNo;
@property (nonatomic,copy)   NSString   *connectorId;
@end
