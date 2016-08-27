//
//  OnDutyLog.m
//  telecom
//
//  Created by ZhongYun on 14-8-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "OnDutyLog.h"
#import "CompAlertBox.h"
#import "FilterCompSelect.h"
#import "NSThread+Blocks.h"
#import "OnDutyLogTemp.h"
#import "OnDutyLogHistory.h"

#define MEMO_BOX_ROW_NUM   3

BOOL userLogAuthor();

@interface OnDutyLog ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>
{
    NSMutableArray* m_sites;
    NSMutableArray* m_batchs;
    NSMutableArray* m_models;
    NSMutableArray* m_bodys;
    NSMutableDictionary* m_selectData;
    
    AlertBox* m_datePicker;
    UITableView* m_table;
    NSArray* m_titleList;

    NSDictionary* m_orgInfo;
    
    NSInteger m_modelIndex;
    NSString* m_modelText;
    NSString* m_inputHumidity;
    NSString* m_inputTemperature;
    NSString* m_inputMemo;
    NSString* m_startDate;
    NSString* m_endDate;
    
    BOOL bisInitLogData;
    BOOL bisAudited;
    
    UIButton* m_checkBtn;
    UIButton* m_signBtn;
    
    NSString* m_AuditText;
    UITextView* m_alertInput;
    AlertBox* m_alertBox;
    
    BOOL m_isLogAuditor;
    BOOL m_isLogViewor;
}
@end

@implementation OnDutyLog

- (void)dealloc
{
//    [m_sites release];
//    [m_models release];
//    [m_batchs release];
//    [m_bodys release];
//    [m_selectData release];
//    [m_orgInfo release];
//    
//    [m_titleList release];
//    [m_table release];
//    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bisAudited = NO;
        m_isLogAuditor = userLogAuthor(1);
        m_isLogViewor = userLogAuthor(2);
        
        bisInitLogData = NO;
        m_orgInfo = nil;
        NSArray* list4 = UGET(U_CONFIG)[@"list4"];
        if (list4.count > 0) {
            m_orgInfo = [list4[0] mutableCopy];
        }
        
        m_sites = [[NSMutableArray alloc] init];
        m_models = [[NSMutableArray alloc] init];
        m_batchs = [[NSMutableArray alloc] init];
        m_bodys = [[NSMutableArray alloc] init];
        
        httpGET1(@{URL_TYPE:NW_ZbLogDict}, ^(id result) {
            
            NSLog(@"result--%@",result);
            
            for (NSDictionary* item in result[@"list"]) {
                if ([item[@"dictId"] isEqualToString:@"site"]) {
                    [m_sites addObjectsFromArray:item[@"dictList"]];
                    for (NSMutableDictionary* item in m_sites) {
                        item[@"ID"] = format(@"%@_%@", item[@"ID"], item[@"NAME"]);
                    }
                } else if ([item[@"dictId"] isEqualToString:@"batch"]) {
                    [m_batchs addObjectsFromArray:item[@"dictList"]];
                } else if ([item[@"dictId"] isEqualToString:@"model"]) {
                    [m_models addObjectsFromArray:item[@"dictList"]];
                } else if ([item[@"dictId"] isEqualToString:@"body"]) {
                    [m_bodys addObjectsFromArray:item[@"dictList"]];
                    mainThread(selectCurrBodys, nil);
                }
            }
            mainThread(initDataByLogData, nil);
        });
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"值班日志";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    m_checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                      (NAV_H-checkIcon.size.height)/2,
                                                      checkIcon.size.width, checkIcon.size.height)];
    [m_checkBtn setBackgroundImage:checkIcon forState:0];
    [m_checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    m_checkBtn.hidden = bisAudited || (!m_isLogAuditor && self.logData);
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:m_checkBtn];
//    [self.navBarView addSubview:m_checkBtn];
    
    UIImage* signIcon = [UIImage imageNamed:(self.logId ? @"log_audit.png" : @"log_history.png")];
    m_signBtn = [[UIButton alloc] initWithFrame:m_checkBtn.frame];
    m_signBtn.fx = m_signBtn.fx - 10 - signIcon.size.width;
    [m_signBtn setBackgroundImage:signIcon forState:0];
    [m_signBtn addTarget:self action:@selector(onSignBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    m_signBtn.hidden = bisAudited || (!m_isLogAuditor && self.logData);
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:m_signBtn];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
//    [self.navBarView addSubview:m_signBtn];
    
    NSArray* tmplist = @[@"填表人", @"值班组织", @"站点名称", @"值班人", @"值班日期",
                         @"值班班次", @"湿度(%)", @"温度(℃)", @"起始日期", @"结束日期",
                         @"值班内容", @"值班备注", @"审核备注"];
    m_titleList = [[NSArray alloc] initWithArray:tmplist];
    
    m_selectData = [[NSMutableDictionary alloc] init];
    m_selectData[@2] = [@{@"list":m_sites} mutableCopy];
    m_selectData[@3] = [@{@"list":m_bodys} mutableCopy];
    m_selectData[@5] = [@{@"list":m_batchs} mutableCopy];
    m_modelIndex = -1;
    m_modelText = @"";
    
    m_table = [[UITableView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-NAV_H)
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = 34;
    m_table.delegate = self;
    m_table.dataSource = self;
    m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:m_table];
    
    [self initDatePickers];
    
    if (self.logId && !bisAudited && m_isLogAuditor) {
        [self getAuditTextField];
    }
}

- (void)setLogData:(NSDictionary *)logData
{
    _logData = logData;
    
    bisAudited = ([self.logData[@"contentStatus"] intValue]==1);
    [self initDataByLogData];
}

- (void)selectCurrBodys
{
    NSString* uname = UGET(U_NAME);
    for (int i=0; i<m_bodys.count; i++) {
        if ([m_bodys[i][@"NAME"] isEqualToString:uname]) {
            m_selectData[@3][@"selected"] = [@[@(i)] mutableCopy];
            
            UITableViewCell* cell = [m_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            if (cell && tagView(cell, 51)) {
                tagViewEx(cell, 51, UITextField).text = m_bodys[i][@"NAME"];
            }
            return;
        }
    }
}

BOOL issame(NSString* p1, NSString* p2)
{
    NSString* tmp1 = NoNullStr(p1);
    NSString* tmp2 = NoNullStr(p2);
    if (tmp1.length>0 && tmp2.length>0) {
        return [tmp1 isEqualToString:tmp2];
    } else if (tmp1.length==0 && tmp2.length==0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)bisLogChanged
{
    NSMutableDictionary* paras = [self getTttpParams];
    if (!issame(self.logData[@"siteName"], paras[@"siteName"]) ||
        !issame(self.logData[@"workBody"], paras[@"userId"]) ||
        !issame(self.logData[@"workDate"], paras[@"workDate"]) ||
        !issame(self.logData[@"batchId"], paras[@"batchId"]) ||
        !issame(self.logData[@"humiDity"], paras[@"humiDity"]) ||
        !issame(self.logData[@"temperature"], paras[@"temperature"]) ||
        !issame(self.logData[@"content"], paras[@"content"]) ||
        !issame(self.logData[@"memo"], paras[@"memo"])  )
    {
        return YES;
    }
        
        
//    if (   ![self.logData[@"siteName"] isEqualToString:paras[@"siteName"]]
//        || ![self.logData[@"workBody"] isEqualToString:paras[@"userId"]]
//        || ![self.logData[@"workDate"] isEqualToString:paras[@"workDate"]]
//        || ![self.logData[@"batchId"] isEqualToString:paras[@"batchId"]]
//        || ![self.logData[@"humiDity"] isEqualToString:paras[@"humiDity"]]
//        || ![self.logData[@"temperature"] isEqualToString:paras[@"temperature"]]
//        || ![self.logData[@"content"] isEqualToString:paras[@"content"]]
//        || ![self.logData[@"memo"] isEqualToString:paras[@"memo"]]  )
//    {
//        return YES;
//    }
    return NO;
}

- (NSMutableDictionary*)getTttpParams
{
    NSMutableDictionary* paras = [[NSMutableDictionary alloc] init];
    paras[URL_TYPE] = NW_ZbLogAdd;
    
    if (m_selectData[@2][@"selected"] != nil) {
        NSInteger selected = [m_selectData[@2][@"selected"] intValue];
        paras[@"siteName"] = m_sites[selected][@"NAME"];
    }
    
    NSArray* sellist = m_selectData[@3][@"selected"];
    NSMutableArray* names = [NSMutableArray array];
    for (id sel in sellist) {
        [names addObject:m_bodys[[sel intValue]][@"NAME"]];
    }
    paras[@"userId"] = [[names componentsJoinedByString:@","] copy];
    
    paras[@"workDate"] = date2str(((UIDatePicker*)m_datePicker.contentView).date, DATE_FORMAT);
    
    if (m_selectData[@5][@"selected"] != nil) {
        NSInteger selected = [m_selectData[@5][@"selected"] intValue];
        paras[@"batchId"] = m_batchs[selected][@"ID"];
    }
    
    if (m_inputHumidity && m_inputHumidity.length > 0) {
        paras[@"humiDity"] = m_inputHumidity;
    }
    
    if (m_inputTemperature && m_inputTemperature.length > 0) {
        paras[@"temperature"] = m_inputTemperature;
    }
    
    paras[@"startDate"] = m_startDate;
    paras[@"endDate"] = m_endDate;
    
    if (m_modelText && m_modelText.length > 0) {
        paras[@"content"] = m_modelText;
    }
    
    if (m_inputMemo && m_inputMemo.length>0) {
        paras[@"memo"] = m_inputMemo;
    }
    
    if (self.logId && self.logId.length>0) {
        paras[@"dutyContentId"] = self.logId;
    }
    return paras;
}

- (void)onCheckBtnTouched:(id)sender
{
    [self.view endEditing:YES];
    if (![self bVerifyInput]) return;
    
    NSMutableDictionary* paras = [self getTttpParams];
    
    httpGET1(paras, ^(id result) {
        showAlert(@"日志保存成功！");
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)onSignBtnTouched:(id)sender
{
    if (self.logId) {
        [m_alertBox show];
    } else {
        OnDutyLogHistory* vc = [[OnDutyLogHistory alloc] init];
        vc.bodys = m_bodys;
        [self.navigationController pushViewController:vc animated:YES];
//        [vc release];
    }
}

- (void)initDatePickers
{
    [NSThread performBlockOnMainThread:^{
        if (!m_datePicker) {
            m_datePicker = newDatePickerBox();
            ((UIDatePicker*)m_datePicker.contentView).minimumDate = nil;
            ((UIDatePicker*)m_datePicker.contentView).maximumDate = [NSDate date];
            [self.view addSubview:m_datePicker];
            m_datePicker.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_datePicker.contentView).date, DATE_FORMAT);
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
                    UITableViewCell* cell = [m_table cellForRowAtIndexPath:indexPath];
                    tagViewEx(cell, 51, UITextField).text = strDate;
                    mainThread(updatePeriod, nil);
                }
            };
            
            mainThread(initDataByLogData, nil);
        }
    }];
}

- (void)updatePeriod
{
    NSString* batchName = tagViewEx([m_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]], 51, UITextField).text;
    if (NoNullStr(batchName).length == 0) return;
    
    NSString* workdate = tagViewEx([m_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]], 51, UITextField).text;
    
    NSInteger selected = [m_selectData[@5][@"selected"] intValue];
    NSString* batchId = m_batchs[selected][@"ID"];
    
    httpGET1(@{URL_TYPE:NW_GetBatchTime, @"workdate":workdate, @"batchId":batchId}, ^(id result) {
        tagViewEx([m_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]], 51, UITextField).text = result[@"detail"][@"dutyStartTime"];
        tagViewEx([m_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]], 51, UITextField).text = result[@"detail"][@"dutyEndTime"];
        
        m_startDate = [result[@"detail"][@"dutyStartTime"] copy];
        m_endDate = [result[@"detail"][@"dutyEndTime"] copy];
    });
}


- (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)bVerifyInput
{
//    if (m_selectData[@2][@"selected"] == nil) {
//        showAlert( format(@"%@不能为空", m_titleList[2]) );
//        return NO;
//    }

    if (((NSArray*)m_selectData[@3][@"selected"]).count == 0) {
        showAlert( format(@"%@不能为空", m_titleList[3]) );
        return NO;
    }

    if (m_selectData[@5][@"selected"] == nil) {
        showAlert( format(@"%@不能为空", m_titleList[5]) );
        return NO;
    }
    
    //-----------------------------------------------------------------
    if (!m_inputHumidity || m_inputHumidity.length == 0) {
//        showAlert( format(@"%@不能为空", m_titleList[6]) );
//        return NO;
    } else {
        if (![self isPureFloat:m_inputHumidity]) {
            showAlert( @"湿度(%)值为无效数字" );
            return NO;
        }
        
        CGFloat fhumidity = [m_inputHumidity floatValue];
        if (fhumidity<0 || fhumidity>100) {
            showAlert( @"湿度(%)超出有效范围(0~100)" );
            return NO;
        }
    }
    
    //-----------------------------------------------------------------
    if (!m_inputTemperature || m_inputTemperature.length == 0) {
//        showAlert( format(@"%@不能为空", m_titleList[7]) );
//        return NO;
    } else {
        if (![self isPureFloat:m_inputTemperature]) {
            showAlert( @"温度(℃)值为无效数字" );
            return NO;
        }
        
//        CGFloat ftempl = [m_inputTemperature floatValue];
//        if (ftempl<0 || ftempl>100) {
//            showAlert( @"温度(℃)超出有效范围(0~100)" );
//            return NO;
//        }
    }
    
    //-----------------------------------------------------------------
    if (!m_modelText || m_modelText.length == 0) {
        showAlert( format(@"%@不能为空", m_titleList[10]) );
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (bisAudited || (!m_isLogAuditor && self.logData)) return NO;
    return YES;
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -= 220;
    frame.size.height += 220;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%d",textField.tag);
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -= 200;
    frame.size.height += 200;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger row = parentCellIndexPath(textField).row;
    if (row == 6) {
        m_inputHumidity = [format(@"%@", textField.text) copy];
    }
    if (row == 7) {
        m_inputTemperature = [format(@"%@", textField.text) copy];
    }
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

#pragma mark - UITextViewDelegate


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (bisAudited || (!m_isLogAuditor && self.logData)){
        return NO;
    }else{
       return YES;
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y -= 320;
        frame.size.height += 320;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    
    
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -= 320;
    frame.size.height += 320;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];

}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSInteger row = parentCellIndexPath(textView).row;
    if (row == 11) {
        m_inputMemo = [textView.text copy];
    }
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowheight = m_table.rowHeight;
    if (indexPath.row == 10) {
        if (m_modelText.length > 0) {
            CGFloat txt_h = getTextHeight(m_modelText, Font(Font3), APP_W-45);
            rowheight = m_table.rowHeight + txt_h + 10;
        }
    }
    if (indexPath.row == 11) {
        rowheight = m_table.rowHeight*(MEMO_BOX_ROW_NUM+1)+10;
    }
    
    if (indexPath.row == 12) {
        rowheight = (bisAudited ? m_table.rowHeight*(MEMO_BOX_ROW_NUM+1)+10 : 0);
    }
    
    return rowheight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (bisAudited || (!m_isLogAuditor && self.logData)) return;
    
    if (m_selectData[@(indexPath.row)] != nil) {
        [self.view endEditing:YES];
        
        NSMutableDictionary* refInfo = m_selectData[@(indexPath.row)];
        FilterCompSelect* vc = [[FilterCompSelect alloc] init];
        if (indexPath.row == 3) {
            vc.multiModule = YES;
            vc.multiSelected = refInfo[@"selected"];
        } else {
            vc.selected = (refInfo[@"selected"]==nil ? -1 : [refInfo[@"selected"] intValue]);
        }
        vc.data = refInfo[@"list"];
        vc.idKey = @"ID";
        vc.nameKey = @"NAME";
        vc.respBlock = ^(NSInteger selected){
            refInfo[@"selected"] = @(selected);
            UITableViewCell* cell = [m_table cellForRowAtIndexPath:indexPath];
            tagViewEx(cell, 51, UITextField).text = refInfo[@"list"][selected][@"NAME"];
            if ([m_titleList[indexPath.row] isEqualToString:@"值班班次"]) {
                mainThread(updatePeriod, nil);
            }
        };
        vc.respMultiBlock = ^(id selected){
            refInfo[@"selected"] = [selected mutableCopy];
            [m_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        };
        [self.navigationController pushViewController:vc animated:YES];
//        [vc release];
    } else if ([m_titleList[indexPath.row] isEqualToString:@"值班日期"]) {
        [m_datePicker show];
    } else if ([m_titleList[indexPath.row] isEqualToString:@"值班内容"]) {
        OnDutyLogTemp* vc = [[OnDutyLogTemp alloc] init];
        vc.data = m_models;
        vc.defIndex = m_modelIndex;
        vc.defText = tagViewEx([m_table cellForRowAtIndexPath:indexPath], 52, UILabel).text;
        vc.respBlock = ^(id resp) {
            m_modelIndex = [resp[@"selected"] integerValue];
            m_modelText = [resp[@"text"] copy];
            UITableViewCell* cell = [m_table cellForRowAtIndexPath:indexPath];
            
            if (m_modelIndex >= 0) {
                tagViewEx(cell, 51, UITextField).text = m_models[m_modelIndex][@"NAME"];
            } else {
                tagViewEx(cell, 51, UITextField).text = @"   ";
            }
            tagViewEx(cell, 52, UILabel).text = m_modelText;
            
            [m_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        };
        [self.navigationController pushViewController:vc animated:YES];
//        [vc release];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* str = [NSString stringWithFormat:@"cell_%@", m_titleList[indexPath.row]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.clipsToBounds = YES;
        
        newLabel(cell, @[@50, RECT_OBJ(10, 10, 65, Font3), RGB(0x006cc3), FontB(Font3), @""]);
        if (indexPath.row <= 10) {
            newTextField(cell, @[@51, RECT_OBJ(77, 1, APP_W-30-75, m_table.rowHeight-2), [UIColor blackColor], Font(Font3), @"", @""]).delegate = self;
            if (indexPath.row == 10) {
                newLabel(cell, @[@52, RECT_OBJ(15, m_table.rowHeight, APP_W-45, 0), [UIColor blackColor], Font(Font3), @""]);
            }
        }
        if (indexPath.row==11 || indexPath.row==12) {
            newTextView(cell, @[@51, RECT_OBJ(15, m_table.rowHeight, APP_W-45, m_table.rowHeight*MEMO_BOX_ROW_NUM), [UIColor blackColor], Font(Font3), @""]).delegate = self;
        }
        
        if (indexPath.row == 6 || indexPath.row == 7) {
            tagViewEx(cell, 51, UITextField).keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            tagViewEx(cell, 51, UITextField).returnKeyType = UIReturnKeyDone;
        }
    }
    
    tagViewEx(cell, 50, UILabel).text  = m_titleList[indexPath.row];
    
    if ([tagView(cell, 51) isKindOfClass:[UITextField class]]) {
        tagViewEx(cell, 51, UITextField).enabled = ([@[@6, @7] containsObject:@(indexPath.row)]);
        cell.accessoryType = (([@[@0, @1, @6, @7, @8, @9, @11, @12] containsObject:@(indexPath.row)]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator);
        
        if ([@[@6, @7] containsObject:@(indexPath.row)]) {
            tagViewEx(cell, 51, UITextField).placeholder = format(@"请输入%@", m_titleList[indexPath.row]);
        }
        
        
        if ([@[@2, @3, @4, @5, @10] containsObject:@(indexPath.row)]) {
            tagViewEx(cell, 51, UITextField).placeholder = format(@"请选择%@", m_titleList[indexPath.row]);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.row == 0) {
        tagViewEx(cell, 51, UITextField).text = (bisInitLogData ? self.logData[@"createUserName"]: UGET(U_NAME));
    }
    if (indexPath.row == 1) {
        tagViewEx(cell, 51, UITextField).text = (bisInitLogData ? self.logData[@"orgName"] : m_orgInfo[@"orgName"]);
    }
    if (indexPath.row==2 && bisInitLogData) {
        id selObj = m_selectData[@(indexPath.row)][@"selected"];
        if (selObj != nil) {
            int selected = [selObj intValue];
            tagViewEx(cell, 51, UITextField).text = m_sites[selected][@"NAME"];
        }
    }
    if (indexPath.row==3) {
        NSArray* sellist = m_selectData[@(indexPath.row)][@"selected"];
        NSMutableArray* tmplist = [NSMutableArray array];
        for (id index in sellist) {
            [tmplist addObject:m_bodys[[index intValue]][@"NAME"]];
        }
        tagViewEx(cell, 51, UITextField).text = [tmplist componentsJoinedByString:@","];
    }
    if (indexPath.row == 4) {
        NSDate* date = (m_datePicker ? ((UIDatePicker*)m_datePicker.contentView).date : [NSDate date]);
        tagViewEx(cell, 51, UITextField).text = date2str(date, DATE_FORMAT);
    }
    if (indexPath.row == 5 && bisInitLogData) {
        int selected = [m_selectData[@(indexPath.row)][@"selected"] intValue];
        tagViewEx(cell, 51, UITextField).text = m_batchs[selected][@"NAME"];
    }
    if (indexPath.row == 6 && bisInitLogData ){
        tagViewEx(cell, 51, UITextField).text = m_inputHumidity;
    }
    if (indexPath.row == 7 && bisInitLogData ){
        tagViewEx(cell, 51, UITextField).text = m_inputTemperature;
    }
    if (indexPath.row == 8 && bisInitLogData ){
        tagViewEx(cell, 51, UITextField).text = m_startDate;
    }
    if (indexPath.row == 9 && bisInitLogData ){
        tagViewEx(cell, 51, UITextField).text = m_endDate;
    }
    if (indexPath.row == 10) {
        tagView(cell, 51).hidden = m_modelText.length>0;
        tagView(cell, 52).hidden = !(tagView(cell, 51).hidden);
        
        if (m_modelIndex >= 0) {
            tagViewEx(cell, 51, UITextField).text = m_models[m_modelIndex][@"NAME"];
        }
        
        tagViewEx(cell, 52, UILabel).text = m_modelText;
        tagView(cell, 52).fh = getTextHeight(m_modelText, Font(Font3), APP_W-45);
    }
    
    if (indexPath.row == 11 && bisInitLogData ){
        tagViewEx(cell, 51, UITextView).text = m_inputMemo;
    }
    
    if (indexPath.row == 12 && bisInitLogData ){
        tagViewEx(cell, 51, UITextView).text = self.logData[@"confirmboydmemo"];
    }
    
    if (bisAudited || (!m_isLogAuditor && self.logData)) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (void)initDataByLogData
{
    if (!self.logData || !m_datePicker || m_sites.count==0) return;
    
    for (int i=0; i<m_sites.count; i++) {
        if ([m_sites[i][@"NAME"] isEqualToString:self.logData[@"siteName"]]) {
            m_selectData[@2][@"selected"] = @(i);
            break;
        }
    }
    
    m_selectData[@3][@"selected"] = @(-1);
    NSArray* names = [self.logData[@"workBody"] componentsSeparatedByString:@","];
    NSMutableArray* sellist = [NSMutableArray array];
    for (int i=0; i<m_bodys.count; i++) {
        for (NSString* name in names) {
            if ([m_bodys[i][@"NAME"] isEqualToString:name]) {
                [sellist addObject:@(i)];
                break;
            }
        }
    }
    m_selectData[@3][@"selected"] = [sellist mutableCopy];
    
    ((UIDatePicker*)m_datePicker.contentView).date = str2date(self.logData[@"workDate"], DATE_FORMAT);
    
    for (int i=0; i<m_batchs.count; i++) {
        if ([m_batchs[i][@"ID"] isEqualToString:self.logData[@"batchId"]]) {
            m_selectData[@5][@"selected"] = @(i);
            break;
        }
    }
    
    m_inputHumidity = [format(@"%@", self.logData[@"humiDity"]) copy];
    m_inputTemperature = [format(@"%@", self.logData[@"temperature"]) copy];
    
    m_startDate = [format(@"%@", self.logData[@"workStartDate"]) copy];
    m_endDate = [format(@"%@", self.logData[@"workEndDate"]) copy];

    m_modelIndex = -1;
    m_modelText = [format(@"%@", self.logData[@"content"]) copy];
    m_inputMemo = [format(@"%@", self.logData[@"memo"]) copy];
    
    bisInitLogData = YES;
    [m_table reloadData];
}


- (void)getAuditTextField
{
    CGFloat view_w=APP_W-50, view_h=80;
    m_alertInput = [[UITextView alloc] initWithFrame:RECT(10, 0, view_w-20, view_h-10)];
    m_alertInput.textAlignment = NSTextAlignmentLeft;
    m_alertInput.font = Font(Font3);
    m_alertInput.text = @"";
    m_alertInput.returnKeyType = UIReturnKeyDone;
    m_alertInput.backgroundColor = [UIColor whiteColor];
    m_alertInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_alertInput.layer.borderWidth = 0.5;
    m_alertInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_alertInput.delegate = self;
    
    m_alertBox = [[AlertBox alloc] initWithContentSize:CGSizeMake(view_w, view_h) Btns:@[@"放弃", @"审核"]];
    m_alertBox.title = @"请输入审核备注";
    m_alertBox.contentView = m_alertInput;
    m_alertBox.respBlock = ^(int index) {
        [self.view endEditing:YES];
        if (index == BTN_OK) {
            m_AuditText = [m_alertInput.text copy];
            mainThread(auditDutyLog, nil);
        }
        m_alertInput.text = @"";
    };
    [self.view addSubview:m_alertBox];
}

- (void)auditDutyLog
{
    if ([self bisLogChanged]) {
        showAlert(@"请先提交修改内容");
        return;
    }
    
    httpGET1(@{URL_TYPE:NW_ZbLogConfirm, @"confirmBodyMemo":m_AuditText, @"dutyContentId":self.logId}, ^(id result) {
        NOTIF_POST(LOG_AUDIT_OVER, nil);
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end

BOOL userLogAuthor(int type)
{
    NSArray* list3 = UGET(U_CONFIG)[@"list3"];
    for (NSDictionary* item in list3) {
        if (([item[@"PrivillegeId"] intValue]==102) && (type==1)) {
            return YES; //有审核权
        }
        
        if (([item[@"PrivillegeId"] intValue]==108) && (type==2)) {
            return YES; //有浏览权
        }
    }
    return NO;
}

