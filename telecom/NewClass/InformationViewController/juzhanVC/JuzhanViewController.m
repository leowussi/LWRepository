//
//  JuzhanViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "JuzhanViewController.h"
#import "JuzhanTableViewCell.h"
#import "JuzhanDetailViewController.h"
#import "PullTableView.h"
@interface JuzhanViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    PullTableView *myTableView;
    NSString *strName;
    NSMutableArray *dataArr;
    UIView *backview;
}

@end
static int a = 1;
@implementation JuzhanViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    self.title = @"局站";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    
    dataArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    [self initView];
}


-(void)initView
{

    UIView *SearchViwe = [self SetsSearchBarWithPlachTitle:@"请输入局站"];
    [self.view addSubview:SearchViwe];
    
    
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：江宁" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.frame=RECT(0, CGRectGetMaxY(SearchViwe.frame)+5, kScreenWidth, 20);
    [self.view addSubview:btn];
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(btn.frame)+5, kScreenWidth-20, kScreenHeight-64-120)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    myTableView = [[PullTableView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-30, kScreenHeight-64-120) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.pullDelegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    if (self.vcTag == 100) {
        dataArr = (NSMutableArray *)self.juzArr;
        myTableView.hidden = NO;
    }else{
        myTableView.hidden = YES;
    }
    
    [backview addSubview:myTableView];
    
}
-(void)btnClick:(UIButton *)btn{
    strName = @"江宁";
    [self searchBtn];
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformScale(btn.transform, 0, 20);
       backview.transform =CGAffineTransformTranslate(backview.transform, 0, -20) ;
    }];
}
#pragma mark == 搜素
-(void)searchBtn
{
    self.vcTag = 10000;
    if (strName == nil || strName.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入局站名称" :@"确定" :nil];
    }else{
     
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetRegionByName";
        paraDict[@"regionName"] = strName;
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
    static NSString *indentifier = @"juidentifier";
    JuzhanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[JuzhanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    //区局
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"district"] description]];
    
    //局站名称
    CGSize with1 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"] description]];
    
    //地址
    CGSize with2 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]];
    
    //主要用途
    CGSize with3 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"usage"] description]];
    
    //X坐标
    CGSize with4 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"gpsx"] description]];
    
    //Y坐标
    CGSize with5 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"gpsy"] description]];
    
    cell.bgV.frame = CGRectMake(0, 10, kScreenWidth-30, with.height+5);
    cell.bgV1.frame = CGRectMake(0, 30+with1.height, kScreenWidth-30, with2.height+5);
    cell.bgV2.frame = CGRectMake(0, 57+with1.height+with2.height+with3.height, kScreenWidth-30, with4.height+5);
    
    cell.leftLable.frame  = CGRectMake(10, 10, 80, 20);
    cell.leftLable1.frame = CGRectMake(10, 15+with.height, 80, 20);
    cell.leftLable2.frame = CGRectMake(10, 35+with1.height, 80, 20);
//    cell.leftLable3.frame = CGRectMake(10, 55+with2.height, 80, 20);
//    cell.leftLable4.frame = CGRectMake(10, 75+with3.height, 80, 20);
//    cell.leftLable5.frame = CGRectMake(10, 95+with4.height, 80, 20);
    
    cell.leftLable3.frame = CGRectMake(10, 47+with1.height+with2.height, 80, with3.height);
    cell.leftLable4.frame = CGRectMake(10, 57+with1.height+with2.height+with3.height, 80, with4.height);
    cell.leftLable5.frame = CGRectMake(10, 67+with1.height+with2.height+with3.height+with4.height, 80, with5.height);
    
    cell.qujuLable.numberOfLines = 0;
    cell.nameLable.numberOfLines = 0;
    cell.addressLable.numberOfLines = 0;
    cell.yongtuLable.numberOfLines = 0;
    cell.XLable.numberOfLines = 0;
    cell.YLable.numberOfLines = 0;
    
    cell.qujuLable.frame = CGRectMake(80, 10, kScreenWidth-120, with.height);
    
    cell.nameLable.frame = CGRectMake(80, 17+with.height, kScreenWidth-120, with1.height);
    cell.addressLable.frame = CGRectMake(80, 37+with1.height, kScreenWidth-120, with2.height);
    cell.yongtuLable.frame = CGRectMake(80, 47+with1.height+with2.height, kScreenWidth-120, with3.height);
    cell.XLable.frame = CGRectMake(80, 57+with1.height+with2.height+with3.height, kScreenWidth-120, with4.height);
    cell.YLable.frame = CGRectMake(80, 67+with1.height+with2.height+with3.height+with4.height, kScreenWidth-120, with5.height);
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"district"] description]isEqualToString:@"<null>"]) {
        cell.qujuLable.text = @"";
    }else{
        cell.qujuLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"district"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"] description]isEqualToString:@"<null>"]) {
        cell.nameLable.text = @"";
    }else{
       cell.nameLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]isEqualToString:@"<null>"]) {
        cell.addressLable.text = @"";
    }else{
       cell.addressLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"usage"] description]isEqualToString:@"<null>"]) {
        cell.yongtuLable.text = @"";
    }else{
        cell.yongtuLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"usage"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"gpsx"] description]isEqualToString:@"<null>"]) {
        cell.XLable.text = @"";
    }else{
       cell.XLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"gpsx"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"gpsy"] description]isEqualToString:@"<null>"]) {
        cell.YLable.text = @"";
    }else{
        cell.YLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"gpsy"] description];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //区局
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"district"] description]];
    
    //局站名称
    CGSize with1 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"] description]];
    
    //地址
    CGSize with2 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]];
    
    //主要用途
    CGSize with3 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"usage"] description]];
    
    //X坐标
    CGSize with4 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"gpsx"] description]];
    
    //Y坐标
    CGSize with5 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"gpsy"] description]];
    return 60+with.height+with1.height+with2.height+with3.height+with4.height+with5.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myRegion/GetRegionById";
    paraDict[@"regionId"] = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionId"] description];
    
    
    httpGET2(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            JuzhanDetailViewController *judVC = [[JuzhanDetailViewController alloc]init];
            judVC.dic = [result objectForKey:@"detail"];
            [self.navigationController pushViewController:judVC animated:YES];
            
        }else{
        }
        
    }, ^(id result) {
        
    });

    
    
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
    paraDict[URL_TYPE] = @"myRegion/GetRegionByName";
    if (self.vcTag == 100) {
        paraDict[@"regionIds"] = self.strID;
    }else{
       paraDict[@"regionName"] = strName;
    }
    
    paraDict[@"curPage"] = str;
    paraDict[@"pageSize"] = @"10";
    
    [dataArr removeAllObjects];
    
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
    paraDict[URL_TYPE] = @"myRegion/GetRegionByName";
//    paraDict[@"regionName"] = strName;
    if (self.vcTag == 100) {
        paraDict[@"regionIds"] = self.strID;
    }else{
        paraDict[@"regionName"] = strName;
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


- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(kScreenWidth-120, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping| NSLineBreakByTruncatingTail];
    return size;
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
