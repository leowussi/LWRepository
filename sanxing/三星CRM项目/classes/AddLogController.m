//
//  AddLogController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/7.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "AddLogController.h"
#import "ZYFHttpTool.h"
#import "ZYFUrl.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFAttributes.h"
#import "ZYFEditStringController.h"
#import "ZYFEditDateController.h"
#import "ZYFPickList.h"
#import "ZYFEditLookupController.h"
#import "LogsFooterView.h"
#import "ZYFAttributes.h"


@interface AddLogController () <ZYFEditDateControllerDelegate>

//派工完成时间
@property (nonatomic,copy) NSString *detailText;
//要求填写时间
@property (nonatomic,copy) NSString *mustWriteTime;

@property (nonatomic,weak) LogsFooterView *footerView;

@end

@implementation AddLogController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
    [self setFooterView];
//    [self addGesture];

}

-(void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKey)];
    [self.view addGestureRecognizer:tap];
}

-(void)hideKey
{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.tableView reloadData];
}

-(void)setFooterView
{
    LogsFooterView *footerView = [[LogsFooterView alloc]init];
    self.tableView.tableFooterView = footerView;
    self.footerView = footerView;
}

-(NSString *)detailText
{
    if (_detailText == nil) {
        _detailText = @"";
    }
    return _detailText;
}

- (NSString *)mustWriteTime
{
    if (_mustWriteTime == nil) {
        _mustWriteTime = @"";
    }
    return _mustWriteTime;
}

#pragma mark -- Cancel ,Save
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)save
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //派工完成时间
    params[@"new_end_order_time"] = self.detailText;
    //要求填写时间
    params[@"new_request_date"] = self.mustWriteTime;
    //派工总结
    params[@"new_order_summary"] = self.footerView.textView.text;
    
    //当前派工单对应的ID和LogicalName
    NSString *strId = [NSString stringWithFormat:@"%@,%@",self.saleList.LogicalName,self.saleList.Id];
    params[@"new_customer_service_requireid"] = strId;
    
    NSString *urlString = kWorkLogCreate;
    
    //点击保存按钮，在保存返回之前，该按钮不允许多次点击
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    [ZYFHttpTool putWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        if ([self.delegate respondsToSelector:@selector(addLogController:isFinished:)]) {
            [self.delegate addLogController:self isFinished:YES];
        }
        [MBProgressHUD showSuccess:@"添加成功"];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"addlog";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"派工完成时间";
        cell.detailTextLabel.text = self.detailText;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"要求填写时间";
        cell.detailTextLabel.text = self.mustWriteTime;

    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFEditDateController *editDateCtrl = [[ZYFEditDateController alloc]init];
    editDateCtrl.delegate = self;
    if (indexPath.row == 0) {
        editDateCtrl.date = self.detailText;
    }else if (indexPath.row == 1){
        editDateCtrl.date = self.mustWriteTime;
    }
    editDateCtrl.indexPath = indexPath;
    [self.navigationController pushViewController:editDateCtrl animated:YES];
}

-(void)editDateChanged:(ZYFEditDateController *)editDateCtrl dateStr:(NSString *)dateString
{
    if (editDateCtrl.indexPath.row == 0) {
        self.detailText = dateString;
    }else if (editDateCtrl.indexPath.row == 1){
        self.mustWriteTime = dateString;
    }
    [self.tableView reloadData];
}



@end
