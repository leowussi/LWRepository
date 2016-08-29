//
//  AssignStatusController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "AssignStatusController.h"

@interface AssignStatusController ()

@property (nonatomic,strong) NSMutableArray *accesoryType;

@end

@implementation AssignStatusController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(NSMutableArray *)accesoryType
{
    if (_accesoryType == nil) {
        _accesoryType = [NSMutableArray array];
        NSArray *array = @[@"1",@"0",@"0",@"0"];
        [_accesoryType addObjectsFromArray:array];
    }
    return _accesoryType;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self getSectionDataDict].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"assignstatus";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSArray *textArray = [[self getSectionDataDict]objectAtIndex:indexPath.row];
    NSString *text = [textArray objectAtIndex:0];
    cell.textLabel.text = text;
    NSInteger accessoryType = [[self.accesoryType objectAtIndex:indexPath.row] integerValue];
    if (accessoryType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //刷新显示的对号
    [self.accesoryType replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [self.tableView reloadData];
    
    NSArray *array = [[self getSectionDataDict]objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(assignStatusController:status:)]) {
        [self.delegate assignStatusController:self status:array];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSArray *)getSectionDataDict
{
    NSArray *dict1 = @[@"待填写",@"10"];
    NSArray *dict2 = @[@"未完工",@"20"];
    NSArray *dict3 = @[@"需重新派工",@"80"];
    NSArray *dict4 = @[@"已完工",@"90"];
    
    NSArray *dataArray = @[dict1,dict2,dict3,dict4];

    return dataArray;
}




@end
