//
//  MapViewController.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "MapViewController.h"
#import "SearchViewController.h"
#import "LeftViewController.h"
#import "MapBackView.h"
#import "SelectTableViewCell.h"
#import "KYPointAnnotation.h"
#import "MapDetailViewController.h"
#import "AllTaskViewController.h"
#import "NetworkDetailViewController.h"
#import "RoomDetailViewController.h"
#import "JuzhanDetailViewController.h"
#import "TemporaryViewController.h"
#import "JuzhanViewController.h"
#import "RoomViewController.h"
#import "NetworkViewController.h"
#import "MyTaskListViewController.h"

static CGFloat kTransitionDuration = 0.45f;

@interface MapViewController ()<BMKPoiSearchDelegate,UISearchBarDelegate,mapBtndelegate,UIScrollViewDelegate,BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate,KYdelegate>
{
    BMKMapView* _mapView;
    BMKLocationService *_locationService;
    KYBubbleView *bubbleView;
    
    BMKAnnotationView* newAnnotation;
    BMKAnnotationView *selectedAV;
    BMKPoiSearch *poisearch;
    BMKBasePoiSearchOption *basePoiSearch;
    BMKPointAnnotation* pointAnnotation;
    NSInteger paopaoTag;
    UISearchBar *mySearchBar;
    UIView *backView;
    MapBackView *mapBackView;
    
    NSMutableArray *slectArray;//选中每行存入数组
    NSMutableDictionary *slectDic;//选中每行存入字典
    NSMutableDictionary *slectDic1;//选中每行存入字典
    NSMutableArray *contacts;
    NSMutableArray *dataArray;
    
    NSMutableArray *contacts1;
    NSMutableArray *dataArray1;
    UIButton *closeBtn;
    UIButton *showBtn;
    NSString *leftUpSmx;
    NSString *leftUpSmy;
    NSString *rightDownSmx;
    NSString *rightDownSmy;
    NSString *inType;
    
    UIView *classView;
    UIButton *infoBtn;
    UIButton *taskbtn;
    
    NSMutableArray *smxyArray;//搜索到的数组
    NSMutableArray *annotationsArray;
    NSInteger clickTag;
    CLLocationManager *locationManager;
    NSString *strLevel;//比例尺
    
    NSArray *leftImgArr;
    NSArray *rightImgArr;
    
    NSString *strMapType;
    
    BMKMapManager *mgr;
    NSMutableArray *idArr;
    NSMutableArray *idArr1;
    NSMutableArray *idArr2;
    NSMutableArray *idArr3;
    NSMutableArray *idArr4;
    NSMutableArray *idArr5;
    NSMutableArray *idArr6;
    NSMutableArray *idArr7;
}
@end

@implementation MapViewController

#pragma mark 地图将要出现
-(void)viewWillAppear:(BOOL)animated
{   self.backBtn.hidden=YES;
    if (self.tag == 10 || self.VCtag == 10000) {
        [self hiddenBottomBar:YES];
    }else{
        [self hiddenBottomBar:NO];
    }
    [_mapView viewWillAppear];
    self.navigationController.navigationBarHidden = NO;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationService.delegate = self;
}

#pragma mark 地图将要消失
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    [_locationService stopUserLocationService];
    _mapView.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil; // 不用时，置nil
}

-(void)addNavTitle :(NSString *)str
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel* titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-160, 44)];
    titlelabel.text = str;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [titleView addSubview:titlelabel];
    self.navigationItem.titleView = titleView;
    titlelabel.textAlignment=NSTextAlignmentCenter;
    
}

-(void)addLSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-8, 7, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    [titleView addSubview:searchImgView];
    
    UITextField *searchFiled = [[UITextField alloc]initWithFrame:CGRectMake(50, 0,kScreenWidth-170, searchImg.size.height/3+5)];
    searchFiled.backgroundColor = [UIColor clearColor];
    searchFiled.text = @"输入站点、名称";
    searchFiled.textColor = [UIColor whiteColor];
    searchFiled.font = [UIFont systemFontOfSize:15.0];
    [searchImgView addSubview:searchFiled];
    
    UIImage *seaBtnImg = [UIImage imageNamed:@"search_btn.png"];
    UIImageView *searchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, seaBtnImg.size.width/2.5, seaBtnImg.size.height/2.5)];
    searchBtn.image = seaBtnImg;
    searchBtn.userInteractionEnabled = YES;
    [searchImgView addSubview:searchBtn];
    
    UIButton *seachButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 3, kScreenWidth-130, searchImg.size.height/3+5)];
    [seachButton setBackgroundColor:[UIColor clearColor]];
    [seachButton addTarget:self action:@selector(seachButton) forControlEvents:UIControlEventTouchUpInside];
    [searchImgView addSubview:seachButton];
    
    self.navigationItem.titleView = titleView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    smxyArray = [[NSMutableArray alloc]initWithCapacity:10];
    annotationsArray = [[NSMutableArray alloc]initWithCapacity:10];
    idArr = [[NSMutableArray alloc]initWithCapacity:10];
    idArr1 = [[NSMutableArray alloc]initWithCapacity:10];
    idArr2 = [[NSMutableArray alloc]initWithCapacity:10];
    idArr3 = [[NSMutableArray alloc]initWithCapacity:10];
    idArr4 = [[NSMutableArray alloc]initWithCapacity:10];
    idArr5 = [[NSMutableArray alloc]initWithCapacity:10];
    idArr6 = [[NSMutableArray alloc]initWithCapacity:10];
    idArr7 = [[NSMutableArray alloc]initWithCapacity:10];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    strMapType = [user objectForKey:@"type"];
    
    if (self.tag == 10 || self.VCtag == 10000) {
        [self addNavigationLeftButton];
        [self addLSearchBar];
        [self addNavigationRightButton:@"头像.png"];
        [self initView];
    }else{
        [self addSearchBar];
        [self addNavigationRightButton:@"头像.png"];
        [self addMessageAndSaoSao:@"message.png"];
        [self initView];
    }
    
    bubbleView = [[KYBubbleView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    bubbleView.delegate = self;
    bubbleView.hidden = YES;
    
    backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor grayColor];
    backView.alpha = 0.3;
    backView.hidden = YES;
    [self.view addSubview:backView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPicker:)];
    [backView addGestureRecognizer:tap];
    
    
    classView = [[UIView alloc]initWithFrame:CGRectMake(45, 150, kScreenWidth-90, 35)];
    classView.backgroundColor = [UIColor whiteColor];
    classView.hidden = YES;
    [self.view addSubview:classView];
    
    infoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-90)/2, 35)];
    [infoBtn setTitle:@"信息" forState:UIControlStateNormal];
    infoBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [infoBtn setBackgroundColor:[UIColor clearColor]];
    [infoBtn addTarget:self action:@selector(infoBtn) forControlEvents:UIControlEventTouchUpInside];
    [classView addSubview:infoBtn];
    
    taskbtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-90)/2, 0, (kScreenWidth-90)/2, 35)];
    [taskbtn setTitle:@"任务" forState:UIControlStateNormal];
    taskbtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [taskbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [taskbtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
    [taskbtn addTarget:self action:@selector(taskbtn) forControlEvents:UIControlEventTouchUpInside];
    [classView addSubview:taskbtn];
    
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
    
    slectDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    slectDic1 = [[NSMutableDictionary alloc]initWithCapacity:0];
    slectArray = [[NSMutableArray alloc]initWithCapacity:0];
    dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    contacts = [NSMutableArray array];
    dataArray1 = [[NSMutableArray alloc]initWithCapacity:0];
    contacts1 = [NSMutableArray array];
    
    dataArray = (NSMutableArray *)@[@"局站",@"机房",@"网元"];
    dataArray1 = (NSMutableArray *)@[@"周期任务",@"故障",@"预约",@"隐患",@"动力"];
    
    for (int i = 0; i <dataArray.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [contacts addObject:dic];
        
    }
    
    for (int i = 0; i <dataArray1.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked1"];
        [contacts1 addObject:dic];
    }
    
    leftImgArr = @[@"map_icn3.png",@"map_icon9.png",@"map_icon8.png"];
    rightImgArr = @[@"map_icon7.png",@"map_icon4.png",@"map_icon2.png",@"map_icon5.png"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(45, 185, kScreenWidth-90, 44*3) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    self.tableView.scrollEnabled=NO;
    [self.view addSubview:self.tableView];
    
    self.tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(45, 185, kScreenWidth-90, 44*4) style:UITableViewStylePlain];
    self.tableView1.dataSource = self;
    self.tableView1.delegate = self;
    self.tableView1.hidden = YES;
    self.tableView1.scrollEnabled=NO;
    [self.view addSubview:self.tableView1];
    
}

#pragma mark == 点击信息
-(void)infoBtn
{
    [taskbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [taskbtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
    
    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [infoBtn setBackgroundColor:[UIColor clearColor]];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    strMapType = [user objectForKey:@"type"];
    
    self.tableView.hidden = NO;
    self.tableView1.hidden = YES;
    //    [self.tableView reloadData];
}

#pragma mark == 任务分类
-(void)taskbtn
{
    [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoBtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
    [taskbtn setBackgroundColor:[UIColor clearColor]];
    [taskbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    strMapType = [user objectForKey:@"type"];
    
    self.tableView.hidden = YES;
    self.tableView1.hidden = NO;
    //        [self.tableView1 reloadData];
}

- (void)mapBtn:(NSInteger)index
{
    if (index == 0) {
        
        self.tableView.hidden = NO;
        self.tableView1.hidden = YES;
        //        [self.tableView reloadData];
        
    }else{
        //        dataArray1 = (NSMutableArray *)@[@"故障",@"隐患",@"预约",@"周期任务",@"动力"];
        
        self.tableView.hidden = YES;
        self.tableView1.hidden = NO;
        //        [self.tableView1 reloadData];
    }
}

-(void)showBtn
{
    [_mapView removeAnnotation:pointAnnotation];
    
    classView.hidden = NO;
    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [infoBtn setBackgroundColor:[UIColor whiteColor]];
    
    [taskbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [taskbtn setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
    
    
    closeBtn.hidden = NO;
    showBtn.hidden = YES;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    strMapType = [user objectForKey:@"type"];
    
    NSArray *arr = @[@"5",@"6",@"7"];
    [contacts removeAllObjects];
    for (int i = 0; i <dataArray.count; i++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        if ([strMapType rangeOfString:[arr objectAtIndex:i]].location != NSNotFound) {
            [dic setValue:@"YES" forKey:@"checked"];
            [contacts addObject:dic];
        }else{
            [dic setValue:@"NO" forKey:@"checked"];
            [contacts addObject:dic];
        }
    }
    
    self.tableView.hidden = NO;
    self.tableView1.hidden = YES;
    
    [self.tableView reloadData];
    //    [self.tableView1 reloadData];
}

#pragma mark - 选好筛选条件开始搜索
-(void)closeBtn
{
    classView.hidden = YES;
    closeBtn.hidden = YES;
    showBtn.hidden = NO;
    self.tableView.hidden = YES;
    self.tableView1.hidden = YES;
    
    [slectArray removeAllObjects];
    
    NSArray *keys = [slectDic allKeys];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:10];
    id key;
    [arr removeAllObjects];
    for (int i = 0; i < [keys count]; i++) {
        key = [keys objectAtIndex:i];
        [arr addObject:[slectDic objectForKey:key]];
    }
    
    
    for (int i = 0; i<4; i++) {
        NSMutableDictionary *dic = [contacts1 objectAtIndex:i];
        if ([[dic objectForKey:@"checked1"] isEqualToString:@"YES"]) {
            NSString *strPID = [NSString stringWithFormat:@"%d",i+1];
            //            [slectArray addObject:strPID];
            NSString *strRow = [NSString stringWithFormat:@"%d",i];
            [slectDic1 setValue:strPID forKey:strRow];
        }
    }
    
    
    NSArray *keys1 = [slectDic1 allKeys];
    NSMutableArray *arr1 = [[NSMutableArray alloc]initWithCapacity:10];
    id key1;
    [arr1 removeAllObjects];
    for (int i = 0; i < [keys1 count]; i++) {
        key1 = [keys1 objectAtIndex:i];
        
        [arr1 addObject:[slectDic1 objectForKey:key1]];
        
    }
    [slectArray addObjectsFromArray:arr];
    [slectArray addObjectsFromArray:arr1];
    
    NSString *txl = [slectArray componentsJoinedByString:@","];
    
    inType = txl;
    
    if (slectArray.count == 0) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"" forKey:@"type"];
    }else{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:inType forKey:@"type"];
        
        [self nearbyResult:inType];
    }
}

#pragma mark == 获取附近结果信息
-(void)nearbyResult:(NSString *)strType
{
    if (leftUpSmx == nil && leftUpSmy == nil && rightDownSmx == nil && rightDownSmy == nil) {
        [self showAlertWithTitle:@"抱歉" :@"正在定位,请稍后再试!" :@"确定" :nil];
    }else{
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myInfo/GetNearbyResult";
        paraDict[@"leftUpSmx"] = leftUpSmx;//左上方经度
        paraDict[@"leftUpSmy"] = leftUpSmy;//左上方纬度
        paraDict[@"rightDownSmx"] = rightDownSmx;//右下方经度
        paraDict[@"rightDownSmy"] = rightDownSmy;//右下方经度
        paraDict[@"inType"] = strType;
        paraDict[@"mapScale"] = strLevel;
        DLog(@"paraDict <==> %@",paraDict);
        //搜索类型(多个以,分割)、其中查询类型:1 周期工作  2故障 3预约 4隐患 5局站 6机房 7网元
        httpPOST(paraDict, ^(id result) {
            DLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                
                [_mapView removeAnnotations:annotationsArray];
                [annotationsArray removeAllObjects];
                [smxyArray removeAllObjects];
                
                CLLocationCoordinate2D coor;
                smxyArray = [result objectForKey:@"list"];
                
                for (int i = 0; i<smxyArray.count; i++) {
                    KYPointAnnotation* annotation = [[KYPointAnnotation alloc]init];
                    annotation.tag = i;
                    coor.latitude = [[smxyArray[i] objectForKey:@"smy"] doubleValue];
                    coor.longitude = [[smxyArray[i] objectForKey:@"smx"] doubleValue];
                    annotation.coordinate = coor;
                    annotation.title = [smxyArray[i] objectForKey:@"address"];    //标题
                    [_mapView addAnnotation:annotation];
                }
            }
        }, ^(id result) {
            [_mapView removeAnnotations:annotationsArray];
            [annotationsArray removeAllObjects];
            [smxyArray removeAllObjects];
            DLog(@"%@",result);
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

#pragma mark == 中间搜索框
-(void)seachButton
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)initView
{
    locationManager = [[CLLocationManager alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        //        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        locationManager.allowsBackgroundLocationUpdates = YES;
    }
    
    [self setUpMapView];
}

#pragma mark - 搭建地图界面
- (void)setUpMapView
{
    _locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-110)];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.buildingsEnabled = NO;
    _mapView.zoomLevel = 18.0;
    [_baseScrollView addSubview:_mapView];
    _mapView.showMapScaleBar = YES;
    //自定义比例尺的位置
    _mapView.mapScaleBarPosition = CGPointMake(10, _mapView.frame.size.height - 45);
    
    int zoom = (int)_mapView.zoomLevel;
    NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",@"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",@"2000000"];
    
    strLevel = [zoomArr objectAtIndex:(19-zoom)];
    
    BMKLocationViewDisplayParam *loaction = [[BMKLocationViewDisplayParam alloc]init];
    loaction.isRotateAngleValid = true;//跟随态旋转角度是否生效
    loaction.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:loaction];
    
    _baseScrollView.scrollEnabled = NO;
    
    UIImage *dingweiImg = [UIImage imageNamed:@"定位.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, kScreenHeight-125, dingweiImg.size.width/2, dingweiImg.size.height/2);
    [button setBackgroundImage:dingweiImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIImage *zoomImg = [UIImage imageNamed:@"zoom_box.png"];
    UIImage *zoomImg1 = [UIImage imageNamed:@"zoom+.png"];
    UIImage *zoomImg2 = [UIImage imageNamed:@"zoom-.png"];
    UIImageView *zoomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-35, kScreenHeight-130, zoomImg.size.width/2-2, zoomImg.size.height/2)];
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
    
    if (self.tag == 10 || self.VCtag == 10000) {
        [_mapView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        [zoomImgView setFrame:CGRectMake(kScreenWidth-35, kScreenHeight-100, zoomImg.size.width/2-2, zoomImg.size.height/2)];
    }else{
        [_mapView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-110)];
    }
    
    [_locationService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
}

#pragma mark == 放大地图
-(void)addZoom
{
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
        
        NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",
                             @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",
                             @"2000000"];
        
        strLevel = [zoomArr objectAtIndex:(19-zoom)];
    }else{
        _mapView.zoomLevel = --_mapView.zoomLevel;
    }
}

#pragma mark == 定位
-(void)startUserLocation
{
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
}

-(void)rightAction
{
    DLog(@"点击了头像");
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.menuController showRightController:YES];
}

-(void)leftAction
{
    if (self.tag == 10 || self.VCtag == 10000 || self.VCtag == 20000) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        LeftViewController *leftController = [[LeftViewController alloc] init];
        [self.navigationController pushViewController:leftController animated:YES];
    }
}


#pragma mark 验证电话号码
-(BOOL)validateMobile:(NSString* )mobileNumber
{
    NSString *mobileStr = @"^((145|147)|(15[^4])|(17[6-8])|((13|18)[0-9]))\\d{8}$";
    NSPredicate *cateMobileStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileStr];
    
    if ([cateMobileStr evaluateWithObject:mobileNumber]==YES)
    {
        return YES;
    }
    return NO;
}

-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if(errorCode == BMK_SEARCH_NO_ERROR){
        //在此处理正常结果
    }
    BMKLocationShareURLOption *hhh = [[BMKLocationShareURLOption alloc]init];
    DLog(@"hhh == %@",hhh.name);
}

#pragma mark 地图zoomlevel++
#pragma mark 地图长按事件
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    DLog(@"长按");
}

#pragma mark 地图双击手势
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    DLog(@"双击");
}

#pragma mark 在开时定位时调用
- (void)willStartLocatingUser
{
    CLLocationCoordinate2D coor;
    coor.latitude = 31.238907;
    coor.longitude = 121.479140;
    [_mapView setCenterCoordinate:coor animated:YES];
}

#pragma mark 设置大头针
#pragma mark 标注
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if (self.VCtag == 10000) {
        
        if (annotation == pointAnnotation) {
            NSString *AnnotationViewID = @"renameMark";
            BMKPinAnnotationView *antionView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
            //            if (antionView == nil) {
            antionView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            antionView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            //                antionView.animatesDrop = YES;
            // 设置可拖拽
            antionView.draggable = YES;
            //            }
            return antionView;
        }
        
        return nil;
        
    }else{
        
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[mapView viewForAnnotation:annotation];
        
        if (annotationView == nil)
        {
            KYPointAnnotation *ann;
            if ([annotation isKindOfClass:[KYPointAnnotation class]]) {
                ann = annotation;
            }
            
            NSUInteger tag = ann.tag;
            NSString *AnnotationViewID = [NSString stringWithFormat:@"AnnotationView-%i", tag];
            
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:AnnotationViewID];
            
            annotationView.canShowCallout = NO;//使用自定义bubble
            
            
            if ([[annotation title] isEqualToString:@"我的位置"]) {
                
                ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"pin_purple@2x.png"];
            }
            else{
                for (int i = 0; i<smxyArray.count; i++)
                {
                    
                    
                    if ([[[smxyArray objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"1"]) {
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"smy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"smx"] doubleValue]){
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 14, 14)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = 7;
                            numLable.font = [UIFont systemFontOfSize:11.0];
                            numLable.backgroundColor = [UIColor orangeColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [annotationView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icon7.png"];
                            
                        }else{
                            
                            
                        }
                        
                        
                        
                        
                    }else if ([[[smxyArray objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"2"]) {
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"smy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"smx"] doubleValue]){
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 14, 14)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = 7;
                            numLable.font = [UIFont systemFontOfSize:11.0];
                            numLable.backgroundColor = [UIColor orangeColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [annotationView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icon4.png"];
                            
                        }else{
                            
                            
                        }
                        
                        
                        
                        
                    }else if ([[[smxyArray objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"3"]) {
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"smy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"smx"] doubleValue]){
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 14, 14)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = 7;
                            numLable.font = [UIFont systemFontOfSize:11.0];
                            numLable.backgroundColor = [UIColor orangeColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [annotationView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icon2.png"];
                            
                        }else{
                            
                            
                        }
                        
                        
                        
                    }else if ([[[smxyArray objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"4"]) {
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"smy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"smx"] doubleValue]){
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 14, 14)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = 7;
                            numLable.font = [UIFont systemFontOfSize:11.0];
                            numLable.backgroundColor = [UIColor orangeColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [annotationView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icon5.png"];
                            
                        }else{
                            
                            
                        }
                        
                        
                        
                    }else if ([[[smxyArray objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"5"]) {
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"smy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"smx"] doubleValue]){
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 14, 14)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = 7;
                            numLable.font = [UIFont systemFontOfSize:11.0];
                            numLable.backgroundColor = [UIColor orangeColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [annotationView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icn3.png"];
                        }else{
                            
                            
                        }
                        
                        
                        
                    }else if ([[[smxyArray objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"6"]) {
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"smy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"smx"] doubleValue]){
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 14, 14)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = 7;
                            numLable.font = [UIFont systemFontOfSize:11.0];
                            numLable.backgroundColor = [UIColor orangeColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [annotationView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icon9.png"];
                            
                        }else{
                            
                            
                        }
                        
                        
                        
                    }else if ([[[smxyArray objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"7"]) {
                        
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"smy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"smx"] doubleValue]){
                            
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 14, 14)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = 7;
                            numLable.font = [UIFont systemFontOfSize:11.0];
                            numLable.backgroundColor = [UIColor orangeColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [annotationView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icon8.png"];
                        }else{
                        }
                    }else if ([[[smxyArray objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"8"]){
                        if (annotation.coordinate.latitude == [[smxyArray[i] objectForKey:@"smy"] doubleValue] && annotation.coordinate.longitude == [[smxyArray[i] objectForKey:@"smx"] doubleValue]){
                            UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 14, 14)];
                            numLable.layer.masksToBounds = YES;
                            numLable.layer.cornerRadius = 7;
                            numLable.font = [UIFont systemFontOfSize:11.0];
                            numLable.backgroundColor = [UIColor orangeColor];
                            numLable.textColor = [UIColor whiteColor];
                            numLable.textAlignment = NSTextAlignmentCenter;
                            [annotationView addSubview:numLable];
                            numLable.text = [[smxyArray objectAtIndex:i]objectForKey:@"content"];
                            ((BMKPinAnnotationView*) annotationView).image = [UIImage imageNamed:@"map_icon_10.png"];
                            
                        }else{
                            
                        }
                    }
                }
            }
            //        1.周期工作 2.故障 3.预约 4.隐患 5.局站 6.机房 7.网元
            annotationView.annotation = annotation;
        }
        return annotationView ;
    }
}

/**
 *设定当前地图的显示范围,采用直角坐标系表示
 *@param mapRect 要设定的地图范围，用直角坐标系表示
 *@param animate 是否采用动画效果
 */
- (void)setVisibleMapRect:(BMKMapRect)mapRect animated:(BOOL)animate
{
    
}

//当选中一个annotationviews时，调用此接口
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //设定是否总让选中的annotaion置于最前面
    _mapView.isSelectedAnnotationViewFront = YES;
    DLog(@"选中一个annotationviews:%f,%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
    
    if (self.VCtag == 10000) {
        
    }else{
        
        if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
            
            NSDictionary *mapDic = [smxyArray objectAtIndex:[(KYPointAnnotation*)view.annotation tag]];
            
            selectedAV = view;
            if (bubbleView.superview == nil) {
                //bubbleView加在BMKAnnotationView的superview(UIScrollView)上,且令zPosition为1
                [view.superview addSubview:bubbleView];
                bubbleView.layer.zPosition = 1;
            }
            bubbleView.infoDict = [smxyArray objectAtIndex:[(KYPointAnnotation*)view.annotation tag]];
            paopaoTag = [(KYPointAnnotation*)view.annotation tag];
            
            [bubbleView.rightButton addTarget:self action:@selector(closeAnnotationViews) forControlEvents:UIControlEventTouchUpInside];
            
            
            //[self showBubble:YES];先移动地图，完成后再显示气泡
            if ([[mapDic objectForKey:@"nearPointList"]count] == 0){
                
                bubbleView.hidden = YES;
                
                if ([[mapDic objectForKey:@"type"]isEqualToString:@"1"]) {
                    
                    //                    MyWorkViewController *ctrl = [[MyWorkViewController alloc] init];
                    //                    [self.navigationController pushViewController:ctrl animated:YES];
                    NSDictionary *paraDict = mapDic;
                    MyTaskListViewController *taskVC = [[MyTaskListViewController alloc] init];
                    
                    taskVC.taskTag = 200;
                    taskVC.planDate = date2str(self.date, DATE_FORMAT);
                    taskVC.site = paraDict;
                    [self.navigationController pushViewController:taskVC animated:YES];
                    
                }else if ([[mapDic objectForKey:@"type"]isEqualToString:@"2"]) {
                    
                    //                    MyRepairFaultListKB *ctrl = [[MyRepairFaultListKB alloc] init];
                    //                    [self.navigationController pushViewController:ctrl animated:YES];
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                    paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
                    paraDict[@"regionId"] = mapDic[@"siteId"];
                    paraDict[@"taskType"] = @"2";
                    paraDict[@"curPage"] = @"1";
                    paraDict[@"pageSize"] = @"10";
                    
                    
                    httpPOST(paraDict, ^(id result) {
                        DLog(@"%@",result);
                        if ([result[@"result"] isEqualToString:@"0000000"]){
                            
                            AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                            allVC.vcTag = 100;
                            allVC.allArr = [result objectForKey:@"list"];
                            allVC.strID = mapDic[@"siteId"];
                            allVC.strType = @"2";
                            [self.navigationController pushViewController:allVC animated:YES];
                            
                        }else{
                            
                        }
                        
                    }, ^(id result) {
                        
                    });
                    
                    
                }else if ([[mapDic objectForKey:@"type"]isEqualToString:@"3"]) {
                    
                    //                    MyBookingAdd *ctrl = [[MyBookingAdd alloc] init];
                    //                    [self.navigationController pushViewController:ctrl animated:YES];
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                    paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
                    paraDict[@"regionId"] = mapDic[@"siteId"];
                    paraDict[@"taskType"] = @"3";
                    paraDict[@"curPage"] = @"1";
                    paraDict[@"pageSize"] = @"10";
                    
                    
                    httpPOST(paraDict, ^(id result) {
                        DLog(@"%@",result);
                        if ([result[@"result"] isEqualToString:@"0000000"]){
                            
                            AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                            allVC.vcTag = 100;
                            allVC.allArr = [result objectForKey:@"list"];
                            allVC.strID = mapDic[@"siteId"];
                            allVC.strType = @"3";
                            [self.navigationController pushViewController:allVC animated:YES];
                            
                        }else{
                            
                        }
                        
                    }, ^(id result) {
                        
                    });
                    
                    
                }else if ([[mapDic objectForKey:@"type"]isEqualToString:@"4"]) {
                    
                    //                    DoNothingViewController *ctrl = [[DoNothingViewController alloc] init];
                    //                    [self.navigationController pushViewController:ctrl animated:YES];
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                    paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
                    paraDict[@"regionId"] = mapDic[@"siteId"];
                    paraDict[@"taskType"] = @"4";
                    paraDict[@"curPage"] = @"1";
                    paraDict[@"pageSize"] = @"10";
                    
                    
                    httpPOST(paraDict, ^(id result) {
                        DLog(@"%@",result);
                        if ([result[@"result"] isEqualToString:@"0000000"]){
                            
                            AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                            allVC.vcTag = 100;
                            allVC.allArr = [result objectForKey:@"list"];
                            allVC.strID = mapDic[@"siteId"];
                            allVC.strType = @"4";
                            [self.navigationController pushViewController:allVC animated:YES];
                            
                        }else{
                            
                        }
                        
                    }, ^(id result) {
                        
                    });
                    
                    
                }else if ([[mapDic objectForKey:@"type"]isEqualToString:@"5"]) {
                    
                    //                    DoNothingViewController *ctrl = [[DoNothingViewController alloc] init];
                    //                    [self.navigationController pushViewController:ctrl animated:YES];
                    
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                    paraDict[URL_TYPE] = @"myRegion/GetRegionById";
                    paraDict[@"regionId"] = mapDic[@"siteId"];
                    
                    
                    httpGET2(paraDict, ^(id result) {
                        DLog(@"%@",result);
                        if ([result[@"result"] isEqualToString:@"0000000"])
                        {
                            JuzhanDetailViewController *judVC = [[JuzhanDetailViewController alloc]init];
                            judVC.dic = [result objectForKey:@"detail"];
                            [self.navigationController pushViewController:judVC animated:YES];
                            
                        }else{
                        }
                        
                    }, ^(id result) {
                        
                    });
                    
                    
                }else if ([[mapDic objectForKey:@"type"]isEqualToString:@"6"]) {
                    
                    //                    MyEngineRoom *ctrl = [[MyEngineRoom alloc] init];
                    //                    [self.navigationController pushViewController:ctrl animated:YES];
                    
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                    paraDict[URL_TYPE] = @"myRegion/GetRoomById";
                    paraDict[@"roomId"] = mapDic[@"roomId"];
                    
                    
                    httpGET2(paraDict, ^(id result) {
                        DLog(@"%@",result);
                        if ([result[@"result"] isEqualToString:@"0000000"])
                        {
                            
                            RoomDetailViewController *roomVC = [[RoomDetailViewController alloc]init];
                            roomVC.dataArr = [result objectForKey:@"detail"];
                            [self.navigationController pushViewController:roomVC animated:YES];
                            
                        }else{
                            
                        }
                        
                    }, ^(id result) {
                        
                    });
                    
                }else if ([[mapDic objectForKey:@"type"]isEqualToString:@"7"]) {
                    
                    //                    DoNothingViewController *ctrl = [[DoNothingViewController alloc] init];
                    //                    [self.navigationController pushViewController:ctrl animated:YES];
                    
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                    paraDict[URL_TYPE] = @"myRegion/GetNuById";
                    paraDict[@"nuId"] = mapDic[@"nuId"];
                    
                    httpGET2(paraDict, ^(id result) {
                        DLog(@"%@",result);
                        if ([result[@"result"] isEqualToString:@"0000000"])
                        {
                            NetworkDetailViewController *netWorkVC = [[NetworkDetailViewController alloc]init];
                            netWorkVC.dictionary = [result objectForKey:@"detail"];
                            [self.navigationController pushViewController:netWorkVC animated:YES];
                            
                        }else{
                        }
                        
                    }, ^(id result) {
                        
                    });
                    
                }else if ([[mapDic objectForKey:@"type"]isEqualToString:@"10"]) {
                    
                    //                    TemporaryViewController *temVC = [[TemporaryViewController alloc]init];
                    //                    [self.navigationController pushViewController:temVC animated:YES];
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                    paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
                    paraDict[@"regionId"] = mapDic[@"siteId"];
                    paraDict[@"taskType"] = @"10";
                    paraDict[@"curPage"] = @"1";
                    paraDict[@"pageSize"] = @"10";
                    
                    DLog(@"%@",paraDict);
                    httpPOST(paraDict, ^(id result) {
                        DLog(@"%@",result);
                        if ([result[@"result"] isEqualToString:@"0000000"])
                        {
                            
                            TemporaryViewController *temVC = [[TemporaryViewController alloc]init];
                            temVC.temArr = [result objectForKey:@"list"];
                            temVC.vcTag = 10;
                            temVC.strSearch = [NSString stringWithFormat:@"%@",mapDic[@"siteId"]];
                            
                            [self.navigationController pushViewController:temVC animated:YES];
                            
                            
                        }else{
                            
                        }
                        
                    }, ^(id result) {
                        
                    });
                    
                    
                }else{
                    
                    DoNothingViewController *ctrl = [[DoNothingViewController alloc] init];
                    [self.navigationController pushViewController:ctrl animated:YES];
                }
                
            }else{
                
                if (selectedAV) {
                    [self showBubble:YES];
                    [self changeBubblePosition];
                    bubbleView.infoDict = [smxyArray objectAtIndex:[(KYPointAnnotation*)view.annotation tag]];
                    paopaoTag = [(KYPointAnnotation*)view.annotation tag];
                    DLog(@"tag == %d",[(KYPointAnnotation*)view.annotation tag]);
                    
                }
                
            }
        }
        else {
            selectedAV = nil;
        }
        
    }
    //    [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

//当取消选中一个annotationviews时，调用此接口
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    DLog(@"取消选中一个annotation views");
    if (self.VCtag == 10000) {
        
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
    
    [idArr removeAllObjects];
    [idArr1 removeAllObjects];
    [idArr2 removeAllObjects];
    [idArr3 removeAllObjects];
    [idArr4 removeAllObjects];
    [idArr5 removeAllObjects];
    [idArr6 removeAllObjects];
    [idArr7 removeAllObjects];
    
    NSDictionary *mapDic = [smxyArray objectAtIndex:paopaoTag];
    
    NSArray *nearArr = [mapDic objectForKey:@"nearPointList"];
    
    DLog(@"%@",mapDic);
    DLog(@"%@",nearArr);
    
    
    NSString *key;  //周期工作
    NSString *key1; //故障
    NSString *key2; //预约
    NSString *key3; //隐患
    NSString *key4; //机房
    NSString *key5; //局站
    NSString *key6; //网元
    NSString *key7; //其他
    
    for (int i = 0; i < [nearArr count]; i++) {
        
        if ([[[[nearArr objectAtIndex:i] objectForKey:@"type"] description] isEqualToString:@"1"]) {
            
            key = [[nearArr objectAtIndex:i] objectForKey:@"roomId"];
            //            [idArr addObject:key];
            
        }else if ([[[[nearArr objectAtIndex:i] objectForKey:@"type"] description] isEqualToString:@"2"]) {
            
            key1 = [[nearArr objectAtIndex:i] objectForKey:@"siteId"];
            [idArr1 addObject:key1];
            
        }else if ([[[[nearArr objectAtIndex:i] objectForKey:@"type"] description] isEqualToString:@"3"]) {
            
            key2 = [[nearArr objectAtIndex:i] objectForKey:@"siteId"];
            [idArr2 addObject:key2];
            
        }else if ([[[[nearArr objectAtIndex:i] objectForKey:@"type"] description] isEqualToString:@"4"]) {
            
            key3 = [[nearArr objectAtIndex:i] objectForKey:@"siteId"];
            [idArr3 addObject:key3];
            
        }else if ([[[[nearArr objectAtIndex:i] objectForKey:@"type"] description] isEqualToString:@"5"]) {
            
            key4 = [[nearArr objectAtIndex:i] objectForKey:@"siteId"];
            [idArr4 addObject:key4];
            
        }else if ([[[[nearArr objectAtIndex:i] objectForKey:@"type"] description] isEqualToString:@"6"]) {
            
            key5 = [[nearArr objectAtIndex:i] objectForKey:@"roomId"];
            [idArr5 addObject:key5];
            
        }else if ([[[[nearArr objectAtIndex:i] objectForKey:@"type"] description] isEqualToString:@"7"]) {
            
            key6 = [[nearArr objectAtIndex:i] objectForKey:@"nuId"];
            [idArr6 addObject:key6];
        }
    }
    NSString *strI =  [idArr componentsJoinedByString:@","];
    NSString *strI1 = [idArr1 componentsJoinedByString:@","];
    NSString *strI2 = [idArr2 componentsJoinedByString:@","];
    NSString *strI3 = [idArr3 componentsJoinedByString:@","];
    NSString *strI4 = [idArr4 componentsJoinedByString:@","];
    NSString *strI5 = [idArr5 componentsJoinedByString:@","];
    NSString *strI6 = [idArr6 componentsJoinedByString:@","];
    //    NSString *strI7 = [idArr7 componentsJoinedByString:@","];
    
    DLog(@"==%@",strI);
    
    switch (index) {
        case 0://周期工作
        {
            MyWorkViewController *ctrl = [[MyWorkViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case 1://故障
        {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
            paraDict[@"regionId"] = strI1;
            paraDict[@"taskType"] = @"2";
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            
            
            httpPOST(paraDict, ^(id result) {
                DLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"]){
                    
                    AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                    allVC.vcTag = 100;
                    allVC.allArr = [result objectForKey:@"list"];
                    allVC.strID = strI;
                    allVC.strType = @"2";
                    [self.navigationController pushViewController:allVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });
            
        }
            break;
        case 2://预约
        {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
            paraDict[@"regionId"] = strI2;
            paraDict[@"taskType"] = @"3";
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            
            
            httpPOST(paraDict, ^(id result) {
                DLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"]){
                    
                    AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                    allVC.vcTag = 100;
                    allVC.allArr = [result objectForKey:@"list"];
                    allVC.strID = strI;
                    allVC.strType = @"3";
                    [self.navigationController pushViewController:allVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });
        }
            break;
        case 3://隐患
        {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
            paraDict[@"regionId"] = strI3;
            paraDict[@"taskType"] = @"4";
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            httpPOST(paraDict, ^(id result) {
                DLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"]){
                    
                    AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                    allVC.vcTag = 100;
                    allVC.allArr = [result objectForKey:@"list"];
                    allVC.strID = strI;
                    allVC.strType = @"4";
                    [self.navigationController pushViewController:allVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });
        }
            break;
        case 4://局站
        {
            
            
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myRegion/GetRegionByName";
            paraDict[@"regionIds"] = strI4;
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            
            httpPOST(paraDict, ^(id result) {
                DLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"])
                {
                    JuzhanViewController *juzVC = [[JuzhanViewController alloc]init];
                    juzVC.vcTag = 100;
                    juzVC.strID = strI;
                    juzVC.juzArr = [result objectForKey:@"list"];
                    [self.navigationController pushViewController:juzVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });
            
        }
            break;
        case 5://机房
        {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myRegion/GetRoomByName";
            paraDict[@"roomIds"] = strI5;
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            
            DLog(@"%@",paraDict);
            httpPOST(paraDict, ^(id result) {
                DLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"])
                {
                    RoomViewController *roomVC = [[RoomViewController alloc]init];
                    roomVC.vcTag = 100;
                    roomVC.strID = strI1;
                    roomVC.roomArr = [result objectForKey:@"list"];
                    [self.navigationController pushViewController:roomVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });
            
            
        }
            break;
        case 6://网元
        {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myRegion/GetNuByName";
            paraDict[@"nuIds"] = strI6;
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            //            DLog(@"%@",strI2);
            httpPOST(paraDict, ^(id result) {
                DLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"])
                {
                    NetworkViewController *netVC = [[NetworkViewController alloc]init];
                    netVC.vcTag = 100;
                    netVC.strID = strI2;
                    netVC.netArr = [result objectForKey:@"list"];
                    [self.navigationController pushViewController:netVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });
            
            
        }
            break;
        case 10://临时任务
        {
            TemporaryViewController *temVC = [[TemporaryViewController alloc]init];
            [self.navigationController pushViewController:temVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DLog(@"scrollView");
}


#pragma mark 地图改变完成
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    DLog(@"改变完成");
    DLog(@"改变完成 == %f",_mapView.zoomLevel);
    if (_mapView.zoomLevel >=19.0) {
        strLevel = @"20";
    }else if (_mapView.zoomLevel <= 3.0){
        strLevel = @"2000000";
    }else{
        int zoom = _mapView.zoomLevel;
        DLog(@"zoom == >%d",zoom);
        
        NSArray *zoomArr = @[@"20", @"50", @"100", @"200", @"500", @"1000", @"2000",
                             @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000",
                             @"2000000"];
        
        strLevel = [zoomArr objectAtIndex:(19-zoom)];
        DLog(@"strLevel == %@",strLevel);
        
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
    DLog(@"左上角1 == >%f",coornation.latitude);
    DLog(@"左下角1 == >%f",coornation.longitude);
    
    CLLocationCoordinate2D coornation1 = [_mapView convertPoint:point1 toCoordinateFromView:_mapView];//获取经纬度
    rightDownSmx = [NSString stringWithFormat:@"%f",coornation1.longitude];
    rightDownSmy = [NSString stringWithFormat:@"%f",coornation1.latitude];
    DLog(@"右上角1 == >%f",coornation1.latitude);
    DLog(@"右下角1 == >%f",coornation1.longitude);
    
    if (self.VCtag == 10000) {
        
        [_mapView removeAnnotation:pointAnnotation];
        //        if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [self.strSmy doubleValue];
        coor.longitude = [self.strSmx doubleValue];
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = self.addressTitle;
        //        }
        DLog(@"%f",[self.strSmy doubleValue]);
        DLog(@"%f",[self.strSmx doubleValue]);
        [_mapView addAnnotation:pointAnnotation];
        //        _mapView.centerCoordinate = CLLocationCoordinate2DMake(coor.latitude,coor.longitude);
        
    }else{
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *str;
        str = @"";
        str = [user objectForKey:@"type"];
        DLog(@"改变完成str === %@",str);
        if (str == nil) {
            strMapType = @"1,2,3,4,5,6,7";
            [self nearbyResult:@"1"];
        }else{
            strMapType = str;
            [self nearbyResult:str];
        }
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
        CGRect rect = CGRectMake(0, 0, 220, 150);
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
        
    }else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        
        bubbleView.hidden = YES;
        [UIView commitAnimations];
    }
}

#pragma mark == 关闭弹出的标注
-(void)closeAnnotationViews
{
    DLog(@"关闭弹出的标注");
    
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

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"当前位置%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
}

//当mapView新添加annotationviews时，调用此接口
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //    DLog(@"mapView新添加annotation views");
}
//当点击annotationview弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    DLog(@"点击annotation view弹出的泡泡");
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

#pragma mark ==  UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return dataArray.count;
    }
    
    if (tableView == self.tableView1) {
        return dataArray1.count;
    }
    return 0;
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
        
        NSString *str = @"5";
        NSString *str1 = @"6";
        NSString *str2 = @"7";
        
        NSUInteger row = [indexPath row];
        NSString *strRow;
        
        strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
        
        
        NSMutableDictionary *dic = [contacts objectAtIndex:row];
        if (strMapType == nil || strMapType.length == 0 || [strMapType isEqualToString:@""]) {
            
            [dic setValue:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
            strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            [slectDic removeObjectForKey:strRow];
            
            
        }else{
            if (indexPath.row == 0) {
                
                
                if ([strMapType rangeOfString:str].location != NSNotFound) {
                    
                    [dic setValue:@"YES" forKey:@"checked"];
                    [cell setChecked:YES];
                    
                    [slectDic setValue:str forKey:strRow];
                    
                }else{
                    [dic setValue:@"NO" forKey:@"checked"];
                    [cell setChecked:NO];
                    strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
                    [slectDic removeObjectForKey:strRow];
                }
            }
            
            if (indexPath.row == 1) {
                
                if ([strMapType rangeOfString:str1].location != NSNotFound) {
                    
                    DLog(@"这个字符串中有a");
                    [dic setValue:@"YES" forKey:@"checked"];
                    [cell setChecked:YES];
                    [slectDic setValue:str1 forKey:strRow];
                    
                }else{
                    [dic setValue:@"NO" forKey:@"checked"];
                    [cell setChecked:NO];
                    strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
                    [slectDic removeObjectForKey:strRow];
                }
            }
            
            if (indexPath.row == 2) {
                
                if ([strMapType rangeOfString:str2].location != NSNotFound) {
                    
                    DLog(@"这个字符串中有a");
                    [dic setValue:@"YES" forKey:@"checked"];
                    [cell setChecked:YES];
                    [slectDic setValue:str2 forKey:strRow];
                    
                }else{
                    [dic setValue:@"NO" forKey:@"checked"];
                    [cell setChecked:NO];
                    strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
                    [slectDic removeObjectForKey:strRow];
                }
            }
        }
        return cell;
        
    }else{
        static NSString *identifier1 = @"identifier1";
        SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        
        cell.leftLable.text = [dataArray1 objectAtIndex:indexPath.row];
        cell.leftImgView.image = [UIImage imageNamed:[rightImgArr objectAtIndex:indexPath.row]];
        
        NSString *str1 = @"1";
        NSString *str2 = @"2";
        NSString *str3 = @"3";
        NSString *str4 = @"4";
        
        NSUInteger row = [indexPath row];
        NSString *strRow;
        DLog(@"%lu",(unsigned long)row);
        
        if (strMapType == nil || strMapType.length == 0 || [strMapType isEqualToString:@""]) {
            NSMutableDictionary *dic = [contacts1 objectAtIndex:row];
            
            [dic setValue:@"NO" forKey:@"checked1"];
            [cell setChecked:NO];
            strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            [slectDic1 removeObjectForKey:strRow];
            
            
        }else{
            
            if (indexPath.row == 0) {
                NSMutableDictionary *dic = [contacts1 objectAtIndex:row];
                if ([strMapType rangeOfString:str1].location != NSNotFound) {
                    
                    DLog(@"这个字符串中有a");
                    [dic setValue:@"YES" forKey:@"checked1"];
                    [cell setChecked:YES];
                    
                }else{
                    [dic setValue:@"NO" forKey:@"checked1"];
                    [cell setChecked:NO];
                }
            }
            
            if (indexPath.row == 1) {
                NSMutableDictionary *dic = [contacts1 objectAtIndex:row];
                if ([strMapType rangeOfString:str2].location != NSNotFound) {
                    
                    DLog(@"这个字符串中有a");
                    [dic setValue:@"YES" forKey:@"checked1"];
                    [cell setChecked:YES];
                    
                }else{
                    [dic setValue:@"NO" forKey:@"checked1"];
                    [cell setChecked:NO];
                }
            }
            
            if (indexPath.row == 2) {
                NSMutableDictionary *dic = [contacts1 objectAtIndex:row];
                if ([strMapType rangeOfString:str3].location != NSNotFound) {
                    
                    DLog(@"这个字符串中有a");
                    [dic setValue:@"YES" forKey:@"checked1"];
                    [cell setChecked:YES];
                    
                }else{
                    [dic setValue:@"NO" forKey:@"checked1"];
                    [cell setChecked:NO];
                }
            }
            
            if (indexPath.row == 3) {
                NSMutableDictionary *dic = [contacts1 objectAtIndex:row];
                if ([strMapType rangeOfString:str4].location != NSNotFound) {
                    
                    DLog(@"这个字符串中有a");
                    [dic setValue:@"YES" forKey:@"checked1"];
                    [cell setChecked:YES];
                    
                }else{
                    [dic setValue:@"NO" forKey:@"checked1"];
                    [cell setChecked:NO];
                }
            }
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        
        SelectTableViewCell *cell = (SelectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        NSString *strTag;
        if (indexPath.row == 0) {
            strTag = @"5";
        }else if (indexPath.row == 1) {
            strTag = @"6";
        }else if (indexPath.row == 2) {
            strTag = @"7";
        }
        DLog(@"contacts == %@",contacts);
        NSUInteger row = [indexPath row];
        NSString *strRow;
        NSMutableDictionary *dic = [contacts objectAtIndex:row];
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
            DLog(@"单选==%d",row);
            NSString *strPID = [NSString stringWithFormat:@"%@",strTag];
            strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            [slectDic setValue:strPID forKey:strRow];
            
        }else {
            //            btnTag = 98;
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
            DLog(@"未单选==%d",row);
            strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            [slectDic removeObjectForKey:strRow];
        }
        
        
    }else{
        
        SelectTableViewCell *cell = (SelectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        NSString *strTag;
        if (indexPath.row == 0) {
            strTag = @"2";
        }else if (indexPath.row == 1) {
            strTag = @"4";
        }else if (indexPath.row == 2) {
            strTag = @"3";
        }else if (indexPath.row == 3) {
            strTag = @"1";
        }
        
        NSUInteger row = [indexPath row];
        NSString *strRow;
        NSMutableDictionary *dic = [contacts1 objectAtIndex:row];
        if ([[dic objectForKey:@"checked1"] isEqualToString:@"NO"]) {
            
            [dic setObject:@"YES" forKey:@"checked1"];
            [cell setChecked:YES];
            NSString *strPID = [NSString stringWithFormat:@"%@",strTag];
            //            [slectArray addObject:strPID];
            strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            [slectDic1 setValue:strPID forKey:strRow];
        }else {
            [dic setObject:@"NO" forKey:@"checked1"];
            [cell setChecked:NO];
            strRow = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            [slectDic1 removeObjectForKey:strRow];
        }
        
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


- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize constraint = CGSizeMake(75, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
