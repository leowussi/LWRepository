//
//  MyResourceQuery.m
//  telecom
//
//  Created by 郝威斌 on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyResourceQuery.h"
#import "QrReadView.h"
#import "MyEngineRoomDetail.h"
#import "MyInformationDetails.h"
@interface MyResourceQuery ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString* m_qrCode;
    UISearchBar* m_searchBar;
    NSMutableArray* m_data;
    UITableView* m_table;
    NSString *strSearch;
}
@end

static int a = 1;
static int b = 1;
static int c = 1;
static int d = 1;
static int e = 1;

@implementation MyResourceQuery

- (void)dealloc
{
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIImage* moreIcon = [UIImage imageNamed:@"jf1.png"];
    UIButton* moreBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-moreIcon.size.width), (NAV_H-moreIcon.size.height)/2,
                                                             moreIcon.size.width/2, moreIcon.size.height/2)];
    [moreBtn setBackgroundImage:moreIcon forState:0];
    [moreBtn addTarget:self action:@selector(onMoreBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    m_searchBar = [[UISearchBar alloc] initWithFrame:RECT(0, 64, APP_W, NAV_H)];
    m_searchBar.delegate = self;
    m_searchBar.placeholder = @"请输入设备名称/设施点编码";
    m_searchBar.translucent = YES;
    m_searchBar.keyboardType = UIKeyboardTypeDefault;
    m_searchBar.backgroundColor = [UIColor lightGrayColor];
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
    m_table = [[UITableView alloc] initWithFrame:RECT(0, m_searchBar.ey, APP_W, (SCREEN_H-m_searchBar.ey))
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = Font2+20;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:m_table];
    
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.frame=RECT(0, 0, kScreenWidth, 20);
    [m_table addSubview:btn];
    if (self.vcTag == 1) {
        self.title = @"A类路由器";
        [btn setTitle:@"点击示例：Z6130" forState:UIControlStateNormal];
    }else if (self.vcTag == 2) {
        self.title = @"BBU资源";
        [btn setTitle:@"点击示例：10325" forState:UIControlStateNormal];
    }else if (self.vcTag == 3) {
        self.title = @"RRU资源";
        [btn setTitle:@"点击示例：LRRU24785" forState:UIControlStateNormal];
    }else if (self.vcTag == 4) {
        self.title = @"天线管理";
        [btn setTitle:@"点击示例：A0015250" forState:UIControlStateNormal];
        m_searchBar.placeholder = @"请输入设备编码";
    }else if (self.vcTag == 5) {
        self.title = @"室分系统";
        [btn setTitle:@"点击示例：DPD00080" forState:UIControlStateNormal];
        m_searchBar.placeholder = @"请输入设备编码";
    }
    
    //下拉刷新
    [self addHeader];
    
    //上拉加载更多
    [self addFooter];
    
}
-(void)btnClick:(UIButton *)btn{
    NSString *str = nil;
    if (self.vcTag == 1) {
        str = @"Z6130";
    }else if (self.vcTag == 2) {
       str =@"10325";
    }else if (self.vcTag == 3) {
        str=@"LRRU24785";
    }else if (self.vcTag == 4) {
        str=@"A0015250";
    }else if (self.vcTag == 5) {
        str=@"DPD00080";
    }

    [self loadData:str];
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformScale(btn.transform, 0, 20);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [btn removeFromSuperview];
        });
//        m_table.transform =CGAffineTransformTranslate(m_table.transform, 0, -20) ;
    }];
    self.view.backgroundColor =[UIColor whiteColor];
}


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
    strSearch =[[NSString stringWithFormat:@"%@",searchBar.text] copy];
    NSLog(@"strSearch == %@",strSearch);
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = NO;
    
    [m_data removeAllObjects];
    [m_table reloadData];
    mainThread(loadData:, searchBar.text);
    
}

#pragma mark == 开始搜索的请求
- (void)loadData:(NSString*)keyword
{
    
    if (self.vcTag == 1) {
        httpGET2(@{URL_TYPE:NW_GetRouterData, @"condition":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
                showAlert(format(@"%@", result[@"error"]));
            }
        }, ^(id result) {
            showAlert(format(@"%@", result[@"error"]));
        });
    }else if (self.vcTag == 2){
        httpGET2(@{URL_TYPE:NW_GetBBUFacilityData, @"condition":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
                showAlert(format(@"%@", result[@"error"]));
            }
            //[m_refreshfooter endRefreshing];
        }, ^(id result) {
            
             showAlert(format(@"%@", result[@"error"]));
        });
    }else if (self.vcTag == 3){
        httpGET2(@{URL_TYPE:NW_GetRRUFacilityData, @"condition":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
                showAlert(format(@"%@", result[@"error"]));
            }
        }, ^(id result) {
            showAlert(format(@"%@", result[@"error"]));
        });
    }else if (self.vcTag == 4){
        httpGET2(@{URL_TYPE:NW_GetAerialListData, @"condition":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
                showAlert(format(@"%@", result[@"error"]));
            }
        }, ^(id result) {
            showAlert(format(@"%@", result[@"error"]));
        });
    }else if (self.vcTag == 5){
        httpGET2(@{URL_TYPE:NW_GetFSystemListData, @"condition":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
                showAlert(format(@"%@", result[@"error"]));
            }
        }, ^(id result) {
            showAlert(format(@"%@", result[@"error"]));
        });
    }
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"nuId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
        if (self.vcTag == 1) {
            newLabel(cell, @[@50, RECT_OBJ(15, 10, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@100, RECT_OBJ(15, 17+Font2, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@150, RECT_OBJ(APP_W-85, 10, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@200, RECT_OBJ(APP_W-85, 17+Font2, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
        }else if (self.vcTag == 2){
            
            newLabel(cell, @[@50, RECT_OBJ(15, 10, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@100, RECT_OBJ(15, 17+Font2, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@1000, RECT_OBJ(15, 36+Font2, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@150, RECT_OBJ(APP_W-85, 10, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@200, RECT_OBJ(APP_W-85, 17+Font2, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
        }else if (self.vcTag == 3){
            
            newLabel(cell, @[@50, RECT_OBJ(15, 10, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@100, RECT_OBJ(15, 17+Font2, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@1000, RECT_OBJ(15, 36+Font2, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@150, RECT_OBJ(APP_W-85, 10, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@200, RECT_OBJ(APP_W-85, 17+Font2, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
        }else if (self.vcTag == 4){
            
            newLabel(cell, @[@50, RECT_OBJ(15, 10, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@100, RECT_OBJ(15, 17+Font2, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            
            newLabel(cell, @[@150, RECT_OBJ(APP_W-85, 10, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@200, RECT_OBJ(APP_W-85, 17+Font2, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
        }else if (self.vcTag == 5){
            
            newLabel(cell, @[@50, RECT_OBJ(15, 5, APP_W-100, 30), [UIColor blackColor], Font(Font3), @""]);
            
            
            newLabel(cell, @[@100, RECT_OBJ(15, 27+Font2, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
            
            newLabel(cell, @[@150, RECT_OBJ(APP_W-85, 10, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
//            newLabel(cell, @[@200, RECT_OBJ(APP_W-85, 17+Font2, 80, Font2), [UIColor blackColor], Font(Font3), @""]);
            
        }
    }
    if (self.vcTag == 1) {
        
        
        tagViewEx(cell, 50, UILabel).text = dataRow[@"facShortName"];
        
        tagViewEx(cell, 100, UILabel).text = dataRow[@"facName"];
        
        tagViewEx(cell, 150, UILabel).text = dataRow[@"facCode"];
        
        tagViewEx(cell, 200, UILabel).text = dataRow[@"netType"];
        
    }else if (self.vcTag == 2){
        
        tagViewEx(cell, 50, UILabel).text = dataRow[@"facNm"];
        
        tagViewEx(cell, 100, UILabel).text = dataRow[@"facModel"];
        
        tagViewEx(cell, 1000, UILabel).text = dataRow[@"whRegion"];
        
        tagViewEx(cell, 150, UILabel).text = dataRow[@"facNO"];
        
        tagViewEx(cell, 200, UILabel).text = dataRow[@"facCode"];
        
    }else if (self.vcTag == 3){
        
        tagViewEx(cell, 50, UILabel).text = dataRow[@"facNm"];
        
        tagViewEx(cell, 100, UILabel).text = dataRow[@"facModel"];
        
        tagViewEx(cell, 1000, UILabel).text = dataRow[@"whRegion"];
        
        tagViewEx(cell, 150, UILabel).text = dataRow[@"facNO"];
        
        tagViewEx(cell, 200, UILabel).text = dataRow[@"facCode"];
        
    }else if (self.vcTag == 4){
        
        tagViewEx(cell, 50, UILabel).text = dataRow[@"aerialNO"];
        
        tagViewEx(cell, 100, UILabel).text = dataRow[@"derrickCode"];
        
        tagViewEx(cell, 150, UILabel).text = dataRow[@"facCode"];
        
        tagViewEx(cell, 200, UILabel).text = dataRow[@"upRRUNO"];
        
    }else if (self.vcTag == 5){
        
        tagViewEx(cell, 50, UILabel).numberOfLines = 0;
        tagViewEx(cell, 50, UILabel).text = dataRow[@"sysName"];
        
        tagViewEx(cell, 100, UILabel).text = dataRow[@"coverArea"];
        
        tagViewEx(cell, 150, UILabel).text = dataRow[@"sysCode"];
        
//        tagViewEx(cell, 200, UILabel).text = dataRow[@"facCode"];
    }
    
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.vcTag == 1) {
        return m_table.rowHeight+20;
    }else if (self.vcTag == 2){
        return m_table.rowHeight+40;
    }else if (self.vcTag == 3){
        return m_table.rowHeight+40;
    }else if (self.vcTag == 4){
        return m_table.rowHeight+20;
    }else if (self.vcTag == 5){
        return m_table.rowHeight+30;
    }else{
        return m_table.rowHeight;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    
    if (m_data[indexPath.row][@"nuId"] == nil) return;
    [self getInfoDetilData:m_data[indexPath.row][@"nuId"]];
}

#pragma mark == 点击表格的请求
- (void)getInfoDetilData:(NSString*)keyword
{
    NSLog(@"%@",keyword);
    if (self.vcTag == 1) {
        
        httpGET2(@{URL_TYPE:NW_GetInfoDetailData, @"nuId":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            MyInformationDetails* vc = [[MyInformationDetails alloc] init];
            vc.dataArray = resList;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            //[m_refreshfooter endRefreshing];
        }, ^(id result) {
            //[m_refreshfooter endRefreshing];
        });
        
    }else if (self.vcTag == 2){
        
        httpGET2(@{URL_TYPE:NW_GetBBUFacilityDetailData, @"nuId":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            MyInformationDetails* vc = [[MyInformationDetails alloc] init];
            vc.dataArray = resList;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            //[m_refreshfooter endRefreshing];
        }, ^(id result) {
            //[m_refreshfooter endRefreshing];
        });
        
    }else if (self.vcTag == 3){
        
        httpGET2(@{URL_TYPE:NW_GetRRUFacilityDetailData, @"nuId":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            MyInformationDetails* vc = [[MyInformationDetails alloc] init];
            vc.dataArray = resList;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            //[m_refreshfooter endRefreshing];
        }, ^(id result) {
            //[m_refreshfooter endRefreshing];
        });
        
    }else if (self.vcTag == 4){
        
        httpGET2(@{URL_TYPE:NW_GetAerialListDetailData, @"nuId":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            MyInformationDetails* vc = [[MyInformationDetails alloc] init];
            vc.dataArray = resList;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            //[m_refreshfooter endRefreshing];
        }, ^(id result) {
            //[m_refreshfooter endRefreshing];
        });
        
    }else if (self.vcTag == 5){
        
        httpGET2(@{URL_TYPE:NW_GetFSystemListDataDetail, @"nuId":keyword}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            MyInformationDetails* vc = [[MyInformationDetails alloc] init];
            vc.dataArray = resList;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            //[m_refreshfooter endRefreshing];
        }, ^(id result) {
            //[m_refreshfooter endRefreshing];
        });
        
    }
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = YES;
    m_searchBar.text = @"";
}

#pragma mark == 二维码扫描
- (void)onMoreBtnTouched:(id)sender
{
    [self.view endEditing:YES];
    
    if ([QrReadView checkCamera]) {
        QrReadView* vc = [[QrReadView alloc] init];
        vc.respBlock = ^(NSString* v) {
            m_qrCode = [v copy];
            mainThread(openRoomDetailInfo:, m_qrCode);
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}
- (void)openRoomDetailInfo:(NSString*)qrCode
{

    strSearch = [qrCode copy];
    if (self.vcTag == 1) {
        
        httpGET2(@{URL_TYPE:NW_GetRouterData, @"condition":qrCode}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data removeAllObjects];
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
               showAlert(format(@"%@", result[@"error"]));
            }
            
        }, ^(id result) {
            
            showAlert(format(@"%@", result[@"error"]));
        });
    }else if (self.vcTag == 2){
        
        httpGET2(@{URL_TYPE:NW_GetBBUFacilityData, @"condition":qrCode}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data removeAllObjects];
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
                showAlert(format(@"%@", result[@"error"]));
            }
            
        }, ^(id result) {
            
            showAlert(format(@"%@", result[@"error"]));
            
        });
    }else if (self.vcTag == 3){
        
        httpGET2(@{URL_TYPE:NW_GetRRUFacilityData, @"condition":qrCode}, ^(id result) {
            
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data removeAllObjects];
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
                
                showAlert(format(@"%@", result[@"error"]));
            }
            
        }, ^(id result) {
            showAlert(format(@"%@", result[@"error"]));
        });
    }else if (self.vcTag == 4){
        
        httpGET2(@{URL_TYPE:NW_GetAerialListData, @"condition":qrCode}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data removeAllObjects];
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
                showAlert(format(@"%@", result[@"error"]));
            }
            
            
        }, ^(id result) {
            
            showAlert(format(@"%@", result[@"error"]));
            
        });
    }else if (self.vcTag == 5){
        
        httpGET2(@{URL_TYPE:NW_GetFSystemListData, @"condition":qrCode}, ^(id result) {
            NSLog(@"%@",result);
            NSArray* resList = result[@"list"];
            if (resList.count > 0) {
                [m_data removeAllObjects];
                [m_data addObjectsFromArray:resList];
                [m_table reloadData];
                
            }else{
                showAlert(format(@"%@", result[@"error"]));
            }
            
        }, ^(id result) {
            
            showAlert(format(@"%@", result[@"error"]));
        });
    }
    

}

- (void)openRoomDetailVC:(NSMutableDictionary*)info
{
    MyInformationDetails* vc = [[MyInformationDetails alloc] init];
//    vc.roomInfo = info;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

///////////////////////////////////////////


//下拉加载
- (void)addFooter
{
    __unsafe_unretained MyResourceQuery *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = m_table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加5条假数据
        //[self.tableView reloadData];
        
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}


//上拉刷新
- (void)addHeader
{
    __unsafe_unretained MyResourceQuery *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = m_table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此5秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithVie:) withObject:refreshView afterDelay:3.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
//    [header beginRefreshing];
    _header = header;
}

#pragma mark == 加载更多
-(void)doneWithView:(MJRefreshBaseView *)refreshView
{
  
    if (strSearch == nil || strSearch.length <= 0) {
        
        [refreshView endRefreshing];
        showAlert(@"请输入要查询的设备名称/设施点编码");
        
    }else{
        if (self.vcTag == 1) {
            a++;
            NSString *strLimit = [NSString stringWithFormat:@"%d",20];
            NSString *str = [NSString stringWithFormat:@"%d",(a-1)*20];
            
            httpGET2(@{URL_TYPE:NW_GetRouterData, @"condition":strSearch,@"limit":strLimit,@"skip":str}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }else{
                    showAlert(format(@"%@", result[@"error"]));
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
                --a;
                showAlert(format(@"%@", result[@"error"]));
            });
        }else if (self.vcTag == 2){
            b++;
            NSString *strLimit = [NSString stringWithFormat:@"%d",20];
            NSString *str = [NSString stringWithFormat:@"%d",(b-1)*20];
            
            httpGET2(@{URL_TYPE:NW_GetBBUFacilityData, @"condition":strSearch,@"limit":strLimit,@"skip":str}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }else{
                    showAlert(format(@"%@", result[@"error"]));
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
                --b;
                showAlert(format(@"%@", result[@"error"]));
            });
        }else if (self.vcTag == 3){
            c++;
            NSString *strLimit = [NSString stringWithFormat:@"%d",20];
            NSString *str = [NSString stringWithFormat:@"%d",(c-1)*20];
            
            httpGET2(@{URL_TYPE:NW_GetRRUFacilityData, @"condition":strSearch,@"limit":strLimit,@"skip":str}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }else{
                    showAlert(format(@"%@", result[@"error"]));
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
                --c;
                showAlert(format(@"%@", result[@"error"]));
            });
        }else if (self.vcTag == 4){
            d++;
            NSString *strLimit = [NSString stringWithFormat:@"%d",20];
            NSString *str = [NSString stringWithFormat:@"%d",(d-1)*20];
            
            
            httpGET2(@{URL_TYPE:NW_GetAerialListData, @"condition":strSearch,@"limit":strLimit,@"skip":str}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }else{
                    showAlert(format(@"%@", result[@"error"]));
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
                --d;
                showAlert(format(@"%@", result[@"error"]));
            });
        }else if (self.vcTag == 5){
            e++;
            NSString *strLimit = [NSString stringWithFormat:@"%d",20];
            NSString *str = [NSString stringWithFormat:@"%d",(e-1)*20];
            
            httpGET2(@{URL_TYPE:NW_GetFSystemListData, @"condition":strSearch,@"limit":strLimit,@"skip":str}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }else{
                    showAlert(format(@"%@", result[@"error"]));
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
                --e;
                showAlert(format(@"%@", result[@"error"]));
            });
        }
    
    }
    

    
}

#pragma mark == 刷新表格
- (void)doneWithVie:(MJRefreshBaseView *)refreshView
{
    if (strSearch == nil || strSearch.length <= 0) {
        
        [refreshView endRefreshing];
        showAlert(@"请输入要查询的设备名称/设施点编码");
        
    }else{
        if (self.vcTag == 1) {
            a = 1;
            
            httpGET2(@{URL_TYPE:NW_GetRouterData, @"condition":strSearch}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data removeAllObjects];
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
            });
        }else if (self.vcTag == 2){
            b = 1;
            
            httpGET2(@{URL_TYPE:NW_GetBBUFacilityData, @"condition":strSearch}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data removeAllObjects];
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
            });
        }else if (self.vcTag == 3){
            c = 1;
            
            httpGET2(@{URL_TYPE:NW_GetRRUFacilityData, @"condition":strSearch}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data removeAllObjects];
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
            });
        }else if (self.vcTag == 4){
            d = 1;
            
            httpGET2(@{URL_TYPE:NW_GetAerialListData, @"condition":strSearch}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data removeAllObjects];
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
            });
        }else if (self.vcTag == 5){
            e = 1;
            
            httpGET2(@{URL_TYPE:NW_GetFSystemListData, @"condition":strSearch}, ^(id result) {
                NSLog(@"%@",result);
                NSArray* resList = result[@"list"];
                if (resList.count > 0) {
                    [m_data removeAllObjects];
                    [m_data addObjectsFromArray:resList];
                    [m_table reloadData];
                    
                }
                [refreshView endRefreshing];
            }, ^(id result) {
                [refreshView endRefreshing];
            });
        }
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
