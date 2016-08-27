//
//  ZiYuanDetailViewController.m
//  telecom
//
//  Created by liuyong on 16/3/2.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#define kAddressTitleHeight  25
#define kBtnWidth 85


#import "MJExtension.h"
#import "ZiYuanDetailViewController.h"
#import "UIImage+MJ.h"



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
#import "IQKeyboardManager.h"
#import "MBProgressHUD.h"

@interface ZiYuanDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,LQfoceListHeadviewDelegate>
{
    UITableView *_tableView;
    UIImageView *_imageView;
    UIButton *_beforeBtn;
    
    UIView *tabBar;
    UIScrollView *tabScrollView;
    UITextField *seaFiled;
    NSInteger curIndex;
    NSString *temstr;

    NSMutableArray *_focListArray;
    
    //记录区头是否是选中状态的字典
    NSMutableDictionary *_isSelectedDict;
}
@property (nonatomic, strong) NSArray *titles;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *GdjdataArray;
@end

@implementation ZiYuanDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资源信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    _focListArray = [[NSMutableArray alloc] initWithCapacity:0];
    _isSelectedDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self addNavigationLeftButton];
    

    UIView *searchView = [self SetsSearchBarWithPlachTitle:@"请输入设备名称/设备编码"];
    [self.view addSubview:searchView];
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：0LT37" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.frame=RECT(0, CGRectGetMaxY(searchView.frame)+5, kScreenWidth, 20);
    [self.view addSubview:btn];
    
    
    tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+5, SCREEN_W, 30)];
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
#pragma mark - 设置显示数字的小按钮
    [self setNumberBtn];
    
    
    tabScrollView.contentSize = CGSizeMake(self.titles.count*kBtnWidth, 0);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tabBar.frame), SCREEN_W, SCREEN_H-CGRectGetMaxY(tabBar.frame)) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tabBar.frame), SCREEN_W, SCREEN_H-104)];
    _imageView.image = [UIImage imageNamed:@"没数据.png"];
    [self.view addSubview:_imageView];
    _imageView.hidden = YES;
    
    if (self.listGdj.count==0) {//Gdj 0
        if (self.listGjjx.count==0) {//Gjjx 1
            if (self.listGfqx.count==0) {//Gfqx 2
                if (self.listOlt.count==0) {//Olt 3
                    if (self.listObd.count==0) {//Obd 4
                        if (!self.listOnu.count==0) {//Onu 5
                            UIButton *btn = [self.view viewWithTag:99999+5];
                            [self btnTap:btn];
                            tabScrollView.contentOffset = CGPointMake(kBtnWidth*5, 0);
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
    self.GdjdataArray = [NSMutableArray array];
    for (NSDictionary *dict in self.listGdj) {
        GdjModel *model = [[GdjModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.GdjdataArray addObject:model];}
    [self btnTap:[self.view viewWithTag:99999]];
    
}
-(void)btnClick:(UIButton *)btn{
    [self httpSend:@"OLT37"];
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformScale(btn.transform, 0, 20);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [btn removeFromSuperview];
            tabBar.transform = CGAffineTransformTranslate(tabBar.transform, 0, -20);
            _tableView.transform = CGAffineTransformTranslate(_tableView.transform, 0, -20);
        });
    }];
}

-(void)searchBtn:(UITextField *)textField{
    [self httpSend:seaFiled.text];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self httpSend:textField.text];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    temstr = textField.text;
}
-(void)searchBtn{
    [self httpSend:temstr];
}
-(void)httpSend:(NSString *)str{
    if (str.length<5) {
        showAlert(@"请输入至少5个关键字");
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/house/SearchHouseList.json",ADDR_IP,ADDR_DIR];
        paraDict[@"equipName"] = str;
        paraDict[@"accessToken"] = accessToken;
        paraDict[@"operationTime"] = operationTime;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 100.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:requestUrl parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"0000000"]) {
                //                DLog(@"%@",result[@"houseResInfo"]);
                self.listGdj = responseObject[@"listGdj"];
                self.listObd = responseObject[@"listObd"];
                self.listOlt = responseObject[@"listOlt"];
                self.listOnu = responseObject[@"listOnu"];
                self.listGfqx = responseObject[@"listGf"];
                self.listGjjx = responseObject[@"listGj"];
                [self reolData];
                [self.view endEditing:YES];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view endEditing:YES];
            if (error.code == -1001) {
                showAlert(@"请求超时");
            }else{
                showAlert(@"请求失败");
            }
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            if ([[window.subviews lastObject] isKindOfClass:[MBProgressHUD class]]) {
                [[window.subviews lastObject] removeFromSuperview];
            }
        }];
        
        [[IQKeyboardManager sharedManager] resignFirstResponder];
        
        
    }
    
    
}
-(void)reolData{
    
    [self setNumberBtn];
    if (self.listGdj.count>0) {
        [self btnTap:(UIButton *)[self.view viewWithTag:99999]];
        return;
    }
    if (self.listGjjx.count>0) {
        [self btnTap:(UIButton *)[self.view viewWithTag:99999+1]];
        return;
    }
    if (self.listGfqx.count>0) {
        [self btnTap:(UIButton *)[self.view viewWithTag:99999+2]];
        return;
    }
    if (self.listOlt.count>0) {
        [self btnTap:(UIButton *)[self.view viewWithTag:99999+3]];
        return;
    }
    if (self.listObd.count>0) {
        [self btnTap:(UIButton *)[self.view viewWithTag:99999+4]];
        return;
    }
    if (self.listOnu.count>0) {
        [self btnTap:(UIButton *)[self.view viewWithTag:99999+5]];
        return;
    }
    
    
    
}

-(void)setNumberBtn{
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
        //DLog(@"%@,%@,%@,%@,%@,%@",self.listGdj,self.listObd,self.listOlt,self.listOnu,self.listGfqx,self.listGjjx);
        DLog(@"%@",_listGjjx);
        switch (i) {
            case 0:
                [numBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.listGdj.count]   forState:UIControlStateNormal];
                break;
            case 1:
                [numBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.listGjjx.count] forState:UIControlStateNormal];
                break;
            case 2:
                [numBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.listGfqx.count] forState:UIControlStateNormal];
                break;
            case 3:
                [numBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.listOlt.count] forState:UIControlStateNormal];
                break;
            case 4:
                [numBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.listObd.count] forState:UIControlStateNormal];
                break;
            case 5:
                [numBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.listOnu.count] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        
    }
    
}
- (void)rightAction
{
    tabScrollView.contentOffset = CGPointMake(SCREEN_W-25, 0);
}

- (void)btnTap:(UIButton *)btn
{
    _beforeBtn.selected = NO;
    btn.selected = YES;
    _beforeBtn = btn;
    
    NSInteger index = btn.tag-99999;
    if (index != curIndex) {
        [_isSelectedDict removeAllObjects];
        [_focListArray removeAllObjects];
    }
    curIndex = index;
    if (index == 0) {//光端机
        int count = self.listGdj.count;
        if (count==0) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:nil];
        }
        
    }else if (index == 1){
        int count = self.listGjjx.count;
        if (count==0) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:nil];
        }
    }else if (index == 2){
        int count = self.listGfqx.count;
        if (count==0) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:nil];
        }
    }else if (index == 3){
        int count = self.listOlt.count;
        if (count==0) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:nil];
        }
    }else if (index == 4){
        int count = self.listObd.count;
        if (count==0) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:nil];
        }
    }else if (index == 5){
        int count = self.listOnu.count;
        if (count==0) {
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:@"没数据.png"];
            _tableView.hidden = YES;
        }else{
            _imageView.hidden = YES;
            _tableView.hidden = NO;
            [self loadDataWithUrl:nil];
        }
    }else{
        
    }
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"光端机", @"光交接箱", @"光分纤箱", @"OLT",@"OBD", @"ONU"];
    }
    return _titles;
}



- (void)loadDataWithUrl:(NSString *)url
{
    if (curIndex == 0) {//gdj
        [self.GdjdataArray removeAllObjects];
        for (NSDictionary *dict in self.listGdj) {
            GdjModel *model = [[GdjModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.GdjdataArray addObject:model];
        }
        [_tableView reloadData];
    }
    if (curIndex == 1){
        [self.dataArray removeAllObjects];
        NSMutableArray *ayy =[NSMutableArray array];
        for (NSDictionary *dic in self.listGjjx) {
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
        self.dataArray = statusFrameArray;
    }
    if (curIndex == 2){
        [self.dataArray removeAllObjects];
        NSMutableArray *ayy =[NSMutableArray array];
        for (NSDictionary *dic in self.listGfqx) {
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
        self.dataArray = statusFrameArray;
    }
    if (curIndex == 3){
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in self.listOlt) {
            OltModel *model = [[OltModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
    }
    if (curIndex == 4){
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in self.listObd) {
            ObdModel *model = [[ObdModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
    }
    if (curIndex == 5){
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in self.listOnu) {
            OnuModel *model = [[OnuModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
    }
    [_tableView reloadData];
    
}

-(void)HeadViewDidClick{
    [_tableView reloadData];
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
    }else if(curIndex==1||curIndex==2){
        NSArray *array = _focListArray[section];
        return array.count;
//        LQrowHightModel *statusFrame= self.dataArray[section];
//        return !statusFrame.isOpened ? 0 : statusFrame.model.focList.count;
    }else{
        return self.dataArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (curIndex==1||curIndex==2) {
//        LQrowHightModel *statusFrame= self.dataArray[section];
//        return statusFrame.model.focList.count == 0 ? statusFrame.HeaderViewHight - 30 : statusFrame.HeaderViewHight;
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
        LQrowHightModel *model = self.dataArray[indexPath.section];
        LQFoceList *liFoceList = [[LQFoceList alloc]init];
        liFoceList.model  =  model.model.focList[indexPath.row];
        return liFoceList.rowHihgt;
    }else if (curIndex == 2){//gfqx
        LQrowHightModel *model = self.dataArray[indexPath.section];
        LQFoceList *liFoceList = [[LQFoceList alloc]init];
        liFoceList.model  =  model.model.focList[indexPath.row];
        return liFoceList.rowHihgt;
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
        head.delegate= self;
        head.model =self.dataArray[section];
        head.jiaoZhengButton.tag = section;
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
#pragma mark -- 区头被点击
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
        //        PglModel *pgModel = model.model.focList[indexPath.row];
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
        cell.jiaoZhengButton.tag = indexPath.row;
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
    
    resourcesChangeVC.resources_type = [NSString stringWithFormat:@"4-%d",curIndex + 1];
    
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
