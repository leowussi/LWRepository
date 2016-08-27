//
//  RoomViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "RoomViewController.h"
#import "RoomTableViewCell.h"
#import "PullTableView.h"
#import "QrReadView.h"
#import "RoomDetailViewController.h"

@interface RoomViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullTableViewDelegate>
{
    PullTableView *myTableView;
    NSString *m_qrCode;
    NSString *strName;
    NSMutableArray *dataArr;
    NSInteger scanfTag;
    UIView *backview;
}

@end

static int a = 1;
@implementation RoomViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    // Do any additional setup after loading the view.
    [self addNavigationRightButton:@"jf1"];
    self.title = @"机房";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    
    dataArr = [[NSMutableArray alloc]initWithCapacity:10];

    [self initView];
}

-(void)initView
{
  
    
     UIView *searchView= [self SetsSearchBarWithPlachTitle:@"请输入机房名称"];
    [self.view addSubview:searchView];
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：古北" forState:UIControlStateNormal];
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
    if (self.vcTag == 100) {
        dataArr = (NSMutableArray *)self.roomArr;
        myTableView.hidden = NO;
    }else{
        myTableView.hidden = YES;
    }
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    [backview addSubview:myTableView];
    
}
-(void)btnClick:(UIButton *)btn{
    strName = @"古北";
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
    scanfTag = 100;
    if (strName == nil || strName.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入局站名称" :@"确定" :nil];
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetRoomByName";
        paraDict[@"roomName"] = strName;
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
#pragma mark == 扫描
-(void)rightAction
{
    
    if ([QrReadView checkCamera]) {
        QrReadView* vc = [[QrReadView alloc] init];
        vc.respBlock = ^(NSString* v) {
            m_qrCode = [v copy];
            mainThread(openRoomDetailInfo:, m_qrCode);
            NSLog(@"%@",m_qrCode);
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)openRoomDetailInfo:(NSString*)qrCode
{
    scanfTag = 1000;
    self.vcTag = 10000;
    if (qrCode == nil || qrCode.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"扫不到二维码中的信息" :@"确定" :nil];
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myRegion/GetRoomByName";
        paraDict[@"roomIds"] = qrCode;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        NSLog(@"%@",paraDict);
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


#pragma mark == UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"identifier";
    RoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[RoomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    
    //区局
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"district"] description]];
    
    //局站名称
    CGSize with1 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"] description]];
    
    //机房名称
    CGSize with2 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"roomName"] description]];
    
    //楼层
    CGSize with3 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"floor"] description]];
    
    //专业
    CGSize with4 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"usage"] description]];
    
    //机房状态
    CGSize with5 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"state"] description]];
    
    
    cell.leftLable.frame  = CGRectMake(10, 10, 80, 20);
    cell.leftLable1.frame = CGRectMake(10, 15+with.height, 80, 20);
    cell.leftLable2.frame = CGRectMake(10, 35+with1.height, 80, 20);
    cell.leftLable3.frame = CGRectMake(10, 47+with1.height+with2.height, 80, with3.height);
    cell.leftLable4.frame = CGRectMake(10, 57+with1.height+with2.height+with3.height, 80, with4.height);
    cell.leftLable5.frame = CGRectMake(10, 67+with1.height+with2.height+with3.height+with4.height, 80, with5.height);
//    cell.leftLable3.frame = CGRectMake(10, 55+with2.height, 80, 20);
//    cell.leftLable4.frame = CGRectMake(10, 75+with3.height, 80, 20);
//    cell.leftLable5.frame = CGRectMake(10, 95+with4.height, 80, 20);
    
    cell.qujuLable.numberOfLines = 0;
    cell.nameLable.numberOfLines = 0;
    cell.juzhanLable.numberOfLines = 0;
    cell.floorLable.numberOfLines = 0;
    cell.proLable.numberOfLines = 0;
    cell.ztLable.numberOfLines = 0;
    
    cell.qujuLable.frame = CGRectMake(80, 10, kScreenWidth-120, with.height);
    
    cell.juzhanLable.frame = CGRectMake(80, 17+with.height, kScreenWidth-120, with1.height);
    cell.nameLable.frame = CGRectMake(80, 37+with1.height, kScreenWidth-120, with2.height);
    cell.floorLable.frame = CGRectMake(80, 47+with1.height+with2.height, kScreenWidth-120, with3.height);
    cell.proLable.frame = CGRectMake(80, 57+with1.height+with2.height+with3.height, kScreenWidth-120, with4.height);
    cell.ztLable.frame = CGRectMake(80, 67+with1.height+with2.height+with3.height+with4.height, kScreenWidth-120, with5.height);

    if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"district"]isEqualToString:@"<null>"]) {
        cell.qujuLable.text = @"";
    }else{
        cell.qujuLable.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"district"];
    }
    
    
    if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"]isEqualToString:@"<null>"]) {
        cell.juzhanLable.text = @"";
    }else{
       cell.juzhanLable.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"];
    }
    
    
    if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"roomName"]isEqualToString:@"<null>"]) {
        cell.nameLable.text = @"";
    }else{
       cell.nameLable.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"roomName"];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"floor"] description]isEqualToString:@"<null>"]) {
        cell.floorLable.text = @"";
    }else{
       cell.floorLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"floor"] description];
    }
    
    
    if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"usage"]isEqualToString:@"<null>"]) {
        cell.proLable.text = @"";
    }else{
        cell.proLable.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"usage"];
    }
    
    
    if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"state"]isEqualToString:@"<null>"]) {
        cell.ztLable.text = @"";
    }else{
       cell.ztLable.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"state"];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //区局
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"district"] description]];
    
    //局站名称
    CGSize with1 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"regionName"] description]];
    
    //机房名称
    CGSize with2 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"roomName"] description]];
    
    //楼层
    CGSize with3 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"floor"] description]];
    
    //专业
    CGSize with4 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"usage"] description]];
    
    //机房状态
    CGSize with5 = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"state"] description]];
    return 60+with.height+with1.height+with2.height+with3.height+with4.height+with5.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myRegion/GetRoomById";
    paraDict[@"roomId"] = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"roomId"];
    
    
    httpGET2(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            
            RoomDetailViewController *roomVC = [[RoomDetailViewController alloc]init];
            roomVC.dataArr = [result objectForKey:@"detail"];
            [self.navigationController pushViewController:roomVC animated:YES];
            
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
    paraDict[URL_TYPE] = @"myRegion/GetRoomByName";
    if (self.vcTag == 100){
        paraDict[@"roomIds"] = self.strID;
    }else if (scanfTag == 100) {
        paraDict[@"roomName"] = strName;
    }else{
        paraDict[@"roomIds"] = m_qrCode;
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
    paraDict[URL_TYPE] = @"myRegion/GetRoomByName";
    
    if (self.vcTag == 100){
        paraDict[@"roomIds"] = self.strID;
    }else if (scanfTag == 100) {
        paraDict[@"roomName"] = strName;
    }else{
        paraDict[@"roomIds"] = m_qrCode;
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
