//
//  HomeViewController.m
//  i YunWei
//
//  Created by XXX on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "HomeViewController.h"
#import "CertificationView.h"
#import "LeftViewController.h"
#import "TopButtonView.h"
#import "MidButtonView.h"
#import "MyPageControl.h"
#import "UIView+border.h"
#import "NearTaskViewController.h"
#import "UrgentViewController.h"
#import "MapViewController.h"
#import "MyTaskMonthList.h"
#import "SearchViewController.h"
#import "UIView+size.h"
#import "InformationViewController.h"
#import "TaskCollectionViewCell.h"
#import "GongGaoViewController.h"
#import "AddTaskCollectionViewCell.h"
#import "FeedbackViewController.h"
#import "HuaXiaoViewController.h"
#import "MonthViewController.h"
#import "UIImageView+WebCache.h"
#import "RequestSupportViewController.h"
#import "PersonnelViewController.h"//人员动向
#import "EnergyUsingViewController.h"
#import "PublicInfoViewController.h"
#import "WebViewController.h"
#import "YZWorkOrderChartView.h"
#import "YZTodayWorkOrderViewController.h"
#import "YZRecentWorkOrderViewController.h"
#import "YZRobWorkOrderViewController.h"
#import "YZWorkOrderStatisticsViewController.h"
#import "YZPercentageView.h"
#import "YZRiskOpertionListTableViewCell.h"
#import "YZRiskOperationDetailViewController.h"
#import "VehicleReservationRecord.h"

@interface HomeViewController ()<topBudelegate,midBtndelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,MyRepairFaultListKBDelegate,AppcationDelegate,YZWorkOrderChartViewDelegate,YZPercentageViewDelegate>
{
    UITableView *myTableView;
    TopButtonView *topView;
    MidButtonView *midView;
    MyPageControl *myPageCtrl;
    MyPageControl *myPageCtrl1;
    UIPageControl *pageControl;
    NSInteger currentIndex;
    CertificationView *customView;
    UIImageView* bgImg;
    UIView *backView;
    UIView *pickView;
    int score;
    NSInteger pageIndex;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    UICollectionView * myColectionView;
    NSMutableArray *imageArray;
    NSMutableArray *titleArray;
    UILabel *labelShow;
    UILabel *numLab;
    UIView *bgLableView;
    UIScrollView *lableScrollView;
    NSTimer *timer;
    NSArray *labArr;
    int pageNum;
    float scoreHeight;
    float scoreY;
    NSDictionary *personalDic;//个人视图
    NSMutableArray *districtArr;//区局视图
    NSArray *leaderArr;//领导视图
    NSArray *rydxArray;//人员动向
    NSDictionary *rydxDic;//人员动向
    NSString *strUser;
    
    NSMutableDictionary *_leaderStatus;
    NSMutableArray *_quickChooseBtnInfoArray;
    NSString *_isTask_isInfo_isDaily;
    BOOL _isQuick;
    NSMutableArray *_quickViewArray;
    
    NSDictionary *_energyUsingViewDict_tuandui;//划小团队视图
    NSDictionary *_energyUsingViewDict_quju;//划小全局视图
    NSDictionary *_energyUsingViewDict_quanju;//划小区局视图
    
    //判断是否成功请求了scroll页面的数据;
    NSMutableDictionary *_loadMutDict;
    YZWorkOrderChartView *_workOrderChartView;
    YZPercentageView *_percentageView;
}
@end

#define btns 6
#define column 3

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated
{   self.backBtn.hidden=YES;
    [self hiddenBottomBar:NO];
    
    //开启定时器
    [timer setFireDate:[NSDate distantPast]];
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    del.delegate = (id)self;
    
}

#pragma mark -- 推送
//客保故障
- (void)appcationDelegatePushToControllerWith:(NSString *)workNo
{
    MyRepairFaultDetailKB *repairFaultDetailKBCtrl = [[MyRepairFaultDetailKB alloc] init];
    repairFaultDetailKBCtrl.pushNotice = @"pushNotice";
    repairFaultDetailKBCtrl.originalVc = NW_GetRepairFault;
    repairFaultDetailKBCtrl.workNo = workNo;
    [self.navigationController pushViewController:repairFaultDetailKBCtrl animated:YES];
}

//风险操作
- (void)appcationDelegatePushToRiskOperationControllerWith:(NSString *)workNo
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"riskOperation/GetRiskOperationList";
    paraDict[@"workNo"] = workNo;
    paraDict[@"type"] = @"2";
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if (![[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
            return ;
        }
        NSArray *listArray = [result objectForKey:@"list"];
        if (listArray.count > 0) {
            NSDictionary *dict = [listArray firstObject];
            YZRiskOpertionList *list = [[YZRiskOpertionList alloc] initWithParserWithDictionary:dict];
            
            [list getDetailTextHeight];
            
            YZRiskOperationDetailViewController *riskOperationDetailVC = [[YZRiskOperationDetailViewController alloc] init];
            riskOperationDetailVC.dataArray = [NSArray arrayWithObjects:list.showDetailArray,list.showMoreArray, nil];
            riskOperationDetailVC.heightArray = [NSArray arrayWithObjects:list.detailHeightArray,list.moreHeightArray, nil];
            
            riskOperationDetailVC.riskId = list.riskId;
            riskOperationDetailVC.workNo = list.workNo;
            [self.navigationController pushViewController:riskOperationDetailVC animated:YES];

        }
    }, ^(id result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    });

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenBottomBar:YES];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [timer setFireDate:[NSDate distantFuture]];
}

-(void)seachButton
{
    NSLog(@"asd");
    
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark == 公告信息列表及其单条内容详细
-(void)MyInfoData
{
    httpGET2(@{URL_TYPE : @"myInfo/GetNoteList"}, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            labArr = [result objectForKey:@"list"];
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
        }
    }, ^(id result) {
        
    });
}

#pragma mark == 获取能耗化统计_团队
-(void)GetTeamEnergyUsingData:(NSString *)indexKey
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kGetEnergyCount;
    paraDict[@"type"] = @"3";
    paraDict[@"curPage"] = @"1";
    paraDict[@"pageSize"] = @"20";
    httpGET2(paraDict, ^(id result) {
        NSLog(@"获取能耗化统计_团队%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            _energyUsingViewDict_tuandui = (NSDictionary *)[result[@"list"] firstObject];
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
            
            [self.topScoreView setContentOffset:CGPointMake(kScreenWidth * [indexKey integerValue], 0) animated:NO];
            [_loadMutDict removeObjectForKey:indexKey];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

#pragma mark == 获取能耗化统计_全局
-(void)GetWholeStationEnergyUsingData:(NSString *)indexKey
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kGetEnergyCount;
    paraDict[@"type"] = @"1";
    paraDict[@"curPage"] = @"1";
    paraDict[@"pageSize"] = @"20";
    httpGET2(paraDict, ^(id result) {
        NSLog(@"获取能耗化统计_全局%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            _energyUsingViewDict_quanju = (NSDictionary *)[result[@"list"] firstObject];
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
            
            [self.topScoreView setContentOffset:CGPointMake(kScreenWidth * [indexKey integerValue], 0) animated:NO];
            [_loadMutDict removeObjectForKey:indexKey];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

#pragma mark == 获取能耗化统计_区局
-(void)GetSingleStationEnergyUsingData:(NSString *)indexKey
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kGetEnergyCount;
    paraDict[@"type"] = @"2";
    paraDict[@"curPage"] = @"1";
    paraDict[@"pageSize"] = @"20";
    httpGET2(paraDict, ^(id result) {
        NSLog(@"获取能耗化统计_区局%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            _energyUsingViewDict_quju = (NSDictionary *)[result[@"list"] firstObject];
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
            
            [self.topScoreView setContentOffset:CGPointMake(kScreenWidth * [indexKey integerValue], 0) animated:NO];
            [_loadMutDict removeObjectForKey:indexKey];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

#pragma mark == 区局视图
-(void)GetDistrictView:(NSString *)indexKey
{
    httpGET2(@{URL_TYPE : @"myView/GetDistrictView"}, ^(id result) {
        NSLog(@"区局视图 == %@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            
            NSArray* listArr = [result  objectForKey:@"list"];
            for (int i = 0; i<listArr.count; i++) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionary];
                NSString* nameStr = [[[listArr objectAtIndex:i] objectForKey:@"quotaName"] description];
                [dic setObject:nameStr forKey:@"UName"];  // 指标名称
                
                NSString* targetStr = [[[listArr objectAtIndex:i] objectForKey:@"targetValue"] description];
                [dic setObject:targetStr forKey:@"target"];  // 目标值
                
                NSString* monthStr = [[[listArr objectAtIndex:i] objectForKey:@"monthValue"] description];
                [dic setObject:monthStr forKey:@"month"];  // 当月值
                
                NSString* rankStr = [[[listArr objectAtIndex:i] objectForKey:@"rank"] description];
                [dic setObject:rankStr forKey:@"rank"];  // 排名
                
                NSString* regainNameStr = [[[listArr objectAtIndex:i] objectForKey:@"regainName"] description];
                [dic setObject:regainNameStr forKey:@"regainName"];  // 区局
                
                NSString* batchDateStr = [[[listArr objectAtIndex:i] objectForKey:@"batchDate"] description];
                [dic setObject:batchDateStr forKey:@"batchDate"];  // 日期
                
                [districtArr addObject:dic];
            }
            NSLog(@"districtArr == %@",districtArr);
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
            [self.topScoreView setContentOffset:CGPointMake(kScreenWidth * [indexKey integerValue], 0) animated:NO];
            [_loadMutDict removeObjectForKey:indexKey];
        }
    }, ^(id result) {
        
    });
}

#pragma mark == 获取领导视图信息
-(void)GetLeaderView:(NSString *)indexKey
{
    httpGET2(@{URL_TYPE : @"myView/GetLeaderView"}, ^(id result) {
        NSLog(@"领导视图 == %@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            leaderArr = [result objectForKey:@"list"];
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
            
            [self.topScoreView setContentOffset:CGPointMake(kScreenWidth * [indexKey integerValue], 0) animated:NO];
            [_loadMutDict removeObjectForKey:indexKey];
            
        }
    }, ^(id result) {
        
    });
}

#pragma mark == 获取个人视图信息
-(void)GetPersonalView:(NSString *)indexKey
{
    httpGET2(@{URL_TYPE : @"myView/GetPersonalView"}, ^(id result) {
        NSLog(@"个人视图 == %@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            personalDic = [result objectForKey:@"detail"];
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
            
            [self.topScoreView setContentOffset:CGPointMake(kScreenWidth * [indexKey integerValue], 0) animated:NO];

            [_loadMutDict removeObjectForKey:indexKey];
        }
    }, ^(id result) {
        
    });
}

#pragma mark == 获取人员动向
-(void)GetPeopleTrends:(NSString *)indexKey
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myInfo/GetPeopleTrends";
    paraDict[@"queryTime"] = dateString;
    
    httpGET2(paraDict, ^(id result) {
        
        NSLog(@"%@",result);
        
        if ([result[@"result"] isEqualToString:@"0000000"]){
            
            rydxDic = result;
            rydxArray = [result objectForKey:@"list"];
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
            [self.topScoreView setContentOffset:CGPointMake(kScreenWidth * [indexKey integerValue], 0) animated:NO];
            [_loadMutDict removeObjectForKey:indexKey];
        }
        
    }, ^(id result) {
        
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    _leaderStatus =[NSMutableDictionary dictionary];
    _quickViewArray = [NSMutableArray array];
    districtArr = [[NSMutableArray alloc]initWithCapacity:10];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    [self addSearchBar];
    [self addNavigationRightButton:@"头像.png"];
    [self addNavLeftButton:@"message.png"];
    
    [self saveAuthorityInfo];

    [self MyInfoData];        //公告信息列表
//
     UIView *heardView = [self tableHeadView];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = heardView;
    [self.view addSubview:myTableView];
    
    [self initView];
    
    [self loadQuickBtnInfo];
    [self addMessageAndSaoSao:@"message.png"];
    
    httpGET1(@{URL_TYPE:NW_GetUserInfo}, ^(id result) {
        USET(U_USID, result[@"detail"][@"userId"]);
    });
}

#pragma mark - 领导视图增加工作状态显示
- (void)getTaskStatusOfLeader:(NSString *)indexKey
{
    httpGET1(@{URL_TYPE:kGetTaskStatusOfLeader}, ^(id result) {
        NSLog(@"%@",result);
        _leaderStatus = (NSMutableDictionary *)result[@"detail"];
        UIView *heardView = [self tableHeadView];
        myTableView.tableHeaderView = heardView;
        [myTableView reloadData];
        
        [self.topScoreView setContentOffset:CGPointMake(kScreenWidth * [indexKey integerValue], 0) animated:NO];
        [_loadMutDict removeObjectForKey:indexKey];
        
    });
}
/*
#pragma mark - 获取能耗化统计
- (void)getEnergyUsingInfoByAuthority
{
    NSArray *authorityViewList = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"authorityViewList"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in authorityViewList) {
        NSString *functionId = dict[@"functionId"];
        [tempArray addObject:functionId];
    }
    
    if ([tempArray containsObject:@"44"]) {
        [self GetTeamEnergyUsingData];//获取能耗化统计_团队
    }
    
    if ([tempArray containsObject:@"54"]) {
        [self GetWholeStationEnergyUsingData];//获取能耗化统计_全局
    }
    
    if ([tempArray containsObject:@"55"]) {
        [self GetSingleStationEnergyUsingData];//获取能耗化统计_区局
    }
}
*/

//- (void)getUserAuthorityInfo
//{
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"flag"] isEqualToString:@"failToSaveAuthorityInfo"]) {
//        [self saveAuthorityInfo];
//    }else{
//        return;
//    }
//}

#pragma mark - 把权限信息保存在PLIST文件里面
- (void)saveAuthorityInfo
{
    //权限,把权限信息保存在PLIST文件里面
    NSMutableDictionary *authorityPara = [NSMutableDictionary dictionary];
    authorityPara[URL_TYPE] = @"myInfo/GetAuthorityInfo";
    httpGET2(authorityPara, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSLog(@"%@",result);
            if (_loadMutDict == nil) {
                _loadMutDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            }
            NSArray *viewListArray = result[@"viewList"];
            NSMutableArray *viewListMutArray = [NSMutableArray arrayWithArray:viewListArray];

            __block NSDictionary *workOrderDict = nil;
            __block NSDictionary *valueViewDict = nil;
            [viewListMutArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
                NSString *functionId = [obj objectForKey:@"functionId"];
                if ([functionId isEqualToString:@"78"]) {
                    workOrderDict = obj;
                }
                if ([functionId isEqualToString:@"79"]) {
                    valueViewDict = obj;
                }
                [_loadMutDict setObject:functionId forKey:[NSString stringWithFormat:@"%d",idx]];

            }];
            
            if (valueViewDict) {
                [viewListMutArray removeObject:valueViewDict];
                [viewListMutArray insertObject:valueViewDict atIndex:0];
            }
            if (workOrderDict) {
                [viewListMutArray removeObject:workOrderDict];
                [viewListMutArray insertObject:workOrderDict atIndex:0];
            }
            [viewListMutArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *functionId = [obj objectForKey:@"functionId"];
                [_loadMutDict setObject:functionId forKey:[NSString stringWithFormat:@"%d",idx]];
                
            }];
            
            [userDefault setObject:viewListMutArray forKey:@"authorityViewList"];
            [userDefault setObject:result[@"taskList"] forKey:@"authorityTaskList"];
            [userDefault setObject:result[@"infoList"] forKey:@"authorityInfoList"];
            [userDefault setObject:result[@"dailyList"] forKey:@"authorityDailyList"];
            [userDefault synchronize];
//            [self getEnergyUsingInfoByAuthority];
            [self loadDataWithFunctionId:[_loadMutDict objectForKey:@"0"] indexKey:@"0"];
        }
    },^(id result){
        showAlert(@"用户权限信息未成功录入,请重新登录!");
    });
}

#pragma mark - - 根据权限加载请求
- (void)loadDataWithFunctionId:(NSString *)functionId indexKey:(NSString *)indexKey
{
    switch ([functionId integerValue]) {
        case 42:
            [self GetPersonalView:indexKey];   //获取个人视图信息
            break;
        case 43:
            [self GetDistrictView:indexKey];   //区局视图
            break;
        case 44:
            [self GetTeamEnergyUsingData:indexKey];//获取能耗化统计_团队
            break;
        case 45:
            [self GetLeaderView:indexKey];     //获取领导视图信息
            [self getTaskStatusOfLeader:indexKey];//领导视图增加工作状态显示

            break;
        case 47:
            [self GetPeopleTrends:indexKey];   //获取人员动向
            break;
        case 54:
            [self GetWholeStationEnergyUsingData:indexKey];//获取能耗化统计_全局
            break;
        case 55:
            [self GetSingleStationEnergyUsingData:indexKey];//获取能耗化统计_区局
            break;
        case 78:
            [self getWorkOrderStatisticsInfo:indexKey];//获取工单统计数据
            break;
        case 79:
            [self getValueViewInfo:indexKey];//获取价值视图信息
            break;
        default:
            break;
    }
    

}

//通用工单
- (void)getWorkOrderStatisticsInfo:(NSString *)indexKey
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *firstDay = getMonthFirstDay([NSDate date]);
    NSString *lastDay = getMonthLastDay([NSDate date]);
    paraDict[@"startTime"] = [NSString stringWithFormat:@"%@ 00:00:00",firstDay];
    paraDict[@"endTime"] = [NSString stringWithFormat:@"%@ 23:59:59",lastDay];
    
    paraDict[@"billType"] = @"0";
    paraDict[@"orgId"] = @"0";
    paraDict[URL_TYPE] = @"commonBill/QueryCommBillFormNums";
    
    NSLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        NSDictionary *detailDict = [result objectForKey:@"detail"];
        
        NSArray *keyArray = @[@"workPlanNums",@"faultNums",@"adjustResNums",@"serviceFulfillNums",@"workFollowNums",@"riskOperatorNums",@"commandTaskNums",@"supportBillNums"];
        NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:0];
        for (NSString *key in keyArray) {
            NSString *number = [detailDict objectForKey:key];

            [numberArray addObject:number];
        }
        
        [_workOrderChartView displayWorkOrderNumbers:numberArray];
        [_loadMutDict removeObjectForKey:indexKey];

    }, ^(id result) {
        NSLog(@"%@",result);
    });

}

//价值视图(管理人员)
- (void)getValueViewInfo:(NSString *)indexKey
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithCapacity:0];
        paraDict[URL_TYPE] = @"commonBill/QueryValueView";
    
    NSLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
            NSDictionary *detailDict = [result objectForKey:@"detail"];
            NSDictionary *listDict = [detailDict objectForKey:@"list"];
            
            NSArray *keyArray = @[@"orderInTimeRates",@"dealInTimeRates",@"repeatFaultRates",@"perNuFaultNums",@"workPlanOverTimeRates"];
            NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
            for (NSString *key in keyArray) {
                NSNumber *value = [NSNumber numberWithFloat:[[listDict objectForKey:key] floatValue]/100];
                [valueArray addObject:value];
            }
            
            [_percentageView setPercentageArray:valueArray];
        }
        
        
        [_loadMutDict removeObjectForKey:indexKey];
        
    }, ^(id result) {
        NSLog(@"%@",result);
    });

}

#pragma mark ---workOrderChartView代理
//选中工单
- (void)workOrderChartView:(YZWorkOrderChartView *)chartView workOrderButtonClickedAtIndex:(NSUInteger)index
{
    UIViewController *workOrderVc = nil;
    switch (index) {
        case 1:
            workOrderVc = [[YZTodayWorkOrderViewController alloc] init];
            break;
        case 2:
            workOrderVc = [[YZRecentWorkOrderViewController alloc] init];
            break;
        case 3:
            workOrderVc = [[YZRobWorkOrderViewController alloc] init];
            break;

        default:
            break;
    }
    [self.navigationController pushViewController:workOrderVc animated:YES];
}

//选中图表
- (void)workOrderChartViewDidClicked:(YZWorkOrderChartView *)chartView
{
    YZWorkOrderStatisticsViewController *workOrderStatisticsVc = [[YZWorkOrderStatisticsViewController alloc] init];
    [self.navigationController pushViewController:workOrderStatisticsVc animated:YES];
}

#pragma mark -- percentageViewDelegate -- 价值视图被点击
- (void)percentageViewDidClicked:(YZPercentageView *)chartView
{
    NSLog(@"----------价值视图被点击");
}

- (void)loadQuickBtnInfo
{
    httpGET1(@{URL_TYPE : @"myInfo/GetMenuList"},^(id result) {
        [_quickViewArray removeAllObjects];
        for (NSDictionary *dict in result[@"list"]) {
            [_quickViewArray addObject:dict];
        }
        
        UIView *heardView = [self tableHeadView];
        myTableView.tableHeaderView = heardView;
        [myTableView reloadData];
    });
}

#pragma mark   首页公告页面跳转    10 24号
-(void)lableBtn:(UIButton *)sender
{
    
    GongGaoViewController *gongVC = [[GongGaoViewController alloc]init];
    gongVC.dataArr = labArr;
    
    [self.navigationController pushViewController:gongVC animated:YES];
}

////////////////////////////////////////

// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = pageControl.currentPage; // 获取当前的page
    [lableScrollView scrollRectToVisible:CGRectMake(0,35*(page+1),kScreenWidth,35) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}

// 定时器 绑定的方法
- (void)runTimePage
{
    int page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page > labArr.count-1 ? 0 : page ;
    pageControl.currentPage = page;
    
    [self turnPage];
}

/////////////////////////////////////////////////////////////
#pragma mark == 表头
-(UIView *)tableHeadView
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    strUser = [user objectForKey:@"userName"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    view.backgroundColor = [UIColor whiteColor];
    if (kScreenHeight >480) {
        myTableView.scrollEnabled =YES;
    }else{
        [view setFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight+45)];
        myTableView.scrollEnabled = YES;
    }
    
    lableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    lableScrollView.bounces = YES;
    lableScrollView.pagingEnabled = YES;
    lableScrollView.userInteractionEnabled = YES;
    lableScrollView.delegate = self;
    lableScrollView.showsHorizontalScrollIndicator = NO;
    [view addSubview:lableScrollView];
    
    numLab = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor blackColor] rect:CGRectMake(kScreenWidth-50, 3, 50, 30)];
    numLab.textAlignment = NSTextAlignmentRight;
    numLab.textColor = [UIColor whiteColor];
    [view addSubview:numLab];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(120,120,100,0)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor clearColor]];
    [pageControl setPageIndicatorTintColor:[UIColor clearColor]];
    pageControl.numberOfPages = labArr.count;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
    
    [lableScrollView setContentSize:CGSizeMake(kScreenWidth, 35*(labArr.count+2))]; //  +上第1页和第3页  原理：3-[1-2-3]-1
    [lableScrollView setContentOffset:CGPointMake(0, 0)];
    [lableScrollView scrollRectToVisible:CGRectMake(0,35,kScreenWidth,35) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    for (int i=0; i< labArr.count; i++)
    {
        bgLableView = [[UIView alloc] initWithFrame:CGRectMake(0, 35+35*i, kScreenWidth, 35)];
        bgLableView.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:182.0/255.0 blue:250.0/255.0 alpha:1.0];
        //        bgLableView.backgroundColor = [UIColor redColor];
        [lableScrollView addSubview:bgLableView];
        
        labelShow = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-50, 35)];
        labelShow.text = [[labArr objectAtIndex:i] objectForKey:@"theme"];
        labelShow.font = [UIFont systemFontOfSize:13.0];
        labelShow.textAlignment = NSTextAlignmentCenter;
        labelShow.textColor = [UIColor whiteColor];
        [bgLableView addSubview:labelShow];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        [button addTarget:self action:@selector(lableBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bgLableView addSubview:button];
        
    }
    self.topScoreView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 305)];
    self.topScoreView.pagingEnabled = YES;
    self.topScoreView.delegate = self;
    self.topScoreView.backgroundColor = [UIColor clearColor];
    self.topScoreView.showsHorizontalScrollIndicator=NO;
    CGSize contentSize = self.topScoreView.contentSize;
    self.topScoreView.bounces= NO;
    contentSize.height = 290;
    
    //根据权限不同，视图也不同
    NSArray *authorityInfo = (NSArray *)[user objectForKey:@"authorityViewList"];
    contentSize.width = authorityInfo.count * kScreenWidth;
    NSLog(@"authorityInfo from nsuserdefault == %@",authorityInfo);
    
    NSMutableArray *authArr = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray *authArr1 = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < authorityInfo.count; i++) {
        NSString *str = [[authorityInfo objectAtIndex:i] objectForKey:@"functionId"];
        NSString *str1 = [[authorityInfo objectAtIndex:i] objectForKey:@"functionName"];
        [authArr addObject:str];
        [authArr1 addObject:str1];
    }
    
    self.topScoreView.contentSize = contentSize;
    [view addSubview:self.topScoreView];
    
    NSArray* array1  = [NSArray arrayWithObjects:@"附近任务",@"当月任务",@"限时任务", nil];
    NSArray *imgArr = [NSArray arrayWithObjects:@"near_task.png",@"current_task.png",@"urgent_task.png", nil];
    
    NSArray* array2  = [NSArray arrayWithObjects:@"周期工作",@"故障维修",@"隐患处理",@"随工预约",/*@"临时任务",*/ nil];
    
    NSString *str1 = [personalDic objectForKey:@"cycleValue"];
    NSString *str2 = [personalDic objectForKey:@"falutValue"];
    NSString *str3 = [personalDic objectForKey:@"dangerValue"];
    NSString *str4 = [personalDic objectForKey:@"orderValue"];
    //    NSString *str5 = [personalDic objectForKey:@"tempTaskValue"];
    
    NSArray* numArr  = [NSArray arrayWithObjects:str1,str2,str3,str4,/*str5,*/ nil];
    
    ////////////////////////////////////////////////////////////////////////////////
    
    for (int i = 0; i < authorityInfo.count; i++)
    {
        
        UIView*  topBackView = [[UIView alloc] init];
        topBackView.tag = 100+i;
        topBackView.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, 297);
        topBackView.backgroundColor = [UIColor clearColor];
        [self.topScoreView addSubview:topBackView];
        
        bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 277)];
        [bgImg setImage:[UIImage imageNamed:@"level_bg.png"]];
        [topBackView addSubview:bgImg];
        
        
        if ([authArr[i]  isEqual: @"42"]) {
#pragma mark - 个人视图_42

            bgImg.hidden = YES;
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(85, 200, 150,0)];
            [bgView setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:255.0/255.0 blue:65.0/255.0 alpha:1.0]];
            [topBackView addSubview:bgView];
            
            UIImageView* bgImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 32, kScreenWidth, 245)];
            [bgImg1 setImage:[UIImage imageNamed:@"qq.png"]];
            //            [bgImg1 setCenter:CGPointMake(kScreenWidth/2, 150)];
            [topBackView addSubview:bgImg1];
            
            float strValue = [[personalDic objectForKey:@"pressureValue"] floatValue];
            if (strValue == 0) {
                
                scoreY = 205;
                scoreHeight = 40;
                
            }else if ( strValue > 0 && strValue <= 5.0) {
                
                scoreY = 200;
                scoreHeight = 45;
                
            }else if ( strValue > 5.0 && strValue <= 10.0) {
                
                scoreY = 195;
                scoreHeight = 50;
                
            }else if ( strValue > 10.0 && strValue <= 15.0) {
                
                scoreY = 187;
                scoreHeight = 58;
                
            }else if ( strValue > 15.0 && strValue <= 20.0) {
                
                scoreY = 179;
                scoreHeight = 66;
                
            }else if ( strValue > 20.0 && strValue <= 25.0) {
                
                scoreY = 171;
                scoreHeight = 74;
                
            }else if ( strValue > 25.0 && strValue <= 30.0) {
                
                scoreY = 163;
                scoreHeight = 82;
                
            }else if ( strValue > 30.0 && strValue <= 35.0) {
                
                scoreY = 155;
                scoreHeight = 90;
                
            }else if ( strValue > 35.0 && strValue <= 40.0) {
                
                scoreY = 147;
                scoreHeight = 98;
                
            }else if ( strValue > 40.0 && strValue <= 45.0) {
                
                scoreY = 139;
                scoreHeight = 106;
                
            }else if ( strValue > 45.0 && strValue <= 50.0) {
                
                scoreY = 131;
                scoreHeight = 114;
                
            }else if ( strValue > 50.0 && strValue <= 55.0) {
                
                scoreY = 123;
                scoreHeight = 122;
                
                
            }else if ( strValue > 55.0 && strValue <= 60.0) {
                
                scoreY = 115;
                scoreHeight = 130;
                
                
            }else if ( strValue > 60.0 && strValue <= 65.0) {
                
                scoreY = 107;
                scoreHeight = 138;
                
                
            }else if ( strValue > 65.0 && strValue <= 70.0) {
                
                scoreY = 99;
                scoreHeight = 146;
                
                
            }else if ( strValue > 70.0 && strValue <= 75.0) {
                
                scoreY = 91;
                scoreHeight = 154;
                
                
            }else if ( strValue > 75.0 && strValue <= 80.0) {
                
                scoreY = 83;
                scoreHeight = 162;
                
            }else if ( strValue > 80.0 && strValue <= 85.0) {
                
                scoreY = 75;
                scoreHeight = 170;
                
                
            }else if ( strValue > 85.0 && strValue <= 90.0) {
                
                scoreY = 67;
                scoreHeight = 178;
                
            }else if ( strValue > 90.0 && strValue <= 95.0) {
                
                scoreY = 62;
                scoreHeight = 183;
                
                
            }else if ( strValue > 95.0 && strValue <= 98.0) {
                
                scoreY = 55;
                scoreHeight = 190;
                
                
            }else if ( strValue > 98.0 && strValue <= 100.0) {
                
                scoreY = 50;
                scoreHeight = 195;
                
            }
            
            NSLog(@"%f == %f",bgView.frame.origin.x, bgView.frame.origin.y);
            
            [UIView animateWithDuration:1 animations:^{
                [bgView setFrame:CGRectMake(bgView.frame.origin.x, scoreY, 150, scoreHeight)];
            } completion:^(BOOL finished) {
                
            }];
            
            UILabel *scoreLable = [UnityLHClass initUILabel:@"80%" font:30.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth/2-30, 70, 100, 60)];
            scoreLable.text = [personalDic objectForKey:@"pressureValue"];
            [topBackView addSubview:scoreLable];
            
            UILabel *titLable = [UnityLHClass initUILabel:@"" font:15.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth/2-40, 115, 80, 50)];
            titLable.numberOfLines = 0;
            titLable.text = [NSString stringWithFormat:@"%@ \r%@",@"压力好大",@"想吐槽一下"];
            titLable.text = [personalDic objectForKey:@"pressureContent"];
            titLable.textAlignment = NSTextAlignmentCenter;
            [topBackView addSubview:titLable];
            
            topView = [[TopButtonView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35) withImageArr:imgArr withTitleArr:array1];
            topView.delegate = self;
            [topBackView addSubview:topView];
            
            UIImageView *bacImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 237, kScreenWidth, 40)];
            bacImgView.image = [UIImage imageNamed:@"灰底"];
            [topBackView addSubview:bacImgView];
            
            midView = [[MidButtonView alloc]initWithFrame:CGRectMake(0, 237, kScreenWidth, 40) withImageArr:nil withTitleArr:array2 withNumArr:numArr];
            midView.delegate = self;
            [topBackView addSubview:midView];
            
            UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, 277-72)];
            clickBtn.backgroundColor = [UIColor clearColor];
            [clickBtn addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
            [topBackView addSubview:clickBtn];
            
        }else if ([authArr[i]  isEqual: @"44"]){
#pragma mark - 划小团队视图_44
            UILabel *titleLable = [UnityLHClass initUILabel:@"能耗划小统计(横浜4月)" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(0, 10, kScreenWidth, 30)];
            titleLable.text = [NSString stringWithFormat:@"能耗划小统计(%@%@月)",NoNullStr([_energyUsingViewDict_tuandui objectForKey:@"siteName"]),NoNullStr([_energyUsingViewDict_tuandui objectForKey:@"month"])];
            titleLable.textAlignment = NSTextAlignmentCenter;
            [titleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
            [topBackView addSubview:titleLable];
            
            UIImage *secImg = [UIImage imageNamed:@"首页-6-5(02).png"];
            UIImageView *secImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, secImg.size.width/2, secImg.size.height/2)];
            secImgView.image = secImg;
            [topBackView addSubview:secImgView];
            
            CGSize sizeWith = [self labelHight:[_energyUsingViewDict_tuandui objectForKey:@"t0"]];
            
            UILabel *weiLab = [UnityLHClass initLabel:@"0.9" font:11.0 color:[UIColor whiteColor] color:[UIColor blueColor] rect:CGRectMake(kScreenWidth-250, 64, sizeWith.width, sizeWith.width) radius:sizeWith.width/2];
            weiLab.text = [_energyUsingViewDict_tuandui objectForKey:@"t0"];
            [topBackView addSubview:weiLab];
            
            UILabel *weiLable = [UnityLHClass initUILabel:@"T0值" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-245+sizeWith.width, 63, 100, 30)];
            [weiLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            weiLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:weiLable];
            
            CGSize sizeWith1 = [self labelHight:[_energyUsingViewDict_tuandui objectForKey:@"billValue"]];
            UILabel *eleLab = [UnityLHClass initLabel:@"597" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:8.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-290, 127, sizeWith1.width, sizeWith1.width) radius:sizeWith1.width/2];
            eleLab.text = [_energyUsingViewDict_tuandui objectForKey:@"billValue"];
            [topBackView addSubview:eleLab];
            
            UILabel *eleLable = [UnityLHClass initUILabel:@"总电量" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-288, 125+sizeWith1.width, 50, 30)];
            [eleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            eleLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:eleLable];
            
            CGSize sizeWith2 = [self labelHight:[_energyUsingViewDict_tuandui objectForKey:@"txValue"]];
            UILabel *commLab = [UnityLHClass initLabel:@"1597°" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:0.0/255.0 green:151.0/255.0 blue:140.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-245, 195, sizeWith2.width, sizeWith2.width) radius:sizeWith2.width/2];
            commLab.text = [_energyUsingViewDict_tuandui objectForKey:@"txValue"];
            [topBackView addSubview:commLab];
            
            UILabel *commLable = [UnityLHClass initUILabel:@"通信电量" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-240+sizeWith2.width, 200, 90, 30)];
            [commLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            commLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:commLable];
            
            CGSize sizeWith3 = [self labelHight:[_energyUsingViewDict_tuandui objectForKey:@"pue"]];
            UILabel *tiLab = [UnityLHClass initLabel:@"120条" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:246.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-123, 55, sizeWith3.width, sizeWith3.width) radius:sizeWith3.width/2];
            tiLab.text = [_energyUsingViewDict_tuandui objectForKey:@"pue"];
            [topBackView addSubview:tiLab];
            
            UILabel *tiLable = [UnityLHClass initUILabel:@"PUE值" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-120+sizeWith3.width, 55, 80, 30)];
            [tiLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            tiLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:tiLable];
            
            CGSize sizeWith4 = [self labelHight:[_energyUsingViewDict_tuandui objectForKey:@"deltaPue"]];
            UILabel *faLab = [UnityLHClass initLabel:@"0.2" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:33.0/255.0 green:64.0/255.0 blue:236.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-100, 125, sizeWith4.width, sizeWith4.width) radius:sizeWith4.width/2];
            faLab.text = [_energyUsingViewDict_tuandui objectForKey:@"deltaPue"];
            [topBackView addSubview:faLab];
            
            UILabel *faLable = [UnityLHClass initUILabel:@"△PUE" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-100+sizeWith4.width, 125, 70, 30)];
            [faLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            faLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:faLable];
            
            CGSize sizeWith5 = [self labelHight:[NSString stringWithFormat:@"￥%@",[_energyUsingViewDict_tuandui objectForKey:@"minusFee"]]];
            UILabel *saveLab = [UnityLHClass initLabel:@"￥59741" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:183.0/255.0 green:0.0/255.0 blue:225.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-120, 190, sizeWith5.width, sizeWith5.width) radius:sizeWith5.width/2];
            saveLab.text = [NSString stringWithFormat:@"￥%@",NoNullStr([_energyUsingViewDict_tuandui objectForKey:@"minusFee"])];
            [topBackView addSubview:saveLab];
            
            UILabel *saveLable = [UnityLHClass initUILabel:@"节电费" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-115+sizeWith5.width, 190+sizeWith5.width/4, 80, 30)];
            [saveLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            saveLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:saveLable];
            
            UILabel *totalLable = [UnityLHClass initUILabel:@"总节电费" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-195, 125, 70, 40)];
            [totalLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
            totalLable.numberOfLines = 0;
            totalLable.text = [NSString stringWithFormat:@"%@\n￥%@",@"总节电费",NoNullStr([_energyUsingViewDict_tuandui objectForKey:@"totalMinusFee"])];
            
            totalLable.textAlignment = NSTextAlignmentCenter;
            totalLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:totalLable];
            
            UIView *handleClickActionView = [[UIView alloc] initWithFrame:topBackView.bounds];
            handleClickActionView.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:handleClickActionView];
            [handleClickActionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teamInfoAction)]];
            
            
        }else if ([authArr[i]  isEqual: @"43"]){
#pragma mark - 区局视图_43
            UIView *thidBackView = [[UIView alloc]initWithFrame:CGRectMake(15, 20, kScreenWidth-30, 35)];
            thidBackView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:216.0/255.0 blue:249.0/255.0 alpha:1.0];
            [topBackView addSubview:thidBackView];
            
            UILabel *titLable = [UnityLHClass initUILabel:@"东区2015年4月" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(0, 0, kScreenWidth-30, 35)];
            
            if (districtArr.count == 0) {
                
            }else{
                titLable.text = [NSString stringWithFormat:@"%@%@",[[districtArr objectAtIndex:0] objectForKey:@"regainName"],[[districtArr objectAtIndex:0] objectForKey:@"batchDate"]];
            }
            
            
            [titLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
            titLable.textAlignment = NSTextAlignmentCenter;
            [thidBackView addSubview:titLable];
            
            
            for (int i = 0; i < 3; i++) {
                UIView *viewback = [[UIView alloc]initWithFrame:CGRectMake(15, 75+i*65, kScreenWidth-30, 30)];
                viewback.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:221.0/255.0 alpha:1.0];
                [topBackView addSubview:viewback];
                
                if (i == 0) {
                    UILabel *lable = [UnityLHClass initUILabel:@"指标名称" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(10, 5, 100, 20)];
                    [lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                    [viewback addSubview:lable];
                    
                    UILabel *lable1 = [UnityLHClass initUILabel:@"目标值" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-180, 5, 100, 20)];
                    [lable1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                    [viewback addSubview:lable1];
                    
                    UILabel *lable2 = [UnityLHClass initUILabel:@"当月值" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-120, 5, 100, 20)];
                    [lable2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                    [viewback addSubview:lable2];
                    
                    UILabel *lable3 = [UnityLHClass initUILabel:@"排名" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-60, 5, 100, 20)];
                    [lable3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                    [viewback addSubview:lable3];
                }
            }
            
            //
            
            if (districtArr.count == 0 || districtArr == nil) {
                
            }else{
                for (int i = 0; i < 4; i++) {
                    
                    UILabel *leftLable = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(25, 112+i*33, 100, 20)];//15, 75+i*65, kScreenWidth-30, 30
                    [leftLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                    leftLable.text = [[districtArr objectAtIndex:i] objectForKey:@"UName"];
                    leftLable.textAlignment = NSTextAlignmentLeft;
                    [topBackView addSubview:leftLable];
                    
                    UILabel *leftLable1 = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-180+7, 112+i*33, 50, 20)];//15, 75+i*65, kScreenWidth-30, 30
                    [leftLable1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                    leftLable1.backgroundColor = [UIColor clearColor];
                    leftLable1.textAlignment = NSTextAlignmentCenter;
                    leftLable1.text = [[districtArr objectAtIndex:i] objectForKey:@"target"];
                    [topBackView addSubview:leftLable1];
                    
                    UILabel *leftLable2 = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-120+7, 112+i*33, 50, 20)];//15, 75+i*65, kScreenWidth-30, 30
                    [leftLable2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                    leftLable2.backgroundColor = [UIColor clearColor];
                    leftLable2.textAlignment = NSTextAlignmentCenter;
                    leftLable2.text = [[districtArr objectAtIndex:i] objectForKey:@"month"];
                    [topBackView addSubview:leftLable2];
                    
                    UILabel *leftLable3 = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-60+10, 112+i*33, 30, 20)];//15, 75+i*65, kScreenWidth-30, 30
                    [leftLable3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                    leftLable3.backgroundColor = [UIColor clearColor];
                    leftLable3.textAlignment = NSTextAlignmentCenter;
                    leftLable3.text = [[districtArr objectAtIndex:i] objectForKey:@"rank"];
                    [topBackView addSubview:leftLable3];
                    
                }
            }
        }else if ([authArr[i]  isEqual: @"45"]){
#pragma mark - 领导视图_45
            UIImage *fImg = [UIImage imageNamed:@"蓝.png"];
            UIImage *fIm1 = [UIImage imageNamed:@"透明.png"];
            UIImage *fIm2 = [UIImage imageNamed:@"波浪.png"];
            [bgImg setFrame:CGRectMake(0, 0, kScreenWidth, 277)];
            [bgImg setImage:fImg];
            [topBackView addSubview:bgImg];
            
            UIImageView *touImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -40, fIm1.size.width/2, fIm1.size.height/2)];
            [touImg setImage:[UIImage imageNamed:@"透明.png"]];
            [bgImg addSubview:touImg];
            
            UIImageView *touImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 260, fIm2.size.width/2, fIm2.size.height/2)];
            [touImg1 setImage:fIm2];
            [touImg addSubview:touImg1];
            
            for (int j = 0; j < leaderArr.count; j++) {
                UILabel *lable = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(42, 65, 70, 40)];
                [lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                lable.text = [NSString stringWithFormat:@"%@\n%@",@"运营队伍",@"4800人"];
                if (leaderArr.count == 0) {
                    lable.text = @"";
                }else{
                    lable.text = [[leaderArr objectAtIndex:j] objectForKey:@"content"];
                }
                
                
                lable.numberOfLines = 0;
                lable.backgroundColor = [UIColor clearColor];
                lable.textAlignment = NSTextAlignmentCenter;
                [topBackView addSubview:lable];
                
                NSInteger indexId = [[[leaderArr objectAtIndex:j] objectForKey:@"id"] integerValue] - 1;
                
                if (indexId == 1) {
                    [lable setFrame:CGRectMake(125, 65, 70, 40)];
                }
                
                if (indexId == 2) {
                    [lable setFrame:CGRectMake(208, 65, 70, 40)];
                }
                
                if (indexId == 3) {
                    [lable setFrame:CGRectMake(83, 132, 70, 40)];
                }
                
                if (indexId == 4) {
                    [lable setFrame:CGRectMake(165, 132, 70, 40)];
                }
            }
            
            NSArray *leaderStatusArray = @[@"周期工作",@"故障维修",@"隐患处理",@"随工预约",@"临时任务"];
            NSString *str1 = [_leaderStatus objectForKey:@"cycleValue"];
            NSString *str2 = [_leaderStatus objectForKey:@"falutValue"];
            NSString *str3 = [_leaderStatus objectForKey:@"dangerValue"];
            NSString *str4 = [_leaderStatus objectForKey:@"orderValue"];
            NSString *str5 = [_leaderStatus objectForKey:@"tempTaskValue"];
            NSArray *numArr = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,nil];
            
            UIImageView *bacImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 237, kScreenWidth, 40)];
            bacImgView.image = [UIImage imageNamed:@"灰底"];
            [topBackView addSubview:bacImgView];
            
            MidButtonView *leaderStatusView = [[MidButtonView alloc]initWithFrame:CGRectMake(0, 237, kScreenWidth, 40) withImageArr:nil withTitleArr:leaderStatusArray withNumArr:numArr];
            leaderStatusView.delegate = self;
            [topBackView addSubview:leaderStatusView];
            
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 277)];
            btn.backgroundColor = [UIColor clearColor];
            if (leaderArr.count == 0) {
            }else{
                [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
            }
            [topBackView addSubview:btn];
            
        }else if ([authArr[i]  isEqual: @"47"]){
#pragma mark - 人员动向视图_47
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"yyyy年MM月dd日"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            
            UILabel *titlale = [UnityLHClass initUILabel:@"" font:15.0 color:[UIColor whiteColor] rect:CGRectMake(0, 20, kScreenWidth, 20)];
            titlale.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
            titlale.text = [NSString stringWithFormat:@"%@%@",NoNullStr([rydxDic objectForKey:@"regionName"]),dateString];
            titlale.textAlignment = NSTextAlignmentCenter;
            [topBackView addSubview:titlale];
            
            
            
            UILabel *classLable = [UnityLHClass initUILabel:@"任务类型" font:12.0 color:RGBCOLOR(88, 76, 54) rect:CGRectMake(20, 45, 80, 20)];
            [topBackView addSubview:classLable];
            
            //            NSArray *leftArr = @[@"故障",@"预约",@"周期故障",@"隐患",@"自定义"];
            NSMutableArray *numberArr = [[NSMutableArray alloc]initWithCapacity:10];
            
            for (int i = 0; i < rydxArray.count; i++) {
                UILabel *leftLable = [UnityLHClass initUILabel:[[rydxArray objectAtIndex:i] objectForKey:@"typeName"] font:12.0 color:[UIColor whiteColor] rect:CGRectMake(0, 70+27*i, 70, 20)];
                leftLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                leftLable.textAlignment = NSTextAlignmentRight;
                [topBackView addSubview:leftLable];
                
                NSString *strNum = [[[rydxArray objectAtIndex:i] objectForKey:@"peopleNum"] description];
                
                [numberArr addObject:strNum];
                
            }
            
            UIImage *img = [UIImage imageNamed:@"bsrt.png"];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(80, 60, 3, img.size.height/2+10)];
            lineView.backgroundColor = [UIColor whiteColor];
            [topBackView addSubview:lineView];
            
            UIImageView *txtImgView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 60, img.size.width/2, img.size.height/2+10)];
            txtImgView.image = img;
            txtImgView.userInteractionEnabled = YES;
            [topBackView addSubview:txtImgView];
            
            //            NSArray *numberArr = @[@300,@250,@400,@150,@95];
            
            NSNumber * max = [numberArr valueForKeyPath:@"@max.floatValue"];
            
            float maxValue = max.floatValue;
            
            for (int i = 0; i < numberArr.count; i++) {
                UIView *txtView = [[UIView alloc]init];
                txtView.backgroundColor = RGBCOLOR(0, 153, 153);
                txtView.layer.masksToBounds = YES;
                txtView.layer.cornerRadius = 5;
                [txtImgView addSubview:txtView];
                
                if ([[numberArr objectAtIndex:i] floatValue] == 0) {
                    txtView.frame = CGRectMake(10, 10+27*i, 0, 20);
                }else{
                    txtView.frame = CGRectMake(10, 10+27*i, [[numberArr objectAtIndex:i] floatValue]*200/maxValue, 20);
                }
                
                UILabel *numLable = [UnityLHClass initUILabel:[NSString stringWithFormat:@"%.f",[[numberArr objectAtIndex:i] floatValue]] font:11.0 color:[UIColor whiteColor] rect:CGRectMake(0, 0, 0, 20)];
                numLable.textAlignment = NSTextAlignmentRight;
                numLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                [txtView addSubview:numLable];
                
                if ([[numberArr objectAtIndex:i] floatValue] == 0) {
                    numLable.frame = CGRectMake(10, 0, 0, 20);
                }else{
                    numLable.frame = CGRectMake(0, 0, [[numberArr objectAtIndex:i] floatValue]*200/maxValue, 20);
                }
                
                //                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, txtView.size.width, 20)];
                //                button.backgroundColor = [UIColor clearColor];
                //                button.tag = 100+i;
                //                [button addTarget:self action:@selector(btnClass:) forControlEvents:UIControlEventTouchUpInside];
                //                [txtView addSubview:button];
            }
            
            UILabel *peopleNumLable = [UnityLHClass initUILabel:@"人员数量" font:11.0 color:RGBCOLOR(88, 76, 54) rect:CGRectMake(kScreenWidth-80, img.size.height/2+75, 50, 20)];
            peopleNumLable.textAlignment = NSTextAlignmentRight;
            [topBackView addSubview:peopleNumLable];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 277)];
            button.backgroundColor = [UIColor clearColor];
            
            [button addTarget:self action:@selector(btnClass:) forControlEvents:UIControlEventTouchUpInside];
            [topBackView addSubview:button];
        }else if ([authArr[i] isEqual:@"54"]){
#pragma mark - 划小全局视图_54
            UILabel *titleLable = [UnityLHClass initUILabel:@"能耗划小统计(横浜4月)" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(0, 10, kScreenWidth, 30)];
            titleLable.text = [NSString stringWithFormat:@"能耗划小统计(%@%@月)",NoNullStr([_energyUsingViewDict_quanju objectForKey:@"siteName"]),NoNullStr([_energyUsingViewDict_quanju objectForKey:@"month"])];
            titleLable.textAlignment = NSTextAlignmentCenter;
            [titleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
            [topBackView addSubview:titleLable];
            
            UIImage *secImg = [UIImage imageNamed:@"首页-6-5(02).png"];
            UIImageView *secImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, secImg.size.width/2, secImg.size.height/2)];
            secImgView.image = secImg;
            [topBackView addSubview:secImgView];
            
            CGSize sizeWith = [self labelHight:[_energyUsingViewDict_quanju objectForKey:@"t0"]];
            
            UILabel *weiLab = [UnityLHClass initLabel:@"0.9" font:11.0 color:[UIColor whiteColor] color:[UIColor blueColor] rect:CGRectMake(kScreenWidth-250, 64, sizeWith.width, sizeWith.width) radius:sizeWith.width/2];
            weiLab.text = [_energyUsingViewDict_quanju objectForKey:@"t0"];
            [topBackView addSubview:weiLab];
            
            UILabel *weiLable = [UnityLHClass initUILabel:@"T0值" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-245+sizeWith.width, 63, 100, 30)];
            [weiLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            weiLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:weiLable];
            
            CGSize sizeWith1 = [self labelHight:[_energyUsingViewDict_quanju objectForKey:@"billValue"]];
            UILabel *eleLab = [UnityLHClass initLabel:@"597" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:8.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-290, 127, sizeWith1.width, sizeWith1.width) radius:sizeWith1.width/2];
            eleLab.text = [_energyUsingViewDict_quanju objectForKey:@"billValue"];
            [topBackView addSubview:eleLab];
            
            UILabel *eleLable = [UnityLHClass initUILabel:@"总电量" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-288, 125+sizeWith1.width, 50, 30)];
            [eleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            eleLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:eleLable];
            
            CGSize sizeWith2 = [self labelHight:[_energyUsingViewDict_quanju objectForKey:@"txValue"]];
            UILabel *commLab = [UnityLHClass initLabel:@"1597°" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:0.0/255.0 green:151.0/255.0 blue:140.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-245, 195, sizeWith2.width, sizeWith2.width) radius:sizeWith2.width/2];
            commLab.text = [_energyUsingViewDict_quanju objectForKey:@"txValue"];
            [topBackView addSubview:commLab];
            
            UILabel *commLable = [UnityLHClass initUILabel:@"通信电量" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-240+sizeWith2.width, 200, 90, 30)];
            [commLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            commLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:commLable];
            
            CGSize sizeWith3 = [self labelHight:[_energyUsingViewDict_quanju objectForKey:@"pue"]];
            UILabel *tiLab = [UnityLHClass initLabel:@"120条" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:246.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-123, 55, sizeWith3.width, sizeWith3.width) radius:sizeWith3.width/2];
            tiLab.text = [_energyUsingViewDict_quanju objectForKey:@"pue"];
            [topBackView addSubview:tiLab];
            
            UILabel *tiLable = [UnityLHClass initUILabel:@"PUE值" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-120+sizeWith3.width, 55, 80, 30)];
            [tiLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            tiLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:tiLable];
            
            CGSize sizeWith4 = [self labelHight:[_energyUsingViewDict_quanju objectForKey:@"deltaPue"]];
            UILabel *faLab = [UnityLHClass initLabel:@"0.2" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:33.0/255.0 green:64.0/255.0 blue:236.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-100, 125, sizeWith4.width, sizeWith4.width) radius:sizeWith4.width/2];
            faLab.text = [_energyUsingViewDict_quanju objectForKey:@"deltaPue"];
            [topBackView addSubview:faLab];
            
            UILabel *faLable = [UnityLHClass initUILabel:@"△PUE" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-100+sizeWith4.width, 125, 70, 30)];
            [faLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            faLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:faLable];
            
            CGSize sizeWith5 = [self labelHight:[NSString stringWithFormat:@"￥%@",[_energyUsingViewDict_quanju objectForKey:@"minusFee"]]];
            UILabel *saveLab = [UnityLHClass initLabel:@"￥59741" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:183.0/255.0 green:0.0/255.0 blue:225.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-120, 190, sizeWith5.width, sizeWith5.width) radius:sizeWith5.width/2];
            saveLab.text = [NSString stringWithFormat:@"￥%@",NoNullStr([_energyUsingViewDict_quanju objectForKey:@"minusFee"])];
            [topBackView addSubview:saveLab];
            
            UILabel *saveLable = [UnityLHClass initUILabel:@"节电费" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-115+sizeWith5.width, 190+sizeWith5.width/4, 80, 30)];
            [saveLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            saveLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:saveLable];
            
            UILabel *totalLable = [UnityLHClass initUILabel:@"总节电费" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-195, 125, 70, 40)];
            [totalLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
            totalLable.numberOfLines = 0;
            totalLable.text = [NSString stringWithFormat:@"%@\n￥%@",@"总节电费",NoNullStr([_energyUsingViewDict_quanju objectForKey:@"totalMinusFee"])];
            
            totalLable.textAlignment = NSTextAlignmentCenter;
            totalLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:totalLable];
            
            UIView *handleClickActionView = [[UIView alloc] initWithFrame:topBackView.bounds];
            handleClickActionView.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:handleClickActionView];
            [handleClickActionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wholeStationAction)]];
            
        }else if ([authArr[i] isEqual:@"55"]){
#pragma mark - 划小区局视图_55
            UILabel *titleLable = [UnityLHClass initUILabel:@"能耗划小统计(横浜4月)" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(0, 10, kScreenWidth, 30)];
            titleLable.text = [NSString stringWithFormat:@"能耗划小统计(%@%@月)",NoNullStr([_energyUsingViewDict_quju objectForKey:@"siteName"]),NoNullStr([_energyUsingViewDict_quju objectForKey:@"month"])];
            titleLable.textAlignment = NSTextAlignmentCenter;
            [titleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
            [topBackView addSubview:titleLable];
            
            UIImage *secImg = [UIImage imageNamed:@"首页-6-5(02).png"];
            UIImageView *secImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, secImg.size.width/2, secImg.size.height/2)];
            secImgView.image = secImg;
            [topBackView addSubview:secImgView];
            
            CGSize sizeWith = [self labelHight:[_energyUsingViewDict_quju objectForKey:@"t0"]];
            
            UILabel *weiLab = [UnityLHClass initLabel:@"0.9" font:11.0 color:[UIColor whiteColor] color:[UIColor blueColor] rect:CGRectMake(kScreenWidth-250, 64, sizeWith.width, sizeWith.width) radius:sizeWith.width/2];
            weiLab.text = [_energyUsingViewDict_quju objectForKey:@"t0"];
            [topBackView addSubview:weiLab];
            
            UILabel *weiLable = [UnityLHClass initUILabel:@"T0值" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-245+sizeWith.width, 63, 100, 30)];
            [weiLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            weiLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:weiLable];
            
            CGSize sizeWith1 = [self labelHight:[_energyUsingViewDict_quju objectForKey:@"billValue"]];
            UILabel *eleLab = [UnityLHClass initLabel:@"597" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:8.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-290, 127, sizeWith1.width, sizeWith1.width) radius:sizeWith1.width/2];
            eleLab.text = [_energyUsingViewDict_quju objectForKey:@"billValue"];
            [topBackView addSubview:eleLab];
            
            UILabel *eleLable = [UnityLHClass initUILabel:@"总电量" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-288, 125+sizeWith1.width, 50, 30)];
            [eleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            eleLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:eleLable];
            
            CGSize sizeWith2 = [self labelHight:[_energyUsingViewDict_quju objectForKey:@"txValue"]];
            UILabel *commLab = [UnityLHClass initLabel:@"1597°" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:0.0/255.0 green:151.0/255.0 blue:140.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-245, 195, sizeWith2.width, sizeWith2.width) radius:sizeWith2.width/2];
            commLab.text = [_energyUsingViewDict_quju objectForKey:@"txValue"];
            [topBackView addSubview:commLab];
            
            UILabel *commLable = [UnityLHClass initUILabel:@"通信电量" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-240+sizeWith2.width, 200, 90, 30)];
            [commLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            commLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:commLable];
            
            CGSize sizeWith3 = [self labelHight:[_energyUsingViewDict_quju objectForKey:@"pue"]];
            UILabel *tiLab = [UnityLHClass initLabel:@"120条" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:246.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-123, 55, sizeWith3.width, sizeWith3.width) radius:sizeWith3.width/2];
            tiLab.text = [_energyUsingViewDict_quju objectForKey:@"pue"];
            [topBackView addSubview:tiLab];
            
            UILabel *tiLable = [UnityLHClass initUILabel:@"PUE值" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-120+sizeWith3.width, 55, 80, 30)];
            [tiLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            tiLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:tiLable];
            
            CGSize sizeWith4 = [self labelHight:[_energyUsingViewDict_quju objectForKey:@"deltaPue"]];
            UILabel *faLab = [UnityLHClass initLabel:@"0.2" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:33.0/255.0 green:64.0/255.0 blue:236.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-100, 125, sizeWith4.width, sizeWith4.width) radius:sizeWith4.width/2];
            faLab.text = [_energyUsingViewDict_quju objectForKey:@"deltaPue"];
            [topBackView addSubview:faLab];
            
            UILabel *faLable = [UnityLHClass initUILabel:@"△PUE" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-100+sizeWith4.width, 125, 70, 30)];
            [faLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            faLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:faLable];
            
            CGSize sizeWith5 = [self labelHight:[NSString stringWithFormat:@"￥%@",[_energyUsingViewDict_quju objectForKey:@"minusFee"]]];
            UILabel *saveLab = [UnityLHClass initLabel:@"￥59741" font:11.0 color:[UIColor whiteColor] color:[UIColor colorWithRed:183.0/255.0 green:0.0/255.0 blue:225.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-120, 190, sizeWith5.width, sizeWith5.width) radius:sizeWith5.width/2];
            saveLab.text = [NSString stringWithFormat:@"￥%@",NoNullStr([_energyUsingViewDict_quju objectForKey:@"minusFee"])];
            [topBackView addSubview:saveLab];
            
            UILabel *saveLable = [UnityLHClass initUILabel:@"节电费" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-115+sizeWith5.width, 190+sizeWith5.width/4, 80, 30)];
            [saveLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
            saveLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:saveLable];
            
            UILabel *totalLable = [UnityLHClass initUILabel:@"总节电费" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-195, 125, 70, 40)];
            [totalLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
            totalLable.numberOfLines = 0;
            totalLable.text = [NSString stringWithFormat:@"%@\n￥%@",@"总节电费",NoNullStr([_energyUsingViewDict_quju objectForKey:@"totalMinusFee"])];
            
            totalLable.textAlignment = NSTextAlignmentCenter;
            totalLable.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:totalLable];
            
            UIView *handleClickActionView = [[UIView alloc] initWithFrame:topBackView.bounds];
            handleClickActionView.backgroundColor = [UIColor clearColor];
            [topBackView addSubview:handleClickActionView];
            [handleClickActionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleStationAction)]];
        }else if ([authArr[i] isEqual:@"78"]) {
            
            if (!_workOrderChartView) {
                _workOrderChartView = [[YZWorkOrderChartView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 276)];
                _workOrderChartView.delegate = self;
            }
            [topBackView addSubview:_workOrderChartView];
            
   
        }else if ([authArr[i] isEqual:@"79"]) {
            
            if (!_percentageView) {
                _percentageView = [[YZPercentageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 276)];
                _percentageView.delegate = self;
            }
            [topBackView addSubview:_percentageView];
        }
    }
    
    myPageCtrl = [[MyPageControl alloc] initWithFrame:CGRectMake(0, 288-40, kScreenWidth, 10)];
    myPageCtrl.currentPage = 0;
    myPageCtrl.numberOfPages = authorityInfo.count;
    myPageCtrl.userInteractionEnabled=NO;
    myPageCtrl.hidesForSinglePage = YES;
    myPageCtrl.pageIndicatorTintColor = [UIColor whiteColor];
    myPageCtrl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0/255.0 green:233.0/255.0 blue:37.0/255.0 alpha:1.0];
    
    [view addSubview:myPageCtrl];
    
    pageIndex = _quickViewArray.count/6+1;
    
    self.midScoreView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,342-79, kScreenWidth, 176)];
    self.midScoreView.pagingEnabled = YES;
    self.midScoreView.delegate = self;
    self.midScoreView.showsHorizontalScrollIndicator = NO;
    self.midScoreView.contentSize = CGSizeMake(kScreenWidth*pageIndex, 176);
    
    
    [view addSubview:self.midScoreView];
    
    UIImage *image = [UIImage imageNamed:@"值班.png"];
    int num = (_quickViewArray.count+1)/btns +1 ;
    self.midScoreView.contentSize = CGSizeMake(kScreenWidth * num, 0);
    self.midScoreView.pagingEnabled = YES;
    
    CGFloat width = image.size.width;
    CGFloat hight = image.size.height;
    
    
    for (int j = 0; j<num; j++) {
        
        UIView * view = [[UIView alloc]init];
        view.frame = CGRectMake(kScreenWidth * j, 0, kScreenWidth, 176);
        
        view.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i<_quickViewArray.count+1; i++) {
            
            if (i < btns * (j +1) && i >= btns * j) {
                
                int n = i - btns * j;
                
                int row = n / column;
                
                int col = n % column;
                
                CGFloat x = width * col+6;
                
                CGFloat y =hight/1.3 * row;
                
                if (i == _quickViewArray.count) {
                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(x+34, y+10, width/2-10, hight/2-10)];
                    imgView.image = [UIImage imageNamed:@"add.png"];
                    imgView.userInteractionEnabled = YES;
                    [view addSubview:imgView];
                    
                    UILabel *lable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor blackColor] rect:CGRectMake(x+4, y+hight/2-10, width, hight/2-10)];
                    lable.textAlignment = NSTextAlignmentCenter;
                    [view addSubview:lable];
                    
                    UIButton *imgViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(x+34, y+10, width/2-10, hight/2-10)];
                    imgViewBtn.tag = 1000+i;
                    [imgViewBtn addTarget:self action:@selector(imgBtn:) forControlEvents:UIControlEventTouchUpInside];
                    imgViewBtn.backgroundColor = [UIColor clearColor];
                    [view addSubview:imgViewBtn];
                }else{
                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(x+34, y+5, width/2-10, hight/2-10)];
                    
                    
                    
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/ywglAppFunctionRole/%@/",ADDR_IP,ADDR_DIR,[[_quickViewArray objectAtIndex:i] objectForKey:@"functionId"]]]];
                    imgView.userInteractionEnabled = YES;
                    [view addSubview:imgView];
                    
                    UILabel *lable = [UnityLHClass initUILabel:[[_quickViewArray objectAtIndex:i] objectForKey:@"functionName"] font:13.0 color:[UIColor blackColor] rect:CGRectMake(x+4, y+hight/2-10, width, hight/2-10)];
                    lable.textAlignment = NSTextAlignmentCenter;
                    [view addSubview:lable];
                    
                    UIButton *imgViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(x+34, y+10, width/2-10, hight/2-10)];
                    imgViewBtn.tag = 1000+i;
                    [imgViewBtn addTarget:self action:@selector(imgViewBtn:) forControlEvents:UIControlEventTouchUpInside];
                    imgViewBtn.backgroundColor = [UIColor clearColor];
                    [view addSubview:imgViewBtn];
                }
            }
            [self.midScoreView addSubview:view];
        }
    }
    
    
    myPageCtrl1 = [[MyPageControl alloc] initWithFrame:CGRectMake(0, 500-64, kScreenWidth, 10)];
    myPageCtrl1.currentPage = 0;
    myPageCtrl1.numberOfPages = pageIndex;
    myPageCtrl1.userInteractionEnabled=NO;
    myPageCtrl1.hidesForSinglePage = YES;
    myPageCtrl1.pageIndicatorTintColor = [UIColor orangeColor];
    myPageCtrl1.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0/255.0 green:233.0/255.0 blue:37.0/255.0 alpha:1.0];
    
    
    [view addSubview:myPageCtrl1];
    
    //滚动新闻是否显示
    if (labArr.count == 0) {
        lableScrollView.hidden = YES;
        self.topScoreView.frame = CGRectMake(0, 0, kScreenWidth, 292);
        self.midScoreView.frame = CGRectMake(0, 342-37, kScreenWidth, 176);
        [myPageCtrl setFrame:CGRectMake(0, 288-24, kScreenWidth, 10)];
        [myPageCtrl1 setFrame:CGRectMake(0, 500-60, kScreenWidth, 10)];
    }else{
        lableScrollView.hidden = NO;
        self.topScoreView.frame = CGRectMake(0, 35, kScreenWidth, 292);
        self.midScoreView.frame = CGRectMake(0, 342-31, kScreenWidth, 176);
        [myPageCtrl setFrame:CGRectMake(0, 288-4, kScreenWidth, 10)];
        [myPageCtrl1 setFrame:CGRectMake(0, 500-64, kScreenWidth, 10)];
    }
    
    return view;
}

-(void)initView
{
    [self addView];
}

- (CGSize)numHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

#pragma mark - 能耗划小视图点击_区局_2
- (void)singleStationAction
{
    EnergyUsingViewController *energyUsingCtrl = [[EnergyUsingViewController alloc] init];
    energyUsingCtrl.type = @"2";
    [self.navigationController pushViewController:energyUsingCtrl animated:YES];
}

#pragma mark - 能耗划小视图点击_团队_3
- (void)teamInfoAction
{
    EnergyUsingViewController *energyUsingCtrl = [[EnergyUsingViewController alloc] init];
    energyUsingCtrl.type = @"3";
    [self.navigationController pushViewController:energyUsingCtrl animated:YES];
}

#pragma mark - 能耗划小视图点击_全局_1
- (void)wholeStationAction
{
    EnergyUsingViewController *energyUsingCtrl = [[EnergyUsingViewController alloc] init];
    energyUsingCtrl.type = @"1";
    [self.navigationController pushViewController:energyUsingCtrl animated:YES];
}

#pragma mark == 划小视图点击
-(void)touchBtn
{
    FeedbackViewController *feedVC = [[FeedbackViewController alloc]init];
    feedVC.tag = 10;
    [self.navigationController pushViewController:feedVC animated:YES];
}

-(void)btn
{
    HuaXiaoViewController *huaVC = [[HuaXiaoViewController alloc]init];
    huaVC.dataArr = leaderArr;
    [self.navigationController pushViewController:huaVC animated:YES];
}

- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

#pragma mark == 快捷菜单
-(void)addView
{
    backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.8;
    backView.hidden = YES;
    [self.view addSubview:backView];
    
    pickView = [[UIView alloc]initWithFrame:self.view.bounds];
    [pickView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    pickView.hidden = YES;
    [self.view addSubview:pickView];
    
    NSArray* array1  = [NSArray arrayWithObjects:@"任务",@"信息",@"日常", nil];
    UIImage *btnClassImg = [UIImage imageNamed:@"tab_bg"];
    for (int i = 0; i<3; i++) {
        
        UIButton* butt = [UIButton buttonWithType:UIButtonTypeCustom];
        [butt setFrame:CGRectMake(i*(btnClassImg.size.width/2+3)+15, 84, btnClassImg.size.width/2+3, btnClassImg.size.height/2+3)];
        [butt setTag:10+i];
        [butt setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        [butt setTitle:[array1 objectAtIndex:i] forState:UIControlStateNormal];
        [butt setTitleColor:[UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        butt.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        [butt addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pickView addSubview:butt];
        
        if (i == 0) {
            [butt setBackgroundImage:[UIImage imageNamed:@"tab_bg_white"] forState:UIControlStateNormal];
            [butt setTitleColor:[UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        
    }
    
    UIView *collectionBackView = [[UIView alloc]initWithFrame:CGRectMake(15, 99+btnClassImg.size.height/2+3, kScreenWidth-30, kScreenHeight-160)];
    collectionBackView.backgroundColor = [UIColor whiteColor];
    [pickView addSubview:collectionBackView];
    
    UICollectionViewWaterfallLayout * layout = [[UICollectionViewWaterfallLayout alloc] init];
    layout.delegate  = self;
    layout.columnCount = 3;
    layout.itemWidth = 75;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    myColectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, kScreenHeight-160) collectionViewLayout:layout];
    
    myColectionView.delegate =  self;
    myColectionView.dataSource = self;
    myColectionView.alwaysBounceVertical = YES;
    myColectionView.backgroundColor = [UIColor whiteColor];
    myColectionView.showsVerticalScrollIndicator = NO;
    [myColectionView registerClass:[AddTaskCollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionCell"];
    
    [collectionBackView addSubview:myColectionView];
    
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPicker:)];
    [backView addGestureRecognizer:tap];
    
    NSArray *classArray = @[@"任务类",@"信息类",@"日常类",@"×"];
    for (int i = 0; i < 4; i++) {
        UIButton *rwBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2-30, 100+100*i, 60, 60)];
        [rwBtn setTitle:[classArray objectAtIndex:i] forState:UIControlStateNormal];
        [rwBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rwBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [rwBtn circularBeadColor:[UIColor blackColor]];
        [rwBtn circularBead:30];
        [rwBtn bottomBorder:10];
        rwBtn.tag = 100+i;
        [rwBtn addTarget:self action:@selector(classBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:rwBtn];
    }
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0];
    [pickView addSubview:navView];
    
    UILabel *titleLable = [UnityLHClass initUILabel:@"快捷菜单选择" font:15.0 color:[UIColor whiteColor] rect:CGRectMake(0, 30, kScreenWidth, 25)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    [navView addSubview:titleLable];
    
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(10, 25,navImg.size.width/1,navImg.size.height/1)];
    imageView.userInteractionEnabled = YES;
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,navImg.size.width/1,navImg.size.height/1);
    [leftButton addTarget:self action:@selector(leftNavAction) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:leftButton];
    [navView addSubview:imageView];
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.topScoreView){
        CGPoint offset = scrollView.contentOffset;
        myPageCtrl.currentPage = offset.x / (self.view.bounds.size.width); //计算当前的页码
        [self.topScoreView setContentOffset:CGPointMake(self.view.bounds.size.width * (myPageCtrl.currentPage),self.topScoreView.contentOffset.y) animated:YES]; //设置scrollview的显示为当前滑动到的页面
        NSString *functionId = [_loadMutDict objectForKey:[NSString stringWithFormat:@"%d",myPageCtrl.currentPage]];
        if (functionId) {
            [self loadDataWithFunctionId:functionId indexKey:[NSString stringWithFormat:@"%d",myPageCtrl.currentPage]];
        }
    }else if (scrollView == self.midScoreView){
        CGPoint offset = scrollView.contentOffset;
        myPageCtrl1.currentPage = offset.x / (self.view.bounds.size.width); //计算当前的页码
        [self.midScoreView setContentOffset:CGPointMake(self.view.bounds.size.width * (myPageCtrl1.currentPage),self.midScoreView.contentOffset.y) animated:YES]; //设置scrollview的显示为当前滑动到的页面
    }else if (scrollView == lableScrollView){
        
        CGFloat pagewidth = lableScrollView.frame.size.height;
        int currentPage = floor((lableScrollView.contentOffset.y - pagewidth/ ([labArr count]+2)) / pagewidth) + 1;
        
        if (currentPage==0)
        {
            [lableScrollView scrollRectToVisible:CGRectMake(0,35 * [labArr count],kScreenWidth,35) animated:NO]; // 序号0 最后1页
        }
        else if (currentPage==([labArr count]+1))
        {
            [lableScrollView scrollRectToVisible:CGRectMake(0,35,kScreenWidth,35) animated:NO]; // 最后+1,循环第1页
        }
        
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender == self.topScoreView) {
        CGFloat pagewidth = self.topScoreView.frame.size.width;
        int page = floor((self.topScoreView.contentOffset.x - pagewidth/5)/pagewidth)+2;
        page --;  // 默认从第二页开始
        myPageCtrl.currentPage = page;
        
//        if (labArr.count == 0){
//            if (page == 3) {
//                [myPageCtrl setFrame:CGRectMake(0, 288-65, kScreenWidth, 10)];
//            }else{
//                [myPageCtrl setFrame:CGRectMake(0, 288-24, kScreenWidth, 10)];
//            }
//        }else{
//            if (page == 3) {
//                [myPageCtrl setFrame:CGRectMake(0, 288-40, kScreenWidth, 10)];
//            }else{
//                [myPageCtrl setFrame:CGRectMake(0, 288-4, kScreenWidth, 10)];
//            }
//        }
        
        
    }else if (sender == self.midScoreView) {
        CGFloat pagewidth = self.midScoreView.frame.size.width;
        int page = floor((self.midScoreView.contentOffset.x - pagewidth/5)/pagewidth)+2;
        page --;  // 默认从第二页开始
        myPageCtrl1.currentPage = page;
        
        
    }else if (sender == lableScrollView){
        
        CGFloat pagewidth = lableScrollView.frame.size.height;
        int page = floor((lableScrollView.contentOffset.y - pagewidth/(labArr.count+2))/pagewidth)+1;
        page --;  // 默认从第二页开始
        pageControl.currentPage = page;
        pageNum = page;
        numLab.text = @"";
        numLab.text = [NSString stringWithFormat:@"%d/%d",pageNum+1,labArr.count];
        [lableScrollView reloadInputViews];
        
        CATransition *myanim = [CATransition animation];
        myanim.type = kCATransitionReveal;          //界面切换的方式
        myanim.subtype = kCATransitionFromTop;  //界面切换的方向
        myanim.duration = 1;      //时长
        [lableScrollView.layer addAnimation:myanim forKey:@"trans"];
    }
}

#pragma mark == 顶部
- (void)topBtn:(NSInteger)index
{
    if (index == 0) {
        NSLog(@"0");
        MapViewController *nearVC = [[MapViewController alloc]init];
        nearVC.tag = 10;
        [self.navigationController pushViewController:nearVC animated:YES];
        
    }else if (index == 1) {
        NSLog(@"1");
        MyTaskMonthList *calendarVC = [[MyTaskMonthList alloc]init];
        [self.navigationController pushViewController:calendarVC animated:YES];
        //        MonthViewController *monthVC = [[MonthViewController alloc]init];
        //        [self.navigationController pushViewController:monthVC animated:YES];
    }else{
        NSLog(@"2");
        UrgentViewController *urgentVC = [[UrgentViewController alloc]init];
        [self.navigationController pushViewController:urgentVC animated:YES];
    }
}

#pragma mark == 中间
- (void)midBtn:(NSInteger)index
{
    if (index == 0) {
        NSLog(@"0");
    }else if (index == 1) {
        NSLog(@"1");
    }else if (index == 2) {
        NSLog(@"2");
    }else{
        NSLog(@"3");
    }
}

-(void)bb
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    LeftViewController *bb = [[LeftViewController alloc]init];
    [self.navigationController pushViewController:bb animated:YES];
}

-(void)rightAction
{
//    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app.menuController showRightController:YES];
    VehicleReservationRecord *ctrl = [[VehicleReservationRecord alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];

    
    
}
//测试政企工单
-(void)leftAction
{
    
    LeftViewController *leftController = [[LeftViewController alloc] init];
    [self.navigationController pushViewController:leftController animated:YES];
    
   
   
    
}


#pragma mark - 自定义快捷菜单
-(void)imgBtn:(UIButton *)sender
{
    _quickChooseBtnInfoArray = [NSMutableArray array];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([_isTask_isInfo_isDaily isEqualToString: @"isTask"]) {
        _quickChooseBtnInfoArray = [ud objectForKey:@"authorityTaskList"];
    }else if ([_isTask_isInfo_isDaily isEqualToString: @"isInfo"]){
        _quickChooseBtnInfoArray = [ud objectForKey:@"authorityInfoList"];
    }else if([_isTask_isInfo_isDaily isEqualToString: @"isDaily"]){
        _quickChooseBtnInfoArray = [ud objectForKey:@"authorityDailyList"];
    }else{
        _quickChooseBtnInfoArray = [ud objectForKey:@"authorityTaskList"];
    }
    
    [self hiddenBottomBar:YES];
    self.navigationController.navigationBarHidden = YES;
    lableScrollView.hidden = YES;
    backView.hidden = YES;
    pickView.hidden = NO;
    [myColectionView reloadData];
}

#pragma mark - 正式添加分类菜单
-(void)clickBtn:(UIButton *)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    UIImage *wxzBtnImg = [UIImage imageNamed:@"tab_bg"]; //未选中button的图片
    UIImage *xzBtnImg = [UIImage imageNamed:@"tab_bg_white"];  //选中button的图片
    
    UIButton* btn1 = (UIButton*)[pickView viewWithTag:10];
    UIButton* btn2 = (UIButton*)[pickView viewWithTag:11];
    UIButton* btn3 = (UIButton*)[pickView viewWithTag:12];
    
    if (sender.tag == 10){
        _isTask_isInfo_isDaily = @"isTask";
        [btn1 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        [btn1 setTitleColor:[UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        _quickChooseBtnInfoArray = [ud objectForKey:@"authorityTaskList"];
        
        [myColectionView reloadData];
    }else if (sender.tag == 11){
        _isTask_isInfo_isDaily = @"isInfo";
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        [btn1 setTitleColor:[UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        _quickChooseBtnInfoArray = [ud objectForKey:@"authorityInfoList"];
        [myColectionView reloadData];
        
    }else if (sender.tag == 12){
        _isTask_isInfo_isDaily = @"isDaily";
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        
        [btn1 setTitleColor:[UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        _quickChooseBtnInfoArray = [ud objectForKey:@"authorityDailyList"];
        [myColectionView reloadData];
    }
}

#pragma mark == UITapGestureRecognizer
- (void)tapPicker:(UITapGestureRecognizer*)sender
{
    CATransition *myanim = [CATransition animation];
    myanim.type = kCATransitionMoveIn;//界面切换的方式
    myanim.subtype = kCATransitionFade;//界面切换的方向
    myanim.duration = 0.3;
    [backView.layer addAnimation:myanim forKey:@"trans"];
    
    UIView* backView11 = (UIView*)sender.view;
    backView11.hidden = YES;
    pickView.hidden = YES;
    lableScrollView.hidden = NO;
    [self hiddenBottomBar:NO];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark == 首页按钮点击进入
-(void)imgViewBtn:(UIButton *)sender
{
    int btnTag = sender.tag - 1000;
    NSString *functionId = _quickViewArray[btnTag][@"locationIos"];
    NSString *iosPackage = _quickViewArray[btnTag][@"iosPackage"];
    DLog(@"%@",functionId);
    if ([iosPackage isEqualToString:@"0"]) {
        if ([functionId isEqualToString:@"MyRepairFaultListKB"]) {
            MyRepairFaultListKB *KBVc = [[MyRepairFaultListKB alloc] init];
            KBVc.delegate = self;
            KBVc.memoryUrlType = self.memoryItem;
            KBVc.memoryFlagType = self.urlFlag;
            [self.navigationController pushViewController:KBVc animated:YES];
        }else{
            UIViewController *vc = [[NSClassFromString(functionId) alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{

 
    }
//    应用间跳转
    if ([iosPackage isEqualToString:@"1"]) {
        NSString* strUrl = format(@"iPower://%@?accessToken=%@", functionId,UGET(U_POWER_TOKEN));
        NSString *unicodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:unicodeURL]];
    }
    
}


- (void)deliverMemorySelectItem:(NSString *)memorySelect urlFlag:(NSString *)urlFlag
{
    self.memoryItem = memorySelect;
    self.urlFlag = urlFlag;
}

#pragma mark == 分类按钮
-(void)classBtn:(UIButton *)sender
{
    if (sender.tag == 100) {
        NSLog(@"0");
        backView.hidden = YES;
        pickView.hidden = NO;
        
        //push动画
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [pickView.layer addAnimation:transition forKey:nil];
        
        imageArray = [[NSMutableArray alloc]initWithObjects:@"zqgz.png",@"gzcl.png",@"xzyykm.png",@"yykmqd.png",@"xzsgyy.png",@"sgqd.png",@"xzyh.png",@"yhqd.png",@"zyxj.png",@"所有任务.png", nil];
        
        titleArray = [[NSMutableArray alloc]initWithObjects:@"周期工作",@"故障处理",@"新增预约开门",@"预约开门清单",@"新增随工预约",@"随工清单",@"新增隐患",@"隐患清单",@"资源巡检",@"所有任务", nil];
        [myColectionView reloadData];
    }else if (sender.tag == 101){
        backView.hidden = YES;
        pickView.hidden = NO;
        
        //push动画
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [pickView.layer addAnimation:transition forKey:nil];
        
        
        imageArray = [[NSMutableArray alloc]initWithObjects:@"jz.png",@"jf.png",@"wy.png",@"wxLTEzy.png",@"jhzy.png",@"wxLTEwg.png",@"EPONxx.png",@"glgd.png",@"动力资源.png",@"动力网管.png",@"所有任务.png", nil];
        
        titleArray = [[NSMutableArray alloc]initWithObjects:@"局站",@"机房",@"网元",@"无线LTE资源",@"交换资源",@"无线LTE网管",@"EPON信息",@"光路工单",@"动力资源",@"动力网管",@"所有任务", nil];
        
        [myColectionView reloadData];
        NSLog(@"1");
    }else if (sender.tag == 102){
        NSLog(@"2");
        backView.hidden = YES;
        pickView.hidden = NO;
        
        //push动画
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [pickView.layer addAnimation:transition forKey:nil];
        
        imageArray = [[NSMutableArray alloc]initWithObjects:@"值班.png",@"jjb.png", nil];
        
        titleArray = [[NSMutableArray alloc]initWithObjects:@"值班日志",@"交接班", nil];
        [myColectionView reloadData];
    }else if (sender.tag == 103){
        NSLog(@"3");
        [self hiddenBottomBar:NO];
        self.navigationController.navigationBarHidden = NO;
        
        backView.hidden = YES;
        pickView.hidden = YES;
        CATransition *myanim = [CATransition animation];
        myanim.type = kCATransitionMoveIn;          //界面切换的方式
        myanim.subtype = kCATransitionFade;  //界面切换的方向
        myanim.duration = 0.3;
        [backView.layer addAnimation:myanim forKey:@"trans"];
    }
}

#pragma mark == 添加快捷菜单左侧按钮
-(void)leftNavAction
{
    _quickViewArray = [NSMutableArray array];
    
    [self hiddenBottomBar:NO];
    self.navigationController.navigationBarHidden = NO;
    lableScrollView.hidden = NO;
    backView.hidden = YES;
    pickView.hidden = YES;
    
    //pop动画
    CATransition *myanim = [CATransition animation];
    myanim.type = kCATransitionMoveIn;          //界面切换的方式
    myanim.subtype = kCATransitionFade;  //界面切换的方向
    myanim.duration = 0.3;
    [pickView.layer addAnimation:myanim forKey:@"trans"];
    
    httpGET1(@{URL_TYPE : @"myInfo/GetMenuList"},^(id result) {
        [_quickViewArray removeAllObjects];
        for (NSDictionary *dict in result[@"list"]) {
            [_quickViewArray addObject:dict];
        }
        
        UIView *heardView = [self tableHeadView];
        myTableView.tableHeaderView = heardView;
        [myTableView reloadData];
    });
}

#pragma mark == 快捷菜单选好点击操作
-(void)okayBtnAction
{
    
    [self hiddenBottomBar:NO];
    self.navigationController.navigationBarHidden = NO;
    
    backView.hidden = YES;
    pickView.hidden = YES;
    lableScrollView.hidden = NO;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark == UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _quickChooseBtnInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddTaskCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCollectionCell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[AddTaskCollectionViewCell alloc]init];
    }
    NSString *isQuick = _quickChooseBtnInfoArray[indexPath.item][@"isQuick"];
    if ([isQuick isEqualToString:@"1"]) {
        cell.imgView.image = [UIImage imageNamed:@"addCell.png"];
    }else{
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/ywglAppFunctionRole/%@/",ADDR_IP,ADDR_DIR,_quickChooseBtnInfoArray[indexPath.item][@"functionId"]]]];
    }
    
    cell.titleLable.text = _quickChooseBtnInfoArray[indexPath.item][@"functionName"];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *isQuick = _quickChooseBtnInfoArray[indexPath.item][@"isQuick"];
    
    if ([isQuick isEqualToString:@"1"]) {//是快捷方式，点击删除
        httpGET1(@{URL_TYPE : @"myInfo/DeleteMenuInfo",@"functionId" : _quickChooseBtnInfoArray[indexPath.item][@"functionId"]}, ^(id result) {
            //权限,把权限信息保存在PLIST文件里面
            NSMutableDictionary *authorityPara = [NSMutableDictionary dictionary];
            authorityPara[URL_TYPE] = @"myInfo/GetAuthorityInfo";
            httpGET1(authorityPara, ^(id result) {
                if ([result[@"result"] isEqualToString:@"0000000"]) {
                    
                    [userDefault setObject:result[@"viewList"] forKey:@"authorityViewList"];
                    [userDefault setObject:result[@"taskList"] forKey:@"authorityTaskList"];
                    [userDefault setObject:result[@"infoList"] forKey:@"authorityInfoList"];
                    [userDefault setObject:result[@"dailyList"] forKey:@"authorityDailyList"];
                    [userDefault synchronize];
                    
                    if ([_isTask_isInfo_isDaily isEqualToString: @"isTask"]) {
                        _quickChooseBtnInfoArray = [userDefault objectForKey:@"authorityTaskList"];
                    }else if ([_isTask_isInfo_isDaily isEqualToString: @"isInfo"]){
                        _quickChooseBtnInfoArray = [userDefault objectForKey:@"authorityInfoList"];
                    }else if([_isTask_isInfo_isDaily isEqualToString: @"isDaily"]){
                        _quickChooseBtnInfoArray = [userDefault objectForKey:@"authorityDailyList"];
                    }else{
                        _quickChooseBtnInfoArray = [userDefault objectForKey:@"authorityTaskList"];
                    }
                    
                    [myColectionView reloadData];
                }
            });
            
        });
        
        
    }else{//不是快捷方式，点击添加
        httpGET1(@{URL_TYPE : @"myInfo/AddMenuInfo",@"functionId" : _quickChooseBtnInfoArray[indexPath.item][@"functionId"]}, ^(id result) {
            //权限,把权限信息保存在PLIST文件里面
            NSMutableDictionary *authorityPara = [NSMutableDictionary dictionary];
            authorityPara[URL_TYPE] = @"myInfo/GetAuthorityInfo";
            httpGET1(authorityPara, ^(id result) {
                if ([result[@"result"] isEqualToString:@"0000000"]) {
                    
                    [userDefault setObject:result[@"viewList"] forKey:@"authorityViewList"];
                    [userDefault setObject:result[@"taskList"] forKey:@"authorityTaskList"];
                    [userDefault setObject:result[@"infoList"] forKey:@"authorityInfoList"];
                    [userDefault setObject:result[@"dailyList"] forKey:@"authorityDailyList"];
                    [userDefault synchronize];
                    
                    if ([_isTask_isInfo_isDaily isEqualToString: @"isTask"]) {
                        _quickChooseBtnInfoArray = [userDefault objectForKey:@"authorityTaskList"];
                    }else if ([_isTask_isInfo_isDaily isEqualToString: @"isInfo"]){
                        _quickChooseBtnInfoArray = [userDefault objectForKey:@"authorityInfoList"];
                    }else if([_isTask_isInfo_isDaily isEqualToString: @"isDaily"]){
                        _quickChooseBtnInfoArray = [userDefault objectForKey:@"authorityDailyList"];
                    }else{
                        _quickChooseBtnInfoArray = [userDefault objectForKey:@"authorityTaskList"];
                    }
                    
                    [myColectionView reloadData];
                }
            });
            
        });
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 30);
}

//每个cell高度指定代理
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


#pragma mark == UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identiCell = @"identiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identiCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiCell];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

#pragma mark == 搜索请求
-(void)request:(NSString *)word :(int)type
{
    
}

#pragma mark == 人员动向视图
-(void)btnClass:(UIButton *)sender
{
    PersonnelViewController *personneVC = [[PersonnelViewController alloc]init];
    personneVC.chuanArr = rydxArray;
    personneVC.chuanDic = rydxDic;
    [self.navigationController pushViewController:personneVC animated:YES];
}

@end
