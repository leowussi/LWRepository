//
//  YZPersonnelWhereaboutsViewController.m
//  telecom
//
//  Created by 锋 on 16/6/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZPersonnelWhereaboutsViewController.h"
#import "YZWorkOrderSiftViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface YZPersonnelWhereaboutsViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
}
@end

@implementation YZPersonLocationPointAnnotation

@end

@implementation YZPersonnelWhereaboutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    _mapView.showMapPoi = YES;
    _mapView.showMapScaleBar = YES;
    _mapView.showsUserLocation = YES;
    
    [self.view addSubview:_mapView];
    
    //定位
    _locService = [[BMKLocationService alloc]init];
    
    //启动LocationService
    [_locService startUserLocationService];
    
    [self addNavigationLeftButton];
    [self addBarButtonItem];
    
}
#pragma mark - 用户自定义方法
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBarButtonItem
{
    self.navigationItem.title = @"人员去向";
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 30, 30);
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"nav_filter"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightBarbuttonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBarbuttonItemClicked
{
    YZWorkOrderSiftViewController *siftVC = [[YZWorkOrderSiftViewController alloc] init];
    siftVC.isFromPerson = YES;
    siftVC.siftCompletionBlock = ^{
        [self loadData];
    };
    [self.navigationController pushViewController:siftVC animated:YES];
}


#pragma mark -- 请求人员去向数据
- (void)loadData
{
   [_mapView removeAnnotations:_mapView.annotations];
   NSDictionary *conditionDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"PersonSiftCondition"];
//    NSLog(@"%@",conditionDict);
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"commonBill/QueryUserLocationList";
    NSString *status = [conditionDict objectForKey:@"status"];
    NSLog(@"%@",paraDict);
    if (status == nil) {
        status = @"2";
    }
    paraDict[@"status"] = status;
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        NSArray *listArray = [result objectForKey:@"list"];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *dict in listArray) {
            YZPersonLocationPointAnnotation* annotation = [[YZPersonLocationPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [[dict objectForKey:@"gpsY"] floatValue];
            coor.longitude = [[dict objectForKey:@"gpsX"] floatValue];
            annotation.coordinate = coor;
            annotation.title = [status isEqualToString:@"2"] ? @"已完成" : @"未完成";
            annotation.number = [[dict objectForKey:@"count"] stringValue];
            annotation.status = [status isEqualToString:@"2"] ? @"已完成" : @"未完成";
            [_mapView addAnnotation:annotation];
            [array addObject:annotation];
        }
        [_mapView showAnnotations:array animated:YES];
//        [_mapView zoomOut];
//        NSLog(@"%@",result);
    }, ^(id result) {
        NSLog(@"%@",result);
    });

}

#pragma mark -- 视图显示和消失
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    _locService.delegate = self;
     [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _locService.delegate = nil;
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(YZPersonLocationPointAnnotation *)annotation
{
    if ([annotation isKindOfClass:[YZPersonLocationPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if ([annotation.status isEqualToString:@"已完成"]) {
              newAnnotationView.image = [UIImage imageNamed:@"蓝色标签"];
        }else{
            newAnnotationView.image = [UIImage imageNamed:@"红色标签"];
        }

        if (newAnnotationView.subviews.count == 0) {
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, newAnnotationView.frame.size.width, newAnnotationView.frame.size.height - 4)];
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel.font = [UIFont systemFontOfSize:13];
            countLabel.text = annotation.number;
            countLabel.textColor = [UIColor whiteColor];
            [newAnnotationView addSubview:countLabel];
            
        }else{
            UILabel *countLabel = [newAnnotationView.subviews firstObject];
            countLabel.text = annotation.number;
        }
        
        
        return newAnnotationView;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
