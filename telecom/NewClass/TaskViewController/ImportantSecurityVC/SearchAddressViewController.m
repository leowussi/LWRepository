//
//  SearchAddressViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/10/20.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "SearchAddressViewController.h"
#import "DataHander.h"
#import "MapBackView.h"
#import <CoreLocation/CoreLocation.h>
#import "SearchAddressTableViewCell.h"

@interface SearchAddressViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,BMKGeneralDelegate>
{
    DataHander *hander;
    MapBackView *mapBackView;
    BMKMapManager *mgr;
    BMKPointAnnotation* pointAnnotation;
    int curPage;//搜索地址用到的
    CLLocationManager *locationManager;
    NSString *strLevel;//比例尺
    NSString *leftUpSmx;
    NSString *leftUpSmy;
    NSString *rightDownSmx;
    NSString *rightDownSmy;
    
    UITableView *searchTableView;
    NSMutableArray *searchArr;
    NSMutableArray *coorArr;
}
@end

@implementation SearchAddressViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _poisearch.delegate = self;
}

#pragma mark 地图将要消失
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil;
    _poisearch.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationLeftButton];
    [self addSearchBar];
    
    [self initView];
    
    hander = [[DataHander alloc]init];
   
    searchArr = [[NSMutableArray alloc]initWithCapacity:10];
    coorArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(80, 64, kScreenWidth-110, 200) style:UITableViewStylePlain];
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    searchTableView.showsVerticalScrollIndicator = NO;
    searchTableView.hidden = YES;
    [self.view addSubview:searchTableView];
}

-(void)initView
{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 19.0;
    [_baseScrollView addSubview:_mapView];
    _mapView.showMapScaleBar = YES;
    
    //自定义比例尺的位置
    _mapView.mapScaleBarPosition = CGPointMake(10, _mapView.frame.size.height - 45);
    
    int zoom = (int)_mapView.zoomLevel;
    NSLog(@"zoom == >%d",zoom);
    
    NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",
                         @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",
                         @"2000000"];
    
    strLevel = [zoomArr objectAtIndex:(19-zoom)];
    NSLog(@"初始strLevel == %@",strLevel);
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    BMKLocationViewDisplayParam *loaction = [[BMKLocationViewDisplayParam alloc]init];
    loaction.isRotateAngleValid = true;//跟随态旋转角度是否生效
    loaction.isAccuracyCircleShow = false;//精度圈是否显示
    
    [_mapView updateLocationViewWithParam:loaction];
    
    _baseScrollView.scrollEnabled = NO;
    _locationService = [[BMKLocationService alloc]init];
    
    _locationService.delegate = self;
    //启动LocationService
    [_locationService startUserLocationService];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    UIImage *dingweiImg = [UIImage imageNamed:@"定位.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, kScreenHeight-125, dingweiImg.size.width/2, dingweiImg.size.height/2);
    [button setBackgroundImage:dingweiImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dobutton:) forControlEvents:UIControlEventTouchUpInside];//dobutton:
    [self.view addSubview:button];
    
    
    UIImage *zoomImg = [UIImage imageNamed:@"zoom_box.png"];
    UIImage *zoomImg1 = [UIImage imageNamed:@"zoom+.png"];
    UIImage *zoomImg2 = [UIImage imageNamed:@"zoom-.png"];
    UIImageView *zoomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-35, kScreenHeight-110, zoomImg.size.width/2-2, zoomImg.size.height/2)];
    zoomImgView.image = zoomImg;
    zoomImgView.userInteractionEnabled = YES;
    [self.view addSubview:zoomImgView];
    
    UIImageView *zoomAddView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, zoomImg1.size.width/2+2, zoomImg1.size.height/2+2)];
    zoomAddView.image = zoomImg1;
    zoomAddView.userInteractionEnabled = YES;
    [zoomImgView addSubview:zoomAddView];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, zoomImg1.size.width/2+2, zoomImg1.size.height/2+2)];
    [addBtn addTarget:self action:@selector(addZoom) forControlEvents:UIControlEventTouchUpInside];
    [zoomAddView addSubview:addBtn];
    
    UIImageView *zoomRedView = [[UIImageView alloc]initWithFrame:CGRectMake(0, zoomImg.size.height/2-zoomImg2.size.height/2-2, zoomImg2.size.width/2+2, zoomImg2.size.height/2+2)];
    zoomRedView.image = zoomImg2;
    zoomRedView.userInteractionEnabled = YES;
    [zoomImgView addSubview:zoomRedView];
    
    UIButton *redBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, zoomImg2.size.width/2+2, zoomImg2.size.height/2+2)];
    [redBtn addTarget:self action:@selector(redZoom) forControlEvents:UIControlEventTouchUpInside];
    [zoomRedView addSubview:redBtn];
    
    _poisearch = [[BMKPoiSearch alloc]init];
    // 设置地图级别
    [_mapView setZoomLevel:19];
    _mapView.isSelectedAnnotationViewFront = YES;
    
}


-(void)addSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    [titleView addSubview:searchImgView];
    
    UITextField *searchFiled = [[UITextField alloc]initWithFrame:CGRectMake(50, 0,kScreenWidth-170, searchImg.size.height/3+5)];
    searchFiled.backgroundColor = [UIColor clearColor];
    searchFiled.placeholder = @"输入搜索地址";
    searchFiled.textColor = [UIColor whiteColor];
    searchFiled.font = [UIFont systemFontOfSize:15.0];
    searchFiled.userInteractionEnabled = YES;
    searchFiled.returnKeyType = UIReturnKeySearch;
    searchFiled.delegate = self;
    [searchImgView addSubview:searchFiled];
    
    UIImage *seaBtnImg = [UIImage imageNamed:@"search_btn.png"];
    UIImageView *searchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, seaBtnImg.size.width/2.5, seaBtnImg.size.height/2.5)];
    searchBtn.image = seaBtnImg;
    searchBtn.userInteractionEnabled = YES;
    [searchImgView addSubview:searchBtn];
    
    
    self.navigationItem.titleView = titleView;
}

#pragma mark == 放大地图
-(void)addZoom
{
    
    NSLog(@"+++++上一次%f",_mapView.zoomLevel);
    
    
    if (_mapView.zoomLevel >= 19.0) {
        _mapView.zoomLevel = 19.0;
        int zoom = _mapView.zoomLevel;
        
        NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",
                             @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",
                             @"2000000"];
        
        strLevel = [zoomArr objectAtIndex:(19-zoom)];
        
    }else{
        
        _mapView.zoomLevel = _mapView.zoomLevel++;
        
    }
    
    
    
    
}

#pragma mark == 缩小地图
-(void)redZoom
{
    
    if (_mapView.zoomLevel <= 3.0) {
        _mapView.zoomLevel = 3.0;
        int zoom = _mapView.zoomLevel;
        //    NSLog(@"zoom == >%d",zoom);
        
        NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",
                             @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",
                             @"2000000"];
        
        strLevel = [zoomArr objectAtIndex:(19-zoom)];
        //        NSLog(@"strLevel == %@",strLevel);
    }else{
        
        _mapView.zoomLevel = --_mapView.zoomLevel;
        //        NSLog(@"----本次%f",_mapView.zoomLevel);
        
    }
    
    
}


#pragma mark == 定位
-(void)dobutton:(id)sender
{
    _locationService = [[BMKLocationService alloc]init];
    
    _locationService.delegate = self;
    
    [_locationService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
}


#pragma mark 在开时定位时调用
- (void)willStartLocatingUser
{
    CLLocationCoordinate2D coor;
    coor.latitude = 31.238907;
    coor.longitude = 121.479140;
    [_mapView setCenterCoordinate:coor animated:YES];
}
#pragma mark 在停止定位后，会调用此函数
- (void)didStopLocatingUser
{
    NSLog(@"定位结束");
    CGPoint pt;
    pt = CGPointMake(10,10);
    //将指南针显示的具体位置赋值于BMKMapView的compassPosition属性
    _mapView.compassPosition = pt;
    
    CGPoint point = CGPointMake(0, 0);
    
    CGPoint point1 = CGPointMake(kScreenWidth, kScreenHeight-64);
    
    CLLocationCoordinate2D coornation = [_mapView convertPoint:point toCoordinateFromView:_mapView];//获取经纬度
    
    leftUpSmx = [NSString stringWithFormat:@"%f",coornation.longitude];
    leftUpSmy = [NSString stringWithFormat:@"%f",coornation.latitude];
    NSLog(@"左上角1 == >%f",coornation.latitude);
    NSLog(@"左下角1 == >%f",coornation.longitude);
    
    CLLocationCoordinate2D coornation1 = [_mapView convertPoint:point1 toCoordinateFromView:_mapView];//获取经纬度
    rightDownSmx = [NSString stringWithFormat:@"%f",coornation1.longitude];
    rightDownSmy = [NSString stringWithFormat:@"%f",coornation1.latitude];
    NSLog(@"右上角1 == >%f",coornation1.latitude);
    NSLog(@"右下角1 == >%f",coornation1.longitude);
    
    
    
    
}

#pragma mark 在地图View将要启动定位时，会调用此函数
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}
#pragma mark 用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    [_mapView updateLocationData:userLocation];
    
    //    物理地址
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
    search.delegate=self;
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = userLocation.location.coordinate;
    NSLog(@"%d",[search reverseGeoCode:rever]);
    [_locationService stopUserLocationService];
}
#pragma mark 用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //    [_mapView updateLocationData:userLocation];
    
}

-(void)updateLocationData:(BMKUserLocation*)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.2;
    region.span.longitudeDelta = 0.2;
    if (_mapView)
    {
        _mapView.region = region;
        NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
}
#pragma mark 在地图View停止定位后，会调用此函数
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}
#pragma mark 定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 31.238907;
    coor.longitude = 121.479140;
    annotation.coordinate = coor;
    [_mapView setCenterCoordinate:coor animated:YES];
}
#pragma mark 获取到物理地址信息
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"result.address == %@",result.address);
    
    
    CGPoint point = CGPointMake(0, 0);
    
    CGPoint point1 = CGPointMake(kScreenWidth, kScreenHeight-64);
    
    CLLocationCoordinate2D coornation = [_mapView convertPoint:point toCoordinateFromView:_mapView];//获取经纬度
    leftUpSmx = [NSString stringWithFormat:@"%f",coornation.longitude];
    leftUpSmy = [NSString stringWithFormat:@"%f",coornation.latitude];
    NSLog(@"左上角 == >%f",coornation.latitude);
    NSLog(@"左下角 == >%f",coornation.longitude);
    
    CLLocationCoordinate2D coornation1 = [_mapView convertPoint:point1 toCoordinateFromView:_mapView];//获取经纬度
    rightDownSmx = [NSString stringWithFormat:@"%f",coornation1.longitude];
    rightDownSmy = [NSString stringWithFormat:@"%f",coornation1.latitude];
    NSLog(@"右下角 == >%f",coornation1.latitude);
    NSLog(@"右下角 == >%f",coornation1.longitude);
    
}


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"当前位置%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

//当mapView新添加annotationviews时，调用此接口
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //    NSLog(@"mapView新添加annotation views");
}
//当点击annotationview弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"点击annotation view弹出的泡泡");
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    curPage = 0;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = curPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"上海";
    citySearchOption.keyword = textField.text;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
        
        [hander showDlg];
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }

    return YES;
}

#pragma mark 地图改变完成
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"改变完成");
    NSLog(@"改变完成 == %f",_mapView.zoomLevel);
    if (_mapView.zoomLevel >=19.0) {
        strLevel = @"20";
    }else if (_mapView.zoomLevel <= 3.0){
        strLevel = @"2000000";
    }else{
        int zoom = _mapView.zoomLevel;
        NSLog(@"zoom == >%d",zoom);
        
        NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",
                             @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",
                             @"2000000"];
        
        strLevel = [zoomArr objectAtIndex:(19-zoom)];
        NSLog(@"strLevel == %@",strLevel);
        
    }
    
    //底图的俯角设为－30目的是让指南针显示出来
    _mapView.overlooking = -30;
    
    CGPoint pt;
    pt = CGPointMake(10,10);
    //将指南针显示的具体位置赋值于BMKMapView的compassPosition属性
    _mapView.compassPosition = pt;
    
    CGPoint point = CGPointMake(0, 0);
    
    CGPoint point1 = CGPointMake(kScreenWidth, kScreenHeight-64);
    
    CLLocationCoordinate2D coornation = [_mapView convertPoint:point toCoordinateFromView:_mapView];//获取经纬度
    
    leftUpSmx = [NSString stringWithFormat:@"%f",coornation.longitude];
    leftUpSmy = [NSString stringWithFormat:@"%f",coornation.latitude];
    NSLog(@"左上角1 == >%f",coornation.latitude);
    NSLog(@"左下角1 == >%f",coornation.longitude);
    
    CLLocationCoordinate2D coornation1 = [_mapView convertPoint:point1 toCoordinateFromView:_mapView];//获取经纬度
    rightDownSmx = [NSString stringWithFormat:@"%f",coornation1.longitude];
    rightDownSmy = [NSString stringWithFormat:@"%f",coornation1.latitude];
    NSLog(@"右上角1 == >%f",coornation1.latitude);
    NSLog(@"右下角1 == >%f",coornation1.longitude);
    
    
    
}


- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    [searchArr removeAllObjects];
    
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSMutableArray *annotations = [NSMutableArray array];
        
        for (int i = 0; i < result.poiInfoList.count; i++) {
            
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
            [searchArr addObject:poi.name];
            NSString *strLat = [NSString stringWithFormat:@"%f",poi.pt.latitude];
            NSString *strLong = [NSString stringWithFormat:@"%f",poi.pt.longitude];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:10];
            [tempDict setValue:strLat forKey:@"lat"];
            [tempDict setValue:strLong forKey:@"lon"];
            [coorArr addObject:tempDict];
            
        }
        searchTableView.hidden = NO;
        [searchTableView reloadData];
        [hander hideDlg];
        [_mapView addAnnotations:annotations];
//        [_mapView showAnnotations:annotations animated:YES];
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}


#pragma mark == UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *searchCell = @"searchCell";
    SearchAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
    if (!cell) {
        cell = [[SearchAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell];
    }
    
    cell.titleLable.text = [searchArr objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"coorArr == %@",[coorArr objectAtIndex:indexPath.row]);
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];

    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [[[coorArr objectAtIndex:indexPath.row] objectForKey:@"lat"] floatValue];
    coor.longitude = [[[coorArr objectAtIndex:indexPath.row] objectForKey:@"lon"] floatValue];
    annotation.coordinate = coor;
    annotation.title = [searchArr objectAtIndex:indexPath.row];
     [_mapView addAnnotation:annotation];
    [_mapView setCenterCoordinate:coor animated:YES];
    
    searchTableView.hidden = YES;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
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
