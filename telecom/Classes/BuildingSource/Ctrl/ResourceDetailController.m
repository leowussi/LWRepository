//
//  ResourceDetailController.m
//  telecom
//
//  Created by liuyong on 16/3/2.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#define kAddressTitleHeight  25
#define kBtnWidth 85

#import "ResourceDetailController.h"

#import "PGLCell.h"


#import "LQrowHightModel.h"
#import "LQfoceListHeadview.h"
#import "LQDownFoceViewTableViewCell.h"
#import "LQCellGDJ.h"
#import "LQCellOLT.h"
#import "LQCellOBD.h"
#import "LQCellONU.h"
#import "PublicModel.h"

#import "GdjModel.h"
#import "GjjxModel.h"
#import "GfqxModel.h"
#import "OltModel.h"
#import "ObdModel.h"
#import "OnuModel.h"
#import "PglModel.h"
#import "YZResourcesChangeViewController.h"

#import "MJRefresh.h"

@interface ResourceDetailController ()<UITableViewDataSource,UITableViewDelegate,LQfoceListHeadviewDelegate>
{
    UITableView *_tableView;
    UIImageView *_imageView;
    UIButton *_beforeBtn;
    
    UIView *tabBar;
    UIScrollView *tabScrollView;
    
    NSInteger curIndex;
    
    //下拉刷新和上拉加载
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_resreshFooter;
    //所要页面
    NSInteger _nextPage;
    
    NSMutableArray *_focListArray;
    
    //记录区头是否是选中状态的字典
    NSMutableDictionary *_isSelectedDict;
}
@property(nonatomic,strong)NSDictionary *dict;
@property (nonatomic, strong) NSArray *titles;
@property(nonatomic,strong)NSArray *urlsArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *GdjdataArray;
@end

@implementation ResourceDetailController

- (void)dealloc
{
    [_resreshFooter free];
    [_refreshHeader free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资源信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    _nextPage = 1;
    _focListArray = [[NSMutableArray alloc] initWithCapacity:0];
    _isSelectedDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.dict = @{@0:@"gdjCount",@1:@"gjjxCount",@2:@"gfqxCount",@3:@"oltCount",@4:@"obdCount",@5:@"onuCount",@6:@"pglCount"};
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self addNavigationLeftButton];
    
    UILabel *addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 20)];
    addressTitle.textAlignment = NSTextAlignmentLeft;
    addressTitle.text = self.currentAddress;
    addressTitle.textColor = [UIColor blackColor];
    addressTitle.backgroundColor = [UIColor colorWithRed:197/255.0f green:197/255.0f blue:197/255.0f alpha:0.9];
    [self.view addSubview:addressTitle];
    
    tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_W, 30)];
    tabBar.layer.borderWidth = 0.5;
    tabBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tabBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabBar];
    
    tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, tabBar.frame.size.width-25, tabBar.frame.size.height)];
    tabScrollView.showsHorizontalScrollIndicator = NO;
    tabScrollView.showsVerticalScrollIndicator = NO;
    [tabBar addSubview:tabScrollView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(tabScrollView.frame), 0, 25, tabBar.frame.size.height);
    [rightBtn setImage:[[UIImage imageNamed:@"双箭头.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:rightBtn];
    
    for (int i=0; i<self.titles.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(kBtnWidth*i, 0, kBtnWidth, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        btn.tag = 99999 + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"选中背景.png"] forState:UIControlStateSelected];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        [tabScrollView addSubview:btn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kBtnWidth+2+(kBtnWidth+2)*i, 3, 0.5, 21)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [tabScrollView addSubview:lineView];
        
        UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        numBtn.frame = CGRectMake(kBtnWidth-15, 0, 17, 15);
        [numBtn setBackgroundImage:[UIImage imageNamed:@"小圆圈.png"] forState:UIControlStateNormal];
        numBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [numBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addSubview:numBtn];
        
        switch (i) {
            case 0:
                [numBtn setTitle:self.singleModel.gdjCount forState:UIControlStateNormal];
                break;
            case 1:
                [numBtn setTitle:self.singleModel.gjjxCount forState:UIControlStateNormal];
                break;
            case 2:
                [numBtn setTitle:self.singleModel.gfqxCount forState:UIControlStateNormal];
                break;
            case 3:
                [numBtn setTitle:self.singleModel.oltCount forState:UIControlStateNormal];
                break;
            case 4:
                [numBtn setTitle:self.singleModel.obdCount forState:UIControlStateNormal];
                break;
            case 5:
                [numBtn setTitle:self.singleModel.onuCount forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        
    }
    
    tabScrollView.contentSize = CGSizeMake(self.titles.count*kBtnWidth, 0);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_W, SCREEN_H-110) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_W, SCREEN_H-104)];
    _imageView.image = [UIImage imageNamed:@"没数据.png"];
    [self.view addSubview:_imageView];
    _imageView.hidden = YES;
    
    if ([self.singleModel.gdjCount isEqualToString:@"0"]) {//Gdj 0
        
        if ([self.singleModel.gjjxCount isEqualToString:@"0"]) {//Gjjx 1
            if ([self.singleModel.gfqxCount isEqualToString:@"0"]) {//Gfqx 2
                if ([self.singleModel.oltCount isEqualToString:@"0"]) {//Olt 3
                    if ([self.singleModel.obdCount isEqualToString:@"0"]) {//Obd 4
                        if (![self.singleModel.onuCount isEqualToString:@"0"]) {//Onu 5
                            UIButton *btn = [self.view viewWithTag:99999+5];
                            [self btnTap:btn];
                            tabScrollView.contentOffset = CGPointMake(kBtnWidth*5, 0);
                        }else{
                            UIButton *btn = [self.view viewWithTag:99999];
                            [self btnTap:btn];
                        }
                    }else{
                        UIButton *btn = [self.view viewWithTag:99999+4];
                        [self btnTap:btn];
                        tabScrollView.contentOffset = CGPointMake(kBtnWidth*4, 0);
                    }
                }else{
                    UIButton *btn = [self.view viewWithTag:99999+3];
                    [self btnTap:btn];
                    tabScrollView.contentOffset = CGPointMake(kBtnWidth*3, 0);
                }
            }else{
                UIButton *btn = [self.view viewWithTag:99999+2];
                [self btnTap:btn];
                tabScrollView.contentOffset = CGPointMake(kBtnWidth*2, 0);
            }
        }else{
            UIButton *btn = [self.view viewWithTag:99999+1];
            [self btnTap:btn];
            tabScrollView.contentOffset = CGPointMake(kBtnWidth*1, 0);
        }
    }else{
        UIButton *btn = [self.view viewWithTag:99999+0];
        [self btnTap:btn];
        tabScrollView.contentOffset = CGPointMake(kBtnWidth*0, 0);
    }
    [self mjRefresh];
}


- (void)mjRefresh
{
    _refreshHeader = [MJRefreshHeaderView header];
    _refreshHeader.scrollView = _tableView;
    
    __weak ResourceDetailController *selfVC = self;
    __block NSInteger *currentIndex = &curIndex;
    _refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        _nextPage = 1;
        [selfVC loadDataWithUrl:selfVC.urlsArray[*currentIndex]];
    };
    
    
    _resreshFooter = [MJRefreshFooterView footer];
    _resreshFooter.scrollView = _tableView;
    _resreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [selfVC nextPageAdd];
        [selfVC loadDataWithUrl:selfVC.urlsArray[*currentIndex]];
    };
    
}
- (void)nextPageAdd
{
    _nextPage++;
}

- (void)rightAction
{
    tabScrollView.contentOffset = CGPointMake(SCREEN_W-25, 0);
}

- (void)btnTap:(UIButton *)btn
{
    _nextPage = 1;
    _beforeBtn.selected = NO;
    btn.selected = YES;
    _beforeBtn = btn;
    
    NSInteger index = btn.tag-99999;
    if (index != curIndex) {
        [_isSelectedDict removeAllObjects];
        [_focListArray removeAllObjects];
    }
    curIndex = index;
    if (index == 0) {
        _tableView.hidden =NO;
        _imageView.hidden = YES;
        _imageView.image = [UIImage imageNamed:@"没数据.png"];
        NSString *count = self.singleModel.gdjCount;
        if ([count isEqualToString:@"0"]) {
            _imageView.hidden = NO;
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:self.urlsArray[index]];
        }
    }else if (index == 1){
        NSString *count = self.singleModel.gjjxCount;
        if ([count isEqualToString:@"0"]) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:self.urlsArray[index]];
        }
    }else if (index == 2){
        NSString *count = self.singleModel.gfqxCount;
        if ([count isEqualToString:@"0"]) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            
            [self loadDataWithUrl:self.urlsArray[index]];
        }
    }else if (index == 3){
        NSString *count = self.singleModel.oltCount;
        if ([count isEqualToString:@"0"]) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:self.urlsArray[index]];
        }
    }else if (index == 4){
        NSString *count = self.singleModel.obdCount;
        if ([count isEqualToString:@"0"]) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:self.urlsArray[index]];
        }
    }else if (index == 5){
        NSString *count = self.singleModel.onuCount;
        if ([count isEqualToString:@"0"]) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:self.urlsArray[index]];
        }
    }else{
        //        NSString *count = self.singleModel.pglCount;
        //        if ([count isEqualToString:@"0"]) {
        //            _imageView.hidden = NO;
        //            _imageView.image = [UIImage imageNamed:@"没数据.png"];
        //            _tableView.hidden = YES;
        //        }else{
        //            _imageView.hidden = YES;
        //            _tableView.hidden = NO;
        //            [self loadDataWithUrl:self.urlsArray[index]];
        //        }
    }
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"光端机", @"光交接箱", @"光分纤箱", @"OLT",@"OBD", @"ONU"];
    }
    return _titles;
}

- (NSArray *)urlsArray{
    if (!_urlsArray) {
        _urlsArray = @[@"house/SearchGdjList",@"house/SearchGjjxList",@"house/SearchGfqxList",@"house/SearchOltList",@"house/SearchObdList",@"house/SearchOnuList"];
    }
    return _urlsArray;
}

- (void)loadDataWithUrl:(NSString *)url
{
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@/%@.json",ADDR_IP,ADDR_DIR,url];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"operationTime"] = operationTime;
    paraDict[@"accessToken"] = UGET(U_TOKEN);
    paraDict[@"road"] =self.road;
    paraDict[@"lane"] =self.lane;
    paraDict[@"gate"] =self.gate;
    paraDict[@"lou"] = self.lou;
    paraDict[@"curPage"] = [NSString stringWithFormat:@"%d",_nextPage];
    paraDict[@"pageSize"] = @"10";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_refreshHeader endRefreshing];
        [_resreshFooter endRefreshing];
        if ([responseObject[@"result"] isEqualToString:@"0000000"]) {
            static NSInteger previousIndex = -1;
            if (curIndex != previousIndex || _nextPage == 1) {
                [self.dataArray removeAllObjects];
                previousIndex = curIndex;
                if (curIndex == 0 && _nextPage == 1) {
                    [self.GdjdataArray removeAllObjects];
                }
            }
            if (curIndex == 0) {//gdj
                if (self.GdjdataArray == nil) {
                    self.GdjdataArray = [NSMutableArray array];
                }
                
                for (NSDictionary *dict in responseObject[@"list"]) {
                    GdjModel *model = [[GdjModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.GdjdataArray addObject:model];
                }
                
            }
            if (curIndex == 1){
                NSMutableArray *ayy =[NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"list"]) {
                    GjjxModel *gjjModel = [[GjjxModel alloc]initWithDict:dic];
                    [ayy addObject:gjjModel];
                }
                NSMutableArray *statusFrameArray = [NSMutableArray array];
                for (GjjxModel *gmodel in ayy) {
                    LQrowHightModel *statusFrame = [[LQrowHightModel alloc] init];
                    statusFrame.model = gmodel;
                    [statusFrameArray addObject:statusFrame];
                    [_focListArray addObject:[NSMutableArray arrayWithCapacity:0]];
                }
                [self.dataArray addObjectsFromArray:statusFrameArray];
            }
            if (curIndex == 2){
                NSMutableArray *ayy =[NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"list"]) {
                    GjjxModel *gjjModel = [[GjjxModel alloc]initWithDict:dic];
                    [ayy addObject:gjjModel];
                }
                
                NSMutableArray *statusFrameArray = [NSMutableArray array];
                for (GjjxModel *gmodel in ayy) {
                    LQrowHightModel *statusFrame = [[LQrowHightModel alloc] init];
                    statusFrame.model = gmodel;
                    [statusFrameArray addObject:statusFrame];
                    [_focListArray addObject:[NSMutableArray arrayWithCapacity:0]];
                }
                [self.dataArray addObjectsFromArray:statusFrameArray];
            }
            if (curIndex == 3){
                for (NSDictionary *dict in responseObject[@"list"]) {
                    OltModel *model = [[OltModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
            }
            if (curIndex == 4){
                for (NSDictionary *dict in responseObject[@"list"]) {
                    ObdModel *model = [[ObdModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
            }
            if (curIndex == 5){
                for (NSDictionary *dict in responseObject[@"list"]) {
                    OnuModel *model = [[OnuModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
                
            }
            if (curIndex == 6){//配光缆
                for (NSDictionary *dict in responseObject[@"list"]) {
                    OnuModel *model = [[OnuModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
                
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshHeader endRefreshing];
        [_resreshFooter endRefreshing];
        showAlert(error);
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (curIndex==1||curIndex==2) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (curIndex==0) {
        return self.GdjdataArray.count;
    }
    if(curIndex==1||curIndex==2){
        NSArray *array = _focListArray[section];
        return array.count;
    }else{
        return self.dataArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (curIndex==1||curIndex==2) {
        LQrowHightModel *statusFrame= self.dataArray[section];
        return statusFrame.HeaderViewHight;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curIndex == 0) {//gdj
        PublicModel *model = [[PublicModel alloc]init];
        model.GDjMoedl = self.GdjdataArray[indexPath.row];
        return model.hight;
    }else if (curIndex == 1){//gjjx
        return 250;
    }else if (curIndex == 2){//gfqx
        
        return 250;
    }else if (curIndex == 3){//olt
        PublicModel *model = [[PublicModel alloc]init];
        model.OltModel = self.dataArray[indexPath.row];
        return model.hight;
    }else if (curIndex == 4){//obd
        PublicModel *model = [[PublicModel alloc]init];
        model.OBDModel = self.dataArray[indexPath.row];
        return model.hight;
    }else{//onu
        PublicModel *model = [[PublicModel alloc]init];
        model.ONUModel = self.dataArray[indexPath.row];
        return model.hight;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (curIndex==1||curIndex==2) {
        LQfoceListHeadview *head = [LQfoceListHeadview headCellWithTableView:tableView];
        head.model =self.dataArray[section];
        head.jiaoZhengButton.tag = section;
        head.delegate = self;
        [head.jiaoZhengButton addTarget:self action:@selector(headerJiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchDown];
        head.tag = section;
        NSString *isSelected = [_isSelectedDict objectForKey:[NSString stringWithFormat:@"%d",section]];
        if (!isSelected || [isSelected isEqualToString:@"NO"]) {
            head.isOpened = NO;
        }else{
            head.isOpened = YES;
        }
        return head;
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    }
}

-(void)HeadViewDidClick:(LQfoceListHeadview *)headerView
{
    NSString *isSelected = [_isSelectedDict objectForKey:[NSString stringWithFormat:@"%d",headerView.tag]];
    NSMutableArray *array = _focListArray[headerView.tag];
    if (!isSelected || [isSelected isEqualToString:@"NO"]) {
        headerView.isOpened = YES;
        LQrowHightModel *model= self.dataArray[headerView.tag];
        
        [array addObjectsFromArray:model.model.focList];
        [_isSelectedDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",headerView.tag]];
    }else{
        headerView.isOpened = NO;
        [array removeAllObjects];
        [_isSelectedDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",headerView.tag]];
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:headerView.tag] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@",self.GdjdataArray);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (curIndex == 0) {
        LQCellGDJ *cell = [LQCellGDJ tableView:tableView];
        GdjModel *model = self.GdjdataArray[indexPath.row];
        cell.model=model;
        cell.jiaoZhengButton.tag = indexPath.row;
        [cell.jiaoZhengButton addTarget:self action:@selector(jiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchDown];
        return cell;
    }else if (curIndex == 1 ){
#pragma mark -光交接箱cell
        LQDownFoceViewTableViewCell *cell=[LQDownFoceViewTableViewCell cellWithTableView:tableView];
        //        LQrowHightModel *model= self.dataArray[indexPath.section];
        //        PglModel *pgModel = model.model.focList[indexPath.row];
        PglModel *pgModel = _focListArray[indexPath.section][indexPath.row];
        LQFoceList *moel = [[LQFoceList alloc]init];
        moel.model=pgModel;
        cell.model=moel;
        cell.jiaoZhengButton.tag = indexPath.section;
        [cell.jiaoZhengButton addTarget:self action:@selector(headerJiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchDown];
        return cell;
    }else if (curIndex == 2){
#pragma mark -光分纤箱cell
        LQDownFoceViewTableViewCell *cell=[LQDownFoceViewTableViewCell cellWithTableView:tableView];
        //        LQrowHightModel *model= self.dataArray[indexPath.section];
        PglModel *pgModel = _focListArray[indexPath.section][indexPath.row];
        LQFoceList *moel = [[LQFoceList alloc]init];
        moel.model=pgModel;
        cell.model=moel;
        cell.jiaoZhengButton.tag = indexPath.section;
        [cell.jiaoZhengButton addTarget:self action:@selector(headerJiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchDown];
        return cell;
    }else if (curIndex == 3){
        LQCellOLT *cell= [LQCellOLT tableView:tableView];
        OltModel *model = self.dataArray[indexPath.row];
        cell.model=model;
        cell.jiaoZhengButton.tag = indexPath.row;
        [cell.jiaoZhengButton addTarget:self action:@selector(jiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchDown];
        return cell;
    }else if (curIndex == 4){
        LQCellOBD *cell= [LQCellOBD tableView:tableView];
        cell.model =self.dataArray[indexPath.row];
        [cell.jiaoZhengButton addTarget:self action:@selector(jiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchDown];
        return cell;
        
    }else{
        LQCellONU *cell = [LQCellONU tableView:tableView];
        cell.model = self.dataArray[indexPath.row];
        cell.jiaoZhengButton.tag = indexPath.row;
        [cell.jiaoZhengButton addTarget:self action:@selector(jiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchDown];
        return cell;
    }
    
}
#pragma mark -- 校正按钮被点击
- (void)jiaoZhengButtonClicked:(UIButton *)sender
{
    
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    if (curIndex == 1) {
        resourcesChangeVC.resources_type = @"4-3";
    }else if (curIndex == 2){
        resourcesChangeVC.resources_type = @"4-2";
    }else{
        resourcesChangeVC.resources_type = [NSString stringWithFormat:@"4-%d",curIndex + 1];
    }
    
    id obj = nil;
    if (curIndex == 0) {
        obj = self.GdjdataArray[sender.tag];
    }else{
        obj = _dataArray[sender.tag];
    }
    NSString *resourcesId = nil;
    if ([obj isKindOfClass:[GdjModel class]]) {
        GdjModel *model = (GdjModel *)obj;
        resourcesId = model.otId;
    }else if ([obj isKindOfClass:[OltModel class]]) {
        OltModel *model = (OltModel *)obj;
        resourcesId = model.oltId;
    }else if ([obj isKindOfClass:[ObdModel class]]) {
        ObdModel *model = (ObdModel *)obj;
        resourcesId = model.obdId;
    }else if ([obj isKindOfClass:[OnuModel class]]) {
        OnuModel *model = (OnuModel *)obj;
        resourcesId = model.onuId;
    }
    
    resourcesChangeVC.resources_id = resourcesId;
    resourcesChangeVC.resources_sceneId = @"3";
    [self.navigationController pushViewController:resourcesChangeVC animated:YES];
    
}

- (void)headerJiaoZhengButtonClicked:(UIButton *)sender
{
    LQrowHightModel *model = [self.dataArray objectAtIndex:sender.tag];
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    if (curIndex == 1) {
        resourcesChangeVC.resources_type = @"4-3";
    }else if (curIndex == 2){
        resourcesChangeVC.resources_type = @"4-2";
    }else{
        resourcesChangeVC.resources_type = [NSString stringWithFormat:@"4-%d",curIndex + 1];
    }
    
    resourcesChangeVC.resources_id = model.model.gId;
    resourcesChangeVC.resources_sceneId = @"3";
    [self.navigationController pushViewController:resourcesChangeVC animated:YES];
    
}

#pragma mark - addNavigationLeftButton
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton setImage:[navImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
