//
//  HandleResultController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/25.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "HandleResultController.h"
#import "HandleResult.h"
#import "MBProgressHUD+MJ.h"

@interface HandleResultController () <UIAlertViewDelegate>

@property (nonatomic,strong) HandleResult *handleResult;
@property (nonatomic,strong) NSMutableArray *accesoryType;

@property (nonatomic,strong) NSIndexPath *alertIndexPath;

@end

@implementation HandleResultController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.handleResult = [HandleResult handleResult];
}

-(NSMutableArray *)accesoryType
{
    if (_accesoryType == nil) {
        _accesoryType = [NSMutableArray array];
        NSArray *array = @[@"0",@"0",@"0",@"0"];
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
    return self.handleResult.keyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"handleResultCtrl";
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
    
    cell.textLabel.text = [self.handleResult.valueArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请确定问题大类、小类、处理结果说明均已填写完毕" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"已填写", nil];
    [alert show];
    self.alertIndexPath = indexPath;

}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //刷新显示的对号
        
        NSIndexPath *indexPath = self.alertIndexPath;
        
        for (int i = 0; i < self.accesoryType.count; i ++ ) {
            [self.accesoryType replaceObjectAtIndex:i withObject:@"0"];
        }
        [self.accesoryType replaceObjectAtIndex:indexPath.row withObject:@"1"];
        [self.tableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(handleResultController:key:value:)]) {
            //汉字描述部分
            NSString *keyStr = [self.handleResult.valueArray objectAtIndex:indexPath.row];
            //对应的数字标识部分
            NSString *valueStr = [self.handleResult.keyArray objectAtIndex:indexPath.row];
            [self.delegate handleResultController:self key:keyStr value:valueStr];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
