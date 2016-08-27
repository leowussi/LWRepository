//
//  LMapViewController.h
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "SXABaseViewController.h"
#import "KYBubbleView.h"
#import "MapResult.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface LMapViewController : SXABaseViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate,KYdelegate>
{
    BMKMapView* _mapView;
    BMKLocationService *_locationService;
    KYBubbleView *bubbleView;
}
//@property (strong, nonatomic) BMKMapView *mapView;
@property(assign,nonatomic)NSInteger tag;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UITableView *tableView1;

@property(assign,nonatomic)NSInteger VCtag;
@property(strong,nonatomic)NSString *strSmx;
@property(strong,nonatomic)NSString *strSmy;
@property(strong,nonatomic)NSString *addressTitle;
@property(nonatomic,strong)NSString *inType;
@property(nonatomic,strong)NSDate* date;
@property(nonatomic,strong)NSMutableArray *smxyArray;//搜索到的数组
@property(nonatomic,strong)NSString *strType1;
@property(nonatomic,strong)NSArray* arr;
@property(nonatomic,strong)NSDictionary *dict;
@end

