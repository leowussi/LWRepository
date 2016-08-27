//
//  lqMKAnnotationView.h
//  telecom
//
//  Created by Sundear on 15/12/30.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface lqMKAnnotationView : BMKAnnotationView
@property (nonatomic, strong) NSMutableArray *annotationImages;
@property (nonatomic, strong) UIImageView *annotationImageView;
+ (instancetype)myAnnoViewWithMapView:(BMKMapView *)mapView;
@end

