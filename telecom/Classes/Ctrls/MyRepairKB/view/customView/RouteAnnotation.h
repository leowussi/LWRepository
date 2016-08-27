//
//  RouteAnnotation.h
//  telecom
//
//  Created by liuyong on 15/9/9.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@property(nonatomic,assign)NSInteger tag;
@end
