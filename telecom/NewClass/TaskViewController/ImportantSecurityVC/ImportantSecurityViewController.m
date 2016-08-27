//
//  ImportantSecurityViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/10/20.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "ImportantSecurityViewController.h"
#import "SearchAddressViewController.h"
#import "MapBackView.h"
#import <CoreLocation/CoreLocation.h>
#import "SelectTableViewCell.h"
#import "ImportantPointAnnotation.h"
#import "ImportantPaopaoView.h"
#import "HWBProgressHUD.h"
#import "DataHander.h"
#import "SearchAddressTableViewCell.h"

#import "JuzhanViewController.h"
#import "NetworkViewController.h"
#import "JuzhanDetailViewController.h"
#import "NetworkDetailViewController.h"

@interface ImportantSecurityViewController ()<BMKGeneralDelegate,UITextFieldDelegate>
{
    DataHander *hander;
    int curPage;//搜索地址用到的
    
    MapBackView *mapBackView;
    BMKMapManager *mgr;
    BMKPointAnnotation* pointAnnotation;
//    ImportantPaopaoView *bubbleView;
    BMKAnnotationView *selectedAV;
    
    NSInteger paopaoTag;
    
    NSMutableArray *idArr;
    NSMutableArray *idArr1;
    NSMutableArray *idArr2;
    
    CLLocationManager *locationManager;
    NSString *strLevel;//比例尺
    NSString *leftUpSmx;
    NSString *leftUpSmy;
    NSString *rightDownSmx;
    NSString *rightDownSmy;
    
    UITableView *searchTableView;
    NSMutableArray *searchArr;
    NSMutableArray *coorArr;
    NSInteger searchTag;
    
    UIView *backView;
    UIView *classView;
    
    NSMutableArray *slectArray;//选中每行存入数组
    NSMutableDictionary *slectDic;//选中每行存入字典
    NSMutableDictionary *slectDic1;//选中每行存入字典
    NSMutableArray *contacts;
    NSMutableArray *dataArray;
    
    NSMutableArray *contacts1;
    NSMutableArray *dataArray1;
    
    NSMutableArray *infoID;//信息id
    NSMutableArray *bussID;//业务id
    
    NSMutableDictionary *slectIdDic;//（单选）选中存放的数组
    
    NSMutableArray *annotationsArray;
    NSMutableArray *smxyArray;
    
    UIButton *infoBtn;
    UIButton *taskbtn;
    UIButton *closeBtn;
    UIButton *showBtn;
    
    NSArray *leftImgArr;
    NSArray *rightImgArr;
    
    UIView *backGroundView;
    UIView *infoView;
    UIView *taskView;
    NSMutableDictionary *selectDict;
    NSMutableDictionary *selectDict1;
    NSMutableArray *typeArr;
    NSString *inTypeStr;
    NSString *typeStr;
}

@property(nonatomic,strong)NSIndexPath *lastPath;

@end

static CGFloat kTransitionDuration = 0.45f;

@implementation ImportantSecurityViewController
@synthesize lastPath;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
     _locationService.delegate = self;
    _poisearch.delegate = self;
}

#pragma mark 地图将要消失
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil;
    _poisearch.delegate = nil;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationLeftButton];
    [self addSearchBar];
    
    annotationsArray = [[NSMutableArray alloc]initWithCapacity:10];
    smxyArray = [[NSMutableArray alloc]initWithCapacity:10];
    idArr = [[NSMutableArray alloc]initWithCapacity:10];
    idArr1 = [[NSMutableArray alloc]initWithCapacity:10];
    idArr2 = [[NSMutableArray alloc]initWithCapacity:10];
    selectDict = [[NSMutableDictionary alloc]initWithCapacity:10];
    selectDict1 = [[NSMutableDictionary alloc]initWithCapacity:10];
    typeArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    [self initView];
    [self addInMapView];
    [self initAddMapView];
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
    
    
    _poisearch = [[BMKPoiSearch alloc]init];
    // 设置地图级别
    [_mapView setZoomLevel:19];
    _mapView.isSelectedAnnotationViewFront = YES;
    
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
    
    bubbleView = [[ImportantPaopaoView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    bubbleView.delegate = self;
    bubbleView.hidden = YES;
}

#pragma mark == 在地图上添加表格
///////////////////////////////////////////////////////////////////////////////
-(void)initAddMapView
{
    dataArray = (NSMutableArray *)@[@"移动",@"宽带",@"固话"];//,@"专线"
    dataArray1 = (NSMutableArray *)@[@"局站",@"网元",@"负责人"];
    
    selectDict = [[NSMutableDictionary alloc]initWithCapacity:10];
    typeArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    bussID = (NSMutableArray *)@[@"1",@"2",@"3"];
    infoID = (NSMutableArray *)@[@"1",@"2",@"3"];
    
    backGroundView = [[UIView alloc]initWithFrame:CGRectMake(45, 150, kScreenWidth-90, 35+44*3)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.hidden = YES;
    [self.view addSubview:backGroundView];
    
    classView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-90, 35)];
    classView.backgroundColor = [UIColor whiteColor];
//    classView.hidden = YES;
    [backGroundView addSubview:classView];
    
    infoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-90)/2, 35)];
    [infoBtn setTitle:@"业务" forState:UIControlStateNormal];
    infoBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [infoBtn setBackgroundColor:[UIColor clearColor]];
    [infoBtn addTarget:self action:@selector(infoBtn) forControlEvents:UIControlEventTouchUpInside];
    [classView addSubview:infoBtn];
    
    taskbtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-90)/2, 0, (kScreenWidth-90)/2, 35)];
    [taskbtn setTitle:@"信息" forState:UIControlStateNormal];
    taskbtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [taskbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [taskbtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
    [taskbtn addTarget:self action:@selector(taskbtn) forControlEvents:UIControlEventTouchUpInside];
    [classView addSubview:taskbtn];
    
    
    
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 185-150, kScreenWidth-90, 44*3)];
    infoView.backgroundColor = [UIColor whiteColor];
//    infoView.hidden = YES;
    [backGroundView addSubview:infoView];
    
    
    taskView = [[UIView alloc]initWithFrame:CGRectMake(0, 185-150, kScreenWidth-90, 44*3)];
    taskView.backgroundColor = [UIColor whiteColor];
    taskView.hidden = YES;
    [backGroundView addSubview:taskView];
    //    select select_none
    UIImage *btnImg = [UIImage imageNamed:@"select_none.png"];
    
    UIImage *leftImg = [UIImage imageNamed:@"map_icon8.png"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    for (int i = 0; i < dataArray.count; i++) {
        UILabel *busLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 12+44*i, kScreenWidth-100, 20)];
        busLable.font = [UIFont systemFontOfSize:13.0];
        busLable.textColor = [UIColor blackColor];
        busLable.text = [dataArray objectAtIndex:i];
        [infoView addSubview:busLable];
        
        UIView *lineView= [[UIView alloc]initWithFrame:CGRectMake(10, 45+44*i, kScreenWidth-100, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        [infoView addSubview:lineView];
        if (i == 2) {
            lineView.hidden = YES;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:btnImg forState:UIControlStateNormal];
        [button setFrame:CGRectMake(kScreenWidth-135, 10+44*i, btnImg.size.width/1.6, btnImg.size.height/1.6)];
        button.tag = 100+i;
        [button addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:button];
        
        if ([user objectForKey:@"inTypeStr"] == nil || [[user objectForKey:@"inTypeStr"] isEqualToString:@""]) {
            
            if (i == 0) {
                [button setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                [selectDict1 setObject:@"1" forKey:@"strInfoType"];
            }
            
        }else{
            
            if (i == [[user objectForKey:@"inTypeStr"] intValue]-1) {
                [button setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                [selectDict1 setObject:[user objectForKey:@"inTypeStr"] forKey:@"strInfoType"];
            }
        }
        
    }
    
    
    
    
    NSLog(@"%@",[user objectForKey:@"typeStr"]);
    NSLog(@"%@",[[user objectForKey:@"typeStr"] allKeys]);
    
    
    for (int i = 0; i < dataArray1.count; i++) {
        
        UIImageView *leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10+44*i, leftImg.size.width/2, leftImg.size.height/2)];
        leftImgView.image = leftImg;
        [taskView addSubview:leftImgView];
        
        if (i == 0) {
            leftImgView.image = [UIImage imageNamed:@"map_icn3.png"];
        }
        
        if (i == 1) {
            leftImgView.image = [UIImage imageNamed:@"map_icon8.png"];
        }
        
        if (i == 2) {
            leftImgView.frame = CGRectMake(8, 10+44*i, [UIImage imageNamed:@"负责人.png"].size.width/2.1, [UIImage imageNamed:@"负责人.png"].size.height/2.1);
            leftImgView.image = [UIImage imageNamed:@"负责人.png"];
        }
        
        UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(10+leftImg.size.width/2, 10+44*i, 80, 20)];
        infoLable.font = [UIFont systemFontOfSize:13.0];
        infoLable.textColor = [UIColor blackColor];
        infoLable.text = [dataArray1 objectAtIndex:i];
        [taskView addSubview:infoLable];
        
        UIView *lineView= [[UIView alloc]initWithFrame:CGRectMake(10, 45+44*i, kScreenWidth-100, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        [taskView addSubview:lineView];
        
        if (i == 2) {
            lineView.hidden = YES;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:btnImg forState:UIControlStateNormal];
        [button setFrame:CGRectMake(kScreenWidth-135, 10+44*i, btnImg.size.width/1.6, btnImg.size.height/1.6)];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(selectBtn1:) forControlEvents:UIControlEventTouchUpInside];
        [taskView addSubview:button];
        
        NSString *strTag = [NSString stringWithFormat:@"%d",button.tag];
        NSLog(@"%@",[[user objectForKey:@"typeStr"]allKeys]);
        if ([[[user objectForKey:@"typeStr"]allKeys] count] == 0 ){
            
            if (i == 0) {
                button.selected = YES;
                [button setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                [selectDict setObject:[infoID objectAtIndex:0] forKey:strTag];
            }
            
        }else{
            
            if ([[[user objectForKey:@"typeStr"] allKeys] containsObject:strTag]) {
                
                NSLog(@"包含了字符串a");
                button.selected = YES;
                [button setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                [selectDict setObject:[infoID objectAtIndex:button.tag-1000] forKey:strTag];
            }
        }
        
        
    }
}


-(void)selectBtn:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);

    UIImage *btnImg = [UIImage imageNamed:@"select_none.png"];
    UIImage *btnImg1 = [UIImage imageNamed:@"select.png"];
    
    UIButton *btn1 = (UIButton *)[infoView viewWithTag:100];
    UIButton *btn2 = (UIButton *)[infoView viewWithTag:101];
    UIButton *btn3 = (UIButton *)[infoView viewWithTag:102];
    
    NSString *strInfoType = [bussID objectAtIndex:sender.tag-100];
    
    if (sender.tag == 100) {
        
        [btn1 setBackgroundImage:btnImg1 forState:UIControlStateNormal];
        [btn2 setBackgroundImage:btnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:btnImg forState:UIControlStateNormal];
        
        [selectDict1 setObject:strInfoType forKey:@"strInfoType"];
        
    }else if (sender.tag == 101) {
        
        [btn2 setBackgroundImage:btnImg1 forState:UIControlStateNormal];
        [btn1 setBackgroundImage:btnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:btnImg forState:UIControlStateNormal];
        
        [selectDict1 setObject:strInfoType forKey:@"strInfoType"];
        
    }else if (sender.tag == 102) {
        
        [btn3 setBackgroundImage:btnImg1 forState:UIControlStateNormal];
        [btn2 setBackgroundImage:btnImg forState:UIControlStateNormal];
        [btn1 setBackgroundImage:btnImg forState:UIControlStateNormal];
        
        [selectDict1 setObject:strInfoType forKey:@"strInfoType"];
    }
    
    NSLog(@"selectDict1 == %@",selectDict1);
}

-(void)selectBtn1:(UIButton *)button
{
    NSLog(@"%ld",(long)button.tag);
    
    UIImage *btnImg = [UIImage imageNamed:@"select_none.png"];
    UIImage *btnImg1 = [UIImage imageNamed:@"select.png"];
    
    button.selected = !button.selected;
    
    if (button.selected == YES) {
        //被选中了
        [button setBackgroundImage:btnImg1 forState:UIControlStateNormal];
        
        if (button.tag == 1000) {
            inTypeStr = @"1";
        }else if (button.tag == 1001) {
            inTypeStr = @"2";
        }else if (button.tag == 1002) {
            inTypeStr = @"3";
        }
        
        [typeArr removeAllObjects];
        NSString *strKey = [NSString stringWithFormat:@"%ld",(long)button.tag];
        [selectDict setObject:inTypeStr forKey:strKey];
        
        
        
    }
    else
    {
        [button setBackgroundImage:btnImg forState:UIControlStateNormal];
        
        NSString *strKey = [NSString stringWithFormat:@"%ld",(long)button.tag];
        [selectDict removeObjectForKey:strKey];
        
    }
    
    [typeArr removeAllObjects];
    NSArray *keys = [selectDict allKeys];
    id key;
    
    for (int i = 0; i < [keys count]; i++) {
        key = [keys objectAtIndex:i];
        
        NSLog(@"Key:%@",key);
        
        [typeArr addObject:[selectDict objectForKey:key]];
        
    }
    NSLog(@"typeArr==>%@",typeArr);
    typeStr = [typeArr componentsJoinedByString:@","];
    
    NSLog(@"typeStr ==%@",typeStr);
}

#pragma mark == 业务
-(void)infoBtn
{
    [taskbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [taskbtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
    
    
    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [infoBtn setBackgroundColor:[UIColor clearColor]];
    
    infoView.hidden = NO;
    taskView.hidden = YES;
    
}

#pragma mark == 信息
-(void)taskbtn
{
    [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoBtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
    [taskbtn setBackgroundColor:[UIColor clearColor]];
    [taskbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    infoView.hidden = YES;
    taskView.hidden = NO;
}

#pragma mark == 显示
-(void)showBtn
{
    
    [classView removeFromSuperview];
    [infoView removeFromSuperview];
    [backGroundView removeFromSuperview];
    [self initAddMapView];
    
    backGroundView.hidden = NO;
    classView.hidden = NO;
    infoView.hidden = NO;
    taskView.hidden = YES;
    
    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [infoBtn setBackgroundColor:[UIColor whiteColor]];
    
    [taskbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [taskbtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
    
    
    closeBtn.hidden = NO;
    showBtn.hidden = YES;
    
    
    [typeArr removeAllObjects];
    NSArray *keys = [selectDict allKeys];
    id key;
    
    for (int i = 0; i < [keys count]; i++) {
        key = [keys objectAtIndex:i];
        
        NSLog(@"Key:%@",key);
        
        [typeArr addObject:[selectDict objectForKey:key]];
        
    }
    NSLog(@"typeArr==>%@",typeArr);
    typeStr = [typeArr componentsJoinedByString:@","];
    
    NSLog(@"typeStr ==%@",typeStr);
    
    inTypeStr = [selectDict1 objectForKey:@"strInfoType"];
    NSLog(@"inTypeStr ==%@",inTypeStr);
    
}

#pragma mark == 关闭按钮
-(void)closeBtn
{
    NSLog(@"点击了关闭按钮");
    
    backGroundView.hidden = YES;
    classView.hidden = YES;
    closeBtn.hidden = YES;
    showBtn.hidden = NO;
    infoView.hidden = YES;
    taskView.hidden = YES;
    

    
    [typeArr removeAllObjects];
    NSArray *keys = [selectDict allKeys];
    id key;
    
    for (int i = 0; i < [keys count]; i++) {
        key = [keys objectAtIndex:i];
        
        NSLog(@"Key:%@",key);
        
        [typeArr addObject:[selectDict objectForKey:key]];
        
    }
    NSLog(@"typeArr==>%@",typeArr);
    typeStr = [typeArr componentsJoinedByString:@","];//信息
    
    NSLog(@"typeStr ==%@",typeStr);
    
    inTypeStr = [selectDict1 objectForKey:@"strInfoType"];//业务
    
    NSLog(@"inTypeStr ==%@",inTypeStr);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:selectDict forKey:@"typeStr"];//信息
    [user setObject:inTypeStr forKey:@"inTypeStr"];//业务
    
    if (typeStr == nil || [typeStr isEqualToString:@""]) {
        
        showAlert(@"请选择信息");
        
    }else if (inTypeStr == nil || [inTypeStr isEqualToString:@""]) {
        
        showAlert(@"请选择业务");
        
    }else{
        
        [self nearbyResult:typeStr :inTypeStr];
        
    }
    
    
    
    
}
///////////////////////////////////////////////////////////////////////////////

-(void)addInMapView
{
    backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor grayColor];
    backView.alpha = 0.3;
    backView.hidden = YES;
    [self.view addSubview:backView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPicker:)];
    [backView addGestureRecognizer:tap];
    
    UIImage *closeImg = [UIImage imageNamed:@"closeBtn"];
    
    UIImage *showImg = [UIImage imageNamed:@"showBtn"];
    showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showBtn setFrame:CGRectMake(kScreenWidth-45-closeImg.size.width, 150-closeImg.size.height, closeImg.size.width+5, closeImg.size.height+5)];
    [showBtn setBackgroundImage:showImg forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showBtn) forControlEvents:UIControlEventTouchUpInside];
    showBtn.hidden = NO;
    [self.view addSubview:showBtn];
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(kScreenWidth-45-closeImg.size.width, 150-closeImg.size.height, closeImg.size.width, closeImg.size.height)];
    [closeBtn setImage:closeImg forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.hidden = YES;
    [self.view addSubview:closeBtn];
    
//    classView = [[UIView alloc]initWithFrame:CGRectMake(45, 150, kScreenWidth-90, 35)];
//    classView.backgroundColor = [UIColor whiteColor];
//    classView.hidden = YES;
//    [self.view addSubview:classView];
//    
//    infoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-90)/2, 35)];
//    [infoBtn setTitle:@"业务" forState:UIControlStateNormal];
//    infoBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
//    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [infoBtn setBackgroundColor:[UIColor clearColor]];
//    [infoBtn addTarget:self action:@selector(infoBtn) forControlEvents:UIControlEventTouchUpInside];
//    [classView addSubview:infoBtn];
//    
//    taskbtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-90)/2, 0, (kScreenWidth-90)/2, 35)];
//    [taskbtn setTitle:@"信息" forState:UIControlStateNormal];
//    taskbtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
//    [taskbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [taskbtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
//    [taskbtn addTarget:self action:@selector(taskbtn) forControlEvents:UIControlEventTouchUpInside];
//    [classView addSubview:taskbtn];
//    
//    UIImage *closeImg = [UIImage imageNamed:@"closeBtn"];
//    
//    UIImage *showImg = [UIImage imageNamed:@"showBtn"];
//    showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [showBtn setFrame:CGRectMake(kScreenWidth-45-closeImg.size.width, 150-closeImg.size.height, closeImg.size.width+5, closeImg.size.height+5)];
//    [showBtn setBackgroundImage:showImg forState:UIControlStateNormal];
//    [showBtn addTarget:self action:@selector(showBtn) forControlEvents:UIControlEventTouchUpInside];
//    showBtn.hidden = NO;
//    [self.view addSubview:showBtn];
//    
//    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeBtn setFrame:CGRectMake(kScreenWidth-45-closeImg.size.width, 150-closeImg.size.height, closeImg.size.width, closeImg.size.height)];
//    [closeBtn setImage:closeImg forState:UIControlStateNormal];
//    [closeBtn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
//    closeBtn.hidden = YES;
//    [self.view addSubview:closeBtn];
//    
//    slectDic = [[NSMutableDictionary alloc]initWithCapacity:0];
//    slectDic1 = [[NSMutableDictionary alloc]initWithCapacity:0];
//    slectArray = [[NSMutableArray alloc]initWithCapacity:0];
//    dataArray = [[NSMutableArray alloc]initWithCapacity:0];
//    contacts = [NSMutableArray array];
//    dataArray1 = [[NSMutableArray alloc]initWithCapacity:0];
//    contacts1 = [NSMutableArray array];
//    
//    slectIdDic = [[NSMutableDictionary alloc]initWithCapacity:10];
//    
//    dataArray = (NSMutableArray *)@[@"移动",@"宽带",@"固话"];//,@"专线"
//    dataArray1 = (NSMutableArray *)@[@"局站",@"网元",@"负责人"];
//    
//    bussID = (NSMutableArray *)@[@"1",@"2",@"3"];
//    infoID = (NSMutableArray *)@[@"1",@"2",@"3"];
//    
//    
//    for (int i = 0; i <dataArray.count; i++) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        
//        [dic setValue:@"NO" forKey:@"checked"];
//        [contacts addObject:dic];
//        
//    }
//    
//    for (int i = 0; i <dataArray1.count; i++) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setValue:@"NO" forKey:@"checked1"];
//        [contacts1 addObject:dic];
//    }
//    
//    rightImgArr = @[@"map_icn3.png",@"map_icon8.png",@"负责人.png"];
//    leftImgArr = @[@"map_icon4.png",@"map_icon5.png",@"map_icon2.png"];
//    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(45, 185, kScreenWidth-90, 44*dataArray.count) style:UITableViewStylePlain];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.scrollEnabled = NO;
//    self.tableView.hidden = YES;
//    [self.view addSubview:self.tableView];
//    
//    self.tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(45, 185, kScreenWidth-90, 44*dataArray1.count) style:UITableViewStylePlain];
//    self.tableView1.dataSource = self;
//    self.tableView1.delegate = self;
//    self.tableView1.scrollEnabled = NO;
//    self.tableView1.hidden = YES;
//    [self.view addSubview:self.tableView1];
    
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
#pragma mark == 放大地图
-(void)addZoom
{
    
    NSLog(@"+++++上一次%f",_mapView.zoomLevel);
    
    
    if (_mapView.zoomLevel >= 19.0) {
        _mapView.zoomLevel = 19.0;
        int zoom = _mapView.zoomLevel;
        //        NSLog(@"zoom == >%d",zoom);
        
        NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",
                             @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",
                             @"2000000"];
        
        strLevel = [zoomArr objectAtIndex:(19-zoom)];
        //        NSLog(@"strLevel == %@",strLevel);
        
    }else{
        
        _mapView.zoomLevel = _mapView.zoomLevel++;
        //        NSLog(@"----本次%f",_mapView.zoomLevel);
        
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
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user objectForKey:@"businessType"];
    [user objectForKey:@"infoType"];
    
    NSString *businessType = [user objectForKey:@"businessType"];
    NSString *infoType = [user objectForKey:@"infoType"];
    NSLog(@"businessType == %@",businessType);
    NSLog(@"infoType == %@",infoType);
    
    if (businessType == nil || infoType == nil) {
        
        [self nearbyResult:@"1" :@"1"];
    }else{
       [self nearbyResult:infoType :businessType];
    }
    
    
}


#pragma mark == 获取附近结果信息
-(void)nearbyResult:(NSString *)infoType :(NSString *)businessType
{
    NSLog(@"strLevel == %@",strLevel);
    
    if (leftUpSmx == nil && leftUpSmy == nil && rightDownSmx == nil && rightDownSmy == nil) {
        
        [self showAlertWithTitle:@"抱歉" :@"正在定位,请稍后再试!" :@"确定" :nil];
        
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyTask/GetTrackedEnsureInfo";
        paraDict[@"leftUpSmx"] = leftUpSmx;//左上方经度
        paraDict[@"leftUpSmy"] = leftUpSmy;//左上方纬度
        paraDict[@"rightDownSmx"] = rightDownSmx;//右下方经度
        paraDict[@"rightDownSmy"] = rightDownSmy;//右下方经度
        paraDict[@"infoType"] = infoType;//信息类型 多个
        paraDict[@"businessType"] = businessType;//业务类型 单个
        paraDict[@"mapScale"] = strLevel;
        NSLog(@"paraDict <==> %@",paraDict);
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:businessType forKey:@"businessType"];
        [user setObject:infoType forKey:@"infoType"];
        
        //搜索类型(多个以,分割)、其中查询类型:1 周期工作  2故障 3预约 4隐患 5局站 6机房 7网元
        
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                
                [_mapView removeAnnotations:annotationsArray];
                [annotationsArray removeAllObjects];
                [smxyArray removeAllObjects];
                
                CLLocationCoordinate2D coor;
                smxyArray = [result objectForKey:@"list"];
                
                for (int i = 0; i<smxyArray.count; i++) {
                    // 添加一个PointAnnotation
                    //              longitude 经度 latitude 纬度
                    
                    ImportantPointAnnotation* annotation = [[ImportantPointAnnotation alloc]init];
                    annotation.tag = i;
                    
                    if ([[[[smxyArray objectAtIndex:i] objectForKey:@"typeId"] description] isEqualToString:@"3"]) {
                        
                        coor.latitude = [[smxyArray[i] objectForKey:@"peopleSmy"] doubleValue];
                        coor.longitude = [[smxyArray[i] objectForKey:@"peopleSmx"] doubleValue];
                        
                    }else{
                        
                        coor.latitude = [[smxyArray[i] objectForKey:@"siteSmy"] doubleValue];
                        coor.longitude = [[smxyArray[i] objectForKey:@"siteSmx"] doubleValue];
                    }
                    
                    annotation.coordinate = coor;
                    annotation.title = [smxyArray[i] objectForKey:@"address"];    //标题
                    [annotationsArray addObject:annotation];
                    
                    [_mapView addAnnotation:annotation];
                    
                }
                
                [_mapView addAnnotations:annotationsArray];
            }
            
        }, ^(id result) {
            
            [_mapView removeAnnotations:annotationsArray];
            [annotationsArray removeAllObjects];
            [smxyArray removeAllObjects];
            NSLog(@"%@",result);
            
            
            if (result == nil ) {
                
            }else{
                
                HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
                //弹出框的类型
                hud.mode = HWBProgressHUDModeText;
                //弹出框上的文字
                
                hud.detailsLabelText = [result objectForKey:@"error"];
                //弹出框的动画效果及时间
                [hud showAnimated:YES whileExecutingBlock:^{
                    //执行请求，完成
                    sleep(1);
                } completionBlock:^{
                    //完成后如何操作，让弹出框消失掉
                    [hud removeFromSuperview];
                }];
                
            }
            
        });
        
        
    }
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


#pragma mark === 地图上标注
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    
    if (searchTag == 123) {
        // 生成重用标示identifier
        NSString *AnnotationViewID = @"xidanMark";
        
        // 检查是否有重用的缓存
        BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
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
    }else{
        
        //    subSpecType：1表示3G、2表示4G、3表示WIFI、4表示OLT(PON)、5表示ONU(PON)、6表示PSTN、7表示NGN
        
        // typeId: 1局站 2网元 3 负责人 4综合类型
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *strType = [user objectForKey:@"businessType"];
        
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[mapView viewForAnnotation:annotation];
        
        if (annotationView == nil)
        {
            ImportantPointAnnotation *ann;
            if ([annotation isKindOfClass:[ImportantPointAnnotation class]]) {
                ann = annotation;
            }
            
            NSUInteger tag = ann.tag;
            NSString *AnnotationViewID = [NSString stringWithFormat:@"AnnotationV-%i", tag];
            
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:AnnotationViewID];
            
            annotationView.canShowCallout = NO;//使用自定义bubble
            
           
            
            if ([[annotation title] isEqualToString:@"我的位置"]) {
                
                ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"pin_purple@2x.png"];
            }
            else{
                for (int i = 0; i<smxyArray.count; i++)
                {
                    
                    
                    if ([[[[smxyArray objectAtIndex:i]objectForKey:@"typeId"] description]isEqualToString:@"1"]) {
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"siteSmy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"siteSmx"] doubleValue]){
                            
                            //1移动  2宽带 3固话
                            UIImage *img;
                            if ([strType isEqualToString:@"1"]) {
                                
                                img = [UIImage imageNamed:@"7.png"];
                                
                            }else if ([strType isEqualToString:@"2"]) {
                                
                                img = [UIImage imageNamed:@"5l.png"];
                                
                            }else if ([strType isEqualToString:@"3"]) {
                                
                                img = [UIImage imageNamed:@"12.png"];
                                
                            }
                            
                            
                            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(2, -25, img.size.width/1.3, img.size.height/1.3)];
                            imgView.image = img;
                            [annotationView addSubview:imgView];
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, img.size.width/1.3, img.size.height/1.3)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = img.size.width/1.3/2;
                            numLable.font = [UIFont systemFontOfSize:12.0];
                            numLable.backgroundColor = [UIColor clearColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [imgView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icn3.png"];
                            
                        }else{
                            
                            
                        }
                        
                        
                        
                    }else if ([[[[smxyArray objectAtIndex:i]objectForKey:@"typeId"] description]isEqualToString:@"2"]) {
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"siteSmy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"siteSmx"] doubleValue]){
                            
                            //1移动  2宽带 3固话
                            UIImage *img;
                            if ([strType isEqualToString:@"1"]) {
                                
                                img = [UIImage imageNamed:@"7.png"];
                                
                            }else if ([strType isEqualToString:@"2"]) {
                                
                                img = [UIImage imageNamed:@"5l.png"];
                                
                            }else if ([strType isEqualToString:@"3"]) {
                                
                                img = [UIImage imageNamed:@"12.png"];
                                
                            }
                            
                            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(2, -25, img.size.width/1.3, img.size.height/1.3)];
                            imgView.image = img;
                            [annotationView addSubview:imgView];
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, img.size.width/1.3, img.size.height/1.3)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = img.size.width/1.3/2;
                            numLable.font = [UIFont systemFontOfSize:12.0];
                            numLable.backgroundColor = [UIColor clearColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [imgView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icon8.png"];
                            
                        }else{
                            
                            
                        }
                        
                        
                        
                        
                    }else if ([[[[smxyArray objectAtIndex:i]objectForKey:@"typeId"] description]isEqualToString:@"3"]) {
                       
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"peopleSmy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"peopleSmx"] doubleValue]){
                            
                            //1移动  2宽带 3固话
//                            UIImage *img;
//                            if ([strType isEqualToString:@"1"]) {
//                                
//                                img = [UIImage imageNamed:@"7.png"];
//                                
//                            }else if ([strType isEqualToString:@"2"]) {
//                                
//                                img = [UIImage imageNamed:@"5l.png"];
//                                
//                            }else if ([strType isEqualToString:@"3"]) {
//                                
//                                img = [UIImage imageNamed:@"12.png"];
//                                
//                            }
//                            
//                            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(1, -26, img.size.width/1.3, img.size.height/1.3)];
//                            imgView.image = img;
//                            [annotationView addSubview:imgView];
//                            
//                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, img.size.width/1.3, img.size.height/1.3)];
//                            numLable.layer.masksToBounds = YES;
//                            numLable.layer.cornerRadius = img.size.width/1.3/2;
//                            numLable.font = [UIFont systemFontOfSize:12.0];
//                            numLable.backgroundColor = [UIColor clearColor];
//                            numLable.textColor = [UIColor whiteColor];
//                            numLable.textAlignment = NSTextAlignmentCenter;
//                            [imgView addSubview:numLable];
//                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"负责人.png"];
                            
                        }else{
                            
                        }
                        
                        
                        
                    }else if ([[[[smxyArray objectAtIndex:i]objectForKey:@"typeId"] description]isEqualToString:@"4"]) {
                        
                       

                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"siteSmy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"siteSmx"] doubleValue]){
                            
                            //1移动  2宽带 3固话
                            UIImage *img;
                            if ([strType isEqualToString:@"1"]) {
                                
                                img = [UIImage imageNamed:@"7.png"];
                                
                            }else if ([strType isEqualToString:@"2"]) {
                                
                                img = [UIImage imageNamed:@"5l.png"];
                                
                            }else if ([strType isEqualToString:@"3"]) {
                                
                                img = [UIImage imageNamed:@"12.png"];
                                
                            }
                            
                            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(2, -25, img.size.width/1.3, img.size.height/1.3)];
                            imgView.image = img;
                            [annotationView addSubview:imgView];
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, img.size.width/1.3, img.size.height/1.3)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = img.size.width/1.3/2;
                            numLable.font = [UIFont systemFontOfSize:12.0];
                            numLable.backgroundColor = [UIColor clearColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [imgView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"26.png"];
                            
                        }else{
                            
                            
                        }
  
                        
                    }
                    
                    
                }
                
                
                
            }
            
            annotationView.annotation = annotation;
        }
        return annotationView ;

    }
    
}



//
#pragma mark == 当选中一个annotationviews时，调用此接口
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //设定是否总让选中的annotaion置于最前面
    _mapView.isSelectedAnnotationViewFront = YES;
    NSLog(@"选中一个annotationviews:%f,%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
    
    if (searchTag == 123) {
        
    }else{
        
        if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
            

           
            NSDictionary *mapDic = [smxyArray objectAtIndex:[(ImportantPointAnnotation*)view.annotation tag]];
            
            NSLog(@"==%d",[(ImportantPointAnnotation*)view.annotation tag]);
            
            selectedAV = view;
            if (bubbleView.superview == nil) {
                //bubbleView加在BMKAnnotationView的superview(UIScrollView)上,且令zPosition为1
                [view.superview addSubview:bubbleView];
                bubbleView.layer.zPosition = 1;
            }
            bubbleView.infoDict = [smxyArray objectAtIndex:[(ImportantPointAnnotation*)view.annotation tag]];
            paopaoTag = [(ImportantPointAnnotation *)view.annotation tag];
            

            if ([[mapDic objectForKey:@"typeId"] isEqualToString:@"4"]){
                
                if (selectedAV) {
                    [self showBubble:YES];
                    [self changeBubblePosition];
                    bubbleView.infoDict = [smxyArray objectAtIndex:[(ImportantPointAnnotation*)view.annotation tag]];
                    paopaoTag = [(ImportantPointAnnotation*)view.annotation tag];
                    NSLog(@"tag == %d",[(ImportantPointAnnotation*)view.annotation tag]);
                    
                }
                
            }else if ([[mapDic objectForKey:@"typeId"] isEqualToString:@"1"]){
                
                bubbleView.hidden = YES;
                
//                if ([[mapDic objectForKey:@"content"] isEqualToString:@"0"]){
//                    
//                }else if ([[mapDic objectForKey:@"content"] isEqualToString:@"1"]){
//                    
//                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
//                    paraDict[URL_TYPE] = @"myRegion/GetRegionById";
//                    paraDict[@"regionId"] = mapDic[@"siteId"];
//                    
//                    NSLog(@"paraDict == %@",paraDict);
//                    
//                    httpGET2(paraDict, ^(id result) {
//                        NSLog(@"%@",result);
//                        if ([result[@"result"] isEqualToString:@"0000000"])
//                        {
//                            JuzhanDetailViewController *judVC = [[JuzhanDetailViewController alloc]init];
//                            judVC.dic = [result objectForKey:@"detail"];
//                            [self.navigationController pushViewController:judVC animated:YES];
//                            
//                        }else{
//                        }
//                        
//                    }, ^(id result) {
//                        
//                    });
//
//                }else{
//                    
//                    NSMutableArray *juzhanArr = [[NSMutableArray alloc]initWithCapacity:10];
//                    NSArray *nearArr = [mapDic objectForKey:@"trackedEnsureList"];
//                    NSString *key;
//                    for (int i = 0; i < [nearArr count]; i++) {
//                        
//                        if ([[[[nearArr objectAtIndex:i] objectForKey:@"typeId"] description] isEqualToString:@"1"]) {
//                            
//                            key = [[nearArr objectAtIndex:i] objectForKey:@"nuId"];
//                            [juzhanArr addObject:key];
//                        }
//                    }
//                    
//                    NSString *strI =  [juzhanArr componentsJoinedByString:@","];
//                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
//                    paraDict[URL_TYPE] = @"myRegion/GetRegionByName";
//                    paraDict[@"regionIds"] = strI;
//                    paraDict[@"curPage"] = @"1";
//                    paraDict[@"pageSize"] = @"10";
//                    
//                    NSLog(@"paraDict == %@",paraDict);
//                    
//                    httpPOST(paraDict, ^(id result) {
//                        NSLog(@"%@",result);
//                        if ([result[@"result"] isEqualToString:@"0000000"])
//                        {
//                            JuzhanViewController *juzVC = [[JuzhanViewController alloc]init];
//                            juzVC.vcTag = 100;
//                            juzVC.strID = strI;
//                            juzVC.juzArr = [result objectForKey:@"list"];
//                            [self.navigationController pushViewController:juzVC animated:YES];
//                            
//                        }else{
//                            
//                        }
//                        
//                    }, ^(id result) {
//                        
//                    });
//                }
                
                

            }else if ([[mapDic objectForKey:@"typeId"] isEqualToString:@"2"]){
                
                bubbleView.hidden = YES;
                
                if ([[mapDic objectForKey:@"content"] isEqualToString:@"0"]){
                    
                }else if ([[mapDic objectForKey:@"content"] isEqualToString:@"1"]){
                    
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                    paraDict[URL_TYPE] = @"myRegion/GetNuById";
                    paraDict[@"nuId"] = mapDic[@"nuId"];
                    
                    NSLog(@"paraDict == %@",paraDict);
                    
                    httpGET2(paraDict, ^(id result) {
                        NSLog(@"%@",result);
                        if ([result[@"result"] isEqualToString:@"0000000"])
                        {
                            NetworkDetailViewController *netWorkVC = [[NetworkDetailViewController alloc]init];
                            netWorkVC.dictionary = [result objectForKey:@"detail"];
                            [self.navigationController pushViewController:netWorkVC animated:YES];
                            
                        }else{
                        }
                        
                    }, ^(id result) {
                        
                    });
                    
                }else{
                    
                    NSMutableArray *netWorkArr = [[NSMutableArray alloc]initWithCapacity:10];
                    NSArray *nearArr = [mapDic objectForKey:@"trackedEnsureList"];
                    NSString *key;
                    for (int i = 0; i < [nearArr count]; i++) {
                        
                        if ([[[[nearArr objectAtIndex:i] objectForKey:@"typeId"] description] isEqualToString:@"2"]) {
                            
                            key = [[nearArr objectAtIndex:i] objectForKey:@"nuId"];
                            [netWorkArr addObject:key];
                        }
                    }
                    
                    NSString *strI1 =  [netWorkArr componentsJoinedByString:@","];
                    
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                    paraDict[URL_TYPE] = @"myRegion/GetNuByName";
                    paraDict[@"nuIds"] = strI1;
                    paraDict[@"curPage"] = @"1";
                    paraDict[@"pageSize"] = @"10";

                    NSLog(@"paraDict == %@",paraDict);
                    
                    httpPOST(paraDict, ^(id result) {
                        NSLog(@"%@",result);
                        if ([result[@"result"] isEqualToString:@"0000000"])
                        {
                            NetworkViewController *netVC = [[NetworkViewController alloc]init];
                            netVC.vcTag = 100;
                            netVC.strID = strI1;
                            netVC.netArr = [result objectForKey:@"list"];
                            [self.navigationController pushViewController:netVC animated:YES];
                            
                        }else{
                            
                        }
                        
                    }, ^(id result) {
                        
                    });

                }
                
                
                
            }else if ([[mapDic objectForKey:@"typeId"] isEqualToString:@"3"]){
                
                bubbleView.hidden = YES;
                
                if ([[mapDic objectForKey:@"content"] isEqualToString:@"0"]){
                    
                }else if ([[mapDic objectForKey:@"content"] isEqualToString:@"1"]){
                    
                    
                    
                }else{
                    
                    NSMutableArray *netWorkArr = [[NSMutableArray alloc]initWithCapacity:10];
                    NSArray *nearArr = [mapDic objectForKey:@"trackedEnsureList"];
                    NSString *key;
                    for (int i = 0; i < [nearArr count]; i++) {
                        
                        if ([[[[nearArr objectAtIndex:i] objectForKey:@"typeId"] description] isEqualToString:@"3"]) {
                            
                            key = [[nearArr objectAtIndex:i] objectForKey:@"nuId"];
                            [netWorkArr addObject:key];
                        }
                    }
                    
                    NSString *strI =  [netWorkArr componentsJoinedByString:@","];
                }
                
            
            }
            
        }
        else {
            selectedAV = nil;
        }
        
    }
    NSLog(@"paopaoTag == %d",paopaoTag);
    
}

//当取消选中一个annotationviews时，调用此接口
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"取消选中一个annotation views");
    if (searchTag == 123) {
        
    }else{
        
        if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
            
            if (selectedAV) {
                [self showBubble:NO];
            }
        }
        
    }

    
}

#pragma mark == 标注详情
- (void)tagBtn:(NSInteger)index
{
    NSLog(@"index == %d",index);
    [idArr removeAllObjects];
    [idArr1 removeAllObjects];
    [idArr2 removeAllObjects];
    
    
    NSDictionary *mapDic = [smxyArray objectAtIndex:paopaoTag];
    
    NSArray *nearArr = [mapDic objectForKey:@"trackedEnsureList"];
    
    NSLog(@"mapDic == %@",mapDic);
    NSLog(@"nearArr == %@",nearArr);
    
    
    NSString *key;  //局站
    NSString *key1; //网元
    NSString *key2; //负责人
    
    for (int i = 0; i < [nearArr count]; i++) {
        
        if ([[[[nearArr objectAtIndex:i] objectForKey:@"typeId"] description] isEqualToString:@"1"]) {
            
            key = [[nearArr objectAtIndex:i] objectForKey:@"nuId"];
            [idArr addObject:key];
            
        }else if ([[[[nearArr objectAtIndex:i] objectForKey:@"typeId"] description] isEqualToString:@"2"]) {
            
            key1 = [[nearArr objectAtIndex:i] objectForKey:@"nuId"];
            [idArr1 addObject:key1];
            
        }else if ([[[[nearArr objectAtIndex:i] objectForKey:@"typeId"] description] isEqualToString:@"3"]) {
            
            key2 = [[nearArr objectAtIndex:i] objectForKey:@"siteId"];
            [idArr2 addObject:key2];
            
        }
        
        
    }
    NSString *strI =  [idArr componentsJoinedByString:@","];//局站
    NSString *strI1 = [idArr1 componentsJoinedByString:@","];//网元
    NSString *strI2 = [idArr2 componentsJoinedByString:@","];//负责人
   
    
    NSLog(@"==%@",strI);
    
    switch (index) {
        case 0://局站
        {
//            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
//            paraDict[URL_TYPE] = @"myRegion/GetRegionByName";
//            paraDict[@"regionIds"] = strI;
//            paraDict[@"curPage"] = @"1";
//            paraDict[@"pageSize"] = @"10";
//            
//            httpPOST(paraDict, ^(id result) {
//                NSLog(@"%@",result);
//                if ([result[@"result"] isEqualToString:@"0000000"])
//                {
//                    JuzhanViewController *juzVC = [[JuzhanViewController alloc]init];
//                    juzVC.vcTag = 100;
//                    juzVC.strID = strI;
//                    juzVC.juzArr = [result objectForKey:@"list"];
//                    [self.navigationController pushViewController:juzVC animated:YES];
//                    
//                }else{
//                    
//                }
//                
//            }, ^(id result) {
//                
//            });

        }
            break;
        case 1://网元
        {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myRegion/GetNuByName";
            paraDict[@"nuIds"] = strI1;
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            //            NSLog(@"%@",strI2);
            httpPOST(paraDict, ^(id result) {
                NSLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"])
                {
                    NetworkViewController *netVC = [[NetworkViewController alloc]init];
                    netVC.vcTag = 100;
                    netVC.strID = strI1;
                    netVC.netArr = [result objectForKey:@"list"];
                    [self.navigationController pushViewController:netVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });

            
        }
            break;
        case 2://负责人
        {
            NSLog(@"%@",strI2);
            
        }
            break;
        
           
        case 100://局站详情
        {
            NSLog(@"局站详情");
//            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
//            paraDict[URL_TYPE] = @"myRegion/GetRegionById";
//            paraDict[@"regionId"] = strI;
//            
//            NSLog(@"paraDict == %@",paraDict);
//            
//            httpGET2(paraDict, ^(id result) {
//                NSLog(@"%@",result);
//                if ([result[@"result"] isEqualToString:@"0000000"])
//                {
//                    JuzhanDetailViewController *judVC = [[JuzhanDetailViewController alloc]init];
//                    judVC.dic = [result objectForKey:@"detail"];
//                    [self.navigationController pushViewController:judVC animated:YES];
//                    
//                }else{
//                }
//                
//            }, ^(id result) {
//                
//            });

            
        }
            break;
            
        case 110://网元详情
        {
            NSLog(@"网元详情");
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myRegion/GetNuById";
            paraDict[@"nuId"] = strI1;
            
            NSLog(@"paraDict == %@",paraDict);
            
            httpGET2(paraDict, ^(id result) {
                NSLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"])
                {
                    NetworkDetailViewController *netWorkVC = [[NetworkDetailViewController alloc]init];
                    netWorkVC.dictionary = [result objectForKey:@"detail"];
                    [self.navigationController pushViewController:netWorkVC animated:YES];
                    
                }else{
                }
                
            }, ^(id result) {
                
            });
            
        }
            break;
        default:
            break;
    }

}

- (void)changeBubblePosition
{
    if (selectedAV) {
        CGRect rect = selectedAV.frame;
        CGPoint center;
        center.x = rect.origin.x + rect.size.width/2;
        center.y = rect.origin.y - bubbleView.frame.size.height/2 + 20;
        bubbleView.center = center;
    }
}

- (void)bounce1AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)showBubble:(BOOL)show
{
    if (show) {
        
        CGRect rect = CGRectMake(0, 0, 150, 65);
        //        [bubbleView showFromRect:selectedAV.frame];
        [bubbleView showFromRect:rect];
        
        bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
        bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        bubbleView.hidden = NO;
        //        bubbleView.center = center;
        
        [UIView commitAnimations];
        
    }
    else {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        
        bubbleView.hidden = YES;
        [UIView commitAnimations];
    }
}

#pragma mark == 关闭弹出的标注
-(void)closeAnnotationViews
{
    NSLog(@"关闭弹出的标注");
    
    if (selectedAV) {
        [self showBubble:NO];
    }
    selectedAV = nil;
}

#pragma mark show bubble animation
- (void)bounce4AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/6];
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(bounce5AnimationStopped)];
    bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView commitAnimations];
}

- (void)bounce3AnimationStopped
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce4AnimationStopped)];
    bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce3AnimationStopped)];
    bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
    [UIView commitAnimations];
}


//- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
//{
//    [mapView bringSubviewToFront:view];
//    [mapView setNeedsDisplay];
//}
/////////////////////////////////////////////////////////////////////////////////////

//-(void)addSearchBar
//{
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
//    titleView.backgroundColor = [UIColor clearColor];
//    
//    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
//    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, kScreenWidth-120, searchImg.size.height/3+5)];
//    searchImgView.image = searchImg;
//    searchImgView.userInteractionEnabled = YES;
//    [titleView addSubview:searchImgView];
//    
//    UITextField *searchFiled = [[UITextField alloc]initWithFrame:CGRectMake(50, 0,kScreenWidth-170, searchImg.size.height/3+5)];
//    searchFiled.backgroundColor = [UIColor clearColor];
//    searchFiled.text = @"输入搜索地址";
//    searchFiled.textColor = [UIColor whiteColor];
//    searchFiled.font = [UIFont systemFontOfSize:15.0];
//    searchFiled.userInteractionEnabled = NO;
//    [searchImgView addSubview:searchFiled];
//    
//    UIImage *seaBtnImg = [UIImage imageNamed:@"search_btn.png"];
//    UIImageView *searchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, seaBtnImg.size.width/2.5, seaBtnImg.size.height/2.5)];
//    searchBtn.image = seaBtnImg;
//    searchBtn.userInteractionEnabled = YES;
//    [searchImgView addSubview:searchBtn];
//    
//    UIButton *seachButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 3, kScreenWidth-130, searchImg.size.height/3+5)];
//    [seachButton setBackgroundColor:[UIColor clearColor]];
//    [seachButton addTarget:self action:@selector(seachButton) forControlEvents:UIControlEventTouchUpInside];
//    [searchImgView addSubview:seachButton];
//    
//    self.navigationItem.titleView = titleView;
//}
//
//#pragma mark == 搜索按钮
//-(void)seachButton
//{
//    SearchAddressViewController *searchVC = [[SearchAddressViewController alloc]init];
//    [self.navigationController pushViewController:searchVC animated:YES];
//}

#pragma mark ==  UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return dataArray.count;
    }else if (tableView == self.tableView1) {
        return dataArray.count;
    }else{
        return coorArr.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *identifier = @"identifier";
        SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.leftLable.text = [dataArray objectAtIndex:indexPath.row];
        cell.leftImgView.image = [UIImage imageNamed:[leftImgArr objectAtIndex:indexPath.row]];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user objectForKey:@"businessType"];
        [user objectForKey:@"infoType"];
        
        NSLog(@"%@",[user objectForKey:@"businessType"]);
        NSLog(@"%@",[user objectForKey:@"infoType"]);
        
        NSInteger row = [indexPath row];
        
        NSInteger oldRow = [lastPath row];
        
        if (row == oldRow && lastPath!=nil) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
        
        
        return cell;
        
    }else if (tableView == self.tableView1) {
        static NSString *identifier1 = @"identifier1";
        SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        
        cell.leftLable.text = [dataArray1 objectAtIndex:indexPath.row];
        cell.leftImgView.image = [UIImage imageNamed:[rightImgArr objectAtIndex:indexPath.row]];
        UIImage *img = [UIImage imageNamed:@"负责人.png"];
        
        if (indexPath.row == 2) {
            
            cell.leftImgView.frame = CGRectMake(8, 10, img.size.width/2, img.size.height/2);
        }
        
        NSUInteger row = [indexPath row];
        NSString *strRow;
        
        strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];

        NSMutableDictionary *dic = [contacts1 objectAtIndex:row];
        [dic setValue:@"NO" forKey:@"checked1"];
        [cell setChecked:NO];
        
        
        return cell;
        
    }else{
        
        static NSString *searchCell = @"searchCell";
        SearchAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
        if (!cell) {
            cell = [[SearchAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell];
        }
        
        cell.titleLable.text = [searchArr objectAtIndex:indexPath.row];
        return cell;

    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableView) {
   
        int newRow = [indexPath row];
        
        int oldRow = (lastPath !=nil)?[lastPath row]:-1;
        
        NSString *strRow = [NSString stringWithFormat:@"%@",[bussID objectAtIndex:indexPath.row]];
        
        if (newRow != oldRow) {
            
            SelectTableViewCell *newCell = (SelectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            SelectTableViewCell *oldCell = (SelectTableViewCell*)[tableView cellForRowAtIndexPath:lastPath];
            
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            
            lastPath = indexPath;
            [slectIdDic setObject:strRow forKey:@"lastPath"];
        }
        
        
        NSLog(@"<><><><>%@",slectIdDic);
        
    }else if (tableView == self.tableView1){
        SelectTableViewCell *cell = (SelectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSUInteger row = [indexPath row];
        NSString *strRow;
        NSMutableDictionary *dic = [contacts1 objectAtIndex:row];
        
        NSString *strTag = [NSString stringWithFormat:@"%@",[infoID objectAtIndex:indexPath.row]];

        if ([[dic objectForKey:@"checked1"] isEqualToString:@"NO"]) {
            
            [dic setObject:@"YES" forKey:@"checked1"];
            [cell setChecked:YES];
            NSString *strPID = [NSString stringWithFormat:@"%@",strTag];
            strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            [slectDic1 setValue:strPID forKey:strRow];
        }else {
            [dic setObject:@"NO" forKey:@"checked1"];
            [cell setChecked:NO];
            strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            [slectDic1 removeObjectForKey:strRow];
        }

    }else{
        
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
        searchTag = 1111;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView){
        return 44;
    }else if (tableView == self.tableView1){
        return 44;
    }else{
       return 30;
    }
    
}

#pragma mark == 显示backview
-(void)showBackView
{
    CATransition *myanim = [CATransition animation];
    myanim.type = kCATransitionMoveIn;          //界面切换的方式
    myanim.subtype = kCATransitionReveal;  //界面切换的方向
    myanim.duration = 1.0;
    
    [backView.layer addAnimation:myanim forKey:@"trans"];
    backView.hidden = NO;
}

#pragma mark == UITapGestureRecognizer
- (void)tapPicker:(UITapGestureRecognizer*)sender
{
    CATransition *myanim = [CATransition animation];
    myanim.type = kCATransitionMoveIn;          //界面切换的方式
    myanim.subtype = kCATransitionFade;  //界面切换的方向
    myanim.duration = 0.3;
    [backView.layer addAnimation:myanim forKey:@"trans"];
    
    UIView* backView11 = (UIView*)sender.view;
    backView11.hidden = YES;
}

//<><><><><><><><><<<><><><><><><><><>><><><><><><><><><><><>><><><><>//
//#pragma mark == 点击信息
//-(void)infoBtn
//{
//    [taskbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [taskbtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
//    
//    
//    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [infoBtn setBackgroundColor:[UIColor clearColor]];
//    
//    self.tableView.hidden = NO;
//    self.tableView1.hidden = YES;
//    
//}
//
//#pragma mark == 任务分类
//-(void)taskbtn
//{
//    [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [infoBtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
//    [taskbtn setBackgroundColor:[UIColor clearColor]];
//    [taskbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    self.tableView.hidden = YES;
//    self.tableView1.hidden = NO;
//    
//}
//
//- (void)mapBtn:(NSInteger)index
//{
//    if (index == 0) {
//        
//        self.tableView.hidden = NO;
//        self.tableView1.hidden = YES;
//        
//    }else{
//        
//        self.tableView.hidden = YES;
//        self.tableView1.hidden = NO;
//        
//        
//    }
//}
//
//-(void)showBtn
//{
//    searchTableView.hidden = YES;
//    searchTag = 123456;
//    [_mapView removeAnnotation:pointAnnotation];
//    
//    classView.hidden = NO;
//    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [infoBtn setBackgroundColor:[UIColor whiteColor]];
//    
//    [taskbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [taskbtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
//    
//    
//    closeBtn.hidden = NO;
//    showBtn.hidden = YES;
//    
//    
//    self.tableView.hidden = NO;
//    self.tableView1.hidden = YES;
//    
//    [self.tableView reloadData];
//    
//    
//}
//
//#pragma mark == 关闭按钮
//-(void)closeBtn
//{
//    NSLog(@"点击了关闭按钮");
//    //    mapBackView.hidden = YES;
//    classView.hidden = YES;
//    closeBtn.hidden = YES;
//    showBtn.hidden = NO;
//    self.tableView.hidden = YES;
//    self.tableView1.hidden = YES;
//    
//    [slectArray removeAllObjects];
//    
//    NSArray *keys1 = [slectDic1 allKeys];
//    NSMutableArray *arr1 = [[NSMutableArray alloc]initWithCapacity:10];
//    id key1;
//    [arr1 removeAllObjects];
//    for (int i = 0; i < [keys1 count]; i++) {
//        key1 = [keys1 objectAtIndex:i];
//        
//        NSLog(@"Key1:%@",key1);
//        
//        [arr1 addObject:[slectDic1 objectForKey:key1]];
//        
//    }
//    NSLog(@"arr1 ==>%@",arr1);
//    [slectArray addObjectsFromArray:arr1];
//    
//    NSLog(@"slectArray==>%@",slectArray);
//    
//    NSLog(@"<><><><>%@",slectIdDic);
//    
//    
//    NSString *txl = [slectArray componentsJoinedByString:@","];
//    NSLog(@"str==%@",txl);
//    NSString *str = [slectIdDic objectForKey:@"lastPath"];
//    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    
//    if (slectArray.count == 0 && slectIdDic.count != 0) {
//        
//        showAlert(@"请选择信息类型");
//        
//    }else if(slectArray.count != 0 && slectIdDic.count == 0){
//        
//        showAlert(@"请选择业务类型");
//        
//    }else{
//        
//        [user setObject:str forKey:@"businessType"];
//        [user setObject:txl forKey:@"infoType"];
//        
//        [self nearbyResult:txl :str];
//    }
//    
//}
//<><><><><><><><><<<><><><><><><><><>><><><><><><><><><><><>><><><><>//



#pragma mark == 搜索地址
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tableView.hidden = YES;
    self.tableView1.hidden = YES;
    searchTag = 123;
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




#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    [searchArr removeAllObjects];
    
    [_locationService stopUserLocationService];
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
//        [_mapView removeAnnotations:annotations];
        [_mapView addAnnotations:annotations];
        //        [_mapView showAnnotations:annotations animated:YES];
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
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
