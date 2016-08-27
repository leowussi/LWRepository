//
//  YZRemindListViewController.m
//  AcceptanceApplication
//
//  Created by 锋 on 16/5/17.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZRemindListViewController.h"
#import "YZAcceptanceListTableViewCell.h"


@interface YZRemindListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    //标记当前的button
    NSInteger _selectedButtonIndex;
    
    UISwipeGestureRecognizer *_rightSwipeGesture;
  
}
@end

@implementation YZRemindListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedButtonIndex = -1;
    
    [self createTableView];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRemindList) name:@"updateRemindList" object:nil];
    
}

- (void)updateRemindList
{
    [_dataArray removeAllObjects];
    [self loadData];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 107) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:243/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 154;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    _rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGesture:)];
}


- (void)loadData
{
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"MyTask/WithWork/GetProjectCheckRemindList";
    httpPOST(para1, ^(id result) {
        NSLog(@"%@",result);
        if (_dataArray == nil) {
            _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        for (NSDictionary *dict in [result objectForKey:@"list"]) {
            YZAcceptanceList *list = [[YZAcceptanceList alloc] initWithParserDictionary:dict];
            [_dataArray addObject:list];
        }
        [_tableView reloadData];
    }, ^(id result) {
        
    });
}


#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZAcceptanceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZAcceptanceListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" contianDeleteButton:YES];
        [cell.button_delete addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addLeftGestureForCell:cell];
    }
    YZAcceptanceList *list = [_dataArray objectAtIndex:indexPath.row];
    cell.label_title.text = list.string_projectname;
    [cell.label_desc setAttributedText:list.string_desc];
    [cell removeGestureRecognizer:_rightSwipeGesture];
    if (_selectedButtonIndex == indexPath.row) {
        cell.view_background.frame = CGRectMake(-52, 12, kScreenWidth - 24, 132);
        [self addRightGestureForCell:cell];
    }else{
        cell.view_background.frame = CGRectMake(12, 12, kScreenWidth - 24, 132);
    }
    
    return cell;
}
#pragma mark -- 删除按钮
- (void)deleteButtonClicked:(UIButton *)sender
{
    NSLog(@"删除按钮被点击");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该条提醒信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            YZAcceptanceList *list = _dataArray[_selectedButtonIndex];
            NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
            para1[URL_TYPE] = @"MyTask/WithWork/DeleteProjectCheckRemind";
            para1[@"checkId"] = list.checkId;
            
            httpPOST(para1, ^(id result) {
                if ([result objectForKey:@"result"]) {
                    [_dataArray removeObjectAtIndex:_selectedButtonIndex];
                    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_selectedButtonIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    _selectedButtonIndex = -1;

                }
            }, ^(id result) {
                
            });
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 手势
- (void)addLeftGestureForCell:(UITableViewCell *)cell
{
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGesture:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:leftSwipeGesture];
    UIScrollView *scrollView = (UIScrollView *)self.view.superview;
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:leftSwipeGesture];
}

- (void)addRightGestureForCell:(UITableViewCell *)cell
{
     UIScrollView *scrollView = (UIScrollView *)self.view.superview;
    
    [cell addGestureRecognizer:_rightSwipeGesture];
    
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:_rightSwipeGesture];

}
- (void)rightSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture
{
    YZAcceptanceListTableViewCell *cell = (YZAcceptanceListTableViewCell *)swipeGesture.view;
    if ([_tableView indexPathForCell:cell].row != _selectedButtonIndex) {
        return;
    }
    CGRect rect = cell.view_background.frame;
    rect.origin.x = rect.origin.x + 64;
    [UIView animateWithDuration:.18 animations:^{
        cell.view_background.frame = rect;
    } completion:^(BOOL finished) {
        _selectedButtonIndex = -1;
        [cell removeGestureRecognizer:_rightSwipeGesture];
    }];
}

- (void)leftSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture
{
    YZAcceptanceListTableViewCell *cell = (YZAcceptanceListTableViewCell *)swipeGesture.view;
    if ([_tableView indexPathForCell:cell].row == _selectedButtonIndex) {
        return;
    }
    if (_selectedButtonIndex > -1) {
        YZAcceptanceListTableViewCell *previousCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedButtonIndex inSection:0]];
        CGRect rect = cell.view_background.frame;
        rect.origin.x = rect.origin.x - 64;
        CGRect previousRect = previousCell.view_background.frame;
        previousRect.origin.x = previousRect.origin.x + 64;
        
        [UIView animateWithDuration:.18 animations:^{
            previousCell.view_background.frame = previousRect;
            cell.view_background.frame = rect;
        } completion:^(BOOL finished) {
            _selectedButtonIndex = [_tableView indexPathForCell:cell].row;
            [previousCell removeGestureRecognizer:_rightSwipeGesture];
            [self addRightGestureForCell:cell];
        }];

    }else{
    
        CGRect rect = cell.view_background.frame;
        rect.origin.x = rect.origin.x - 64;
        [UIView animateWithDuration:.18 animations:^{
            cell.view_background.frame = rect;
        } completion:^(BOOL finished) {
            _selectedButtonIndex = [_tableView indexPathForCell:cell].row;
            [self addRightGestureForCell:cell];
        }];
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
