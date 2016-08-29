//
//  TaskContentController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/20.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "TaskContentController.h"
#import "ZYFDelayApplyController.h"
#import "LogsController.h"
#import "DelaysController.h"
#import "ServerContentController.h"
#import "ZYFEditStringController.h"
#import "ZYFEditDateController.h"
#import "ZYFEditLookupController.h"
#import "CleanDefectController.h"
#import "ZYFShowLongStringController.h"
#import "HandleResultController.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFHttpTool.h"
#import "ZYFUrlTask.h"
#import "TQTaskController.h"
#import "ProblemsController.h"
#import "CRMHelper.h"
#import "AFNetworking.h"


#define kType @"taiqu"

@interface TaskContentController () <HandleResultControllerDelegate,ZYFShowLongStringControllerDelegate,ProblemsControllerDelegate>

@property (nonatomic,strong) ZYFSaleList *saleList ;
@property (nonatomic,strong) NSArray *taskArray;

@end

@implementation TaskContentController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"任务内容"];
    if (self.segmentIndex == 0) {
        //集抄
        [self getDataFromServer:1 url:kMainTaskMuster];
    }else if (self.segmentIndex == 1){
        //台区
        [self getDataFromServer:1 url:kMainTaskCollect];
    }else if (self.segmentIndex == 2){
        //公专变
        [self getDataFromServer:1 url:kMainTaskElectricMeter];
    }
}

- (NSString *)getUrlStringWithType:(NSString *)type
{
    if ([type isEqualToString:@"jichao"]) {
        return kMainTaskMuster;
    }else if ([type isEqualToString:@"taiqu"]){
        return kMainTaskCollect;
    }else{
        return kMainTaskElectricMeter;
    }
}

- (void)getDataFromServer:(NSInteger)page url:(NSString *)urlStr
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    NSString *urlString = [NSString stringWithFormat:@"%@?page=%ld",urlStr,page];
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.taskArray = (NSArray *)json;
        if (self.taskArray.count > 0) {
            self.saleList = [self.taskArray objectAtIndex:self.indexRow];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.type isEqualToString:kType]) {
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.saleList.attrArray.count - 4;
    }else if(section == 1){
        return 4;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"taskContent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        NSLog(@"0000indexpath.section = %d,row=%d,text=%@",indexPath.section,indexPath.row,cell.detailTextLabel.text);
        
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
        //如果是问题大类、小类、处理结果、处理结果说明
        if ([attr.myKey isEqualToString:@"new_big_problem_categorie"] || [attr.myKey isEqualToString:@"new_small_problem_categorie"] || [attr.myKey isEqualToString:@"new_yw_resultstatus"] || [attr.myKey isEqualToString:@"new_result_note"]) {
            
        }else{
            cell.textLabel.text = [disPlayCol.nameArray objectAtIndex:indexPath.row];
            
            NSNumber *editable = [disPlayCol.editableArray objectAtIndex:indexPath.row];
            if (editable.intValue) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            if (attr) {
                cell.detailTextLabel.text = [self getValueString:attr];
            }
        }
        
    }
    if(indexPath.section == 1){
        NSLog(@"11111indexpath.section = %d,row=%d,text=%@",indexPath.section,indexPath.row,cell.detailTextLabel.text);
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {//问题大类
            cell.textLabel.text = @"问题大类";
            for (ZYFAttributes *attr in self.saleList.attrArray) {
                if ([attr.myKey isEqualToString:@"new_big_problem_categorie"]) {
                    cell.detailTextLabel.text = [self getValueString:attr];
                    break;
                }else{
                    cell.detailTextLabel.text = @"";
                }
            }
        }else if (indexPath.row == 1){//问题小类
            cell.textLabel.text = @"问题小类";
            for (ZYFAttributes *attr in self.saleList.attrArray) {
                if ([attr.myKey isEqualToString:@"new_small_problem_categorie"]) {
                    cell.detailTextLabel.text = [self getValueString:attr];
                    break;
                }else{
                    cell.detailTextLabel.text = @"";
                }
            }
        }else if (indexPath.row == 2){//处理结果说明
            cell.textLabel.text = @"处理结果说明";
            for (ZYFAttributes *attr in self.saleList.attrArray) {
                if ([attr.myKey isEqualToString:@"new_result_note"]) {
                    cell.detailTextLabel.text = [self getValueString:attr];
                    break;
                }else{
                    cell.detailTextLabel.text = @"";
                }
            }
        }else if (indexPath.row == 3){//处理结果
            cell.textLabel.text = @"处理结果";
            for (ZYFAttributes *attr in self.saleList.attrArray) {
                if ([attr.myKey isEqualToString:@"new_yw_resultstatus"]) {
                    cell.detailTextLabel.text = [self getValueString:attr];
                    break;
                }else{
                    cell.detailTextLabel.text = @"";
                }
            }
        }else{
            NSLog(@"indexpath.section = %d,row=%d,text=%@",indexPath.section,indexPath.row,cell.detailTextLabel.text);
            
        }
    }
    if(indexPath.section == 2){
        cell.textLabel.text = @"任务";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(NSString*)getValueString:(ZYFAttributes*)attr
{
    NSString *resultString = @"";
    
    if (attr.myValueString) {
        resultString = attr.myValueString;
    }else if(attr.lookUp){
        resultString = attr.lookUp.Name;
    }else if (attr.pickList){
        //如果是picklist类型，从formattedValue中（格式化后的）来显示
        for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
            if (format.myKey == NULL) {
                NSLog(@"format.mykey is null");
                break ;
            }else{
                if ([format.myKey isEqualToString:attr.myKey]) {
                    resultString = format.myValueString;
                }
            }
        }
    }else{
        //如果是date类型，从formattedValue中（格式化后的）来显示
        for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
            if (format.myKey == NULL) {
                NSLog(@"format.mykey is null222");
                break;
            }else{
                if ([format.myKey isEqualToString:attr.myKey]) {
                    resultString= format.myValueString;
                }
            }
        }
    }
    return resultString;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"indexpath.section = %d,row=%d",indexPath.section,indexPath.row);
    //    return;
    if (indexPath.section == 0) {
        ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        
        //如果是较长的字符串，需要用ZYFShowLongStringController来显示
        if ([attr.myKey isEqualToString:@"new_ammeter_install_position"] || [attr.myKey isEqualToString:@"new_user_address"] || [attr.myKey isEqualToString:@"new_operation_fault_details.new_collect_point_name"] || [attr.myKey isEqualToString:@"new_operation_tgid"]) {
            ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
            if (attr.myValueString) {
                ctrl.textString = attr.myValueString;
            }else if (attr.lookUp){
                ctrl.textString = attr.lookUp.Name;
            }
            [self.navigationController pushViewController:ctrl animated:YES];
            return;
        }
        
        //editable表示当前行是否需要编辑
        NSNumber *editable = [disPlayCol.editableArray objectAtIndex:indexPath.row];
        //type表示进行编辑时，根据当前行对应的类型显示对应的编辑界面
        NSString *type = [disPlayCol.valueArray objectAtIndex:indexPath.row];
        //name表示对应的中文名字
        NSString *name = [disPlayCol.nameArray objectAtIndex:indexPath.row];
        
        if (editable.intValue) {
            //如果可以编辑,跳转到相应地编辑界面
            
            if ([type isEqualToString:@"string"]) {
                ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
                ctrl.textString = attr.myValueString;
                ctrl.editable = YES;
                ctrl.indexPath = indexPath;
                ctrl.delegate = self;
                [self.navigationController pushViewController:ctrl animated:YES];
                return;
                
            }else if ([type isEqualToString:@"picklist"]){
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                ZYFEditLookupController *lookupCtrl = [[ZYFEditLookupController alloc]init];
                [self.navigationController pushViewController:lookupCtrl animated:YES];
            }else if ([type isEqualToString:@"lookup"]){
                //消缺类型明细（地图和照片）
                if ([attr.myKey isEqualToString:@"new_operation_fault_detailsid"]) {
                    CleanDefectController *cleanCtrl = [[CleanDefectController alloc]init];
                    cleanCtrl.saleList = self.saleList;
                    [self.navigationController pushViewController:cleanCtrl animated:YES];
                } else{
                    ZYFEditLookupController *lookupCtrl = [[ZYFEditLookupController alloc]init];
                    [self.navigationController pushViewController:lookupCtrl animated:YES];
                }
            }else if ([type isEqualToString:@"datetime"]){
                ZYFEditDateController *dateCtrl = [[ZYFEditDateController alloc]init];
                NSString *date = [self getValueString:attr];
                dateCtrl.date = date;
                [self.navigationController pushViewController:dateCtrl animated:YES];
            }else{
                //                NSLog(@"不是一个预先定义好的类型");
            }
            
        }else{
            //如果当前cell类型不可以编辑
            
        }
        
        
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"问题大类"]) {
            //问题大类
            ProblemsController *problemBigCtrl = [[ProblemsController alloc]init];
            problemBigCtrl.delegate = self;
            problemBigCtrl.isBigType = YES;
            //                    cleanCtrl.saleList = self.saleList;
            [self.navigationController pushViewController:problemBigCtrl animated:YES];
            return;
        }else if ([cell.textLabel.text isEqualToString:@"问题小类"]){
            //问题小类
            //1、首先判断问题大类的id是否存在
            @try {
                NSString *problemBigID = [ZYFUserDefaults objectForKey:ZYFProblemId];
            }
            @catch (NSException *exception) {
                [MBProgressHUD showError:@"请先选择问题大类"];
            }
            @finally {
                
            }
            
            ProblemsController *problemSmallCtrl = [[ProblemsController alloc]init];
            problemSmallCtrl.delegate = self;
            problemSmallCtrl.isBigType = NO;
            //                    cleanCtrl.saleList = self.saleList;
            [self.navigationController pushViewController:problemSmallCtrl animated:YES];
            return;
        }
        
        if ([cell.textLabel.text isEqualToString:@"处理结果"]) {
            //如果是处理结果
            HandleResultController *ctrl = [[HandleResultController alloc]init];
            ctrl.delegate = self;
            [self.navigationController pushViewController:ctrl animated:YES];
            return;
        }
        if ([cell.textLabel.text isEqualToString:@"处理结果说明"]) {
            //处理结果说明
            ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
            ctrl.textString = cell.detailTextLabel.text;
            ctrl.editable = YES;
            ctrl.delegate = self;
            ctrl.indexPath = indexPath;
            [self.navigationController pushViewController:ctrl animated:YES];
            return;
        }
        
    }else if (indexPath.section == 2){
        TQTaskController *ctrl = [[TQTaskController alloc]init];
        ctrl.TQSale = self.saleList;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma  mark -- HandleResultControllerDelegate

/**
 *  handleResultController的代理方法
 *
 *  @param ctrl        ctrl
 *  @param keyString   汉字描述部分
 *  @param valueString 对应的数字标识部分
 */
-(void)handleResultController:(HandleResultController *)ctrl key:(NSString *)keyString value:(NSString *)valueString
{
    [self updateServerData:valueString type:@"new_yw_resultstatus" keyString:keyString];
}

/**
 *  problemsController的代理方法
 *
 *  @param ctrl        ctrl
 *  @param keyString   汉字描述部分
 *  @param valueString 对应的数字标识部分
 */
-(void)problemsController:(ProblemsController *)ctrl key:(NSString *)keyString value:(NSString *)valueString
{
    if (ctrl.isBigType) {
        [self updateServerData:valueString type:@"new_big_problem_categorie" keyString:keyString];
    }else{
        [self updateServerData:valueString type:@"new_small_problem_categorie" keyString:keyString];
    }
    
}

-(void)updateServerData:(NSString *)editString type:(NSString*) typeString keyString:(NSString *)keyString
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[typeString] = editString;
    params[@"LogicalName"] = self.saleList.LogicalName;
    params[@"Id"] = self.saleList.Id;
    
    NSString *urlString = kHandleResult;
    [ZYFHttpTool postWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        if (code.intValue == 1) {
            //如果是问题大类
            if ([typeString isEqualToString:@"new_big_problem_categorie"]) {
                NSString *logicalName = @"new_concentrato_problem_categorie";
                //1是逗号
                NSString *problemId = [editString substringWithRange:NSMakeRange((logicalName.length + 1),editString.length - (logicalName.length + 1))];
                [ZYFUserDefaults setObject:problemId forKey:ZYFProblemId];
            }
            
            [self getDataFromServer:1 url:[self getUrlStringWithType:self.type]];
        }else{
            
        }
        [MBProgressHUD showSuccess:msg];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark -- ZYFShowLongStringControllerDelegate
-(void)showLongStringController:(ZYFShowLongStringController *)ctrl editString:(NSString *)editString
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ctrl.indexPath];
    NSString *cellText = cell.textLabel.text;
    if ([cellText isEqualToString:@"处理结果说明"]) {
        [self updateServerData:editString type:@"new_result_note" keyString:nil];
    }else if ([cellText isEqualToString:@"新铅封"]){
        [self updateServerData:editString type:@"new_new_item" keyString:nil];
    }else if ([cellText isEqualToString:@"旧铅封"]){
        [self updateServerData:editString type:@"new_old_item" keyString:nil];
    }
}


@end
