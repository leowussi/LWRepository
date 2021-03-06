//
//  SearchAddressViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/10/20.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface SearchAddressViewController : SXABaseViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService *_locationService;
    BMKPoiSearch* _poisearch;
}


@end
