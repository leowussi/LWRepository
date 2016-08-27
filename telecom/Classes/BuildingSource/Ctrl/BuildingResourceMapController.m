//
//  BuildingResourceMapController.m
//  telecom
//
//  Created by liuyong on 16/2/25.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "BuildingResourceMapController.h"
#import "LeftViewController.h"
#import "SearchViewController.h"
#import "RouteAnnotation.h"
#import "ResourceModel.h"
#import "ResourceDetailController.h"
#import "NewsView.h"
#import "GeoSearchResultCtrl.h"
#import "GongGaoViewController.h"
#import "LQLouYuButton.h"
#import "JianSuoViewController.h"
#import "UIImage+MJ.h"
#import "MBProgressHUD+MJ.h"
#import "ZiYuanDetailViewController.h"
#import "ExplainViewController.h"
#import "AnnotationTopView.h"
#import "DredgeDetailCell.h"
#import "AnnotationDataModel.h"
#import "AnnotationDetailDataModel.h"
#import "FloorListDataModel.h"
#import "HWBProgressHUD.h"
#import "YZResourcesChangeSearchViewController.h"
#import "LouYuAddRequestController.h"
#import "BusinessResourceDetailController.h"
#import "RequestSupportViewController.h"



@interface BuildingResourceMapController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,NSURLConnectionDataDelegate,UITextFieldDelegate,GeoSearchResultCtrlDelegate,UITableViewDataSource,UITableViewDelegate,AnnotationTopViewDelegate,DredgeDetailCellDelegate>
{
    NewsView *_newsView;
    NSMutableArray *_newsArray;
    UIView *_popView;
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch* _geocodesearch;
    BMKPinAnnotationView *_annoView;
    NSString *_scaleLevel;
    NSString *leftUpSmx;
    NSString *leftUpSmy;
    NSString *rightDownSmx;
    NSString *rightDownSmy;
    
    NSMutableArray *_wayPointsArray;
    NSMutableArray *_annotationArray;
    
    UITextField *searchField;
}
@property (nonatomic,strong) NSMutableArray *statusArray;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) AnnotationDetailDataModel *annotationDetailModel;//大头针详情model
@property (nonatomic,strong) BMKCircle* circle;
@property (nonatomic,copy) NSString *currentAddress;
@end

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@implementation BuildingResourceMapController

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}
- (NSMutableArray *)statusArray
{
    if (nil == _statusArray) {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]setObject:@"BuildingResourceMapController" forKey:@"selectRootVC"];//记住每次登陆的是i运维还是i楼宇
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    _wayPointsArray = [NSMutableArray array];
    _annotationArray = [NSMutableArray array];
    _newsArray = [NSMutableArray array];
    
    //[self addNavTitle:@"楼宇资源信息"];
    [self addNavigationRightButton:@"头像.png"];
    //[self addNavLeftButton:@"message.png"];
    //遮住左边返回按钮
    UIView *killView =[[UIView alloc]initWithFrame:CGRectMake(0, 20, 30, 30)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithCustomView:killView];
    self.navigationItem.leftBarButtonItem = spaceItem;
    
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 24, 24)];
    leftImageView.image = [UIImage imageNamed:@"search_btn.png"];
    [searchImgView addSubview:leftImageView];
    
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(29, 0, kScreenWidth-149, searchImg.size.height/3+5)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.text = @"输入地址点";
    searchField.textColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.userInteractionEnabled = NO;
    searchField.enablesReturnKeyAutomatically = YES;
    searchField.font = [UIFont systemFontOfSize:15.0];
    [searchImgView addSubview:searchField];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(5,0 ,kScreenWidth-125 , searchImg.size.height/3+5)];
    [searchBtn setBackgroundColor:[UIColor clearColor]];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchImgView addSubview:searchBtn];
    
    
    self.navigationItem.titleView = searchImgView;
    
    // [self MyInfoData];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    [self setUpMapView];
    
    [self startLocationAction];
    //增加说明按钮
    UIImageView *explainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W - 60, 74, 50, 50)];
    explainImageView.userInteractionEnabled = YES;
    explainImageView.image = [UIImage imageNamed:@"lou_shuoming"];
    explainImageView.tag = 888+4;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imViewDidClick:)];
    [explainImageView addGestureRecognizer:ges];
    [self.view addSubview:explainImageView];
    
#pragma mark 底部view
    [self setUpTabBarView];
}
#pragma mark 添加底部条框
-(void)setUpTabBarView{
    UIView *TabView =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    
    CGFloat buttonWidth = 30;
    CGFloat buttonHeight = 30;
    CGFloat labelWidth = APP_W/4;
    CGFloat labelHeight = 10;
    CGFloat space = (APP_W - 4*buttonWidth)/5;
    NSArray *imageArray = @[@"b1.jpg",@"请求支撑",@"变更工单查询",@"资源查询"];
    NSArray *titleArray = @[@"网格查询",@"请求支撑",@"资源变更工单",@"资源查询"];
    for (int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(space+(buttonWidth+space)*i, 5, buttonWidth, buttonHeight)];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 888+i;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imViewDidClick:)];
        [imageView addGestureRecognizer:ges];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelWidth)];
        label.center = CGPointMake(imageView.center.x, imageView.center.y+(buttonHeight + labelHeight)/2);
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:9];
        label.textColor = [UIColor blueColor];
        [TabView addSubview:imageView];
        [TabView addSubview:label];
    }
    TabView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:TabView];
}
#pragma mark 底部图片点击
-(void)imViewDidClick:(UITapGestureRecognizer *)ges{
    NSInteger index = ges.view.tag -888;
    switch (index) {
        case 0:
        {
            JianSuoViewController *vc = [[JianSuoViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
            RequestSupportViewController *ctrl = [[RequestSupportViewController alloc] init];
            ctrl.source = @"1";
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case 2:
        {
            YZResourcesChangeSearchViewController *ctrl = [[YZResourcesChangeSearchViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case 3:
        {
            ZiYuanDetailViewController *detailVc = [[ZiYuanDetailViewController alloc]init];
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case 4:
        {
            ExplainViewController *explain = [[ExplainViewController alloc] init];
            [self.navigationController pushViewController:explain animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - 公告信息列表及其单条内容详细
- (void)MyInfoData
{
    httpGET2(@{URL_TYPE : @"myInfo/GetNoteList"}, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            _newsArray = [result objectForKey:@"list"];
            if (!_newsArray.count) {
                return ;//如果没有公告数据 直接返回
            }else{
                _newsView = [[NewsView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 35) news:_newsArray];
                [_newsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publicInfoAction)]];
                [self.view addSubview:_newsView];
                [_newsView showNewsInfo];
            }
        }
    }, ^(id result) {
        [_newsView removeFromSuperview];
        showAlert(result[@"error"]);
    });
}

- (void)publicInfoAction{
    GongGaoViewController *gongVC = [[GongGaoViewController alloc]init];
    gongVC.dataArr = _newsArray;
    [self.navigationController pushViewController:gongVC animated:YES];
}

- (void)setUpMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-44)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 19.0f;
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.showMapScaleBar = YES;
    [self.view addSubview:_mapView];
    
    int zoom = (int)_mapView.zoomLevel;
    NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",@"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",@"2000000"];
    
    _scaleLevel = [zoomArr objectAtIndex:(19-zoom)];
    
    UIImage *locationImage = [UIImage imageNamed:@"定位.png"];
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    locationBtn.frame = RECT(5, APP_H-75, locationImage.size.width/2, locationImage.size.height/2);
    [locationBtn setImage:[locationImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    [locationBtn setImage:[locationImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateHighlighted];
    [locationBtn addTarget:self action:@selector(startLocationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
}

- (void)startLocationAction
{
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
}
#pragma mark 地图改变完成
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"改变完成");
    NSLog(@"改变完成 == %f",_mapView.zoomLevel);
    
    if (_mapView.zoomLevel<17.0) {
        
    }
    
    if (_mapView.zoomLevel >=19.0) {
        _scaleLevel = @"20";
    }else if (_mapView.zoomLevel <= 3.0){
        _scaleLevel = @"2000000";
    }else{
        int zoom = _mapView.zoomLevel;
        NSLog(@"zoom == >%d",zoom);
        
        NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",
                             @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",
                             @"2000000"];
        
        _scaleLevel = [zoomArr objectAtIndex:(19-zoom)];
        // NSLog(@"_scaleLevel -- %@",_scaleLevel);
        
    }
    
    CGPoint point = CGPointMake(0, 0);
    
    CGPoint point1 = CGPointMake(kScreenWidth, kScreenHeight-64);
    
    CLLocationCoordinate2D coornation = [_mapView convertPoint:point toCoordinateFromView:_mapView];//获取经纬度
    
    leftUpSmx = [NSString stringWithFormat:@"%f",coornation.longitude];
    leftUpSmy = [NSString stringWithFormat:@"%f",coornation.latitude];
    NSLog(@"左上角 latitude -- %f",coornation.latitude);
    NSLog(@"左上角 longitude -- %f",coornation.longitude);
    
    CLLocationCoordinate2D coornation1 = [_mapView convertPoint:point1 toCoordinateFromView:_mapView];//获取经纬度
    rightDownSmx = [NSString stringWithFormat:@"%f",coornation1.longitude];
    rightDownSmy = [NSString stringWithFormat:@"%f",coornation1.latitude];
    NSLog(@"右下角 longitude -- %f",coornation1.latitude);
    NSLog(@"右下角 longitude -- %f",coornation1.longitude);
    
    [self loadData];
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    
    
    if (_mapView.zoomLevel >=19.0) {
        _scaleLevel = @"20";
    }else if (_mapView.zoomLevel <= 3.0){
        _scaleLevel = @"2000000";
    }else{
        int zoom = _mapView.zoomLevel;
        NSLog(@"zoom -- %d",zoom);
        
        NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",
                             @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",
                             @"2000000"];
        
        _scaleLevel = [zoomArr objectAtIndex:(19-zoom)];
        NSLog(@"_scaleLevel -- %@",_scaleLevel);
    }
    
    CGPoint point = CGPointMake(0, 0);
    
    CGPoint point1 = CGPointMake(kScreenWidth, kScreenHeight-64);
    
    CLLocationCoordinate2D coornation = [_mapView convertPoint:point toCoordinateFromView:_mapView];//获取经纬度
    
    leftUpSmx = [NSString stringWithFormat:@"%f",coornation.longitude];
    leftUpSmy = [NSString stringWithFormat:@"%f",coornation.latitude];
    NSLog(@"左上角 latitude -- %f",coornation.latitude);
    NSLog(@"左上角 longitude -- %f",coornation.longitude);
    
    CLLocationCoordinate2D coornation1 = [_mapView convertPoint:point1 toCoordinateFromView:_mapView];//获取经纬度
    rightDownSmx = [NSString stringWithFormat:@"%f",coornation1.longitude];
    rightDownSmy = [NSString stringWithFormat:@"%f",coornation1.latitude];
    NSLog(@"右下角 longitude -- %f",coornation1.latitude);
    NSLog(@"右下角 longitude -- %f",coornation1.longitude);
    
    [self loadData];
}


- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (void)dropAnnotationOnMapView
{
    [_mapView removeAnnotations:_annotationArray];
    [_annotationArray removeAllObjects];
    
    CLLocationCoordinate2D coor;
    
    if (_wayPointsArray.count > 0) {
        for (int i=0; i<_wayPointsArray.count; i++) {
            AnnotationDataModel *model = _wayPointsArray[i];
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
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[view viewForAnnotation:annotation];
    
    if (annotationView == nil)
    {
        RouteAnnotation *ann;
        if ([annotation isKindOfClass:[RouteAnnotation class]]) {
            ann = (id)annotation;
        }
        
        NSUInteger tag = ann.tag;
        
        NSString *AnnotationViewID = [NSString stringWithFormat:@"AnnotationView-%i", tag];
        
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:AnnotationViewID];
        
        annotationView.canShowCallout = NO;
        annotationView.calloutOffset = CGPointMake(50, 60);
        
        AnnotationDataModel *annotationModel = _wayPointsArray[tag];
        if ([annotationModel.isUrgency isEqualToString:@"0"]) {
            annotationView.image = [UIImage imageNamed:@"lou_green.png"];
        }else{
            annotationView.image = [UIImage imageNamed:@"lou_red.png"];
        }
        
        annotationView.annotation = annotation;
    }
    return annotationView ;
}
#pragma mark  点击大头针

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
        NSInteger tag = [(RouteAnnotation*)view.annotation tag];
        
        AnnotationDataModel *model = _wayPointsArray[tag];
        self.annotationDetailModel = nil;
        UIView *popView = [[UIView alloc] initWithFrame:RECT(0, 0, SCREEN_W, SCREEN_H)];
        popView.tag = 44444;
        popView.backgroundColor = [UIColor clearColor];
        popView.userInteractionEnabled = YES;
        [popView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapAction)]];
        AnnotationTopView *annotationTopView = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationTopView" owner:nil options:nil] lastObject];
        annotationTopView.tag = 2000;
        annotationTopView.delegate  = self;
        annotationTopView.frame = CGRectMake(0, 0, 254,100);
        annotationTopView.center = CGPointMake(popView.center.x, popView.center.y-120);
        annotationTopView.clipsToBounds = YES;
        annotationTopView.layer.cornerRadius = 5;
        annotationTopView.layer.borderWidth = 1;
        annotationTopView.layer.borderColor = COLOR(200, 200, 200).CGColor;
        [popView addSubview:annotationTopView];
        //添加手势
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnnotation:)];
        [annotationTopView.backView addGestureRecognizer:ges];
        //给 路 弄  号  传值
        annotationTopView.road = model.road;
        annotationTopView.lane = model.lane;
        annotationTopView.gate = model.gate;
        annotationTopView.lou = model.buildingNo;
        
        UIView *middleLineView = [[UIView alloc] initWithFrame:CGRectMake(annotationTopView.frame.origin.x+2, annotationTopView.ey, 254-4, 2)];
        middleLineView.backgroundColor = COLOR(239, 239, 239);
        middleLineView.clipsToBounds = YES;
        middleLineView.layer.cornerRadius = 2;
        [popView addSubview:middleLineView];
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"house/GetHouseSummaryInfo";
        paraDict[@"buildingNo"] = model.buildingNo;
        paraDict[@"address"] = model.address;
        httpPOST2(paraDict, ^(id result) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = result[@"detail"];
                AnnotationDetailDataModel *annotationDetailModel = [[AnnotationDetailDataModel alloc] initWithDictionary:dict error:nil];
                self.annotationDetailModel = annotationDetailModel;
                if (model.buildingNo.length>0) {
                    annotationTopView.addressLabel.text = [NSString stringWithFormat:@"%@%@号楼",model.address,model.buildingNo];
                    self.currentAddress = annotationTopView.addressLabel.text;
                }else{
                    annotationTopView.addressLabel.text = [NSString stringWithFormat:@"%@",model.address];
                    self.currentAddress = annotationTopView.addressLabel.text;
                }
                
                annotationTopView.label1.text = annotationDetailModel.gdjCount;
                annotationTopView.label2.text = annotationDetailModel.gjjxCount;
                annotationTopView.label3.text = annotationDetailModel.gfqxCount;
                annotationTopView.label4.text = annotationDetailModel.oltCount;
                annotationTopView.label5.text = annotationDetailModel.obdCount;
                annotationTopView.label6.text = annotationDetailModel.onuCount;
                NSInteger count = annotationDetailModel.floorList.count;
                // 记录每个楼层的展开
                [self.statusArray removeAllObjects];
                for (int i = 0; i<count; i++) {
                    if (i == 0) {
                        [self.statusArray addObject:@"1"];
                    }else{
                        [self.statusArray addObject:@"0"];
                    }
                    
                }
                
                [self.table reloadData];
            }
        }, ^(id result) {
            showAlert(result[@"error"]);
        });
        
        //创建tableView
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(annotationTopView.frame.origin.x, middleLineView.ey, 254, 260) style:UITableViewStylePlain];
        self.table.delegate =  self;
        self.table.dataSource = self;
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        annotationTopView.clipsToBounds = YES;
        self.table.bounces = NO;
        self.table.showsHorizontalScrollIndicator = NO;
        self.table.showsVerticalScrollIndicator = NO;
        self.table.layer.cornerRadius = 5;
        self.table.backgroundColor = [UIColor clearColor];
        [popView addSubview:self.table];
        
        
        [self.view addSubview:popView];
        
        _mapView.scrollEnabled = NO;
    }
}

- (void)deliverPoiInfo:(BMKPoiInfo *)info
{
    searchField.text = info.name;
    
    CLLocationCoordinate2D coor;
    coor.latitude = info.pt.latitude;
    coor.longitude = info.pt.longitude;
    
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.000001, 0.000001);
    [_mapView setRegion:BMKCoordinateRegionMake(coor, span) animated:YES];
    //
    [_mapView removeOverlay:self.circle];
    self.circle = [BMKCircle circleWithCenterCoordinate:coor radius:30];
    
    [_mapView addOverlay:self.circle];
    
    
    
    
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor grayColor] colorWithAlphaComponent:1];
        circleView.strokeColor = [COLOR(29, 163, 228) colorWithAlphaComponent:0.8];
        circleView.lineWidth = 1;
        
        return circleView;
    }
    return nil;
}
- (void)bgViewTapAction
{
    //[self cancleAction];
}

- (void)cancleAction
{
    UIView *popView = [self.view viewWithTag:44444];
    [self.table removeFromSuperview];
    [popView removeFromSuperview];
    popView = nil;
    self.currentAddress = nil;
    _mapView.scrollEnabled = YES;
}
#pragma mark - AnnotationTopViewDelegate
- (void)deleteAnnotationTopView{
    [self cancleAction];
}
#pragma mark 点击弹出框跳转到其他视图
- (void)tapAnnotation:(UITapGestureRecognizer *)ges
{
    
    AnnotationDetailDataModel *model = self.annotationDetailModel;
    if ([model.gdjCount isEqualToString:@"0"] && [model.gjjxCount isEqualToString:@"0"] && [model.gfqxCount isEqualToString:@"0"] && [model.oltCount isEqualToString:@"0"] && [model.obdCount isEqualToString:@"0"] && [model.onuCount isEqualToString:@"0"] ) {
        
    }else{
        AnnotationTopView *annotationTopView = (id)ges.view.superview;
        ResourceDetailController *resourceDetailCtrl = [[ResourceDetailController alloc] init];
        resourceDetailCtrl.singleModel = model;
        resourceDetailCtrl.road = annotationTopView.road;
        resourceDetailCtrl.lane = annotationTopView.lane;
        resourceDetailCtrl.gate = annotationTopView.gate;
        resourceDetailCtrl.lou =  annotationTopView.lou;
        resourceDetailCtrl.currentAddress = self.currentAddress;
        [self.navigationController pushViewController:resourceDetailCtrl animated:YES];
    }
}
#pragma 加载地图数据。
- (void)loadData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"house/GetHouseHeadPageInfo";
    paraDict[@"topLeftX"] = leftUpSmx;
    paraDict[@"topLeftY"] = leftUpSmy;
    paraDict[@"botRightX"] = rightDownSmx;
    paraDict[@"botRightY"] = rightDownSmy;
    paraDict[@"scale"] = _scaleLevel;
    [_locService stopUserLocationService];
    httpGET2(paraDict, ^(id result) {
        [_wayPointsArray removeAllObjects];
        
        for (NSDictionary *dict in result[@"list"]) {
            AnnotationDataModel *model = [[AnnotationDataModel alloc] initWithDictionary:dict error:nil];
            [_wayPointsArray addObject:model];
        }
        
        //去除没有坐标的点
        NSMutableArray *temparray = [NSMutableArray array];
        for (int i=0; i<_wayPointsArray.count; i++) {
            AnnotationDataModel *model = _wayPointsArray[i];
            if (![model.gpsX isEqualToString:@""] || ![model.gpsY isEqualToString:@""]) {
                //                    [_wayPointsArray removeObjectAtIndex:i];
                [temparray addObject:model];
            }
        }
        _wayPointsArray = temparray;
        DLog(@"_wayPointsArray--%@",_wayPointsArray);
        
        [self dropAnnotationOnMapView];
        
        
    }, ^(id result) {
        HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = HWBProgressHUDModeText;
        hud.detailsLabelText = result[@"error"];
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2.5);
        } completionBlock:^{
            [hud removeFromSuperview];
        }];
        
    });
    
    
}

#pragma mark - NSURLConnectionDataDelegate

- (void)searchAction
{
    GeoSearchResultCtrl *geoSearchCtrl = [[GeoSearchResultCtrl alloc] init];
    geoSearchCtrl.delegate = self;
    [self.navigationController pushViewController:geoSearchCtrl animated:YES];
}

- (void)rightAction
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.menuController showRightController:YES];
    
}

- (void)leftAction
{
    LeftViewController *leftController = [[LeftViewController alloc] init];
    [self.navigationController pushViewController:leftController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
}

- (void)dealloc {
    if (_mapView != nil) {
        _mapView = nil;
        _wayPointsArray= nil;
        _annotationArray=nil;
    }
    if (_locService != nil) {
        _locService = nil;
    }
    
    if (_newsView!=nil) {
        _newsView = nil;
    }
    DLog(@"==页面销毁=");
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.annotationDetailModel.floorList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.statusArray[section] isEqualToString:@"0"]) {
        return 0;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"dredgeDetailCell";
    DredgeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DredgeDetailCell" owner:nil options:nil] lastObject];
    }
    cell.layer.borderColor = COLOR(200, 200, 200).CGColor;
    cell.layer.borderWidth = 1;
    if (indexPath.section == (self.annotationDetailModel.floorList.count - 1)) {
        cell.clipsToBounds = YES;
        cell.layer.cornerRadius = 5;
    }
    FloorListDataModel *model = self.annotationDetailModel.floorList[indexPath.section];
    cell.indexPath = indexPath;
    cell.delegate  = self;
    [cell configModel:model];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    header.tag = 5000+section;
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
    [header addGestureRecognizer:tap];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, header.size.width-30, 20)];
    header.backgroundColor = COLOR(250, 150, 0);
    FloorListDataModel *model = self.annotationDetailModel.floorList[section];
    leftLabel.text = model.coverageFloor;
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:11];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, header.size.height-2, header.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    [header addSubview:lineView];
    [header addSubview:leftLabel];
    
    //右边图片
    UIImageView *rightImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(tableView.size.width - 20, 2.5, 15, 15)];
    rightImageView.tag = 999;
    
    if ([self.statusArray[section] isEqualToString:@"0"]) {
        rightImageView.image = [UIImage imageNamed:@"louyujiantou"];
        
    }else{
        rightImageView.image = [UIImage imageNamed:@"louyujiantou"];
        rightImageView.transform=CGAffineTransformMakeRotation(M_PI);
    }
    [header addSubview:rightImageView];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
#pragma mark - 点击组头
- (void)tapHeader:(UITapGestureRecognizer *)ges
{
    NSInteger section = ges.view.tag - 5000;
    
    UIImageView *rightImageView = (UIImageView *)[ges.view viewWithTag:999];
    if ([self.statusArray[section] isEqualToString:@"0"]) {
        [self.statusArray replaceObjectAtIndex:section withObject:@"1"];
        rightImageView.image = [UIImage imageNamed:@"louyujiantou"];
        rightImageView.transform=CGAffineTransformMakeRotation(M_PI);
        for (int i = 0; i<self.statusArray.count; i++) {
            if (i != section) {
                [self.statusArray replaceObjectAtIndex:i withObject:@"0"];
                
            }
        }
        self.table.contentOffset = CGPointZero;
        [UIView animateWithDuration:0.1 animations:^{
            self.table.contentOffset = CGPointMake(self.table.contentOffset.x, 20*section);
        }];
        
    }else{
        [self.statusArray replaceObjectAtIndex:section withObject:@"0"];
        rightImageView.image = [UIImage imageNamed:@"louyujiantou"];
        
    }
    [self.table reloadData];
    
    
}
#pragma mark - DredgeDetailCellDelegate
- (void)tapView:(UITapGestureRecognizer *)ges indexPath:(NSIndexPath *)indexPath
{
    UIView *tapView = ges.view;
    NSInteger tag = tapView.tag;
    FloorListDataModel *model = self.annotationDetailModel.floorList[indexPath.section];
    BusinessResourceDetailController *ctrl = [[BusinessResourceDetailController alloc] init];
    switch (tag) {
        case 11:
            ctrl.deviceId = model.deviceOnu;
            ctrl.deviceType = model.deviceOnuType;
            ctrl.viewTag = tag;
            break;
        case 12:
            ctrl.deviceId = model.deviceFtth;
            ctrl.deviceType = model.deviceFtthType;
            ctrl.viewTag = tag;
            break;
        case 13:
            ctrl.deviceId = model.deviceOnu;
            ctrl.deviceType = model.deviceOnuType;
            ctrl.viewTag = tag;
            break;
        case 14:
            ctrl.deviceId = model.deviceCir;
            ctrl.deviceType = model.deviceCirType;
            ctrl.viewTag = tag;
            break;
        case 15:
            ctrl.deviceId = model.devicedFtto;
            ctrl.deviceType = model.devicedFttoType;
            ctrl.viewTag = tag;
            break;
        case 21:
            ctrl.deviceId = model.deviceCir;
            ctrl.deviceType = model.deviceCirType;
            ctrl.viewTag = tag;
            break;
        case 22:
            ctrl.deviceId = model.deviceCir;
            ctrl.deviceType = model.deviceCirType;
            ctrl.viewTag = tag;
            break;
        case 23:
            ctrl.deviceId = model.deviceFtth;
            ctrl.deviceType = model.deviceFtthType;
            ctrl.viewTag = tag;
            break;
        case 24:
            ctrl.deviceId = model.deviceOnu;
            ctrl.deviceType = model.deviceOnuType;
            ctrl.viewTag = tag;
            break;
        case 31:
            ctrl.deviceId = model.deviceCir;
            ctrl.deviceType = model.deviceCirType;
            ctrl.viewTag = tag;
            break;
        case 32:
            ctrl.deviceId = model.deviceCir;
            ctrl.deviceType = model.deviceCirType;
            ctrl.viewTag = tag;
            break;
            
        default:
            break;
    }
    ctrl.currentAddress = self.currentAddress;
    if (ctrl.deviceId == nil || ctrl.deviceId.length==0) {
        showAlert(@"该业务无匹配资源!");
        return;
    }
   
    [self.navigationController pushViewController:ctrl animated:YES];
    /*
     "deviceOnu":"onu 设备id---五类线宽带/ADSL宽带/普通电话的设备ID",
     "deviceOnuType":"onu 设备类型---五类线宽带/ADSL宽带/普通电话的设备类型",
     "deviceFtth":"c类obd 设备id---光纤宽带/光电话的设备ID",
     "deviceFtthType":"c类obd 类型---光纤宽带/光电话的设备类型",
     "devicedFtto":"专网设备id",
     "devicedFttoType":"专网设备类型",
     "deviceCir":"通局光路光分id---IPMAN/30B+D/DID/SDH/MSTP的设备ID",
     "deviceCirType":"通局光路设备类型----IPMAN/30B+D/DID/SDH/MSTP的设备类型",
     */
}
@end
