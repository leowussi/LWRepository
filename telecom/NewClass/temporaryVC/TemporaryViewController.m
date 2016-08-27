//
//  TemporaryViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "TemporaryViewController.h"
#import "TemporyTableViewCell.h"
#import "PullTableView.h"

@interface TemporaryViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    PullTableView *myTableView;
    NSString *strName;
    NSMutableArray *dataArr;
}
@end

static int a = 1;

@implementation TemporaryViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    self.title = @"临时任务";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    
    if (self.vcTag == 10) {
        dataArr = self.temArr;
        
    }else{
        dataArr = [[NSMutableArray alloc]initWithCapacity:10];
    }
    
    
    [self initView];
}

-(void)initView
{
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectZero];
    rightLable.text = @"      ";
    [rightLable setFont:[UIFont systemFontOfSize:13.0]];
    rightLable.alpha = 0.5;
    [rightLable sizeToFit];
    
    UITextField *seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(30, 80, kScreenWidth-80, 28)];
    seaFiled.backgroundColor = [UIColor whiteColor];
    seaFiled.placeholder = @"请输入任务内容、局站";
    seaFiled.font = [UIFont systemFontOfSize:13.0];
    seaFiled.rightViewMode = UITextFieldViewModeAlways;
    seaFiled.rightView = rightLable;
    seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    seaFiled.layer.borderWidth = 0.6f;
    seaFiled.layer.cornerRadius = 14.0f;
    seaFiled.delegate = self;
    seaFiled.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:seaFiled];
    
    UIImage *btnImg = [UIImage imageNamed:@"2.9.png"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(kScreenWidth-30-btnImg.size.width/2, 80, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(10, 120, kScreenWidth-20, kScreenHeight-64-120)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    
    myTableView = [[PullTableView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-30, kScreenHeight-64-120) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.pullDelegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    [backview addSubview:myTableView];
    
}

#pragma mark == 搜索
-(void)searchBtn
{
    self.vcTag = 100;
    if (strName == nil || strName.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入任务内容、局站" :@"确定" :nil];
    }else{
       
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
        paraDict[@"content"] = strName;
        paraDict[@"taskType"] = @"10";
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                
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


#pragma mark == UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"identifier";
    TemporyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TemporyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CGSize with = [self contentLabelHight:[NSString stringWithFormat:@"%@",[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskContent"] description]]];
    
    cell.taskContent.numberOfLines = 0;
    [cell.taskContent setFrame:CGRectMake(85, 10, kScreenWidth-120, with.height)];
    [cell.View setFrame:CGRectMake(0, 10, kScreenWidth-30, with.height)];
    
    
    [cell.leftLable1 setFrame:CGRectMake(5, with.height+10, 80, 20)];
    
    [cell.View1 setFrame:CGRectMake(0, with.height+30, kScreenWidth-30, 20)];
    
    [cell.leftLable2 setFrame:CGRectMake(5, with.height+30, 90, 20)];
    
    [cell.leftLable3 setFrame:CGRectMake(5, with.height+50, 80, 20)];
    
    [cell.taskAddress setFrame:CGRectMake(85, with.height+10, kScreenWidth-120, 20)];
    
    [cell.taskDate setFrame:CGRectMake(95, with.height+30, kScreenWidth-120, 20)];
    
    [cell.taskPeople setFrame:CGRectMake(85, with.height+50, kScreenWidth-120, 20)];
    
    
    
    cell.taskContent.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskContent"] description];
    
    cell.taskAddress.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description];
    
    cell.taskDate.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"planEndDate"] description];
    
    cell.taskPeople.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"fillerName"] description];
    
    
    return cell;
}


- (CGSize)contentLabelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(kScreenWidth-120, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize with = [self contentLabelHight:[NSString stringWithFormat:@"%@",[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"taskContent"] description]]];
    return 75+with.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (self.vcTag == 10) {
        paraDict[@"regionId"] = self.strSearch;
    }else{
       paraDict[@"content"] = strName;
    }
    
    paraDict[@"taskType"] = @"10";
    paraDict[@"curPage"] = str;
    paraDict[@"pageSize"] = @"10";
    
    httpGET2(paraDict, ^(id result) {
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
//    paraDict[@"content"] = strName;
    if (self.vcTag == 10) {
        paraDict[@"regionId"] = self.strSearch;
    }else{
        paraDict[@"content"] = strName;
    }
    paraDict[@"taskType"] = @"10";
    paraDict[@"curPage"] = str;
    paraDict[@"pageSize"] = @"10";
    
    httpGET2(paraDict, ^(id result) {
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
