//
//  JianSuoViewController.m
//  telecom
//
//  Created by Sundear on 16/3/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "JianSuoViewController.h"
#import "HeadView.h"
#import "OpenModel.h"
#import "AddressModel.h"
#import "MJRefresh.h"
#import "ZiYuanDetailViewController.h"
#import "ResourceModel.h"
#import "ResourceDetailController.h"

@interface JianSuoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,HeadViewDelegate,MJRefreshBaseViewDelegate>{
    UITableView *tabview;
}
@property(nonatomic,strong)NSMutableArray *resArray;
@property(nonatomic,strong)MJRefreshFooterView *footerview;
@property(nonatomic,strong)UITextField *searchField ;
@end

@implementation JianSuoViewController
-(NSMutableArray *)resArray{
    if (_resArray==nil) {
        _resArray  = [NSMutableArray array];
    }
    return _resArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    [self addNavigationRightButton:@"头像.png"];
    [self setUpSearchBar:@"输入地址点"];
    [self setupTabview];
}

-(void)setUpSearchBar:(NSString *)string{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-125, searchImg.size.height/3+5)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.placeholder = @"输入地址";
    searchField.textColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.enablesReturnKeyAutomatically = YES;
    searchField.font = [UIFont systemFontOfSize:15.0];
    [searchField becomeFirstResponder];
    self.searchField = searchField;
    [searchImgView addSubview:searchField];
    
    self.navigationItem.titleView = searchImgView;
    
    
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length<=0) {
        showAlert(@"请输入地址点进行搜索");
    }else{
        [self searchWithStrt:self.searchField.text];
    }
    return YES;
}
-(void)searchWithStrt:(NSString *)string{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"house/GetGridAddrList" forKey:URL_TYPE];
    [dic setObject:string forKey:@"address"];
    dic[@"curPage"] = @"1";
    dic[@"pageSize"] = @"10";
    httpPOST2(dic, ^(id result) {
        if ([result[@"result"]isEqualToString:@"0000000"]) {
            DLog(@"%@",result[@"list"]);
            [self.resArray removeAllObjects];
            for (NSDictionary *dic in result[@"list"]) {
                OpenModel *model = [OpenModel OpenModelWithDict:dic];
                [self.resArray addObject:model];
                DLog(@"%@",self.resArray);
            }
            [tabview reloadData];
        }
        
    }, ^(id result) {
        
    });

}
static int i =1;
-(void)loadDataWithstr:(NSString *)string{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"house/GetGridAddrList" forKey:URL_TYPE];
    [dic setObject:string forKey:@"address"];
    i++;
    dic[@"curPage"] = [NSString stringWithFormat:@"%d",i];
    dic[@"pageSize"] = @"10";
    httpGET2(dic, ^(id result) {
        if ([result[@"result"]isEqualToString:@"0000000"]) {
//            [self.resArray removeAllObjects];
            [self.footerview endRefreshing];
            for (NSDictionary *dic in result[@"list"]) {
                OpenModel *model = [OpenModel OpenModelWithDict:dic];
                [self.resArray addObject:model];
                DLog(@"%@",self.resArray);
            }
            [tabview reloadData];
        }
        
    }, ^(id result) {
        i--;
        [self.footerview endRefreshing];
    });

}
-(void)dealloc{
    tabview =nil;
    i=1;
    [self.footerview free];
    self.footerview =nil;
}
-(void)rightAction{
    i=1;
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.menuController showRightController:YES];
}
-(void)leftAction{
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super leftAction];
    });
    
}
#pragma mark 添加tabview
-(void)setupTabview{
    tabview= [[UITableView alloc]initWithFrame:RECT(10, 64, kScreenWidth-20, kScreenHeight-64) style:UITableViewStylePlain];
    tabview.delegate =self;
    tabview.dataSource = self;
    tabview.rowHeight = 40;
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：东大名路" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.frame=RECT(0, 5, tabview.width, 20);
    [tabview addSubview:btn];
    
    tabview.sectionHeaderHeight = 44;
    tabview.sectionFooterHeight = 0;
    tabview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tabview];
    
    self.footerview = [[MJRefreshFooterView alloc]init];
    self.footerview.delegate = self;
    self.footerview.scrollView = tabview;

}
-(void)btnClick:(UIButton *)butn{
    butn.transform = CGAffineTransformScale(butn.transform, 0, 20);
    [self searchWithStrt:@"东大名路"];
    
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadDataWithstr:self.searchField.text];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OpenModel *OpenModel = self.resArray[section];
    return   !OpenModel.isOpened ?  0 : OpenModel.addressList.count;//
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *ID = @"jiansuo";
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"p2.jpg"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    OpenModel *model = self.resArray[indexPath.section];
    AddressModel *mo =model.addressList[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = mo.address;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeadView *tab = [HeadView headViewWithTableView:tabview];
    tab.delegate = self;
    tab.friendGroup = self.resArray[section];
    return tab;
}
- (void)clickHeadView
{
    [tabview reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OpenModel *open = self.resArray[indexPath.section];
    AddressModel *address =  open.addressList[indexPath.row];
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    
//    par[URL_TYPE] = @"house/SearchHouseList";
    par[@"lane"] = address.lane;
    par[@"gate"] = address.gate;
    par[@"road"] = address.road;
    par[@"accessToken"]=UGET(U_TOKEN);
    par[@"opreatinTime"]=date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //修改
    NSString *url = [NSString stringWithFormat:@"http://%@/%@/house/GetAddressCount.json",ADDR_IP,ADDR_DIR];
    [manager POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"0000000"]) {
            ResourceModel *model = [[ResourceModel alloc] init];
            [model setValuesForKeysWithDictionary:[responseObject objectForKey:@"detail"]];
            ResourceDetailController *resourceDetailCtrl = [[ResourceDetailController alloc] init];
            resourceDetailCtrl.road = address.road;
            resourceDetailCtrl.gate = address.gate;
            resourceDetailCtrl.lane = address.lane;
            
            resourceDetailCtrl.singleModel = model;
            [self.navigationController pushViewController:resourceDetailCtrl animated:YES];
        }else{
            [self showAlertWithTitle:@"提示" :[responseObject objectForKey:@"error"] :@"确定" :nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    /*
    NSString *url = [NSString stringWithFormat:@"http://%@/%@/house/SearchHouseList.json",ADDR_IP,ADDR_DIR];
    [manager POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {

            ZiYuanDetailViewController *detailVc = [[ZiYuanDetailViewController alloc]init];
            detailVc.listGdj = responseObject[@"listGdj"];
            detailVc.listObd =responseObject[@"listObd"];
            detailVc.listOlt =responseObject[@"listOlt"];
            detailVc.listOnu =responseObject[@"listOnu"];
            detailVc.listGfqx =responseObject[@"listGf"];
            detailVc.listGjjx =responseObject[@"listGj"];
            [self.view endEditing:YES];
            [self.navigationController pushViewController:detailVc animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        showAlert(@"请求失败");
    }];
   */
}

@end
