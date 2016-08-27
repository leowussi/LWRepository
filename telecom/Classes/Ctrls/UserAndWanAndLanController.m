//
//  UserAndWanAndLanController.m
//  telecom
//
//  Created by SD0025A on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "UserAndWanAndLanController.h"

#import "UserAndWANAndLANOneModel.h"
#import "UserAndWANAndLanOneCell.h"//用户

#import "UserAndWANAndLANTwoModel.h"//LAN
#import "UserAndWANAndLanTwoCell.h"

#import "UserAndWanAndLANCell.h"
#import "UserAndWanAndLANModel.h"//WAN
#define UserAndWanLanUrl  @"Medium/UserWanLanInfo"

@interface UserAndWanAndLanController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *m_table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *isShow;

@property (nonatomic,strong) NSMutableArray *lanArray;
@property (nonatomic,strong) NSMutableArray *userArray;
@property (nonatomic,strong) NSMutableArray *wanArray;

@property (nonatomic,strong) NSMutableArray *numArray;
@end

@implementation UserAndWanAndLanController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self downloadData];
    
    
}
- (void)downloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[URL_TYPE] = UserAndWanLanUrl;
    param[@"workNO"] = self.workNo;
    httpGET2(param, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result;
            NSDictionary *subDic = dict[@"return_data"];
            NSMutableDictionary * lanDic= subDic[@"Lan"];
            NSMutableDictionary * userDic = subDic[@"User"];
            NSMutableDictionary * wanDic = subDic[@"Wan"];
            NSString *num1 = userDic[@"userPortNum"];
            NSString *num2 = lanDic[@"lanPortNum"];
            NSString *num3 = wanDic[@"wanPortNum"];
            [self.numArray addObject:num1];
            [self.numArray addObject:num2];
            [self.numArray addObject:num3];
            NSArray *array1 = lanDic[@"lanList"];
            NSArray *array2 = userDic[@"userList"];
            NSArray *array3 = wanDic[@"wanList"];
            if (array1.count != 0) {
                self.lanArray = [UserAndWANAndLANTwoModel arrayOfModelsFromDictionaries:array1 error:nil];
            }  
            if (array2.count != 0) {
                self.userArray = [UserAndWANAndLANOneModel arrayOfModelsFromDictionaries:array2 error:nil];
            }
            if (array3.count != 0) {
                self.wanArray = [UserAndWanAndLANModel arrayOfModelsFromDictionaries:array3 error:nil];
            }
            [self createUI];
            [self.m_table reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}
- (NSMutableArray *)numArray
{
    if (nil == _numArray) {
        _numArray = [NSMutableArray array];
    }
    return _numArray;
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)isShow
{
    if (nil == _isShow) {
        _isShow = [NSMutableArray array];
    }
    return _isShow;
}
- (NSMutableArray *)lanArray
{
    if (nil == _lanArray) {
        _lanArray = [NSMutableArray array];
    }
    return _lanArray;
}
- (NSMutableArray *)userArray
{
    if (nil == _userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
- (NSMutableArray *)wanArray
{
    if (nil == _wanArray) {
        _wanArray = [NSMutableArray array];
    }
    return _wanArray;
}

- (void)createUI
{
    //设置每一组状态为 收起的  0 收起   1 展开
    [self.isShow addObject:@(0)];
    [self.isShow addObject:@(0)];
    [self.isShow addObject:@(0)];
    self.view.backgroundColor = COLOR(248, 248, 248);
    self.navigationItem.title = @"用户/WAN/LAN";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, APP_W-20, APP_H-74) style:UITableViewStylePlain];
    self.m_table.dataSource = self;
    self.m_table.delegate = self;
    self.m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.m_table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.m_table];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.isShow[section] integerValue] == 0) {
        return 0;
    }else{
        if (section == 0) {
            return self.userArray.count;
        }
        if (section == 1) {
            return self.lanArray.count;
        }else{
            return self.wanArray.count;
        }
        
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserAndWANAndLANOneModel *model = self.userArray[indexPath.row];
    NSLog(@"user  %f",[model configCellHeight]);
       return [model configCellHeight];
        
    }
    if (indexPath.section == 1) {
         UserAndWANAndLANTwoModel *model = self.lanArray[indexPath.row];
        NSLog(@"lan  %f",[model configCellHeight]);
        return [model configCellHeight];
    }
    if (indexPath.section == 2) {
        UserAndWanAndLANModel *model = self.wanArray[indexPath.row];
        NSLog(@"wan  %f",[model configCellHeight]);
        return [model configCellHeight];
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W-20, 30)];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 120, 20)];
    lable.font = [UIFont systemFontOfSize:17];
    lable.textColor = [UIColor greenColor];
    [headerView addSubview:lable];
    
    if (section == 0) {
        lable.text = [NSString stringWithFormat:@"用户 端口数：%@",self.numArray[0]];
    }else if (section == 1){
        lable.text = [NSString stringWithFormat:@"LAN 端口数：%@",self.numArray[1]];
    }else if (section == 2){
        lable.text = [NSString stringWithFormat:@"WAN端口数：%@",self.numArray[2]];
    }
    
    //clickBtn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(180, 5, 20, 20);
    btn.tag =  section+400;
    
    if ([self.isShow[section] integerValue ] == 0) {
        btn.selected = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"arrowDown@2x.png"] forState:UIControlStateNormal];
    }else{
        btn.selected = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"arrowUp@2x.png"] forState:UIControlStateNormal];
    }
    
    
    [btn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    
    return headerView;
}
- (void)clickHeaderBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"arrowUp@2x.png"] forState:UIControlStateSelected];
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"arrowDown@2x.png"] forState:UIControlStateNormal];
    }
    
    NSInteger section = btn.tag- 400;
    if ([self.isShow[section] integerValue ] == 0) {
        [self.isShow replaceObjectAtIndex:section withObject:@(1)];
    }else{
        [self.isShow replaceObjectAtIndex:section withObject:@(0)];
    }
    [self.m_table reloadSections:[NSIndexSet indexSetWithIndex:btn.tag-400] withRowAnimation:UITableViewRowAnimationFade];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //用户
        static NSString *cellId = @"userAndWANAndLanOneCell";
        UserAndWANAndLanOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserAndWANAndLanOneCell" owner:self options:nil] lastObject];
        }
        if (self.userArray != nil) {
            UserAndWANAndLANOneModel *model = self.userArray[indexPath.row];
            [cell configModel:model];
        }
        
        return cell;
        
    }
    if (indexPath.section == 1) {
        //LAN
        static NSString *cellId = @"userAndWANAndLanTwoCell";
        UserAndWANAndLanTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserAndWANAndLanTwoCell" owner:self options:nil] lastObject];
        }
        if (self.lanArray != nil) {
            UserAndWANAndLANTwoModel *model = self.lanArray[indexPath.row];
            [cell configModel:model];
        }
        
        
        return cell;
        
    }
    if (indexPath.section == 2) {
        //WAN
        static NSString *cellId = @"wanAndLanCell";
        UserAndWanAndLANCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserAndWanAndLANCell" owner:self options:nil] lastObject];
        }
        if (self.wanArray != nil) {
            UserAndWanAndLANModel *model = self.wanArray[indexPath.row];
            [cell configModel:model];
        }
        
        return cell;
        
    }else{
        return nil;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.m_table)
    {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
@end
