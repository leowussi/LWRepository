//
//  CycleTaskTrackController.m
//  telecom
//
//  Created by liuyong on 15/9/9.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "CycleTaskTrackController.h"
#import "CycleTaskTrackModel.h"

#import "UIImage+Rotate.h"
#import "RouteAnnotation.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface CycleTaskTrackController ()<BMKMapViewDelegate, BMKRouteSearchDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* _mapView;
    BMKRouteSearch* _routesearch;
    BMKLocationService *_locService;
    
    int _index;
    NSString *_taskName;
    NSString *_dealUserName;
    NSString *_startTime;
    NSString *_endTime;
    
    NSMutableArray *_wayPointsArray;
    NSMutableArray *_annotationArray;
    
    UIView *_popView;
}
@end

@implementation CycleTaskTrackController

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _routesearch.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务轨迹";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _index = 0;
    _wayPointsArray = [NSMutableArray array];
    _annotationArray = [NSMutableArray array];
    
    [self addNavigationLeftButton];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    _routesearch = [[BMKRouteSearch alloc] init];
    
    [self setUpMapView];
    
    [self loadFaultTrackData];
}

- (void)loadFaultTrackData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kGetFaultTrajectory;
    paraDict[@"taskId"] = self.taskDict[@"taskId"];
    
    httpPOST(paraDict, ^(id result) {
        
        NSLog(@"%@",result);
        
        _taskName = result[@"detail"][@"taskName"];
        _dealUserName = result[@"detail"][@"dealUserName"];
        _startTime = result[@"detail"][@"startTime"];
        _endTime = result[@"detail"][@"endTime"];
        
        for (NSDictionary *gpsDict in result[@"detail"][@"transList"]) {
            CycleTaskTrackModel *cycleTaskModel = [[CycleTaskTrackModel alloc] init];
            [cycleTaskModel setValuesForKeysWithDictionary:gpsDict];
            [_wayPointsArray addObject:cycleTaskModel];
        }

        //去除没有坐标的点
        for (int i=0; i<_wayPointsArray.count; i++) {
            CycleTaskTrackModel *model = _wayPointsArray[i];
            if ([model.gpsX isEqualToString:@""] || [model.gpsY isEqualToString:@""]) {
                [_wayPointsArray removeObjectAtIndex:i];
            }
        }
        
        [self dropAnnotationOnMapView];
        
        [self startDrivingRouteSearchWithIndex:_index];
        
    }, ^(id result) {
        showAlert(@"寻寻觅觅，找不到任务轨迹!");
        [self startLocationAction];
    });
}

- (void)setUpMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-44)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 14.0f;
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.showMapScaleBar = YES;
    [self.view addSubview:_mapView];
    
    UIImage *locationImage = [UIImage imageNamed:@"定位.png"];
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    locationBtn.frame = RECT(5, APP_H-75, locationImage.size.width/2, locationImage.size.height/2);
    [locationBtn setImage:[locationImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    [locationBtn setImage:[locationImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateHighlighted];
    [locationBtn addTarget:self action:@selector(startLocationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
}

- (void)willStartLocatingUser
{
    CLLocationCoordinate2D coor;
    coor.latitude = 31.238907;
    coor.longitude = 121.479140;
    [_mapView setCenterCoordinate:coor animated:YES];
}

- (void)startLocationAction
{
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)dropAnnotationOnMapView
{
    [_mapView removeAnnotations:_annotationArray];
    [_annotationArray removeAllObjects];
    
    CLLocationCoordinate2D coor;
    
    if (_wayPointsArray.count > 0) {
        for (int i=0; i<_wayPointsArray.count; i++) {
            CycleTaskTrackModel *model = _wayPointsArray[i];
            if (model.gpsX != nil && ![model.gpsX isEqualToString:@""] && model.gpsY != nil && ![model.gpsY isEqualToString:@""]) {
                RouteAnnotation *routeAnno = [[RouteAnnotation alloc] init];
                routeAnno.tag = i;
                coor.latitude = [model.gpsY doubleValue];
                coor.longitude = [model.gpsX doubleValue];
                routeAnno.coordinate = coor;
                routeAnno.title = @"";
                [_mapView addAnnotation:routeAnno];
                [_annotationArray addObject:routeAnno];
            }
        }
    }
    
    if (_annotationArray.count != 0) {
        [_mapView showAnnotations:_annotationArray animated:YES];
    }else{
        showAlert(@"寻寻觅觅，找不到任务轨迹!");
        [self startLocationAction];
    }
}

- (void)startDrivingRouteSearchWithIndex:(int)index
{
    if (_wayPointsArray.count >= 2) {
        CycleTaskTrackModel *startModel = _wayPointsArray[index];
        CycleTaskTrackModel *endModel = _wayPointsArray[index+1];
        
        BMKPlanNode *start = [[BMKPlanNode alloc] init];
        start.pt = CLLocationCoordinate2DMake([startModel.gpsY doubleValue], [startModel.gpsX doubleValue]);
        BMKPlanNode *end = [[BMKPlanNode alloc] init];
        end.pt = CLLocationCoordinate2DMake([endModel.gpsY doubleValue], [endModel.gpsX doubleValue]);
        
        BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        drivingRouteSearchOption.from = start;
        drivingRouteSearchOption.to = end;
        BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
        
        if(flag){
            NSLog(@"search success.");
        }else{
            showAlert(@"寻寻觅觅，找不到任务轨迹!");
            [self startLocationAction];//没有找到轨迹信息就调用定位，定位到自己所在的位置
        }
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[view viewForAnnotation:annotation];
    
    if (annotationView == nil)
    {
        RouteAnnotation *ann;
        if ([annotation isKindOfClass:[RouteAnnotation class]]) {
            ann = annotation;
        }
        
        NSUInteger tag = ann.tag;
        NSString *AnnotationViewID = [NSString stringWithFormat:@"AnnotationView-%i", tag];
        
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:AnnotationViewID];
        
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-20, -30);
        int randNum = arc4random() % 4;
        NSArray *imagePng = @[@"A",@"B",@"C",@"D"];
        annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imagePng[randNum]]];
        annotationView.annotation = annotation;
    }
    return annotationView ;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
        if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
            
            NSInteger index = [(RouteAnnotation*)view.annotation tag];
            if (index == 0) {//开始点
                UIView *popView = [[UIView alloc] initWithFrame:RECT(0, 0, 150, 130)];
                popView.backgroundColor = RGBCOLOR(219, 219, 219);
                popView.layer.borderWidth = 0.5;
                popView.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
                popView.layer.cornerRadius = 5;
                
                UILabel *workerTitleLabel = [MyUtil createLabel:RECT(2, 2, 50, 50) text:@"任务名:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                [popView addSubview:workerTitleLabel];
                
                UILabel *workerLabel = [MyUtil createLabel:RECT(workerTitleLabel.ex+3, workerTitleLabel.fy, popView.fw-5-workerTitleLabel.fw, workerTitleLabel.fh) text:_taskName alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                workerLabel.numberOfLines = 2;
                [popView addSubview:workerLabel];
                
                UILabel *operationTitleLabel = [MyUtil createLabel:RECT(2, workerTitleLabel.ey, 75, 25) text:@"任务执行人:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                [popView addSubview:operationTitleLabel];
        
                UILabel *operationLabel = [MyUtil createLabel:RECT(operationTitleLabel.ex+3, operationTitleLabel.fy, popView.fw-5-operationTitleLabel.fw, operationTitleLabel.fh) text:_dealUserName alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                [popView addSubview:operationLabel];
                
                UILabel *operationTimeTitleLabel = [MyUtil createLabel:RECT(2, operationTitleLabel.ey, 65, 50) text:@"开始时间:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                [popView addSubview:operationTimeTitleLabel];
        
                UILabel *operationTimeLabel = [MyUtil createLabel:RECT(operationTimeTitleLabel.ex+3, operationTimeTitleLabel.fy, popView.fw-5-operationTimeTitleLabel.fw, operationTimeTitleLabel.fh) text:_startTime alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                operationTimeLabel.numberOfLines = 2;
                [popView addSubview:operationTimeLabel];
                
                [view.paopaoView addSubview:popView];
                [_popView removeFromSuperview];
        
                _popView = popView;
            }
            
            if (index == _wayPointsArray.count-1) {//结束点
                UIView *popView = [[UIView alloc] initWithFrame:RECT(0, 0, 150, 130)];
                popView.backgroundColor = RGBCOLOR(219, 219, 219);
                popView.layer.borderWidth = 0.5;
                popView.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
                popView.layer.cornerRadius = 5;
                
                UILabel *workerTitleLabel = [MyUtil createLabel:RECT(2, 2, 50, 50) text:@"任务名:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                workerTitleLabel.numberOfLines = 2;
                [popView addSubview:workerTitleLabel];
                
                UILabel *workerLabel = [MyUtil createLabel:RECT(workerTitleLabel.ex+3, workerTitleLabel.fy, popView.fw-5-workerTitleLabel.fw, workerTitleLabel.fh) text:_taskName alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                workerLabel.numberOfLines = 2;
                [popView addSubview:workerLabel];
                
                UILabel *operationTitleLabel = [MyUtil createLabel:RECT(2, workerLabel.ey, 75, 25) text:@"任务执行人:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                [popView addSubview:operationTitleLabel];
                
                UILabel *operationLabel = [MyUtil createLabel:RECT(operationTitleLabel.ex+3, operationTitleLabel.fy, popView.fw-5-operationTitleLabel.fw, operationTitleLabel.fh) text:_dealUserName alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                [popView addSubview:operationLabel];
                
                UILabel *operationTimeTitleLabel = [MyUtil createLabel:RECT(2, operationTitleLabel.ey, 65, 25*2) text:@"结束时间:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                operationTimeTitleLabel.numberOfLines = 2;
                [popView addSubview:operationTimeTitleLabel];
                
                UILabel *operationTimeLabel = [MyUtil createLabel:RECT(operationTimeTitleLabel.ex+3, operationTimeTitleLabel.fy, popView.fw-5-operationTimeTitleLabel.fw, operationTimeTitleLabel.fh) text:_endTime alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
                operationTimeLabel.numberOfLines = 2;
                [popView addSubview:operationTimeLabel];
                
                [view.paopaoView addSubview:popView];
                [_popView removeFromSuperview];
                
                _popView = popView;
            }
        }
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            //            if(i==0){
            //                RouteAnnotation* item = [[RouteAnnotation alloc]init];
            //                item.coordinate = plan.starting.location;
            //                item.title = @"起点";
            //                item.type = 0;
            //                [_mapView addAnnotation:item]; // 添加起点标注
            //
            //            }else if(i==size-1){
            //                RouteAnnotation* item = [[RouteAnnotation alloc]init];
            //                item.coordinate = plan.terminal.location;
            //                item.title = @"终点";
            //                item.type = 1;
            //                [_mapView addAnnotation:item]; // 添加起点标注
            //            }
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint  temppoints[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        
        _index++;
        if (_index < _wayPointsArray.count - 1) {
            [self startDrivingRouteSearchWithIndex:_index];
        }
        
        [_locService stopUserLocationService];
        
        [self mapViewFitPolyLine:polyLine];
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    CLLocationCoordinate2D coor;
    coor.latitude = 31.238907;
    coor.longitude = 121.479140;
    [_mapView setCenterCoordinate:coor animated:YES];
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton setImage:[navImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;     // 不用时，置nil
    _routesearch.delegate = nil; // 不用时，置nil
    _locService.delegate = self;
}

- (void)dealloc {
    if (_routesearch != nil) {
        _routesearch = nil;
    }
    if (_mapView != nil) {
        _mapView = nil;
    }
    if (_locService != nil) {
        _locService = nil;
    }
}

@end
