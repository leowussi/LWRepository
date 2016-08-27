//
//  ImportantPointAnnotation.h
//  telecom
//
//  Created by 郝威斌 on 15/10/26.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface ImportantPointAnnotation : BMKPointAnnotation
{
    NSUInteger _tag;
}

@property(assign,nonatomic) NSUInteger tag;

@end
