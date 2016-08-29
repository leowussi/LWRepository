//
//  AddLogDetailController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "AddLogDetailController.h"
#import "ServiceContentController.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFEditStringController.h"
#import "ZYFUrl.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFHttpTool.h"
#import "ZYFAttributes.h"
#import "ZYFShowLongStringController.h"

@interface AddLogDetailController () <ServiceContentControllerDelegate,ZYFEditStringControllerDelegate,ZYFShowLongStringControllerDelegate>

@property (nonatomic,strong) NSArray *textData;
@property (nonatomic,strong) NSMutableArray *detailData;
/**
 *  选择的服务内容是否是需要填写服务数量，如果true，则需要填写，如果false，则不需要
 */
@property (nonatomic,assign,getter=isNum) BOOL num;

/**
 *  保存时，ServiceContentControllerDelegate传回来的saleList
 */
@property (nonatomic,strong) ZYFSaleList *serviceContentSaleList;

@property (nonatomic,copy) NSString *realityNum; /**实际数量*/
@property (nonatomic,copy) NSString *serviceIntro; /**服务说明*/
@property (nonatomic,copy) NSString *servicePerson; /**服务对象*/
@property (nonatomic,copy) NSString *telephone; /**电话*/
@property (nonatomic,copy) NSString *productType; /**产品型号*/



@end

@implementation AddLogDetailController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"添加工作日志明细"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
    self.num = false;
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//创建工作日志明细
-(void)save
{
    //当选择服务内容是参数设置时，判断当前服务数量是否为空，如果为空，则不能保存
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.detailTextLabel.text isEqualToString:@"参数设置"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.detailTextLabel.text.length > 0) {
            
        }else{
            [MBProgressHUD showError:@"请填写服务数量"];
            return;
        }
    }
    
    [MBProgressHUD showMessage:nil toView:self.view ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //工作日志对应的logincname和id
    NSString *logLogicalAndId = [NSString stringWithFormat:@"%@,%@",self.saleList.LogicalName,self.saleList.Id];
    params[@"new_work_date_reportid"] = logLogicalAndId;
    //服务内容对应的logincname和id
    NSString *serviceLogincalAndId = [NSString stringWithFormat:@"%@,%@",self.serviceContentSaleList.LogicalName,self.serviceContentSaleList.Id];
    params[@"new_customer_service_contentid"] = serviceLogincalAndId;
    
    //实际数量
    if (self.realityNum) {
        params[@"new_performance"] = self.realityNum;

    }else{
        self.realityNum = @"";
    }
    //服务说明
    if (self.serviceIntro) {
        params[@"new_customer_service_content_des"] = self.serviceIntro;
    }
    //服务对象
    if (self.servicePerson) {
        params[@"new_contact"] = self.servicePerson;
    }
    //电话
    if (self.telephone) {
        params[@"new_tel"] = self.telephone;
    }
    //产品型号
    if (self.productType) {
        params[@"new_producttype"] = self.productType;
    }

    NSString *urlString = kCreateLogDetail;
    
    //点击保存按钮，在保存返回之前，该按钮不允许多次点击
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    
    [ZYFHttpTool putWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        
        if (code.intValue == 1) {
            [MBProgressHUD showSuccess:@"创建成功"];
            //通知上一级界面更新已经创建好的工作日志明细
            if ([self.delegate respondsToSelector:@selector(addLogDetailController:didFinishCreate:)]) {
                [self.delegate addLogDetailController:self didFinishCreate:YES];
            }
        }else{
            [MBProgressHUD showError:msg];
        }

        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getSectionArray].count;
}

-(NSMutableArray *)detailData
{
    if (_detailData == nil) {
        _detailData = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",nil];
    }
    return _detailData;
}

-(NSArray *)getSectionArray
{
    self.textData = @[@"服务内容",@"服务数量",@"服务说明",@"服务对象",@"电话",@"产品型号"];
    return self.textData;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"zyflogdetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[self getSectionArray]objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.detailData objectAtIndex:indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ServiceContentController *servContentCtrl = [[ServiceContentController alloc]init];
        //        servContentCtrl.sale = self.sale;
        servContentCtrl.delegate = self;
        servContentCtrl.showCheckmark = NO;
        [self.navigationController pushViewController:servContentCtrl animated:YES];
    }
    if (indexPath.row == 1) {
        //实际数量
        if (self.isNum) {
            //可以编辑
            ZYFEditStringController *editCtrl = [[ZYFEditStringController alloc]init];
            editCtrl.delegate = self;
            editCtrl.showNumKeyboard = YES;
            NSMutableArray *cellDataArray = [NSMutableArray array];
            [cellDataArray addObject:@"实际数量"];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell.detailTextLabel.text) {
                [cellDataArray addObject:cell.detailTextLabel.text];
            }else{
                [cellDataArray addObject:@""];
            }
            editCtrl.cellData = cellDataArray;
            
            [self.navigationController pushViewController:editCtrl animated:YES];
        }else{
            //不可以编辑
            [MBProgressHUD showError:@"请先选择合适的内容类型"];
        }
        
    }
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5) {
        //服务说明,服务对象，电话
        ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
        ctrl.editable = YES;
        //给ctrl 的文本框赋值
        ctrl.textString = @"";
        ctrl.delegate = self;
        if (indexPath.row == 4) {
            //电话
            ctrl.keyType = UIKeyboardTypePhonePad;
        }
        //记录下点击的哪一行
        ctrl.view.tag = indexPath.row;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
}

#pragma mark -- ZYFShowLongStringControllerDelegate
- (void)showLongStringController:(ZYFShowLongStringController *)ctrl editString:(NSString *)editString
{
    //ctrl.view.tag中存放的是点击的行号
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ctrl.view.tag inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = editString;
    if ([cell.textLabel.text isEqualToString:@"服务说明"]) {
        self.serviceIntro = cell.detailTextLabel.text;
    }else if ([cell.textLabel.text isEqualToString:@"服务对象"]){
        self.servicePerson = cell.detailTextLabel.text;
    }else if ([cell.textLabel.text isEqualToString:@"电话"]){
        self.telephone = cell.detailTextLabel.text;
    }else if ([cell.textLabel.text isEqualToString:@"产品型号"]){
        self.productType = cell.detailTextLabel.text;
    }
}

#pragma mark -- ServiceContentControllerDelegate

-(void)serviceContentController:(ServiceContentController *)ctrl didSelectedRow:(NSString *)rowString serviceIntro:(NSString *)serviceIntro isNum:(BOOL)isNum
{
    //修改服务内容文本
    NSIndexPath *indexpath1 =  [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *serviceContentCell = [self.tableView cellForRowAtIndexPath:indexpath1];
    serviceContentCell.detailTextLabel.text = rowString;
    //服务说明的文本根据服务内容的文本进行相应地调整
    NSIndexPath *indexpath2 =  [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *serviceIntroCell = [self.tableView cellForRowAtIndexPath:indexpath2];
    serviceIntroCell.detailTextLabel.text = serviceIntro;
    self.num = isNum;
}

-(void)serviceContentController:(ServiceContentController *)ctrl saleList:(ZYFSaleList *)saleList
{
    self.serviceContentSaleList = saleList;
}

-(void)editStringController:(ZYFEditStringController *)ctrl editString:(NSString *)editString
{
    //实际数量
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = editString;
    //    [self.tableView reloadData];
    self.realityNum = editString;
}

@end
