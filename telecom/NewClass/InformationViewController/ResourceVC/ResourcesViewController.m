//
//  ResourcesViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "ResourcesViewController.h"
#import "Resource.h"
#import "ResourceGroup.h"
#import "MyResourceHeaderView.h"
#import "ResourceTableViewCell.h"
#import "QrReadView.h"
#import "PullTableView.h"
#import "YZResourcesChangeViewController.h"
#import "YZResourcesChangeSearchViewController.h"

@interface ResourcesViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    PullTableView *myTableView;
    NSString* m_qrCode;
    NSString *strName;
    NSMutableArray *dataArray;
    BOOL isOpen;
    BOOL isOpen1;
    UIView *backview;
    NSInteger scanfTag;
}


@end

static int a = 1;

@implementation ResourcesViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    [self addNavigationRightButton:@"jf1"];
    self.title = @"交换资源";
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    
    dataArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    isOpen=NO;
    isOpen1=NO;
    
    [self initView];
    
}

-(void)initView
{
    UIView *searchView= [self SetsSearchBarWithPlachTitle:@"请输入局名/局号"];
    [self.view addSubview:searchView];
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：5660" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.frame=RECT(0, CGRectGetMaxY(searchView.frame)+5, kScreenWidth, 20);
    [self.view addSubview:btn];
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(btn.frame)+5, kScreenWidth-20, kScreenHeight-64-120)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];

    
    myTableView = [[PullTableView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-30, kScreenHeight-64-120) style:UITableViewStyleGrouped];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.pullDelegate = self;
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    [backview addSubview:myTableView];

    [self setExtraCellLineHidden:myTableView];
    
}
-(void)btnClick:(UIButton *)btn{
    strName = @"5660";
    [self searchBtn];
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformScale(btn.transform, 0, 20);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [btn removeFromSuperview];
        });
        backview.transform =CGAffineTransformTranslate(backview.transform, 0, -20) ;
    }];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark == 搜素
-(void)loadDataWithSearchCondition:(NSString *)searchCondition
{
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetExchangeByName";
        paraDict[@"name"] = searchCondition;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        httpPOST(paraDict, ^(id result) {
            NSLog(@"++++%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                NSArray *tempArray = [result objectForKey:@"list"];
                for (NSDictionary *dict in tempArray) {
                    ResourceGroup *headGoup=[[ResourceGroup  alloc]init];
                    headGoup.isExp= NO;
                    headGoup.roomName = [dict objectForKey:@"roomName"];
                    headGoup.dataArray = [dict objectForKey:@"slots"];
                    headGoup.shelfNumber = [dict objectForKey:@"shelfNumber"];
                    headGoup.rackNumber = [dict objectForKey:@"rackNumber"];
                    headGoup.rackId = [dict objectForKey:@"siteNumber"];
                    headGoup.rack_id = [dict objectForKey:@"rackId"];
                    [dataArray addObject:headGoup];
                }
                myTableView.hidden = NO;
                [myTableView reloadData];
            }else{
                myTableView.hidden = YES;
            }
        }, ^(id result) {
        });
}


#pragma mark == 搜素
-(void)searchBtn
{
    scanfTag = 100;
    if (strName == nil || strName.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入交换资源名称/局号" :@"确定" :nil];
    }else{
     
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetExchangeByName";
        paraDict[@"name"] = strName;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        httpPOST(paraDict, ^(id result) {
            NSLog(@"--->>>%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                
                NSArray *tempArray = [result objectForKey:@"list"];
                for (NSDictionary *dict in tempArray) {
                    ResourceGroup *headGoup=[[ResourceGroup  alloc]init];
                    headGoup.isExp= NO;
                    headGoup.roomName = [dict objectForKey:@"roomName"];
                    headGoup.dataArray = [dict objectForKey:@"slots"];
                    headGoup.shelfNumber = [dict objectForKey:@"shelfNumber"];
                    headGoup.rackNumber = [dict objectForKey:@"rackNumber"];
                    headGoup.rackId = [dict objectForKey:@"siteNumber"];
                    headGoup.rack_id = [dict objectForKey:@"rackId"];
                    [dataArray addObject:headGoup];
                }
                
                
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

#pragma mark == 扫描
-(void)rightAction
{
    if ([QrReadView checkCamera]) {
        QrReadView* vc = [[QrReadView alloc] init];
        vc.respBlock = ^(NSString* v) {
            m_qrCode = [v copy];
            mainThread(openRoomDetailInfo:, m_qrCode);
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)openRoomDetailInfo:(NSString*)qrCode
{
    scanfTag = 1000;
    if (qrCode == nil || qrCode.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"扫不到二维码中的信息" :@"确定" :nil];
    }else{
        
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetExchangeByName";
        paraDict[@"assertNo"] = qrCode;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        NSLog(@"%@",paraDict);
        
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                
                NSArray *tempArray = [result objectForKey:@"list"];
                for (NSDictionary *dict in tempArray) {
                    ResourceGroup *headGoup=[[ResourceGroup  alloc]init];
                    headGoup.isExp= NO;
                    headGoup.roomName = [dict objectForKey:@"roomName"];
                    headGoup.dataArray = [dict objectForKey:@"slots"];
                    headGoup.shelfNumber = [dict objectForKey:@"shelfNumber"];
                    headGoup.rackNumber = [dict objectForKey:@"rackNumber"];
                    headGoup.rackId = [dict objectForKey:@"rackId"];
                    headGoup.rack_id = [dict objectForKey:@"rackId"];
                    [dataArray addObject:headGoup];
                }
                
                
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ResourceGroup *group=[dataArray objectAtIndex:section];
    return group.isExp?group.dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Resourcecell";
    
    ResourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ResourceTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ResourceGroup *group=[dataArray objectAtIndex:indexPath.section];
    NSDictionary *dic=[group.dataArray objectAtIndex:indexPath.row];
    
    cell.jicaoLable.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"slotNumber"]];;
    cell.zicaoLable.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"subSlot"]];;
    cell.ztLable.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"slotState"]];
    cell.classLable.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"boardType"]];
    cell.xinghaoLable.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"boardMinorType"]];
    
    //校正按钮
    cell.jiaoZhengButton.buttonIndexPath = indexPath;
    [cell.jiaoZhengButton addTarget:self action:@selector(cellJiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyResourceHeaderView *headv=[[MyResourceHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headv.backgroundColor = RGBCOLOR(16, 219, 232);
    ResourceGroup *group=[dataArray objectAtIndex:section];
    headv.label1.text = [NSString stringWithFormat:@"%@(%@)",group.roomName,group.rackId];
    
    headv.label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    headv.label2.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    headv.label3.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    
    headv.label2.text = [NSString stringWithFormat:@"正面  机框 : %@",group.shelfNumber];
    headv.label3.text = [NSString stringWithFormat:@"机架 : %@",group.rackNumber];
    
    headv.jiaoZhengButton.tag = 200 + section;
    [headv.jiaoZhengButton addTarget:self
                              action:@selector(headerJiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    headv.bgBtn.tag=200+section;
    [headv.bgBtn addTarget:self action:@selector(expButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return headv;

}
#pragma mark -- 资源校正按钮
//header校正按钮
- (void)headerJiaoZhengButtonClicked:(UIButton *)sender
{
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    ResourceGroup *group = dataArray[sender.tag - 200];
    resourcesChangeVC.resources_id = group.rack_id;
    resourcesChangeVC.resources_type = @"1-1";
    resourcesChangeVC.resources_sceneId = @"3";
    [self.navigationController pushViewController:resourcesChangeVC animated:YES];
}
//cell校正按钮
- (void)cellJiaoZhengButtonClicked:(YZJiaoZhengButtom *)sender
{
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    ResourceGroup *group=[dataArray objectAtIndex:sender.buttonIndexPath.section];
    NSDictionary *dic=[group.dataArray objectAtIndex:sender.buttonIndexPath.row];
    resourcesChangeVC.resources_id = [dic objectForKey:@"slotId"];
    resourcesChangeVC.resources_type = @"1-2";
    resourcesChangeVC.resources_sceneId = @"3";
    [self.navigationController pushViewController:resourcesChangeVC animated:YES];
}

-(void)expButtonAction:(UIButton*)btn
{
    ResourceGroup *group=[dataArray objectAtIndex:btn.tag-200];
    if (group.isExp) {
        group.isExp=NO;
        
    }else
    {
        group.isExp=YES;
    }
    
    [myTableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    ViewController *viewController = [[ViewController alloc] init];
    //    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)clickHeadView
{
    [myTableView reloadData];
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
    
    [dataArray removeAllObjects];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myRegion/GetExchangeByName";
    paraDict[@"name"] = strName;
    paraDict[@"curPage"] = str;
    paraDict[@"pageSize"] = @"10";
    
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            
            NSArray *tempArray = [result objectForKey:@"list"];
            for (NSDictionary *dict in tempArray) {
                ResourceGroup *headGoup=[[ResourceGroup  alloc]init];
                headGoup.isExp= NO;
                headGoup.roomName = [dict objectForKey:@"roomName"];
                headGoup.dataArray = [dict objectForKey:@"slots"];
                headGoup.shelfNumber = [dict objectForKey:@"shelfNumber"];
                headGoup.rackNumber = [dict objectForKey:@"rackNumber"];
                headGoup.rackId = [dict objectForKey:@"siteNumber"];
                [dataArray addObject:headGoup];
            }
            
            
            myTableView.hidden = NO;
            [myTableView reloadData];
            
        }else{
            myTableView.hidden = YES;
        }
        
    }, ^(id result) {
        
    });
    myTableView.pullTableIsLoadingMore = NO;

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
    paraDict[URL_TYPE] = @"myRegion/GetExchangeByName";
    paraDict[@"name"] = strName;
    paraDict[@"curPage"] = str;
    paraDict[@"pageSize"] = @"10";
    
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            
            NSArray *tempArray = [result objectForKey:@"list"];
            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:10];
            
            for (NSDictionary *dict in tempArray) {
                ResourceGroup *headGoup=[[ResourceGroup  alloc]init];
                headGoup.isExp= NO;
                headGoup.roomName = [dict objectForKey:@"roomName"];
                headGoup.dataArray = [dict objectForKey:@"slots"];
                headGoup.shelfNumber = [dict objectForKey:@"shelfNumber"];
                headGoup.rackNumber = [dict objectForKey:@"rackNumber"];
                headGoup.rackId = [dict objectForKey:@"siteNumber"];
                [arr addObject:headGoup];
                
            }
            [dataArray addObjectsFromArray:arr];
            
            myTableView.hidden = NO;
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
