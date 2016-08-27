//
//  JumperConnectionController.m
//  telecom
//
//  Created by SD0025A on 16/4/1.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JumperConnectionController.h"
#import "JumperConnectionListModel.h"
#import "JumperConnectionCellModel.h"
#import "JumperConnectionCell.h"

#define JumpConnnectionUrl @"Medium/skipInfo"
@interface JumperConnectionController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *m_table;
//数据源
@property (nonatomic,strong) NSMutableArray *dataArray;
//每一组是否展开状态数组
@property (nonatomic,strong) NSMutableArray *statusArray;
//安装 数据源数组
@property (nonatomic,strong) NSMutableArray *installListArray;
//拆除 数据源数组
@property (nonatomic,strong) NSMutableArray *removeListArray;

@end
//跳接表控制器
@implementation JumperConnectionController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createUI];
    [self downloadData];
    

}
//懒加载
- (NSMutableArray *)statusArray
{
    if (nil == _statusArray) {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)downloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"workNo"] = self.workNo;
    param[URL_TYPE] = JumpConnnectionUrl;
    httpGET2(param, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result;
            NSDictionary *detailDic = dict[@"return_data"];
            NSArray *array1 = detailDic[@"installList"];
            //安装
            self.installListArray = [JumperConnectionListModel arrayOfModelsFromDictionaries:array1 error:nil ];
            [self.dataArray addObjectsFromArray:self.installListArray];
            //拆除
            NSArray * array2 = detailDic[@"removeList"];
            self.removeListArray = [JumperConnectionListModel arrayOfModelsFromDictionaries:array2 error:nil ];
            [self.dataArray addObjectsFromArray:self.removeListArray];
            //0不展开  1展开
            for (int i=0; i<self.dataArray.count; i++) {
                [self.statusArray addObject:@(0)];
            }
           
            [self.m_table reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
}
//创建UI
- (void)createUI
{
    self.view.backgroundColor = COLOR(248, 248, 248);
    self.navigationItem.title = @"跳接表";
    //创建tableView
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, APP_W-20, APP_H-74) style:UITableViewStylePlain];
    self.m_table.delegate = self;
    self.m_table.dataSource = self;
    self.m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.m_table];
}
#pragma mark - UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.statusArray[section] integerValue] == 0) {
        return 0;
    }else{
        JumperConnectionListModel *model = self.dataArray[section];
        return model.infoList.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JumperConnectionListModel *model = self.dataArray[indexPath.section];
    
    JumperConnectionCellModel *cellModel = model.infoList[indexPath.row];
    return [cellModel configHeight];
}
 //组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
       JumperConnectionListModel *listModel = self.dataArray[section];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, APP_W-30, 65)];
        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headView.frame.size.width-20, 20)];
    if (section > 0) {
        JumperConnectionListModel *nextModel = self.dataArray[section-1];
        if ([nextModel.kind isEqualToString:listModel.kind]) {
            Label.hidden = YES;
        }

    }
    if (![listModel.kind isEqualToString:@"安装"]) {
        Label.text = @"拆除";
    }else{
        Label.text = @"安装";
    }
    
        Label.textColor = [UIColor greenColor];
        Label.font = [UIFont systemFontOfSize:15];
        [headView addSubview:Label];
    
    
        //列表label,右边展开按钮宽度30
           float w = headView.frame.size.width-10;
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, w-40, 20)];
            label1.text = listModel.equipName;
            label1.font = [UIFont systemFontOfSize:12];
            label1.textColor = [UIColor blueColor];
            [headView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, w-40, 20)];
            label2.font = [UIFont systemFontOfSize:12];
            label2.textColor = [UIColor orangeColor];
            label2.text = listModel.roomAddr;
            [headView addSubview:label2];
            
            //右边clickBtn
            UIButton *clickbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            clickbtn1.frame = CGRectMake(headView.frame.size.width - 35, headView.frame.size.height-30, 30, 30);
            clickbtn1.tag = 100+section;
            if ([self.statusArray[section] integerValue ] == 0) {
                clickbtn1.selected = NO;
                [clickbtn1 setBackgroundImage:[UIImage imageNamed:@"arrowDown@2x.png"] forState:UIControlStateNormal];
            }else{
                clickbtn1.selected = YES;
                [clickbtn1 setBackgroundImage:[UIImage imageNamed:@"arrowUp@2x.png"] forState:UIControlStateNormal];
            }
            [clickbtn1 addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:clickbtn1];
   
        return headView;
    
}
- (void)rightBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"arrowUp@2x.png"] forState:UIControlStateSelected];
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"arrowDown@2x.png"] forState:UIControlStateNormal];
    }

    NSInteger section = btn.tag -100;
    if ([self.statusArray[section] integerValue] == 0) {
        [self.statusArray replaceObjectAtIndex:section withObject:@(1)];
    }else{
        [self.statusArray replaceObjectAtIndex:section withObject:@(0)];
    }
    [self.m_table reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    
}
//组视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"jumperConnection";
    JumperConnectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JumperConnectionCell" owner:self options:nil]lastObject];
    }
    JumperConnectionListModel *model = self.dataArray[indexPath.section];
    NSMutableArray *cellArray = [NSMutableArray array];
    [cellArray addObjectsFromArray:model.infoList];
    JumperConnectionCellModel *cellModel = cellArray[indexPath.row];
    [cell configModel:cellModel];
   
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.m_table)
    {
        CGFloat sectionHeaderHeight = 65;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

@end
