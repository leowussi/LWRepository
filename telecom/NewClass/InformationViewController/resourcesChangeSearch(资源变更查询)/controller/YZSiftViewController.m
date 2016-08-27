//
//  YZSiftViewController.m
//  CheckResourcesChange
//
//  Created by 锋 on 16/4/29.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZSiftViewController.h"
#import "YZConditionSiftView.h"

@interface YZSiftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSMutableDictionary *_chooseDict;
    //筛选视图
    YZConditionSiftView *_siftView;
    
}

@end

@implementation YZSiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"请选择筛选条件";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRightBarButtonItem];
    [self createData];
    [self requestData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)createData
{
    _chooseDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    _titleArray = [[NSArray alloc] initWithObjects:@"细化任务类型",@"专业",@"工单状态",@"范围", nil];
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"siftArray"];
    if (array == nil) {
         _siftArray = [[NSMutableArray alloc] initWithObjects:@"全部",@"全部",@"全部",@"我的资源变更工单", nil];
    }else{
        _siftArray = [[NSMutableArray alloc] initWithArray:array];
    }
   
    [self addNavigationLeftButton];

}

- (void)createSiftView
{
    _siftView = [[YZConditionSiftView alloc] initWithFrame:CGRectZero tableViewFrame:CGRectZero dataArray:nil title:nil];
    
}
                 

- (void)requestData
{
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"adjustRes/QuerySubTypeDic";
    httpPOST(para1, ^(id result) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            [mutArray addObject:[dict objectForKey:@"name"]];
        }
        [_chooseDict setObject:mutArray forKey:@"0"];
    }, ^(id result) {
        
    });
    para1[URL_TYPE] = @"adjustRes/QueryMajorDic";
    httpPOST(para1, ^(id result) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            [mutArray addObject:[dict objectForKey:@"name"]];
        }
        [_chooseDict setObject:mutArray forKey:@"1"];
    }, ^(id result) {
        
    });
    
    para1[URL_TYPE] = @"adjustRes/QueryStatusDic";
    httpPOST(para1, ^(id result) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            [mutArray addObject:[dict objectForKey:@"name"]];
        }
        [_chooseDict setObject:mutArray forKey:@"2"];
    }, ^(id result) {
        
    });
    
    NSArray *array = [NSArray arrayWithObjects:@"我的资源变更工单",@"本区局的资源变更工单",@"待评价的资源变更工单",@"已撤销的资源变更工单", nil];
    [_chooseDict setObject:array forKey:@"3"];
}

#pragma mark -- 导航条右侧按钮
- (void)addRightBarButtonItem
{
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(0, 0, 30, 30);
    [checkButton setBackgroundImage:[UIImage imageNamed:@"nav_check"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, 0, 30, 30);
    [clearButton setBackgroundImage:[UIImage imageNamed:@"nav_clear"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    
    self.navigationItem.rightBarButtonItems = @[clearItem,checkItem];
}

- (void)checkItemClicked
{
    NSMutableArray *mutArray = [_recordSelectedDict objectForKey:@"0"];
    NSArray * array = [_chooseDict objectForKey:@"0"];
    if (![mutArray containsObject:@"998"]) {
        
        [mutArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[array objectAtIndex:[obj integerValue]] isEqualToString:@"其他"]) {
                [mutArray replaceObjectAtIndex:idx withObject:@"998"];
                return ;
            }

        }];
        
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:_recordSelectedDict forKey:@"conditionSift"];
    [[NSUserDefaults standardUserDefaults] setObject:_siftArray forKey:@"siftArray"];
    [_siftView removeFromSuperview];
    
    _completionBlock();
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearItemClicked
{
    [_siftArray removeAllObjects];
    NSArray *array = @[@"全部",@"全部",@"全部",@"我的资源变更工单"];
    [_siftArray addObjectsFromArray:array];
    for (NSString *key in _recordSelectedDict) {
        NSMutableArray *array = [_recordSelectedDict objectForKey:key];
        [array removeAllObjects];
    }
    [_tableView reloadData];
}

#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.detailTextLabel.text = _siftArray[indexPath.row];
    cell.textLabel.text = _titleArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = _siftArray[indexPath.row];
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    return array.count * 20 > 40 ? array.count *20 : 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_siftView) {
        [self createSiftView];
//        [self createRecordSelectedArray];
    }
    [_siftView removeFromSuperview];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //根据条件判断如果范围是待评价的资源变更工单.已撤销的资源变更工单,状态只有已关闭和已撤销;
    NSMutableArray *array = [_chooseDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    if (indexPath.row == 2) {
        NSString * regoinName = [_siftArray objectAtIndex:3];
        if ([regoinName isEqualToString:@"待评价的资源变更工单"]) {
            array = [NSMutableArray arrayWithObjects:@"已关闭", nil];
        }else if ([regoinName isEqualToString:@"已撤销的资源变更工单"]) {
            array = [NSMutableArray arrayWithObjects:@"已撤销", nil];
        }
    }
    
    
    CGFloat height = (array.count + 1)* 28 + 66 > kScreenHeight - 130 ? kScreenHeight - 130 :  (array.count + 1)* 28 + 66;
    _siftView.frame = CGRectMake(20, cell.frame.origin.y + 64, kScreenWidth - 40, cell.frame.size.height);
    _siftView.tableView.frame = CGRectMake(0, 0, _siftView.frame.size.width, height);
    _siftView.title_desc = _titleArray[indexPath.row];
    _siftView.isSingleSelect = indexPath.row == 3 ? YES :NO;
    if (array.count == 1) {
        _siftView.isSingleSelect = YES;
    }
     _siftView.dataArray = array;
    if ([_recordSelectedDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] == nil) {
        _siftView.selectedIndexArray = [[NSMutableArray alloc] initWithCapacity:0];
        [_recordSelectedDict setObject:[NSMutableArray arrayWithCapacity:0] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }else{
        if (array.count == 1) {
            _siftView.selectedIndexArray = [NSMutableArray arrayWithObjects:@"0", nil];
        }else {
            NSMutableArray *selectArray = [NSMutableArray arrayWithArray:[_recordSelectedDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
            //如果选中的数组包含其他
            if ([selectArray containsObject:@"998"]) {
                
                [selectArray replaceObjectAtIndex:[selectArray indexOfObject:@"998"] withObject:[NSString stringWithFormat:@"%d",array.count - 1]];
            }
            _siftView.selectedIndexArray = selectArray;
        }
    }
    
    [self.view addSubview:_siftView];
    
    __weak NSMutableArray *weakArray = _siftArray;
    __weak UITableView *weakTableView = _tableView;
    __weak NSMutableDictionary *recordSelectedDict =  _recordSelectedDict;
    __weak NSMutableArray *selectedIndexArray = _siftView.selectedIndexArray;
    __weak typeof (self) weekSelf = self;
    _siftView.completionBlock = ^(NSString *selectedString){
        
        if ([selectedString isEqualToString:@"全部"]) {
            [[recordSelectedDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] removeAllObjects];
        }else{
            [[recordSelectedDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] removeAllObjects];
            [[recordSelectedDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] addObjectsFromArray:selectedIndexArray];
        }
        
        
        if (indexPath.row == 3) {
            [weekSelf adjustWorkOrderStatusAccordingToRegoinName:selectedString];
        }
        
        [weakArray replaceObjectAtIndex:indexPath.row withObject:selectedString];

        if (indexPath.row == 2) {
            [weekSelf adjustWorkOrderStatusWhenSelected];
        }
        
        [weakTableView reloadData];
    };
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = _siftView.frame;
        rect.size.height = height;
        _siftView.frame = rect;
        _siftView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    }];
}

- (void)adjustWorkOrderStatusWhenSelected
{
    NSString * regoinName = [_siftArray objectAtIndex:3];
    NSMutableArray *statusArray = [_recordSelectedDict objectForKey:@"2"];
    if ([regoinName isEqualToString:@"待评价的资源变更工单"]) {
        [statusArray removeAllObjects];
        [statusArray addObject:@"2"];
    }else if ([regoinName isEqualToString:@"已撤销的资源变更工单"]) {
        [statusArray removeAllObjects];
        [statusArray addObject:@"4"];
    }

}

- (void)adjustWorkOrderStatusAccordingToRegoinName:(NSString *)regoinName
{
    NSMutableArray *array = [_recordSelectedDict objectForKey:@"2"];
    if ([regoinName isEqualToString:@"我的资源变更工单"] || [regoinName isEqualToString:@"本区局的资源变更工单"]) {
        
        NSString *previousRegoinName = [_siftArray objectAtIndex:3];
        if ([previousRegoinName isEqualToString:@"待评价的资源变更工单"] || [previousRegoinName isEqualToString:@"已撤销的资源变更工单"]) {
            [_siftArray replaceObjectAtIndex:2 withObject:@"全部"];
            [array removeAllObjects];
        }
        
        return;
    }
    
    [array removeAllObjects];
    if ([regoinName isEqualToString:@"待评价的资源变更工单"]) {
        [_siftArray replaceObjectAtIndex:2 withObject:@"已关闭"];
        
        [array addObject:@"2"];
        
    }else if ([regoinName isEqualToString:@"已撤销的资源变更工单"]) {
        [_siftArray replaceObjectAtIndex:2 withObject:@"已撤销"];
        [array addObject:@"4"];
    }
    
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
