//
//  MyTaskListViewController.m
//  telecom
//
//  Created by ZhongYun on 14-6-14.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyTaskListViewController.h"
#import "TaskTypeBar.h"
#import "TaskListView.h"
#import "QrReadView.h"
#import "MyTaskCallBackController.h"
#import "MyFindHiddenViewController.h"
#import "TaskDetail.h"
#import "ZonghehuaDetailViewController.h"
#import "CycleTaskTrackController.h"
#import "HWBProgressHUD.h"
#import "MyWorkListViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YZResourcesChangeViewController.h"

#define TVIEW_H         40
#define TAG_BASIC       18000

@interface MyTaskListViewController ()<TaskTypeBarDelegate,TaskListViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* m_typeList;
    TaskTypeBar* m_typeView;
    UIButton* m_checkBtn;
    UIButton* m_signBtn;
    UIButton* m_findBtn;
    UIButton* m_findBtn2;
    UIButton* m_findBtn3;
    UIView *backView;
    UIView *menuView;
    UILabel *labelLiu;
    //    NSString *strTaskID;
    //    NSString *strTaskStatus;
    
    UITableView* m_table;
    NSMutableArray* m_data;
    
    NSMutableArray* m_taskArr;
    NSMutableArray *taskId;
}
@property(nonatomic,strong)NSDictionary *infoDict;
//视频播放
 @property (nonatomic,strong) MPMoviePlayerViewController *requireVedio;
@property (nonatomic,copy) NSString *itemId;
@end

#define ROW1_H      100+20
#define ROW2_H      55
#define HEAD_H      40

#define TASK_OPEN 0
#define TASK_DONE 1
#define TASK_DOING 3
#define TASK_REDO 4

@implementation MyTaskListViewController

@synthesize strTaskID,strTaskStatus;

- (void)dealloc
{
    [m_typeView release];
    [m_typeList release];
    [m_table release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad
{
    //    w_dxwl_zxp
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    taskId = [NSMutableArray array];
    UIImage* checkIcon = [UIImage imageNamed:@"图标.png"];
    m_checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                      (NAV_H-checkIcon.size.height)/2,
                                                      checkIcon.size.width/1.5, checkIcon.size.height/1.5)];
    [m_checkBtn setBackgroundImage:checkIcon forState:0];
    [m_checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:m_checkBtn];
    
    UIImage* signIcon = [UIImage imageNamed:@"扫码图标.png"];
    m_signBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-20-checkIcon.size.width),
                                                     (NAV_H-checkIcon.size.height)/2,
                                                     signIcon.size.width/1.5, signIcon.size.height/1.5)];
    m_signBtn.fx = m_signBtn.fx - 10 - signIcon.size.width;
    [m_signBtn setBackgroundImage:signIcon forState:0];
    [m_signBtn addTarget:self action:@selector(onSignBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:m_signBtn];
    
    UIImage *findIcon = [UIImage imageNamed:@"我发现的隐患 -图标2.png"];
    m_findBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-30-checkIcon.size.width),
                                                     (NAV_H-checkIcon.size.height)/2,
                                                     findIcon.size.width/1.5, findIcon.size.height/1.5)];
    m_findBtn.fx = m_findBtn.fx - 30 - findIcon.size.width;
    [m_findBtn setBackgroundImage:findIcon forState:0];
    [m_findBtn addTarget:self action:@selector(findBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:m_findBtn];
    
    UIImage *findIcon2 = [UIImage imageNamed:@"我发现的隐患 -图标2.png"];
    m_findBtn2 = [[UIButton alloc] initWithFrame:RECT((APP_W-30-checkIcon.size.width),
                                                      (NAV_H-checkIcon.size.height)/2,
                                                      findIcon2.size.width/1.5, findIcon2.size.height/1.5)];
    m_findBtn2.fx = m_findBtn2.fx - 30 - findIcon2.size.width;
    [m_findBtn2 setBackgroundImage:findIcon2 forState:0];
    [m_findBtn2 addTarget:self action:@selector(findBtn2) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *findIcon3 = [UIImage imageNamed:@"3_1.png"];
    m_findBtn3 = [[UIButton alloc] initWithFrame:RECT((APP_W-30-checkIcon.size.width),
                                                      (NAV_H-checkIcon.size.height)/2,
                                                      findIcon3.size.width/2, findIcon3.size.height/2)];
    m_findBtn3.fx = m_findBtn3.fx - 30 - findIcon3.size.width;
    [m_findBtn3 setBackgroundImage:findIcon3 forState:0];
    [m_findBtn3 addTarget:self action:@selector(findBtn3) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2,item3];
    [item1 release];
    [item2 release];
    [item3 release];
    
    m_typeView = [[TaskTypeBar alloc] initWithFrame:RECT(0, 64, APP_W, TVIEW_H)];
    m_typeView.backgroundColor = [UIColor whiteColor];
    m_typeView.delegate = self;
    [self.view addSubview:m_typeView];
    
    m_typeList = [[NSMutableArray alloc] init];
    
    m_taskArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight-104) style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor clearColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = ROW1_H;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:m_table];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H)];
    backView.backgroundColor = [UIColor clearColor];
    backView.hidden = YES;
    [self.view addSubview:backView];
    
    menuView = [[UIView alloc]initWithFrame:CGRectMake(APP_W-80, 64, 80, 70)];
    menuView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:menuView];
    
    NSArray *btnArr = @[@"开始",@"结束"];
    NSLog(@"%@",btnArr);
    for (int i = 0; i < btnArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10, 10+30*i, 60, 25)];
        [btn setTitle:[btnArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn];
    }
    
}

//- (void)leftAction
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark == 我发现的隐患
-(void)findBtn
{
    MyFindHiddenViewController *findVC = [[MyFindHiddenViewController alloc]init];
    findVC.strTaskID = self.site[@"siteId"];
    findVC.vcTag = 100;
    [self.navigationController pushViewController:findVC animated:YES];
    [findVC release];
}

-(void)findBtn2
{
    NSLog(@"asd");
    MyFindHiddenViewController *findVC = [[MyFindHiddenViewController alloc]init];
    [self.navigationController pushViewController:findVC animated:YES];
    [findVC release];
}


-(void)findBtn3
{
    NSLog(@"3");
    backView.hidden = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    backView.hidden = YES;
}

-(void)btnSelect:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    backView.hidden = YES;
    
    NSMutableArray* commitList = [NSMutableArray array];
    NSMutableArray* taskIds = [NSMutableArray array];
    
    
    for (int section=0; section<m_data.count; section++) {
        NSArray* sectionList = m_data[section][@"demandList"];
        for (int row=0; row<sectionList.count; row++) {
            NSDictionary* item = sectionList[row];
            
            if ([item[@"selected"] intValue] == 1) {
                [taskIds addObject:item[@"taskId"]];
                [commitList addObject:[NSIndexPath indexPathForRow:row inSection:section]];
            }
        }
    }
    
    strTaskID = [taskIds componentsJoinedByString:@","];
    NSLog(@"1==%@",strTaskID);
    NSLog(@"2==%@",strTaskStatus);
    
    if (sender.tag == 10) {
        [self beginData];
    }else{
        [self endData];
    }
}

#pragma mark == 开始
-(void)beginData
{
    
    if (strTaskID == nil || [strTaskID isEqualToString:@""]) {
        showAlert(@"请选择要执行的任务");
    }else if([strTaskStatus isEqualToString:@"3"]){
        NSLog(@"不能点击");
    }else if([strTaskStatus isEqualToString:@"0"]){
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyTask/ExecuteCycleTotalization";
        paraDict[@"flag"] = @"1";
        paraDict[@"taskId"] = strTaskID;
        
        httpGET2(paraDict,
                 ^(id result) {
                     NSLog(@"result == %@",result);
                     if ([result[@"result"] isEqualToString:@"0000000"]){
                         [self zhhwhData];
                     }else{
                         
                     }
                     
                     
                 }, ^(id result) {
                     
                 });
        
        
    }else{
        
    }
    
}

#pragma mark == 结束
-(void)endData
{
    if (strTaskID == nil || [strTaskID isEqualToString:@""]) {
        showAlert(@"请选择要执行的任务");
    }else if([strTaskStatus isEqualToString:@"3"]){
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyTask/ExecuteCycleTotalization";
        paraDict[@"flag"] = @"2";
        paraDict[@"taskId"] = strTaskID;
        
        
        httpGET2(paraDict,
                 ^(id result) {
                     NSLog(@"result == %@",result);
                     if ([result[@"result"] isEqualToString:@"0000000"]){
                             NSString *workTime = result[@"detail"][@"workTime"];
                             NSString *finishSituation = result[@"detail"][@"finishSituation"];
                             NSString *experienceValue = result[@"detail"][@"experienceValue"];
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标准化测评结果" message:[NSString stringWithFormat:@"%@\n%@\n%@。",workTime,finishSituation,experienceValue] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                             [alertView show];
                         [self zhhwhData];
                     }else if([result[@"result"] isEqualToString:@"2011708"]){
                         showAlert(result[@"error"]);
                     }
                 }, ^(id result) {
                     showAlert(result[@"error"]);
                 });
    }else{
        
    }
    
    
}

- (void)onCheckBtnTouched:(id)sender
{
    TaskListView* listView = tagViewEx(self.view, m_typeView.selected+TAG_BASIC, TaskListView);
    [listView commitCheck];
}

- (void)onSignBtnTouched:(id)sender
{
    if ([QrReadView checkCamera]) {
        QrReadView* vc = [[QrReadView alloc] init];
        vc.respBlock = ^(NSString* v) {
            NSString* specialtyId = m_typeList[m_typeView.selected][@"speciltyId"];
            httpGET2(@{URL_TYPE:NW_SignInAtSite, @"siteId":v, @"specialtyId":specialtyId}, ^(id result) {
                showAlert(@"签到成功");
            }, ^(id result) {
                showAlert(@"站点扫码签到失败。");
            });
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)setSite:(NSDictionary *)site
{
    _site = [site retain];
    if (self.taskTag == 100) {
        self.title = (site[@"regionName"] != nil ? site[@"regionName"] : site[@"taskTypeName"]);
    }if (self.taskTag == 200) {
        self.title = (site[@"siteName"] != nil ? site[@"siteName"] : site[@"taskTypeName"]);
    }else{
        self.title = (site[@"siteName"] != nil ? site[@"siteName"] : site[@"taskName"]);
    }
    
    tagViewEx(self.view, TAG_NAV_TITLE, UILabel).text = self.title;
    [self loadTypeList];
}

- (void)loadTypeList
{
    
    NSLog(@"self.site == %@",self.site);
    NSLog(@"%d",self.taskTag);
    if (self.taskTag == 100) {
        
        NSDictionary* params = @{URL_TYPE:NW_GetSpecTaskAmount, @"siteId":self.site[@"regionId"],@"siteName":self.site[@"regionName"]};
        if (self.planDate != nil) {
            params = @{URL_TYPE:NW_GetSpecTaskAmount, @"siteId":self.site[@"regionId"],@"siteName":self.site[@"regionName"], @"planDate":[self.planDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"]};
        }
        httpGET2(params, ^(id result) {
            NSLog(@"%@",result);
            mainThread(updateTypeListBar1:, result);
        }, ^(id result) {
            mainThread(updateTypeListBar1:, nil);
        });
        
    }else if (self.taskTag == 200) {
        
        NSDictionary* params = @{URL_TYPE:NW_GetSpecTaskAmount, @"siteId":self.site[@"siteId"],@"siteName":self.site[@"siteName"]};
        if (self.planDate != nil) {
            params = @{URL_TYPE:NW_GetSpecTaskAmount, @"siteId":self.site[@"siteId"],@"siteName":self.site[@"siteName"], @"planDate":[self.planDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"]};
        }
        httpGET2(params, ^(id result) {
            NSLog(@"%@",result);
            mainThread(updateTypeListBar2:, result);
        }, ^(id result) {
            mainThread(updateTypeListBar2:, nil);
        });
        
    }else{
        
        NSDictionary* params = @{URL_TYPE:NW_GetSpecTaskAmount, @"siteId":self.site[@"siteId"],@"siteName":self.site[@"siteName"]};
        if (self.planDate != nil) {
            params = @{URL_TYPE:NW_GetSpecTaskAmount, @"siteId":self.site[@"siteId"],@"siteName":self.site[@"siteName"], @"planDate":[self.planDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"]};
        }
        httpGET2(params, ^(id result) {
            mainThread(updateTypeListBar:, result);
        }, ^(id result) {
            mainThread(updateTypeListBar:, nil);
        });
        
    }
    
    
}

- (void)updateTypeListBar:(id)result
{
    [m_typeList removeAllObjects];
    [m_typeList addObjectsFromArray:result[@"list"]];
    NSInteger selected = 0;
    //    if (m_typeList.count == 1 && [[[m_typeList objectAtIndex:0]objectForKey:@"speciltyName"] isEqualToString:@"综合"])
    NSLog(@"%@",result);
    
    if (m_typeList.count == 0) {
        
    }else if ([[[m_typeList objectAtIndex:0]objectForKey:@"speciltyId"] isEqualToString:@"0"]) {
        m_typeView.typeList = m_typeList;
        m_typeView.selected = selected;
        [self zhhwhData];
    }else{
        if (m_typeList.count > 0) {
            CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
            for (int i=0; i<m_typeList.count; i++) {
                TaskListView* view = [[TaskListView alloc] initWithFrame:frame];
                view.planDate = [self.planDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
                view.delegate = self;
                view.typeInfo = m_typeList[i];
                view.siteInfo = self.site;
                view.backgroundColor = [UIColor whiteColor];
                view.tag = i + TAG_BASIC;
                view.hidden = YES;
                [self.view addSubview:view];
                [view release];
            }
            m_typeView.typeList = m_typeList;
            m_typeView.selected = selected;
        }
    }
    
    
}

- (void)updateTypeListBar1:(id)result
{
    NSLog(@"%@",result);
    [m_typeList removeAllObjects];
    [m_typeList addObjectsFromArray:result[@"list"]];
    NSInteger selected1 = 0;
    
    if (m_typeList.count > 0) {
        CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
        for (int i=0; i<m_typeList.count; i++) {
            TaskListView* view = [[TaskListView alloc] initWithFrame:frame];
            view.planDate = [self.planDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            view.delegate = self;
            view.vcTag = 100;
            view.siteInfo = self.site;
            view.typeInfo = m_typeList[i];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i + TAG_BASIC;
            
            view.hidden = YES;
            [self.view addSubview:view];
            [view release];
        }
        m_typeView.typeList = m_typeList;
        m_typeView.selected = selected1;
    }
}

- (void)updateTypeListBar2:(id)result
{
    NSLog(@"%@",result);
    [m_typeList removeAllObjects];
    [m_typeList addObjectsFromArray:result[@"list"]];
    NSInteger selected1 = 0;
    
    if (m_typeList.count > 0) {
        CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
        for (int i=0; i<m_typeList.count; i++) {
            TaskListView* view = [[TaskListView alloc] initWithFrame:frame];
            view.planDate = [self.planDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            view.delegate = self;
            view.vcTag = 200;
            view.siteInfo = self.site;
            view.typeInfo = m_typeList[i];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i + TAG_BASIC;
            
            view.hidden = YES;
            [self.view addSubview:view];
            [view release];
        }
        m_typeView.typeList = m_typeList;
        m_typeView.selected = selected1;
    }
}



- (void)pushToTaskCallBackWithInfo:(NSDictionary *)dict
{
    MyTaskCallBackController *callBackCtrl = [[MyTaskCallBackController alloc] init];
    callBackCtrl.callBackInfoDict = dict;
    [self.navigationController pushViewController:callBackCtrl animated:YES];
    [callBackCtrl release];
}

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count
{
    [m_typeView updatePointStatus:index Count:count];
}

- (void)updateNavBtnStatus:(TaskListView*)view
{
    if (view.tag-TAG_BASIC == m_typeView.selected) {
        
    }
}

- (void)zhhData:(NSInteger )zhhTag
{
    
    TaskListView* listView = tagViewEx(self.view, m_typeView.selected+TAG_BASIC, TaskListView);
    listView.hidden = YES;
    NSLog(@"%d",zhhTag);
    [self zhhwhData];
}

#pragma mark == 综合化维护
-(void)zhhwhData
{
    //    NSLog(@"%@",m_typeList);
    NSLog(@"%@",self.site);
    NSLog(@"==>%d",m_typeView.selected);
    
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithCustomView:m_findBtn2];
    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithCustomView:m_findBtn3];
    
    self.navigationItem.rightBarButtonItems = @[item5,item4];
    [item4 release];
    [item5 release];
    NSString* specialtyId = m_typeList[m_typeView.selected][@"speciltyId"];
    NSLog(@"%@",specialtyId);
    NSDictionary* params = @{URL_TYPE:@"MyTask/GetCycleTotalizationList",
                             @"siteId":self.site[@"siteId"],
                             @"specId":specialtyId};
    
    httpGET2(params,
             ^(id result) {
                 NSLog(@"result == %@",result);
                 mainThread(updateViewData:, result);
             }, ^(id result) {
                 mainThread(updateViewData:, nil);
             });
}

- (void)updateViewData:(id)result
{
    [m_data removeAllObjects];
    [m_data addObjectsFromArray:result[@"list"]];
   
    DLog(@"%@",m_data);
    for (NSDictionary *restric in m_data) {
        DLog(@"%@",restric[@"itemId"]);
    }
    
    [m_table reloadData];
}


- (void)changeBefore:(TaskTypeBar*)sender
{
    [self.view viewWithTag:m_typeView.selected+TAG_BASIC].hidden = YES;
}

- (void)changeAfter:(TaskTypeBar*)sender
{
    
    NSInteger viewTag = sender.selected+TAG_BASIC;
    TaskListView* view = tagViewEx(self.view, viewTag, TaskListView);
    view.hidden = NO;
    [self updateNavBtns:view];
}

- (void)updateNavBtns:(TaskListView*)currView
{
    BOOL isCeliang = [currView.typeInfo[@"dealType"] isEqualToString:@"A"];
    BOOL isDongli = [currView.typeInfo[@"dealType"] isEqualToString:@"C"];
    if (isCeliang || isDongli) {
        m_checkBtn.hidden = NO;
        m_signBtn.fx = m_checkBtn.fx-10-m_signBtn.fw;
    } else {
        m_checkBtn.hidden = YES;
        m_signBtn.fx = APP_W-10-m_signBtn.fw;
    }
    m_signBtn.hidden = ([currView.typeInfo[@"signType"] intValue] != 1);
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = ROW1_H;
    if ([m_data[indexPath.section][@"extended"] intValue] != 1) {
        rowHeight = 0;
    }
    return rowHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)m_data[section][@"demandList"]).count;
}


#pragma mark - UITableViewDataSource - section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEAD_H;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = [[UIView alloc] initWithFrame:RECT(0, 0, APP_W, HEAD_H)];
    header.backgroundColor = COLOR(240, 240, 240);
    
    UIView* line1 = [[UIView alloc] initWithFrame:RECT(0, 0, APP_W, 0.5)];
    line1.backgroundColor = COLOR(200, 199, 204);
    [header addSubview:line1];
    [line1 release];
    
    UIView* line2 = [[UIView alloc] initWithFrame:RECT(0, header.fh, APP_W, 0.5)];
    line2.backgroundColor = COLOR(200, 199, 204);
    [header addSubview:line2];
    [line2 release];
    
    NSString* title = format(@"%@",m_data[section][@"demandName"]);
    //修改标题头视图 中标题label 的位置15->40
    UILabel*lbtitle = newLabel(header, @[@50, RECT_OBJ(40, (HEAD_H-Font2)/2, 270, Font2), [UIColor blackColor], Font(Font2), title]);
    lbtitle.font = [UIFont systemFontOfSize:14];
    //[lbtitle sizeToFit];
    
    NSString* imgName = ([m_data[section][@"extended"] intValue] == 1 ? @"arr_down.png" : @"arr_up.png");
    newImageView(header, @[@51,imgName, RECT_OBJ(APP_W-20, (HEAD_H-7.5)/2, 10, 7.5)]);
    
    UIButton* headBtn = [[UIButton alloc] initWithFrame:RECT(1, 1, APP_W-2, HEAD_H-2)];
    [headBtn addTarget:self action:@selector(onHeadBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    headBtn.tag = 1000+section;
    [header addSubview:headBtn];
    [headBtn release];
    
    UIImage *editImg = [UIImage imageNamed:@"edit.png"];
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(kScreenWidth-60, 8, editImg.size.width/1.5, editImg.size.height/1.5)];
    [editBtn setBackgroundColor:[UIColor clearColor]];
    [editBtn setBackgroundImage:editImg forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.tag = section;
    [header addSubview:editBtn];
    
    CGFloat point_w = 10;
    UIView* point = [[UIView alloc] initWithFrame:RECT(lbtitle.ex+10, (HEAD_H-point_w)/2, point_w, point_w)];
    point.hidden = ([m_data[section][@"today"] intValue] != 1);
    point.layer.cornerRadius = point_w/2;
    point.backgroundColor = COLOR(255, 127, 127);
    [header addSubview:point];
    [point release];
     //增加视频播放按钮
    if ([m_data[section][@"isVideo"] intValue] == 1) {
    
        UIButton *vedioPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [vedioPlay setBackgroundImage:[UIImage imageNamed:@"0poop"] forState:UIControlStateNormal];
        vedioPlay.frame = CGRectMake(5, 5, 30, 30);
        //增加tag取出itemId
        vedioPlay.tag = 500+section;
        
        //添加点击事件
        [vedioPlay addTarget:self action:@selector(vedioPlay:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:vedioPlay];
      
   }
    
    return header;
}
//播放在线视频
- (void)vedioPlay:(UIButton *)vedioPlayBtn

{
   
    NSInteger num = vedioPlayBtn.tag-500;
    self.itemId = m_data[num][@"itemId"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/help/video/%@.mp4",ADDR_IP_WEB,self.itemId];
    NSURL *url = [NSURL URLWithString:urlString];
     NSLog(@"===============%@****%@",urlString,self.itemId);
   
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    self.requireVedio = moviePlayer;
    [moviePlayer release];
    
    self.requireVedio.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    
    self.requireVedio.moviePlayer.shouldAutoplay = YES;
    
    [self.requireVedio.moviePlayer prepareToPlay];
    //播放
    [self.requireVedio.moviePlayer play];
    //显示
    [self presentViewController:self.requireVedio animated:YES completion:nil];
    //NSLog(@"%@",m_data);

}
-(void)clickBtn:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    [m_taskArr removeAllObjects];
    
    NSArray *taskIdArr = [[m_data objectAtIndex:sender.tag] objectForKey:@"demandList"];
    for (int i = 0; i < taskIdArr.count; i++) {
        if ([[[[taskIdArr objectAtIndex:i]objectForKey:@"taskStatus"] description]isEqualToString:@"3"]) {
            NSString *strID = [[[taskIdArr objectAtIndex:i]objectForKey:@"taskId"] description];
            [m_taskArr addObject:strID];
        }
    }
    
    if (m_taskArr.count == 0) {
        
        HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
        //弹出框的类型
        hud.mode = HWBProgressHUDModeText;
        //弹出框上的文字
        hud.detailsLabelText = @"没有执行中的任务";
        //弹出框的动画效果及时间
        [hud showAnimated:YES whileExecutingBlock:^{
            //执行请求，完成
            sleep(1);
        } completionBlock:^{
            //完成后如何操作，让弹出框消失掉
            [hud removeFromSuperview];
            
        }];

        
    }else{
        
        ZonghehuaDetailViewController *vc = [[ZonghehuaDetailViewController alloc]init];
        vc.strTaskId = [m_taskArr componentsJoinedByString:@","];
        vc.strTitle =  format(@"%@",m_data[sender.tag][@"demandName"]);
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.section][@"demandList"][indexPath.row];
    //    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"id"]];
    static NSString *reuseId = @"reuse";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:reuseId];
    CGFloat row_x = 15 ;
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reuseId] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        cell.textLabel.font = FontB(Font1);
        cell.contentView.userInteractionEnabled = YES;
        
        
        CGFloat row_h = ROW1_H;
        
        for (NSDictionary *dic in m_typeList) {
            if ([dic[@"speciltyName"] isEqualToString:@"综维"]) {
                UIButton* btn1= [[UIButton alloc] initWithFrame:RECT(5, (row_h-40)/2, 30, 30)];
                [btn1 setBackgroundImage:[UIImage imageNamed:@"作业指导手册图标-2.png"] forState:0];
                [btn1 addTarget:self action:@selector(onCheckBtn1:) forControlEvents:UIControlEventTouchUpInside];
                
                row_x = 45;
                [cell addSubview:btn1];
                [btn1 release];
            }
        }
        
        
        newLabel(cell, @[@50, RECT_OBJ(160, 62, 70, Font3), [UIColor lightGrayColor], Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        newLabel(cell, @[@53, RECT_OBJ(232, 77+20, 50, Font3), [UIColor lightGrayColor], Font(Font3), @""]).textAlignment = NSTextAlignmentRight;//未完成label
//       labelLiu =  newLabel(cell, @[@51, RECT_OBJ(row_x, 10, cell.frame.size.width-row_x-10, Font2), [UIColor lightGrayColor], Font(Font2), @""]);//自适应label
//       labelLiu.lineBreakMode = NSLineBreakByWordWrapping ;

        newLabel(cell, @[@52, RECT_OBJ(row_x, 77+20, 215, Font3), [UIColor lightGrayColor], Font(Font3), @""]).numberOfLines=0;//时间 日期label
        UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT(APP_W-40, 65+20, 40, 40)];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"check_no.png"] forState:0];
        [checkBtn addTarget:self action:@selector(onCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.tag = 54;

        //        checkBtn.hidden = (!m_isCeliang); //测量有批量处理;
        [cell addSubview:checkBtn];
        [checkBtn release];
        //资源校正
        YZIndexPathButton *jiaoZhengButton = [YZIndexPathButton buttonWithType:UIButtonTypeCustom];
        jiaoZhengButton.tag = 132;
        jiaoZhengButton.frame = CGRectMake(202, 77+19, 21, 21);
        [jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正"] forState:UIControlStateNormal];
        [jiaoZhengButton addTarget:self action:@selector(jiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:jiaoZhengButton];
    }
    
    labelLiu =  newLabel(cell, @[@51, RECT_OBJ(row_x, 10, cell.frame.size.width-row_x-10, Font2), [UIColor lightGrayColor], Font(Font2), @""]);//自适应label
    labelLiu.lineBreakMode = NSLineBreakByWordWrapping ;
   
    
    int taskStatus = [dataRow[@"taskStatus"] intValue];
    BOOL isOver = ([dataRow[@"undoUnitAmount"] intValue] <= 0);
    
    isOver = (taskStatus == TASK_DONE);
    tagViewEx(cell, 51, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : RGB(0x000000));
    tagViewEx(cell, 51, UILabel).text = dataRow[@"taskContent"];
  
    
    CGSize size = [labelLiu sizeThatFits:CGSizeMake(cell.frame.size.width-55, MAXFLOAT)];
    labelLiu.frame =CGRectMake(labelLiu.frame.origin.x, labelLiu.frame.origin.y, labelLiu.frame.size.width, size.height);

  
    
    NSString* strDate = dataRow[@"taskTime"];
    if (strDate.length > 0)
        strDate = format(@"%@      ", strDate);
    
    tagViewEx(cell, 52, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : RGB(0x000000));
    tagViewEx(cell, 52, UILabel).text = format(@"%@%@%@",
                                               strDate,
                                               dataRow[@"unitNum"],
                                               dataRow[@"unit"]);
    
    tagViewEx(cell, 50, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : RGB(0x000000));
    tagViewEx(cell, 50, UILabel).text = dataRow[@"userId"];
    
    tagViewEx(cell, 53, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : [UIColor redColor]);
    
    NSString* strStatus = @"";
    if (taskStatus == TASK_OPEN) strStatus = @"未完成";
    if (taskStatus == TASK_DONE) strStatus = @"已完成";
    if (taskStatus == TASK_REDO) strStatus = @"召回重做";
    if (taskStatus == TASK_DOING) strStatus = @"进行中";
    tagViewEx(cell, 53, UILabel).text = strStatus;
    
    if ([strStatus isEqualToString:@"进行中"]) {
        tagViewEx(cell, 53, UILabel).textColor = RGBCOLOR(0, 246, 93);
    }
    
    //    tagView(cell, 54).hidden = !(!isOver && (m_isCeliang || m_isChuanshu));
    NSString* imgName = ([dataRow[@"selected"] intValue]==1 ? @"check_ok.png" : @"check_no.png");
    [tagViewEx(cell, 54, UIButton) setBackgroundImage:[UIImage imageNamed:imgName] forState:0];
    //    NSLog(@"%@",dataRow);
    
    if ([[dataRow objectForKey:@"taskStatus"]isEqualToString:@"1"]) {
        tagViewEx(cell, 54, UIButton).enabled = NO;
    }else{
        tagViewEx(cell, 54, UIButton).enabled = YES;
    }
    
//    cell.selectionStyle = (isOver ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray);
    
    NSString* today = date2str([NSDate date], DATE_FORMAT);
    BOOL isToday = ([dataRow[@"date"] isEqualToString:today] && !isOver);
    cell.backgroundColor = (isToday ? COLOR(255, 176, 176) : [UIColor whiteColor]);
    //资源校正
    YZIndexPathButton *jiaoZhengButton = [cell.contentView viewWithTag:132];
    jiaoZhengButton.ButtonIndexPath = indexPath;
    
    return cell;
}

#pragma mark -- 资源校正
- (void)jiaoZhengButtonClicked:(YZIndexPathButton *)sender
{
    NSMutableDictionary* dataRow = m_data[sender.ButtonIndexPath.section][@"demandList"][sender.ButtonIndexPath.row];
    
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    resourcesChangeVC.resources_id = NoNullStr([dataRow objectForKey:@"nuid"]);
    if (![resourcesChangeVC.resources_id isEqualToString:@""] && resourcesChangeVC) {
        resourcesChangeVC.resources_type = @"2-1";
        resourcesChangeVC.resources_sceneId = @"3";
    }
    
    [self.navigationController pushViewController:resourcesChangeVC animated:YES];
    [resourcesChangeVC release];
}


- (void)onCheckBtn1:(UIButton*)sender{
    UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
    NSIndexPath* indexPath = [m_table indexPathForCell:cell];
    NSMutableDictionary* dataRow = m_data[indexPath.section][@"demandList"][indexPath.row];
    
    DLog(@"%ld-----%ld",(long)indexPath.section,(long)indexPath.row);
     MyWorkListViewController *vc = [[MyWorkListViewController alloc]init];
    DLog(@"%@----------%@",m_data[indexPath.section][@"itemId"],dataRow[@"contentId"]);
    NSString *str = [NSString stringWithFormat:@"http://%@/help/item_content/%@_%@.html",ADDR_IP_WEB,m_data[indexPath.section][@"itemId"],dataRow[@"contentId"]];
    DLog(@"%@",str);
    DLog(@"%@",m_data);
    vc.string = str;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    

}

- (void)onHeadBtnTouched:(UIButton*)sender
{
    NSInteger section = sender.tag-1000;
    NSInteger status = [m_data[section][@"extended"] intValue];
    status = (status==1 ? 0 : 1);
    m_data[section][@"extended"] = @(status);
    [m_table reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)onCheckBtn:(UIButton*)sender
{
    UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
    NSIndexPath* indexPath = [m_table indexPathForCell:cell];
    NSMutableDictionary* dataRow = m_data[indexPath.section][@"demandList"][indexPath.row];
    DLog(@"%@",dataRow);
    int status = [dataRow[@"selected"] intValue];
    status = (status==0 ? 1 : 0);
    dataRow[@"selected"] = @(status);
    
    strTaskStatus = [[dataRow objectForKey:@"taskStatus"] description];
//    [m_table reloadData];
    [m_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"=================这是第%d行",indexPath.row);
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    
    NSMutableDictionary* dataRow = m_data[indexPath.section][@"demandList"][indexPath.row];
    //    taskStatus:0：未完成  1：已完成 3: 执行中
    
    if ([dataRow[@"taskStatus"] intValue] == 0) {
        
        //        TaskDetail* vc = [[TaskDetail alloc] init];
        //        vc.detail = dataRow;
        //        vc.strVCTag = 888;
        //        vc.respBlock= ^(id result) {
        ////            mainThread(onCommitAfter:, @[indexPath]);
        //        };
        //        [self.navigationController pushViewController:vc animated:YES];
        //        [vc release];
    }else if ([dataRow[@"taskStatus"] intValue] == 1){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userMapFlag"] isEqualToString:@"1"]) {
            self.infoDict = m_data[indexPath.section][@"demandList"][indexPath.row];
            CycleTaskTrackController *cycleTaskTrackCtrl = [[CycleTaskTrackController alloc] init];
            cycleTaskTrackCtrl.taskDict = self.infoDict;
            [self.navigationController pushViewController:cycleTaskTrackCtrl animated:YES];
            [cycleTaskTrackCtrl release];
        }
    }else{
        
    }
}


@end
