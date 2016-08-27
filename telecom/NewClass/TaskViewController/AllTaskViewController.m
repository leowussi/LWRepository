//
//  AllTaskViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AllTaskViewController.h"
#import "AllTaskTableViewCell.h"
#import "PullTableView.h"
#import "UILabel+caculateSize.h"
#import "MyTaskListViewController.h"

#import "TemporaryViewController.h"
#import "NetworkDetailViewController.h"
#import "RoomDetailViewController.h"
#import "JuzhanDetailViewController.h"
#import "MyBookingSGRWController.h"

@interface AllTaskViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullTableViewDelegate>
{
    PullTableView *myTableView;
    NSMutableArray *dataArr;
    NSString *strName;
    NSString *locationString;
    UIView *backview;
}
@end

static int a = 1;
@implementation AllTaskViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    self.title = @"所有任务";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    
    dataArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    locationString = [dateformatter stringFromDate:senddate];
    
    
    [self initView];
}

-(void)initView
{
    
    UIView *searchView = [self SetsSearchBarWithPlachTitle:@"请输入任务内容、局站"];
    [self.view addSubview:searchView];
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：金生" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.frame=RECT(0, CGRectGetMaxY(searchView.frame)+5, kScreenWidth, 20);
    [self.view addSubview:btn];

    
    backview = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(btn.frame)+5, kScreenWidth-20, kScreenHeight-64-120)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    myTableView = [[PullTableView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-30, kScreenHeight-64-120) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.pullDelegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.hidden = YES;
    [backview addSubview:myTableView];
    
    if (self.vcTag == 100) {
        dataArr = (NSMutableArray *)self.allArr;
        myTableView.hidden = NO;
        [myTableView reloadData];
    }else{
        
    }

    
}
-(void)btnClick:(UIButton *)btn{
    strName = @"金生";
    [self searchBtn];
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformScale(btn.transform, 0, 20);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [btn removeFromSuperview];
        });
        backview.transform =CGAffineTransformTranslate(backview.transform, 0, -20) ;
    }];
}
#pragma mark == 搜索
-(void)searchBtn
{
    self.vcTag = 1000;
    if (strName == nil || strName.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入任务内容、局站" :@"确定" :nil];
    }else{
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
        paraDict[@"content"] = strName;
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

#pragma mark == UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
//    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allIndentifier = @"allidentifier";
    AllTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allIndentifier];
    if (!cell) {
        cell = [[AllTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allIndentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    CGSize with = [self labelHight:[NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskContent"]]];
    
    CGSize with1 = [self labelHight:[NSString stringWithFormat:@"%@ :",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskTypeName"]]];
    
    CGSize contentWith = [self contentLabelHight:[NSString stringWithFormat:@"%@  %@  %@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionAddress"],[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"],[[dataArr objectAtIndex:indexPath.row] objectForKey:@"fillerName"]]];
    
    cell.nameLable.numberOfLines = 0;
    [cell.nameLable setFrame:CGRectMake(with1.width+20, 5, kScreenWidth-130, with.height)];
    
    cell.contentLable.numberOfLines = 0;
    [cell.contentLable setFrame:CGRectMake(10, with.height+10, kScreenWidth-150, contentWith.height)];
    
    [cell.dateLable setFrame:CGRectMake(kScreenWidth-130, with.height+10, kScreenWidth-40, 20)];
    
    cell.titleLable.text = [NSString stringWithFormat:@"%@ :",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskTypeName"]];
    
    cell.nameLable.text = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskContent"]];
    
    cell.contentLable.text = [NSString stringWithFormat:@"%@  %@  %@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionAddress"],[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"],[[dataArr objectAtIndex:indexPath.row] objectForKey:@"fillerName"]];
    
    cell.dateLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"planStartDate"] description];
    

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 60;
//    AllTaskTableViewCell *cell = [self tableView:myTableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    CGSize with = [self labelHight:[NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskContent"]]];
    CGSize contentWith = [self contentLabelHight:[NSString stringWithFormat:@"%@  %@  %@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionAddress"],[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"],[[dataArr objectAtIndex:indexPath.row] objectForKey:@"fillerName"]]];
    
    return 20+with.height+contentWith.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    1 周期工作   2故障       3预约       4隐患     5局站  6机房  7网元
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskType"] description]isEqualToString:@"1"]) {
        
//        MyWorkViewController *ctrl = [[MyWorkViewController alloc] init];
//        [self.navigationController pushViewController:ctrl animated:YES];
        NSDictionary *paraDict = [dataArr objectAtIndex:indexPath.row];
        MyTaskListViewController *taskVC = [[MyTaskListViewController alloc] init];
        
        taskVC.taskTag = 100;
        taskVC.planDate = date2str(self.date, DATE_FORMAT);
        taskVC.site = paraDict;
        [self.navigationController pushViewController:taskVC animated:YES];
        
    }else if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskType"] description]isEqualToString:@"2"]) {
        
        DoNothingViewController *ctrl = [[DoNothingViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }else if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskType"] description]isEqualToString:@"3"]) {
        
        MyBookingSGRWController *ctrl = [[MyBookingSGRWController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }else if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskType"] description]isEqualToString:@"4"]) {
        
        DoNothingViewController *ctrl = [[DoNothingViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }else if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskType"] description]isEqualToString:@"5"]) {
        
        DoNothingViewController *ctrl = [[DoNothingViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
        
    }else if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskType"] description]isEqualToString:@"6"]) {
        
        DoNothingViewController *ctrl = [[DoNothingViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }else if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskType"] description]isEqualToString:@"7"]) {
        
        DoNothingViewController *ctrl = [[DoNothingViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];

    }else if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskType"] description]isEqualToString:@"10"]) {
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
        paraDict[@"regionId"] = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionId"] description];
        paraDict[@"taskType"] = @"10";
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        NSLog(@"%@",paraDict);
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                
                TemporaryViewController *temVC = [[TemporaryViewController alloc]init];
                temVC.temArr = [result objectForKey:@"list"];
                temVC.vcTag = 10;
                temVC.strSearch = [NSString stringWithFormat:@"%@",[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionId"] description]];
                
                [self.navigationController pushViewController:temVC animated:YES];

                
            }else{
                
            }
            
        }, ^(id result) {
            
        });

        
    }
    
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
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void) refreshTable
{
    a = 1;
    NSString* str = [NSString stringWithFormat:@"%d",a];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
    
    if (self.vcTag == 100){
        paraDict[@"regionId"] = self.strID;
        paraDict[@"taskType"] = self.strType;
    }else{
       paraDict[@"content"] = strName;
    }

    
    paraDict[@"curPage"] = str;
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
    NSString* str = [NSString stringWithFormat:@"%d",a];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
    if (self.vcTag == 100){
        paraDict[@"regionId"] = self.strID;
        paraDict[@"taskType"] = self.strType;
    }else{
        paraDict[@"content"] = strName;
    }
    paraDict[@"curPage"] = str;
    paraDict[@"pageSize"] = @"10";
    
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            NSArray *arr = [result objectForKey:@"list"];
            [dataArr addObjectsFromArray:arr];
            [myTableView reloadData];
            
        }else{
            myTableView.hidden = YES;
        }
        
    }, ^(id result) {
        
    });
    
    myTableView.pullTableIsLoadingMore = NO;
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
