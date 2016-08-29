//
//  ExpenseTypeController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ExpenseTypeController.h"
#import "ExpenseType.h"

@interface ExpenseTypeController ()

@property (nonatomic,strong) ExpenseType *expenseType;
@property (nonatomic,strong) NSMutableArray *accesoryType;

@end

@implementation ExpenseTypeController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.expenseType = [ExpenseType expenseType];
}

-(NSMutableArray *)accesoryType
{
    if (_accesoryType == nil) {
        _accesoryType = [NSMutableArray array];
        NSArray *array = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
        [_accesoryType addObjectsFromArray:array];
    }
    return _accesoryType;
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expenseType.keyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ExpenseTypeController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSInteger accessoryType = [[self.accesoryType objectAtIndex:indexPath.row] integerValue];
    if (accessoryType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [self.expenseType.valueArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //刷新显示的对号
    [self.accesoryType replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(expenseTypeController:key:value:)]) {
        //汉字描述部分
        NSString *keyStr = [self.expenseType.valueArray objectAtIndex:indexPath.row];
        //对应的数字标识部分
        NSString *valueStr = [self.expenseType.keyArray objectAtIndex:indexPath.row];
        [self.delegate expenseTypeController:self key:keyStr value:valueStr];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
