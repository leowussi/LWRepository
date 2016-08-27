//
//  NetworkViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "NetworkViewController.h"
#import "NetWorkTableViewCell.h"
#import "NetworkDetailViewController.h"
#import "PullTableView.h"
#import "HWBProgressHUD.h"
#import "YZResourcesChangeViewController.h"

@interface NetworkViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullTableViewDelegate>
{
    PullTableView *myTableView;
    NSString *strName;
    NSMutableArray *dataArr;
    UIView *backview;
}
@end

static int a = 1;
static int b = 1;
@implementation NetworkViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    self.title = @"网元";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    
    dataArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    [self initView];
}

-(void)initView
{

    UIView *searchView= [self SetsSearchBarWithPlachTitle:@"请输入网元名称"];
    [self.view addSubview:searchView];
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：王港" forState:UIControlStateNormal];
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
    if (self.vcTag == 100) {
        b = 1;
        dataArr = (NSMutableArray *)self.netArr;
        myTableView.hidden = NO;
    }else{
        myTableView.hidden = YES;
    }
    [backview addSubview:myTableView];
    
}
-(void)btnClick:(UIButton *)btn{
    strName = @"王港";
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
        [self showAlertWithTitle:@"提示" :@"请输入网元名称" :@"确定" :nil];
    }else{
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetNuByName";
        paraDict[@"nuName"] = strName;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        httpPOST(paraDict, ^(id result) {
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
    NetWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[NetWorkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"nuName"] description]];
    
    cell.rightLable.numberOfLines = 0;
    [cell.rightLable setFrame:CGRectMake(80, 5, kScreenWidth-120, with.height)];
    
    [cell.leftLable1 setFrame:CGRectMake(10, with.height+5, kScreenWidth-40, 20)];
    [cell.leftLable2 setFrame:CGRectMake(10, with.height+25, kScreenWidth-40, 20)];
    [cell.leftLable3 setFrame:CGRectMake(10, with.height+45, kScreenWidth-40, 20)];
    [cell.leftLable4 setFrame:CGRectMake(10, with.height+65, kScreenWidth-40, 20)];
    [cell.leftLable5 setFrame:CGRectMake(10, with.height+85, kScreenWidth-40, 20)];
    [cell.leftLable6 setFrame:CGRectMake(10, with.height+105, kScreenWidth-40, 20)];
    [cell.leftLable7 setFrame:CGRectMake(10, with.height+125, kScreenWidth-40, 20)];
    [cell.leftLable8 setFrame:CGRectMake(10, with.height+145, kScreenWidth-40, 20)];
    [cell.leftLable9 setFrame:CGRectMake(10, with.height+165, kScreenWidth-40, 20)];
    
    [cell.rightLable1 setFrame:CGRectMake(80, with.height+5,   kScreenWidth-120, 20)];
    [cell.rightLable2 setFrame:CGRectMake(80, with.height+25,  kScreenWidth-120, 20)];
    [cell.rightLable3 setFrame:CGRectMake(80, with.height+45,  kScreenWidth-120, 20)];
    [cell.rightLable4 setFrame:CGRectMake(80, with.height+65,  kScreenWidth-120, 20)];
    [cell.rightLable5 setFrame:CGRectMake(80, with.height+85,  kScreenWidth-120, 20)];
    [cell.rightLable6 setFrame:CGRectMake(80, with.height+105,  kScreenWidth-120, 20)];
    [cell.rightLable7 setFrame:CGRectMake(80, with.height+125,  kScreenWidth-120, 20)];
    [cell.rightLable8 setFrame:CGRectMake(80, with.height+145, kScreenWidth-120, 20)];
    [cell.rightLable9 setFrame:CGRectMake(80, with.height+165, kScreenWidth-120, 20)];
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"nuName"] description]isEqualToString:@"<null>"]) {
        cell.rightLable.text = @"";
    }else{
       cell.rightLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"nuName"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"category"] description]isEqualToString:@"<null>"]) {
        cell.rightLable1.text = @"";
    }else{
       cell.rightLable1.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"category"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"state"] description]isEqualToString:@"<null>"]) {
        cell.rightLable2.text = @"";
    }else{
       cell.rightLable2.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"state"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"manufacturerName"] description]isEqualToString:@"<null>"]) {
        cell.rightLable3.text = @"";
    }else{
        cell.rightLable3.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"manufacturerName"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"onLineTime"] description]isEqualToString:@"<null>"]) {
        cell.rightLable4.text = @"";
    }else{
       cell.rightLable4.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"onLineTime"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"spec"] description]isEqualToString:@"<null>"]) {
        cell.rightLable5.text = @"";
    }else{
       cell.rightLable5.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"spec"] description];
    }
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"roomName"] description]isEqualToString:@"<null>"]) {
        cell.rightLable6.text = @"";
    }else{
        cell.rightLable6.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"roomName"] description];
    }

    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"roomAddress"] description]isEqualToString:@"<null>"]) {
        cell.rightLable7.text = @"";
    }else{
        cell.rightLable7.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"roomAddress"] description];
    }

    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"device"] description]isEqualToString:@"<null>"]) {
        cell.rightLable8.text = @"";
    }else{
        cell.rightLable8.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"device"] description];
    }

    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"version"] description]isEqualToString:@"<null>"]) {
        cell.rightLable9.text = @"";
    }else{
        cell.rightLable9.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"version"] description];
    }
    
    //校正按钮
    cell.jiaoZhengButton.tag = indexPath.row;
    [cell.jiaoZhengButton addTarget:self action:@selector(cellJiaoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//校正按钮被点击
- (void)cellJiaoButtonClicked:(UIButton *)sender
{
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    resourcesChangeVC.resources_id = [[dataArr objectAtIndex:sender.tag] objectForKey:@"nuId"];
    resourcesChangeVC.resources_type = @"2-1";
    resourcesChangeVC.resources_sceneId = @"3";
    [self.navigationController pushViewController:resourcesChangeVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"nuName"] description]];
    return 190+with.height;
}


- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(kScreenWidth-120, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myRegion/GetNuById";
    paraDict[@"nuId"] = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"nuId"] description];
    
    
    httpGET2(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            NetworkDetailViewController *netWorkVC = [[NetworkDetailViewController alloc]init];
            netWorkVC.dictionary = [result objectForKey:@"detail"];
            [self.navigationController pushViewController:netWorkVC animated:YES];
            
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
    if (self.vcTag == 100){
        
        b = 1;
        NSString* str = [NSString stringWithFormat:@"%d",b];
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetNuByName";
        paraDict[@"nuIds"] = self.strID;
        paraDict[@"curPage"] = str;
        paraDict[@"pageSize"] = @"10";
        
        [dataArr removeAllObjects];
        
        httpGET2(paraDict, ^(id result) {
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
        
    }else{
       
        a = 1;
        NSString* str = [NSString stringWithFormat:@"%d",a];
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetNuByName";
        paraDict[@"nuName"] = strName;
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
        
    }
    
    
    myTableView.pullTableIsRefreshing = NO;
}

#pragma mark - 下拉
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

- (void) loadMoreDataToTable
{
//    121.512711,31.293386
    if (self.vcTag == 100){
        b++;
        NSString* str = [NSString stringWithFormat:@"%d",b];
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetNuByName";
        paraDict[@"nuIds"] = self.strID;
        paraDict[@"curPage"] = str;
        paraDict[@"pageSize"] = @"10";
        
//        NSLog(@"%@",self.strID);
        httpGET2(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                
                NSArray *arr = [result objectForKey:@"list"];
                if (arr.count == 0) {
                    b--;
                    HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //弹出框的类型
                    hud.mode = HWBProgressHUDModeText;
                    //弹出框上的文字
                    hud.detailsLabelText = @"没有数据了...";
                    //弹出框的动画效果及时间
                    [hud showAnimated:YES whileExecutingBlock:^{
                        //执行请求，完成
                        sleep(1);
                    } completionBlock:^{
                        //完成后如何操作，让弹出框消失掉
                        [hud removeFromSuperview];
                    }];

                }else{
                    
                }
                [dataArr addObjectsFromArray:arr];
                [myTableView reloadData];
                
            }else{
                myTableView.hidden = YES;
            }
            
        }, ^(id result) {
            
        });
        
    }else{
        
        a++;
        NSString* str = [NSString stringWithFormat:@"%d",a];
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetNuByName";
        paraDict[@"nuName"] = strName;
        paraDict[@"curPage"] = str;
        paraDict[@"pageSize"] = @"10";
        
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                NSArray *arr = [result objectForKey:@"list"];
                if (arr.count == 0) {
                    a--;
                    HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //弹出框的类型
                    hud.mode = HWBProgressHUDModeText;
                    //弹出框上的文字
                    hud.detailsLabelText = @"没有数据了...";
                    //弹出框的动画效果及时间
                    [hud showAnimated:YES whileExecutingBlock:^{
                        //执行请求，完成
                        sleep(1);
                    } completionBlock:^{
                        //完成后如何操作，让弹出框消失掉
                        [hud removeFromSuperview];
                    }];
                }else{
                    
                }
                [dataArr addObjectsFromArray:arr];
                [myTableView reloadData];
                
            }else{
                myTableView.hidden = YES;
            }
            
        }, ^(id result) {
            
        });

        
    }
    
    myTableView.pullTableIsLoadingMore = NO;
}

- (CGSize)labelHight1:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(200, 20000.0f);
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
