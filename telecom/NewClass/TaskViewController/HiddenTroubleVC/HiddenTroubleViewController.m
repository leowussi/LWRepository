//
//  HiddenTroubleViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "HiddenTroubleViewController.h"
#import "HiddenTableViewCell.h"
#import "HIddenDetailViewController.h"
#import "MathTroubleViewController.h"
#import "PullTableView.h"
#import "ShaiXuanViewController.h"

static int a = 1;
@interface HiddenTroubleViewController ()<PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    PullTableView *myTableView;
    NSMutableArray *dataArr;
    NSString *str;
    
}
@property(nonatomic,strong)NSMutableArray *array1;
@end

@implementation HiddenTroubleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
    [self getDataWith:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐患处理清单";
    [self addNavigationLeftButton];
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    dataArr = [[NSMutableArray alloc]initWithCapacity:10];
    [self initView];
}

-(void)initView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 120, kScreenWidth-20, kScreenHeight-64-120)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIImage* filterimage = [UIImage imageNamed:@"shaixuan.png"];
    UIButton* filter = [[UIButton alloc] initWithFrame:RECT((APP_W-10-30), (NAV_H-30)/2, 30, 30)];
    [filter setBackgroundImage:filterimage forState:0];
    [filter addTarget:self action:@selector(onFilterBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem1 = [[UIBarButtonItem alloc] initWithCustomView:filter];
    self.navigationItem.rightBarButtonItem=barBtnItem1;
    
    
    [self SetSearchBarWithPlachTitle:@"请输入网元/站点/隐患编号"];
    
    
    myTableView = [[PullTableView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-30, kScreenHeight-64-120) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.pullDelegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.hidden = YES;
    [self setExtraCellLineHidden:myTableView];
    [bgView addSubview:myTableView];
}
#pragma mark 筛选按钮
-(void)onFilterBtnTouched{
    [self httpSend];
}
-(void)httpSend{
    self.array1 = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[URL_TYPE] =@"MyTask/GetDangerDictionaries";
    __weak typeof(self) WeakSelf = self;
    httpGET1(dic, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            [WeakSelf.array1 addObject:result[@"deptList"]];
            [WeakSelf.array1 addObject:result[@"specList"]];
            [WeakSelf.array1 addObject:result[@"categroyList"]];
            [WeakSelf.array1 addObject:result[@"levelList"]];
            [WeakSelf.array1 addObject:result[@"statusList"]];
            
            ShaiXuanViewController *vc = [[ShaiXuanViewController alloc]init];
            vc.arr = WeakSelf.array1;
            DLog(@"%@",WeakSelf.array1);
            vc.ShaiXuan = ^{
                [WeakSelf getDataWith:nil];
            };
            [WeakSelf.navigationController pushViewController:vc animated:YES];
            
        }
    });
    
    
}

#pragma mark 搜索按钮点击
-(void)searchBtn{
    [super searchBtn];
    [self getDataWith:str];
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
////    str=textField.text;
//    return YES;
//}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    str=textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self getDataWith:textField.text];
    return YES;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(void)getDataWith:(NSString *)str
{   [self.view endEditing:YES];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"MyTask/GetDangerInfoList";
    paraDict[@"dangerFlag"] = @"0";
    if (str==nil) {
        
    }else{
        paraDict[@"inName"] = str;
    }
    paraDict[@"inParam"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"YinHuanShaiXuan"];
    DLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            [dataArr removeAllObjects];
            dataArr = [result objectForKey:@"list"];
            myTableView.hidden = NO;
            [myTableView reloadData];
            
        }else{
            myTableView.hidden = YES;
        }
        
    }, ^(id result) {
        
    });
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HiddenTableViewCell *cell = [HiddenTableViewCell table:tableView];
    
    cell.dict=dataArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        NSLog(@"%@",dataArr);
        NSString *riskId = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"riskId"] description];
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyTask/GetDangerDetailInfo";
        paraDict[@"dangerId"] = riskId;
    
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                HIddenDetailViewController *hiddenVC = [[HIddenDetailViewController alloc]init];
                hiddenVC.dic = result;
                hiddenVC.strDangerId = riskId;
                [self.navigationController pushViewController:hiddenVC animated:YES];
    
            }else{
    
            }
    
        }, ^(id result) {
    
        });
//    SoureSearchController *vc = [[SoureSearchController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
#pragma mark - 上拉
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void) refreshTable
{
    a = 1;
    NSString* curstr = [NSString stringWithFormat:@"%d",a];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"curPage"] = curstr;
    paraDict[@"pageSize"] = @"10";
    paraDict[URL_TYPE] = @"MyTask/GetDangerInfoList";
    paraDict[@"dangerFlag"] = @"0";
    if (str==nil) {
        
    }else{
        paraDict[@"inName"] = str;
    }
    paraDict[@"inParam"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"YinHuanShaiXuan"];
    DLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            [dataArr removeAllObjects];
            dataArr = [result objectForKey:@"list"];
            myTableView.hidden = NO;
            [myTableView reloadData];
            
        }else{
            myTableView.hidden = YES;
        }
        
    }, ^(id result) {
        
    });
    myTableView.pullTableIsRefreshing = NO;
}

#pragma mark - 下拉
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

- (void) loadMoreDataToTable
{
    a++;
    NSString* curstr = [NSString stringWithFormat:@"%d",a];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"curPage"] = curstr;
    paraDict[@"pageSize"] = @"10";
    paraDict[URL_TYPE] = @"MyTask/GetDangerInfoList";
    paraDict[@"dangerFlag"] = @"0";
    if (str==nil) {
    }else{
        paraDict[@"inName"] = str;
    }
    paraDict[@"inParam"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"YinHuanShaiXuan"];
    DLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            NSArray *arr = [result objectForKey:@"list"];
            [dataArr addObjectsFromArray:arr];
            myTableView.hidden = NO;
            [myTableView reloadData];
            
        }else{
            myTableView.hidden = YES;
        }
        
    }, ^(id result) {
        
    });
    myTableView.pullTableIsLoadingMore = NO;
    
}

@end
