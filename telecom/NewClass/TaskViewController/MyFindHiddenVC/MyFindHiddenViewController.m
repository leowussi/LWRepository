//
//  MyFindHiddenViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyFindHiddenViewController.h"
#import "PullTableView.h"
#import "MyFindHiddenTableViewCell.h"
#import "HIddenDetailViewController.h"

@interface MyFindHiddenViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullTableViewDelegate>
{
    PullTableView *myTableView;
    NSMutableArray *dataArr;
    NSString *strName;
    NSString *locationString;
}


@end

static int a = 1;
@implementation MyFindHiddenViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
    if (self.vcTag == 100) {
        [self getData];
    }else{
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我发现的隐患";
    [self addNavigationLeftButton];
    // Do any additional setup after loading the view.
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    [self initView];
}

-(void)initView
{

    
    [self SetSearchBarWithPlachTitle:@"请输入网元/对象或隐患编号"];
   
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(10, 120, kScreenWidth-20, kScreenHeight-64-120)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    myTableView = [[PullTableView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-30, kScreenHeight-64-120) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.pullDelegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.hidden = YES;
    [backview addSubview:myTableView];
  
}
//搜索按钮点击
-(void)searchBtn{
    
    if (strName == nil || strName.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入网元/对象或隐患编号" :@"确定" :nil];
    }else{
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"MyTask/GetDangerInfoList";
    paraDict[@"dangerFlag"] = @"1";
    if (strName==nil) {
        
    }else{
        paraDict[@"inName"] = strName;
    }
        paraDict[@"siteId"] =self.strTaskID;
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
}
-(void)getData
{
    if (self.strTaskID == nil || self.strTaskID.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入网元/对象或隐患编号" :@"确定" :nil];
    }else{
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyTask/GetDangerInfoList";
        paraDict[@"dangerFlag"] = @"1";
        paraDict[@"siteId"] = self.strTaskID;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        
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
}

#pragma mark == 搜索


#pragma mark == UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   dataArr;
    static NSString *myFindIndentifier = @"myFindIndentifierCell";
    MyFindHiddenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myFindIndentifier];
    if (!cell) {
        cell = [[MyFindHiddenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myFindIndentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@  %@",[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"dangerNum"] description],[[dataArr objectAtIndex:indexPath.row] objectForKey:@"dangerCategory"]];
    
       NSString *str= [[dataArr objectAtIndex:indexPath.row] objectForKey:@"nuName"];
    NSString *str1= [[dataArr objectAtIndex:indexPath.row] objectForKey:@"siteName"];
    if (![str isEqualToString:@""]) {
        cell.classLabel.text =str;
    }else{
        cell.classLabel.text = str1;
    }

    
    cell.ztLabel.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"statusName"];
    
    cell.dateLabel.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"commiteTime"];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            hiddenVC.Vctag = @"1";
            [self.navigationController pushViewController:hiddenVC animated:YES];
            
        }else{
            
        }
        
    }, ^(id result) {
        
    });
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    strName = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    strName = textField.text;
    [textField resignFirstResponder];
    textField.text = @"";
    self.vcTag = 1000;
    [self searchBtn];
    return YES;
}

- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(kScreenWidth-130, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (CGSize)contentLabelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(kScreenWidth-130, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

#pragma mark - 上拉


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
    
        if (self.vcTag == 100){
           paraDict[@"siteId"] = self.strTaskID;
        }else{
            paraDict[@"siteId"] = self.strTaskID;
            paraDict[@"dangerNum"] = strName;
        }
    
        paraDict[@"curPage"] = curstr;
    if (strName==nil) {
        
    }else{
        paraDict[@"inName"] = strName;
    }
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
    if (self.vcTag == 100){
            paraDict[@"siteId"] = self.strTaskID;
        }else{
            paraDict[@"siteId"] = self.strTaskID;
            paraDict[@"dangerNum"] = strName;
        }
    
        paraDict[@"curPage"] = curstr;
    
    if (strName==nil) {
    }else{
        paraDict[@"inName"] = strName;
    }
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
