//
//  MyWorkViewController.m
//  telecom
//
//  Created by ZhongYun on 14-6-12.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyWorkViewController.h"
#import "FilterViewController.h"
#import "MyTaskListViewController.h"
#import "FilterCompSelect.h"
#import "QrReadView.h"
#import "MJRefresh.h"

#define PAGE_ID     106
#define LD_NORMOR  0
#define LD_SEARCH  1
#define LD_FILTER  2

@interface MyWorkViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,
    MJRefreshBaseViewDelegate, UITextFieldDelegate>
{
    UISearchBar* m_searchBar;
    UITableView* m_table;
    NSMutableArray* m_data;
    MJRefreshFooterView* m_refreshfooter;
    NSInteger m_loadDataType;
    NSString* m_filterStr;
    
    NSInteger m_sortSelected;
}
@end

static int a = 1;
@implementation MyWorkViewController
@synthesize m_sortId;

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [m_refreshfooter free];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的周期工作";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    m_sortSelected = -1;
    NOTIF_ADD(UP_TASK_LIST, onUpTaskList:);
    
    
    UIImage* moreIcon = [UIImage imageNamed:@"nav_more.png"];
    UIButton* moreBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-moreIcon.size.width), (NAV_H-moreIcon.size.height)/2,
                                                             moreIcon.size.width, moreIcon.size.height)];
    [moreBtn setBackgroundImage:moreIcon forState:0];
    [moreBtn addTarget:self action:@selector(onMoreBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.titleLabel.text = @"1";
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
    [barBtnItem release];
    
    m_searchBar = [[UISearchBar alloc] initWithFrame:RECT(0, 64, APP_W, NAV_H)];
    m_searchBar.delegate = self;
    m_searchBar.placeholder = @"请输入局站名称";
    m_searchBar.translucent = YES;
    m_searchBar.keyboardType = UIKeyboardTypeDefault;
    m_searchBar.backgroundColor = COLOR(187, 187, 186);
    [self.view addSubview:m_searchBar];
    
    if (iOSv7) {
        UIView* barView = [m_searchBar.subviews objectAtIndex:0];
        [[barView.subviews objectAtIndex:0] removeFromSuperview];
        UITextField* searchField = [barView.subviews objectAtIndex:0];
        [searchField setReturnKeyType:UIReturnKeySearch];
    } else {
        [[m_searchBar.subviews objectAtIndex:0] removeFromSuperview];
        UITextField* searchField = [m_searchBar.subviews objectAtIndex:0];
        [searchField setReturnKeyType:UIReturnKeySearch];
    }
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, 64+NAV_H, APP_W, (SCREEN_H-64-NAV_H))
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = 58;
    m_table.delegate = self;
    m_table.dataSource = self;
    [self.view addSubview:m_table];
    
    m_refreshfooter = [[MJRefreshFooterView alloc] init];
    m_refreshfooter.delegate = self;
    m_refreshfooter.scrollView = m_table;
    
    m_loadDataType = LD_NORMOR;
    [self loadData];
    
    [self addMorePopView];
}
/**
 *  加载更多数据  12 09号改好
 */
- (void)loadData
{
    NSString* d1 = getMonthFirstDay([NSDate date]);
    NSString* d2 = getMonthLastDay([NSDate date]);

    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    NSString *string =  [[NSUserDefaults standardUserDefaults]objectForKey:@"chooseString"];
    if (string==nil) {
        paraDict[@"condition"] = @"0,0,0,0";
    }else{
        paraDict[@"condition"] = string;
    }
//回传保存
    paraDict[URL_TYPE] = @"MyTask/GetCycleWorkInfo";
    paraDict[@"startDate"] = d1;
    paraDict[@"endDate"] = d2;
    paraDict[@"limit"] = @"20";
    paraDict[@"skip"] = @"0";
    CLLocationCoordinate2D coord = getCoordinate();
    paraDict[@"longitude"] = format(@"%g", coord.longitude);
    paraDict[@"latitude"] = format(@"%g", coord.latitude);
    
    if (m_sortSelected >= 0) {
        paraDict[@"sortId"] = m_sortId;
    }
    
    if (m_loadDataType == LD_NORMOR) {
        
    } else if (m_loadDataType == LD_SEARCH) {
        paraDict[@"siteName"] = m_searchBar.text;
    } else if (m_loadDataType == LD_FILTER) {
        paraDict[@"condition"] = m_filterStr;
        NSLog(@"m_filterStr == %@",m_filterStr);
        
//        CLLocationCoordinate2D coord = getCoordinate();
//        paraDict[@"latitude"] = format(@"%g,%g", coord.longitude, coord.latitude);
    }
    
    NSLog(@"%@",paraDict);
    httpGET2(paraDict, ^(id result) {
        //控制用户是否有查看地图的权限
        [[ NSUserDefaults standardUserDefaults] setObject:result[@"mapFlag"] forKey:@"userMapFlag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSArray* resList = result[@"list"];
        if (resList.count > 0) {
            [m_data addObjectsFromArray:resList];
            [m_table reloadData];
        }
        [m_refreshfooter endRefreshing];
    }, ^(id result) {
        [m_refreshfooter endRefreshing];
    });
}


- (void)onMoreBtnTouched:(id)sender
{
    [self popviewHidden:NO];
}

- (void)addMorePopView
{
    CGFloat row_h = 40;
    UIButton* popViewBg = [[UIButton alloc] initWithFrame:RECT(0,0,SCREEN_W,SCREEN_H)];
    popViewBg.tag = 1501;
    popViewBg.hidden = YES;
    popViewBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:popViewBg];
    [popViewBg clickBlock:^{
        [self popviewHidden:YES];
    }];
    
    
    CGFloat w = 100;
    UIView* popView = [[UIView alloc] initWithFrame:RECT(APP_W-w-10, 64, w, row_h*3)];
    popView.backgroundColor = COLOR(239, 239, 239);
    popView.hidden = YES;
    popView.tag = 1502;
    popView.layer.borderWidth = 0.5;
    popView.layer.borderColor = COLOR(215, 215, 215).CGColor;
    showShadow(popView, CGSizeMake(0, 0));
    [self.view addSubview:popView];
    
    UIView* line1 = [[UIView alloc] initWithFrame:RECT(1, row_h*1, popView.fw-2, 1)];
    line1.backgroundColor = COLOR(215, 215, 215);
    [popView addSubview:line1];
    
    UIView* line2 = [[UIView alloc] initWithFrame:RECT(1, row_h*2, popView.fw-2, 1)];
    line2.backgroundColor = COLOR(215, 215, 215);
    [popView addSubview:line2];
    
    UIButton* menu1 = [[UIButton alloc] initWithFrame:RECT(1, 1, popView.fw-2, row_h - 2)];
    menu1.backgroundColor = [UIColor clearColor];
    //menu1.layer.borderWidth = 0.5;
    menu1.titleLabel.font = FontB(Font3);
    [menu1 setTitle:@"排序" forState:0];
    [menu1 setTitleColor:[UIColor blackColor] forState:0];
    [menu1 clickBlock:^{
        [self popviewHidden:YES];
        FilterCompSelect* vc = [[FilterCompSelect alloc] init];
        vc.selected = m_sortSelected;
        vc.data = [self getSortList];
        vc.idKey = @"sortId";
        vc.nameKey = @"sortName";
        vc.respBlock = ^(NSInteger selected){
            m_sortSelected = selected;
            m_sortId = format(@"%@", vc.data[selected][@"sortId"]);
            [m_data removeAllObjects];
            [m_table reloadData];
            mainThread(loadData, nil);
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }];
    [popView addSubview:menu1];
    [menu1 release];
    
    UIButton* menu2 = [[UIButton alloc] initWithFrame:RECT(1, row_h*1+1, popView.fw-2, row_h - 2)];
    menu2.backgroundColor = [UIColor clearColor];
    //menu2.layer.borderWidth = 0.5;
    menu2.titleLabel.font = FontB(Font3);
    [menu2 setTitle:@"扫码" forState:0];
    [menu2 setTitleColor:[UIColor blackColor] forState:0];
    [menu2 clickBlock:^{
        [self popviewHidden:YES];
        if ([QrReadView checkCamera]) {
            QrReadView* vc = [[QrReadView alloc] init];
            vc.respBlock = ^(NSString* v) {
                NSLog(@"扫码得到的内容 == %@", v);
                [self updata:v];
            };
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }];
    [popView addSubview:menu2];
    [menu2 release];
    
    UIButton* menu3 = [[UIButton alloc] initWithFrame:RECT(1, row_h*2+1, popView.fw-2, row_h - 2)];
    menu3.backgroundColor = [UIColor clearColor];
    menu3.titleLabel.font = FontB(Font3);
    [menu3 setTitle:@"筛选" forState:0];
    [menu3 setTitleColor:[UIColor blackColor] forState:0];
    [menu3 clickBlock:^{
        [self popviewHidden:YES];
        [self onFilterBtnTouched:nil];
    }];
    [popView addSubview:menu3];
    [menu3 release];
    
    
    [line1 release];
    [line2 release];
    [popViewBg release];
    [popView release];
}


- (void)updata:(NSString *)str
{
    [m_data removeAllObjects];
    NSString* d1 = getMonthFirstDay([NSDate date]);
    NSString* d2 = getMonthLastDay([NSDate date]);
//    NSString *accessToken = UGET(U_TOKEN);
//    NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
//    CLLocationCoordinate2D coord = getCoordinate();
//    NSString *strLongitude = [NSString stringWithFormat:@"%f",coord.longitude];
//    NSString *strLatitude = [NSString stringWithFormat:@"%f",coord.latitude];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params  addEntriesFromDictionary:@{URL_TYPE:NW_GetCycleWork,
                                        @"startDate":d1, @"endDate":d2,
                                        @"limit":@(MAX_ROW_NUM),
                                        @"skip":@(m_data.count),
                                        @"roomId":str
                                        }];
    
//    if (m_sortSelected >= 0) {
//        params[@"sortId"] = m_sortId;
//    }
//    
//    if (m_loadDataType == LD_NORMOR) {
//        
//    } else if (m_loadDataType == LD_SEARCH) {
////        params[@"siteName"] = str;
//    } else if (m_loadDataType == LD_FILTER) {
//        params[@"condition"] = m_filterStr;
//        CLLocationCoordinate2D coord = getCoordinate();
//        params[@"latitude"] = format(@"%g,%g", coord.longitude, coord.latitude);
//    }
    NSLog(@"== %@",params);
    httpGET2(params, ^(id result) {
        NSLog(@"result == %@",result);
        NSArray* resList = result[@"list"];
          
        if ([[result objectForKey:@"result"]isEqualToString:@"0000000"]) {
            [m_data addObjectsFromArray:resList];
            [m_table reloadData];
        }
        [m_refreshfooter endRefreshing];
    }, ^(id result) {
        [m_refreshfooter endRefreshing];
    });
}

- (void)popviewHidden:(BOOL)isHidden
{
    [self.view viewWithTag:1501].hidden = isHidden;
    [self.view viewWithTag:1502].hidden = isHidden;
}

- (NSArray*)getSortList
{
    NSDictionary* config = UGET(U_CONFIG);
    for (NSDictionary* item in config[@"list"]) {
        if ([item[@"pageId"] intValue] == PAGE_ID) {
            return item[@"listSort"];
        }
    }
    return nil;
}

- (void)onFilterBtnTouched:(id)sender
{
    FilterViewController* vc = [[FilterViewController alloc] init];
    vc.respBlock = ^ (NSString* resp) {
        m_filterStr = [resp copy];
        m_loadDataType = LD_FILTER;
        [m_data removeAllObjects];
        [m_table reloadData];
        mainThread(loadData, nil);
    };
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onUpTaskList:(id)sender
{
    [m_data removeAllObjects];
    [m_table reloadData];
    mainThread(loadData, nil);
}

//#pragma mark - UISearchBarDelegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    m_searchBar.showsCancelButton = YES;
//    return YES;
//}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    m_searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = NO;
    
    m_loadDataType = (m_searchBar.text.length > 0 ? LD_SEARCH : LD_NORMOR);
    [m_data removeAllObjects];
    [m_table reloadData];
    mainThread(loadData, nil);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = YES;
    m_searchBar.text = @"";
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadMoreData];
}


-(void)loadMoreData
{
    a++;
    
    NSLog(@"==%d",a);
    
    NSString *strLimit = [NSString stringWithFormat:@"%d",20];
    NSString *str = [NSString stringWithFormat:@"%d",(a-1)*20];
    
    NSString* d1 = getMonthFirstDay([NSDate date]);
    NSString* d2 = getMonthLastDay([NSDate date]);
    
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"MyTask/GetCycleWorkInfo";
    paraDict[@"startDate"] = d1;
    paraDict[@"endDate"] = d2;
    paraDict[@"limit"] = strLimit;
    paraDict[@"skip"] = str;
    CLLocationCoordinate2D coord = getCoordinate();
    paraDict[@"longitude"] = format(@"%g", coord.longitude);
    paraDict[@"latitude"] = format(@"%g", coord.latitude);
    
    if (m_sortSelected >= 0) {
        paraDict[@"sortId"] = m_sortId;
    }
    
    if (m_loadDataType == LD_NORMOR) {
        
    } else if (m_loadDataType == LD_SEARCH) {
        paraDict[@"siteName"] = m_searchBar.text;
    } else if (m_loadDataType == LD_FILTER) {
        paraDict[@"condition"] = m_filterStr;
//        CLLocationCoordinate2D coord = getCoordinate();
//        paraDict[@"latitude"] = format(@"%g,%g", coord.longitude, coord.latitude);
    }
    
    NSLog(@"%@",paraDict);
    httpGET2(paraDict, ^(id result) {
        
        NSArray* resList = result[@"list"];
        if (resList.count > 0) {
            [m_data addObjectsFromArray:resList];
            [m_table reloadData];
        }else{
            a--;
        }
        [m_refreshfooter endRefreshing];
    }, ^(id result) {
        [m_refreshfooter endRefreshing];
    });
    
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    if (m_data[indexPath.row][@"siteId"] == nil) return;
    
    MyTaskListViewController* vc = [[MyTaskListViewController alloc] init];
    vc.site = m_data[indexPath.row];
    DLog(@"%@",m_data);
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"siteId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        newLabel(cell, @[@50, RECT_OBJ(10, 10, APP_W-30, Font1), [UIColor blackColor], FontB(Font1), @""]);
        newLabel(cell, @[@51, RECT_OBJ(10, 10+Font1+7, 245, Font4), [UIColor blackColor], Font(Font4), @""]);
        newLabel(cell, @[@52, RECT_OBJ(246, 10+Font1+7, 55, Font4), COLOR(238, 142, 63), Font(Font4), @""]);//.textAlignment = NSTextAlignmentRight;
    }
    
    ((UILabel*)[cell viewWithTag:50]).text = dataRow[@"siteName"];
    ((UILabel*)[cell viewWithTag:51]).text = format(@"我的未完成:%@/总:%@ | 全组未完成:%@/总:%@",
                                                    dataRow[@"undoTaskNum"], dataRow[@"taskTotal"],
                                                    dataRow[@"undoTaskNumOrg"], dataRow[@"taskTotalOrg"]);
    if([dataRow[@"undoTaskNumOrg"] isEqualToString:@"0"]&&[dataRow[@"undoTaskNum"] isEqualToString:@"0"]){
        //        cell.userInteractionEnabled=NO;
        cell.backgroundColor = RGBCOLOR(173, 173, 173);
        
    }
    
    ((UILabel*)[cell viewWithTag:52]).text = format(@"%@/%@", dataRow[@"siteType"], NoNullStr(dataRow[@"siteLevel"]));

    return cell;
}


@end

CLLocationCoordinate2D getCoordinate()
{
    CLLocationManager* locManager = [[CLLocationManager alloc] init];
    //locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locManager startUpdatingLocation];
    locManager.distanceFilter = 1000.0f;
    CLLocationCoordinate2D coor = locManager.location.coordinate;
    [locManager stopUpdatingLocation];
    [locManager release];
    
    return coor;
}
