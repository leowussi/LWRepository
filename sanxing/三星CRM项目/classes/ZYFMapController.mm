//
//  MapController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/24.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFMapController.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFUrlTask.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+Rotate.h"
#import <BaiduMapAPI/BMapKit.h>

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface ZYFMapController () <UIActionSheetDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

//当期位置的地名
@property (nonatomic ,copy) NSString *currentPositionName;
//当前位置的location
@property (nonatomic,strong) BMKUserLocation *curLocation;
@property (nonatomic,strong)  BMKMapView* mapView;
@property (nonatomic,strong) BMKLocationService* locService;
@property (nonatomic,copy) NSString *addr;


@end

@implementation ZYFMapController
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加控件
    [self setControl];
    //开始地图
    CGRect textViewFrame = self.textView.frame;
    
    const CGFloat margin = 5;
    CGFloat y = textViewFrame.origin.y + textViewFrame.size.height + margin;
    CGFloat h = kSystemScreenHeight  - y;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, y, kSystemScreenWidth, h)];
    [self.view addSubview:_mapView];
    
    UIButton *jumpToBaiduMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpToBaiduMapButton.frame = CGRectMake(20, kSystemScreenHeight -  60, 100, 40);
    jumpToBaiduMapButton.backgroundColor = [UIColor blueColor];
    jumpToBaiduMapButton.layer.cornerRadius = 10.0;
    [jumpToBaiduMapButton setTitle:@"跳到地图导航" forState:UIControlStateNormal];
    jumpToBaiduMapButton.titleLabel.tintColor = [UIColor whiteColor];
    jumpToBaiduMapButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [jumpToBaiduMapButton addTarget:self action:@selector(jumpToBaiduMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpToBaiduMapButton];
    
    //定位
    [self setupLocation];
    
}
//如果外部有百度地图，跳转到百度地图
- (void)jumpToBaiduMap
{
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    start.pt = self.curLocation.location.coordinate;
    //指定起点名称
    start.name = @"我的位置";
    //指定起点
    para.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    CLLocationCoordinate2D endCoordination = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    end.pt = endCoordination;
    //指定终点名称
    end.name = self.addr;
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    
    //调启百度地图客户端导航
    BMKOpenErrorCode errorCode = [BMKNavigation openBaiduMapNavigation:para];
    switch (errorCode) {
        case BMK_OPEN_OPTION_NULL:
            [MBProgressHUD showError:@"传入的参数为空"];
            break;
        case BMK_OPEN_NOT_SUPPORT:
            [MBProgressHUD showError:@"没有安装百度地图，或者版本太低"];
            break;
        case BMK_OPEN_ROUTE_START_ERROR:
            [MBProgressHUD showError:@"路线起点有误"];
            break;
        case BMK_OPEN_ROUTE_END_ERROR:
            [MBProgressHUD showError:@"路线终点有误"];
            break;
        default:
            break;
    }
}

- (void)setupLocation
{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    //添加标注
    CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    [self addPointAnnotationWithCoordination:endCoordinate title:@"目的地" subTitle:self.text];
    
    
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    BMKCoordinateRegion region = BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(userLocation.location.coordinate.latitude + 0.000001, userLocation.location.coordinate.longitude + 0.000001));
    [_mapView setRegion:region];
    self.curLocation = userLocation;
    if (userLocation) {
        [self addPointAnnotationWithCoordination:self.curLocation.location.coordinate title:@"我的位置" subTitle:nil];
        [_locService stopUserLocationService];
    }
}

//添加标注
- (void)addPointAnnotationWithCoordination:(CLLocationCoordinate2D)coor title:(NSString *)title subTitle:(NSString *)subtitle
{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = title;
        pointAnnotation.subtitle = subtitle;
    }
    [_mapView addAnnotation:pointAnnotation];
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        // 设置可拖拽
        annotationView.draggable = YES;
    }
    return annotationView;
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

#pragma mark - 百度地图

-(void)setControl
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更新位置" style:UIBarButtonItemStyleDone target:self action:@selector(updatePosition)];
    
    self.textView.text = self.text;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1.1;
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.masksToBounds = YES;
    
}

#pragma mark -- 上传当前位置
//将当前位置上传给服务器
-(void)updatePosition
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传描述位置",@"上传地理位置", nil];
    [action showInView:self.view];
}
#pragma mark -- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.sale) {
        if (buttonIndex == 0) {
            //上传描述信息
            [self postPositionToServer:buttonIndex];
            
        }else if (buttonIndex == 1){
            //上传地里位置
            [self postPositionToServer:buttonIndex];
            
        }else if(buttonIndex == 2){
            //取消
        }
    }
    
}

-(void)postPositionToServer: (NSInteger)type
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"LogicalName"] = self.sale.LogicalName;
    params[@"Id"] = self.sale.Id;
    
    if (type == 0) {
        //上传描述信息
        params[@"new_ammeter_install_position"] = self.textView.text;
    }
    if (type == 1) {
        //上传地里位置
        params[@"new_longitude"] = [NSString stringWithFormat:@"%f",self.curLocation.location.coordinate.longitude];
        params[@"new_latitude"] = [NSString stringWithFormat:@"%f",self.curLocation.location.coordinate.latitude];
    }
    
    NSString *urlString = kPositionUpdate;
    [ZYFHttpTool postWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        if (code.intValue == 1) {
            //如果上传描述信息成功，刷新界面
            [MBProgressHUD showSuccess:msg];
            if (type == 0) {
                if ([self.delegate respondsToSelector:@selector(mapController:updateAdress:)]) {
                    [self.delegate mapController:self updateAdress:self.textView.text];
                }
            }
        }else{
            [MBProgressHUD showError:msg];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];

    }];
}









@end
