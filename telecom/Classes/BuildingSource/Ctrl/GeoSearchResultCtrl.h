//
//  GeoSearchResultCtrl.h
//  telecom
//
//  Created by liuyong on 16/3/7.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@protocol GeoSearchResultCtrlDelegate <NSObject>

- (void)deliverPoiInfo:(BMKPoiInfo *)info;

@end

@interface GeoSearchResultCtrl : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;

@property(nonatomic,weak)id <GeoSearchResultCtrlDelegate> delegate;
@end
