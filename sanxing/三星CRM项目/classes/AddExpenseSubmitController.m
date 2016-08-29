//
//  AddExpenseSubmitController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "AddExpenseSubmitController.h"

#import "ServiceContentController.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFEditStringController.h"
#import "ZYFUrl.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFHttpTool.h"
#import "ZYFAttributes.h"
#import "ExpenseTypeController.h"

@interface AddExpenseSubmitController () <ZYFEditStringControllerDelegate,ExpenseTypeControllerDelegate>

@property (nonatomic,strong) NSArray *cellData;
@property (nonatomic,strong) NSMutableArray *detailTextData;

//费用
@property (nonatomic,copy) NSString *expense;
//派工费用类型 -- 对应的数字标识部分
@property (nonatomic,copy) NSString *expenseType;

@end

@implementation AddExpenseSubmitController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"添加费用登记"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
}

-(NSArray *)cellData
{
    if (_cellData == nil) {
        _cellData = @[@"费用",@"派工费用类型"];
    }
    return _cellData;
}

-(NSArray *)detailTextData
{
    if (_detailTextData == nil) {
        _detailTextData = [NSMutableArray arrayWithObjects:@"",@"",@"" ,nil];
    }
    return _detailTextData;
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)save
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //工作日志对应的logincname和id
    NSString *logLogicalAndId = [NSString stringWithFormat:@"%@,%@",self.saleList.LogicalName,self.saleList.Id];
    params[@"new_work_date_reportid"] = logLogicalAndId;
    //费用类型
//    NSString *expenseType = [NSString stringWithFormat:@"%@",];
    if (self.expenseType.length <= 0) {
        [MBProgressHUD showError:@"请选择费用类型"];
        return;
    }else{
        params[@"new_order_fee_type"] = self.expenseType;
    }
    //费用
    if (self.expense.length <= 0) {
        [MBProgressHUD showError:@"请输入费用"];
        return;
    }else{
        params[@"new_fee"] = self.expense;

    }
    
    NSString *urlString = kExpenseCreate;
    [MBProgressHUD showMessage:nil toView:self.view ];
    [ZYFHttpTool putWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        
        if (code.intValue == 1) {
            //通知上一级界面更新已经创建好的工作日志明细
            if ([self.delegate respondsToSelector:@selector(addExpenseSubmitController:isFinish:)]) {
                [self.delegate addExpenseSubmitController:self isFinish:YES];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else{
            [MBProgressHUD showError:msg];
        }
        


    } failure:^(NSError *error) {        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"addExpenseSubmit";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.cellData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.detailTextData objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        //费用
        ZYFEditStringController *editCtrl = [[ZYFEditStringController alloc]init];
        editCtrl.info = @"new_fee";
        editCtrl.delegate = self;
        //设置只显示数字键盘
        editCtrl.showNumKeyboard = YES;
        
        NSMutableArray *cellDataArray = [NSMutableArray array];
        [cellDataArray addObject:@"费用"];
        [cellDataArray addObject:@""];
        editCtrl.cellData = cellDataArray;
        [self.navigationController pushViewController:editCtrl animated:YES];
    }
    if (indexPath.row == 1) {
        //派工费用类型
        ExpenseTypeController *expenseCtrl = [[ExpenseTypeController alloc]init];
        expenseCtrl.delegate = self;
        [self.navigationController pushViewController:expenseCtrl animated:YES];
    }
}

#pragma mark -- ZYFEditStringControllerDelegate
-(void)editStringController:(ZYFEditStringController *)ctrl editString:(NSString *)editString
{
    [self.detailTextData replaceObjectAtIndex:0 withObject:editString];
    self.expense = editString;
    [self.tableView reloadData];
}

#pragma mark -- ExpenseTypeControllerDelegate
/**
 *  ExpenseTypeController的代理方法
 *
 *  @param ctrl        ctrl
 *  @param keyString   汉字描述部分
 *  @param valueString 对应的数字标识部分
 */

-(void)expenseTypeController:(ExpenseTypeController *)ctrl key:(NSString *)keyString value:(NSString *)valueString
{
    [self.detailTextData replaceObjectAtIndex:1 withObject:keyString];
    self.expenseType = valueString;
    [self.tableView reloadData];
}



@end
