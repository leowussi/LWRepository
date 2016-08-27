//
//  FaultTrackViewController.h
//  telecom
//
//  Created by liuyong on 15/8/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface FaultTrackViewController : UIViewController
@property (nonatomic,copy)NSString *workNum;
@property (nonatomic,copy)NSString *orderNo;
@property(nonatomic,strong)NSDictionary *workInfo;
@end
