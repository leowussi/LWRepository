//
//  ProblemsController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/1.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ProblemsController.h"
#import "ZYFHttpTool.h"
#import "ZYFUrlTask.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFDisplayCols.h"
#import "ZYFSaleList.h"
#import "ZYFDisplayCols.h"
#import "CRMHelper.h"


@interface ProblemsController ()

@property (nonatomic,strong) NSArray *problems;
@property (nonatomic,strong) NSMutableArray *accesoryType;

@end

@implementation ProblemsController

- (void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isBigType) {
        self.title = @"问题大类";
    }else
    {
        self.title = @"问题小类";
    }
    [self getProblemsDataFromServer];
}

-(NSMutableArray *)accesoryType
{
    if (_accesoryType == nil) {
        _accesoryType = [NSMutableArray array];
        for (NSInteger i = 0; i < self.problems.count; i ++) {
            [_accesoryType addObject:@"0"];
        }
    }
    return _accesoryType;
}

- (void)getProblemsDataFromServer
{
    NSString *url = @"";
    NSString *urlString = @"";
    if (self.isBigType) {
        //如果是问题大类
        urlString = kProblemBig;
    }else{
        //问题小类
        url = kProblemSmall;
        NSString *problemBigId = [ZYFUserDefaults objectForKey:ZYFProblemId];
        urlString = [NSString stringWithFormat:@"%@?id=%@",url,problemBigId];
        
        
    }
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.problems = json;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.problems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"problems";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSInteger accessoryType = [[self.accesoryType objectAtIndex:indexPath.row] integerValue];
    if (accessoryType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    ZYFSaleList *sale = [self.problems objectAtIndex:indexPath.row];
    for (ZYFAttributes *attr in sale.attrArray) {
        if ([attr.myKey isEqualToString:@"new_name"]) {
            cell.textLabel.text = attr.myValueString;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFSaleList *sale = [self.problems objectAtIndex:indexPath.row];
    
    NSString *keyStr = @"";
    NSString *valueStr = @"";
    
    for (ZYFAttributes *attr in sale.attrArray) {
        if ([attr.myKey isEqualToString:@"new_name"]) {
            //汉字描述部分
            keyStr = attr.myValueString;
            //对应的数字标识部分
            NSString *loginNameAndId = [NSString stringWithFormat:@"%@,%@",sale.LogicalName,sale.Id];
            valueStr = loginNameAndId;
        }
    }
    //刷新显示的对号
    for (int i = 0; i < self.accesoryType.count; i ++ ) {
        [self.accesoryType replaceObjectAtIndex:i withObject:@"0"];
    }
    [self.accesoryType replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(problemsController:key:value:)]) {
        [self.delegate problemsController:self key:keyStr value:valueStr];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
