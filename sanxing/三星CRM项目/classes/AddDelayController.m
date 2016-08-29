//
//  AddDelayController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/22.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "AddDelayController.h"

#import "CRMHelper.h"
#import "ZYFDatePickerController.h"
#import "ZYFDelayApplyView.h"

#import "ZYFEditStringController.h"
#import "ZYFEditDateController.h"
#import "ZYFEditLookupController.h"

#import "ZYFUrl.h"
#import "AFNetworking.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"

@interface AddDelayController () <ZYFEditDateControllerDelegate>

@property (nonatomic,strong) UIView *dateView;
@property (nonatomic,copy) NSString *sectionTwoData;
@property (nonatomic,weak) ZYFDelayApplyView *footerView;
@property (nonatomic,copy) NSString *dateEnd;

@end

@implementation AddDelayController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
    ZYFDelayApplyView *footerView = [[ZYFDelayApplyView alloc]init];
    self.tableView.tableFooterView = footerView;
    self.footerView = footerView;
    
    //给textview设置键盘
    //    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    //    [self.tableView addGestureRecognizer:tapGesture];
    
}

-(void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  新加的延期申请，想服务器发送保存请求
 */
-(void)save
{
    if ((self.sectionTwoData == nil) || (self.sectionTwoData.length <= 0) || (self.footerView.textView.text == nil) || (self.footerView.textView.text.length <= 0)) {
        [MBProgressHUD showError:@"延期日期或原因不能为空"];
        return;
    }
    
    //1、获取到要求到达时间
    NSString *dateEnd = @"";
    NSString *delayTime = @"";
    for (ZYFAttributes *attr in self.saleList.attrArray) {
        NSLog(@"attr.mykey == %@",attr.myKey);
        if ([attr.myKey isEqualToString:@"new_mustarriveday"]) {
            dateEnd = attr.myDateTime;
        }
    }
    dateEnd = [dateEnd stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    //2、获取到延期申请时间，并格式化
    delayTime = [self.sectionTwoData stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    
    if (dateEnd > delayTime) {
        [MBProgressHUD showError:@"延期申请时间必须大于要求到达时间"];
        return;
    }
    
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlString = kDelayApplySave;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"new_delay_time"] = self.sectionTwoData;
    params[@"new_application_remark"] = self.footerView.textView.text;
    NSString *str = [NSString stringWithFormat:@"%@,%@",self.saleList.LogicalName,self.saleList.Id];
    params[@"new_customer_service_requireid"] = str;
    for (ZYFAttributes *attr in self.saleList.attrArray) {
        if ([attr.myKey isEqualToString:@"new_pre_time"]) {
            params[@"new_pre_time"] = attr.myValueString;
        }
    }
    //在等待网络请求的过程中，不允许再次点击保存按钮
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];

    [ZYFHttpTool putWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        
        if (code.intValue == 1) {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(delayApplyController:isFinished:)]) {
                    [self.delegate delayApplyController:self isFinished:YES];
                }
            }];
        }else{
            
        }
        [MBProgressHUD showSuccess:msg];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        self.navigationItem.rightBarButtonItem.enabled = NO;

        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.saleList.attrArray.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"zyfDelays";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        if (self.saleList == nil) {
            //            cell.textLabel.text = [[self getSectionOneData]objectAtIndex:indexPath.row];
        }else{
            ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
            ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
            cell.textLabel.text = [disPlayCol.nameArray objectAtIndex:indexPath.row];

            //根据是否可以编辑，设置cell显示样式
            NSNumber *editable = [disPlayCol.editableArray objectAtIndex:indexPath.row];
            if (editable.intValue) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            if (attr.myValueString) {
                cell.detailTextLabel.text = attr.myValueString;
            }else if(attr.lookUp){
                cell.detailTextLabel.text = attr.lookUp.Name;
            }else if (attr.pickList){
                //如果是picklist类型，从formattedValue中（格式化后的）来显示
                for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                    if ([format.myKey isEqualToString:attr.myKey]) {
                        cell.detailTextLabel.text = format.myValueString;
                    }
                }
            }else{
                //如果是date类型，从formattedValue中（格式化后的）来显示
                for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                    if ([format.myKey isEqualToString:attr.myKey]) {
                        cell.detailTextLabel.text = format.myValueString;
                    }
                }
            }
        }
    }else if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"延期到: ";
        cell.detailTextLabel.text = self.sectionTwoData;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        
        //editable表示当前行是否需要编辑
        NSNumber *editable = [disPlayCol.editableArray objectAtIndex:indexPath.row];
        //type表示进行编辑时，根据当前行对应的类型显示对应的编辑界面
        NSString *type = [disPlayCol.valueArray objectAtIndex:indexPath.row];
        //name表示对应的中文名字
        NSString *name = [disPlayCol.nameArray objectAtIndex:indexPath.row];
        
        if (editable.intValue) {
            //如果可以编辑,跳转到相应地编辑界面
            
            if ([type isEqualToString:@"string"]) {
                ZYFEditStringController *stringCtrl = [[ZYFEditStringController alloc]initWithStyle:UITableViewStyleGrouped];
                NSMutableArray *cellDataArray = [NSMutableArray array];
                [cellDataArray addObject:name];
                [cellDataArray addObject:[self getValueString:attr]];
                stringCtrl.cellData = cellDataArray;
                
                [self.navigationController pushViewController:stringCtrl animated:YES];
            }else if ([type isEqualToString:@"picklist"]){
                ZYFEditLookupController *lookupCtrl = [[ZYFEditLookupController alloc]init];
                [self.navigationController pushViewController:lookupCtrl animated:YES];
            }else if ([type isEqualToString:@"lookup"]){
                ZYFEditLookupController *lookupCtrl = [[ZYFEditLookupController alloc]init];
                [self.navigationController pushViewController:lookupCtrl animated:YES];
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
    }else if(indexPath.section == 1){
        ZYFEditDateController *datePicker = [[ZYFEditDateController alloc]init];
        datePicker.delegate = self;
        [self.navigationController pushViewController:datePicker animated:YES];
    }
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
            if ([format.myKey isEqualToString:attr.myKey]) {
                resultString = format.myValueString;
            }
        }
    }else{
        //如果是date类型，从formattedValue中（格式化后的）来显示
        for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
            if ([format.myKey isEqualToString:attr.myKey]) {
                resultString= format.myValueString;
            }
        }
    }
    return resultString;
}

-(NSArray*)getSectionOneData
{
    NSArray *sectionData = @[@"日志编号:",@"任务状态:",@"派工总结:",@"完成时间:"];
    return sectionData;
}


-(void)setDelayTime
{
    [self setDatePicker];
}

-(void)setDatePicker
{
    UIView *dateView = [[UIView alloc]init];
    [UIView animateWithDuration:1.0 animations:^{
        dateView.frame = CGRectMake(0, 0, kSystemScreenWidth, 250);
    } completion:^(BOOL finished) {
        
    }];
    //    CGFloat kHeight = 150.0;
    // 初始化UIDatePicker
    //    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,kSystemScreenHeight - kHeight, kSystemScreenWidth, kHeight)];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kSystemScreenHeight * 0.3, kSystemScreenWidth, kSystemScreenHeight)];
    
    // 设置时区
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    // 设置当前显示时间
    //    [datePicker setDate:tempDate animated:YES];
    // 设置显示最大时间（此处为当前时间）
    //    [datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    // 当值发生改变的时候调用的方法
    //    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [dateView addSubview:datePicker];
    self.dateView = dateView;
    
    // 获得当前UIPickerDate所在的时间
    NSDate *selected = [datePicker date];
}

#pragma mark - ZYFEditDateControllerDelegate

-(void)editDateChanged:(ZYFEditDateController *)editDateCtrl dateStr:(NSString *)dateString
{
    self.sectionTwoData = dateString;
    [self.tableView reloadData];
}

-(NSString *)sectionTwoData
{
    if (_sectionTwoData == nil) {
        _sectionTwoData = @"";
    }
    return _sectionTwoData;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
