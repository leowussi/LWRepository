//
//  MapViewController.h
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "SXABaseViewController.h"
#import "KYBubbleView.h"
#import "MapResult.h"
#import "HWBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface MapViewController : SXABaseViewController

@property(assign,nonatomic)NSInteger tag;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UITableView *tableView1;

@property(assign,nonatomic)NSInteger VCtag;
@property(strong,nonatomic)NSString *strSmx;
@property(strong,nonatomic)NSString *strSmy;
@property(strong,nonatomic)NSString *addressTitle;
@property(nonatomic,strong)NSDate* date;
@property(nonatomic,strong)NSArray* arr;
@end
