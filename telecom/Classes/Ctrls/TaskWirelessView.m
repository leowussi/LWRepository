//
//  TaskWirelessView.m
//  telecom
//
//  Created by ZhongYun on 15-3-23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "TaskWirelessView.h"
#import "NSThread+Blocks.h"
#import "TaskWirelessInputText.h"
#import "TaskWirelessDetail.h"
#import "CompAlertBox.h"
#import "TaskFaultRisk.h"
#import "RadioBtnGroup.h"
#import "MemoInput.h"

#define ROW_H   44
#define TITLE_W (APP_W-45-60-30)
#define IS_TYPE(n)  ([dataRow[@"writeType"] rangeOfString:n].location != NSNotFound)
#define TAG_STAND_BTN  15539
#define TAG_FILES_BTN  15538

@interface TaskWirelessView()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView* m_table;
    NSArray* m_data;
    TaskWirelessDetail* m_parentVC;
    
    AlertBox* m_timePicker1;
    AlertBox* m_datePicker1;
    UIButtonEx* m_dateBtn;
    UIButtonEx* m_timeBtn;
    NSString* m_dateSubTaskId;
    BOOL m_isFirstPage;
    
    NSInteger textFiledTag;
}
@end

@implementation TaskWirelessView

- (void)dealloc
{
    [m_datePicker1 release];
    [m_timePicker1 release];
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        m_data = [[NSMutableArray alloc] init];
        m_table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        m_table.backgroundColor = [UIColor clearColor];
        m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        m_table.bounces = YES;
        m_table.rowHeight = ROW_H;
        m_table.delegate = self;
        m_table.showsHorizontalScrollIndicator = NO;
        m_table.showsVerticalScrollIndicator = NO;
        m_table.dataSource = self;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        m_table.tableFooterView = footerView;
        [footerView release];
        [self addSubview:m_table];
        
        [self initDatePickers];
        
        [self performSelector:@selector(initTimePickers) withObject:nil afterDelay:2];
    }
    return self;
}

- (void)initDatePickers
{
    [NSThread performBlockOnMainThread:^{
        if (!m_datePicker1) {
            m_datePicker1 = newDatePickerBox();
            [getViewController(self).view addSubview:m_datePicker1];
            m_datePicker1.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_datePicker1.contentView).date, DATE_FORMAT);
                    [m_dateBtn setTitle:strDate forState:0];
                    [m_parentVC changeSubTask:m_dateSubTaskId Key:STK_CT Value:strDate];
                }
            };
        }
    }];
}

- (void)initTimePickers
{
    [NSThread performBlockOnMainThread:^{
        if (!m_timePicker1) {
            m_timePicker1 = newTimePickerBox();
            [getViewController(self).view addSubview:m_timePicker1];
            m_timePicker1.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_datePicker1.contentView).date, DATE_FORMAT);
                    NSString* strTime = date2str(((UIDatePicker*)m_timePicker1.contentView).date, @"HH:mm");
                    [m_dateBtn setTitle:strDate forState:0];
                    [m_timeBtn setTitle:strTime forState:0];
                    NSString* strValue = format(@"%@ %@", strDate, strTime);
                    [m_parentVC changeSubTask:m_dateSubTaskId Key:STK_CT Value:strValue];
                }
            };
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    m_parentVC = (TaskWirelessDetail*)getViewController(self);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%d",textField.tag);
    
    [m_table setContentInset:UIEdgeInsetsMake(0 , 0, 200, 0)];
    
    if (textField.tag > 300 && textField.tag <520) {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.frame;
        frame.origin.y -= textField.tag-200;
        frame.size.height += textField.tag-200;
        self.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame = frame;
        [UIView commitAnimations];

    }else if (textField.tag > 520) {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.frame;
        frame.origin.y -= textField.tag-250;
        frame.size.height += textField.tag-250;
        self.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame = frame;
        [UIView commitAnimations];
        
    }
    else{
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.frame;
        frame.origin.y -= textField.tag;
        frame.size.height += textField.tag;
        self.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame = frame;
        [UIView commitAnimations];
    }
}


- (void)setGroup:(NSDictionary *)group
{
    _group = [group retain];
    m_data = [self.group[@"groupContent"] mutableCopy];
    m_isFirstPage = ( [self.typeInfo[@"groupId"] intValue] == 0 );
    
    for (NSMutableDictionary* item in m_data) {
        CGSize titleSize = getTextSize(item[@"subTaskName"], FontB(Font2), TITLE_W);
        item[@"title_h"] = @(titleSize.height);
        item[@"row_h"] = @(titleSize.height + (ROW_H-Font2));
        item[@"extern_h"] = @0;

        if ( !m_isFirstPage ) {
            item[@"extern_h"] = @40;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [m_data[indexPath.row][@"row_h"] floatValue] + [m_data[indexPath.row][@"extern_h"] floatValue];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (m_data ? m_data.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"subTaskId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.clipsToBounds = YES;
        

        CGFloat title_h = [dataRow[@"title_h"] floatValue];
        CGFloat row_h = [dataRow[@"row_h"] floatValue];
        newLabel(cell, @[@50, RECT_OBJ(5, (row_h-title_h)/2, TITLE_W, title_h), RGB(0x666666), FontB(Font2), dataRow[@"subTaskName"]]);

        if ( !m_isFirstPage ) {
            [self cell_otherBtns:cell IndexPath:indexPath];
        }
        
        if ([dataRow[@"isAuto"] intValue] == 1) {
            [self cell_auto:cell IndexPath:indexPath];
        } else {
            if ( IS_TYPE(@"精确到天") ) {
                [self cell_date:cell IndexPath:indexPath];
            } else if ( IS_TYPE(@"精确到分") ) {
                [self cell_time:cell IndexPath:indexPath];
            } else if ( IS_TYPE(@"文本") ) {
                [self cell_text:cell IndexPath:indexPath];
            } else if ( IS_TYPE(@"数值") ) {
                [self cell_number:cell IndexPath:indexPath];
            } else if ( IS_TYPE(@"正常") || IS_TYPE(@"否") || IS_TYPE(@"室分") ) {
                [self cell_rediobtn:cell IndexPath:indexPath];
            } else if ( IS_TYPE(@"场强") || IS_TYPE(@"PCI")) {
                [self cell_dBm:cell IndexPath:indexPath];
            }
        }
        
    }

    return cell;
}

- (void)cell_auto:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    CGFloat row_h = [dataRow[@"row_h"] floatValue];
    CGFloat ext_h = [dataRow[@"extern_h"] floatValue];
  
    if ( m_isFirstPage ){
        UILabel* lbvalue = newLabel(cell, @[@51, RECT_OBJ(0, (row_h-Font3)/2, APP_W-5, Font3), RGB(0x666666), Font(Font3), dataRow[@"result"]]);
        lbvalue.textAlignment = NSTextAlignmentRight;
        //[lbvalue sizeToFit];
    } else {
        CGFloat fx = 5, fh = 30, fw = 60, fy = (ext_h - fh)/2 + tagView(cell, 50).ey + 7;
        UILabel* lbinfo = newLabel(cell, @[@60, RECT_OBJ(fx, fy, fw, fh), RGB(0x456af2), Font(Font3), @"执行操作"]);
        
        CGFloat txt_x = lbinfo.ex+5, txt_w = tagView(cell, 50).ex-txt_x - 20;
        UILabel* lbvalue = newLabel(cell, @[@51, RECT_OBJ(txt_x, lbinfo.fy, txt_w, lbinfo.fh), RGB(0x666666), Font(Font3), dataRow[@"result"]]);
        lbvalue.textAlignment = NSTextAlignmentLeft;
        //[lbvalue sizeToFit];
    }
}

- (void)cell_date:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    CGFloat row_h = [dataRow[@"row_h"] floatValue];
    
    UIButtonEx* btnDate = [[UIButtonEx alloc] initWithFrame:RECT(140, (row_h-30)/2, APP_W-5-140, 30)];
    btnDate.info = dataRow;
    btnDate.clipsToBounds = YES;
    btnDate.layer.borderColor = RGB(0x666666).CGColor;
    btnDate.layer.borderWidth = 0.5;
    btnDate.layer.cornerRadius = 4;
    btnDate.titleLabel.font = Font(Font3);
    [btnDate setTitle:dataRow[@"result"] forState:0];
    [btnDate setTitleColor:RGB(0x666666) forState:0];
    [btnDate setBackgroundImage:color2Image(RGB(0xeeeeee)) forState:0];
    [btnDate addTarget:self action:@selector(onBtnDateTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnDate];
    [btnDate release];
}

- (void)cell_time:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    CGFloat row_h = [dataRow[@"row_h"] floatValue];
    
    NSDate* resTime = str2date(dataRow[@"result"], @"yyyy-MM-dd HH:mm");
    
    UIButtonEx* btnDate = [[UIButtonEx alloc] initWithFrame:RECT(140, (row_h-30)/2, 105, 30)];
    btnDate.info = dataRow;
    btnDate.clipsToBounds = YES;
    btnDate.layer.borderColor = RGB(0x666666).CGColor;
    btnDate.layer.borderWidth = 0.5;
    btnDate.layer.cornerRadius = 4;
    btnDate.titleLabel.font = Font(Font3);
    [btnDate setTitle:date2str(resTime, DATE_FORMAT) forState:0];
    [btnDate setTitleColor:RGB(0x000000) forState:0];
    [btnDate setBackgroundImage:color2Image(RGB(0xeeeeee)) forState:0];
    [btnDate addTarget:self action:@selector(onBtnDateTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnDate];
    
    UIButtonEx* btnTime = [[UIButtonEx alloc] initWithFrame:RECT(btnDate.ex+5, (row_h-30)/2, APP_W-5-(btnDate.ex+5), 30)];
    btnTime.info = dataRow;
    btnTime.clipsToBounds = YES;
    btnTime.layer.borderColor = RGB(0x666666).CGColor;
    btnTime.layer.borderWidth = 0.5;
    btnTime.layer.cornerRadius = 4;
    btnTime.titleLabel.font = Font(Font3);
    [btnTime setTitle:date2str(resTime, @"HH:mm") forState:0];
    [btnTime setTitleColor:RGB(0x000000) forState:0];
    [btnTime setBackgroundImage:color2Image(RGB(0xeeeeee)) forState:0];
    [btnTime addTarget:self action:@selector(onBtnTimeTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnTime];
    
    [btnTime release];
    [btnDate release];
}

- (void)cell_text:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    CGFloat row_h = [dataRow[@"row_h"] floatValue];
    CGFloat ext_h = [dataRow[@"extern_h"] floatValue];
    
    float heigt = [m_data[indexPath.row][@"row_h"] floatValue] + [m_data[indexPath.row][@"extern_h"] floatValue];
    
    textFiledTag = indexPath.row*heigt;
    
    UITextField* textField = newTextField(cell, @[@51, RECT_OBJ(140, (row_h-30)/2, APP_W-5-140, 30), RGB(0x000000), Font(Font3), @"", dataRow[@"result"]]);
    textField.delegate = self;
    textField.tag = textFiledTag;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.borderColor = RGB(0x666666).CGColor;
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 4;
    
    if ( !m_isFirstPage ) {
        CGFloat fx = 5, fh = 30, fw = 60, fy = (ext_h - fh)/2 + tagView(cell, 50).ey + 7;
        UILabel* lbinfo = newLabel(cell, @[@60, RECT_OBJ(fx, fy, fw, fh), RGB(0x456af2), Font(Font3), @"执行操作"]);
        
        CGFloat txt_x = lbinfo.ex+5, txt_w = tagView(cell, 50).ex-txt_x - 20;
        textField.frame = RECT(txt_x, lbinfo.fy, txt_w, lbinfo.fh);
    }
}

- (void)cell_number:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    CGFloat ext_h = [dataRow[@"extern_h"] floatValue];
    
    CGFloat fx = 5, fh = 30, fw = 60, fy = (ext_h - fh)/2 + tagView(cell, 50).ey + 7;
    UILabel* lbinfo = newLabel(cell, @[@60, RECT_OBJ(fx, fy, fw, fh), RGB(0x456af2), Font(Font3), @"执行操作"]);
    
    CGFloat txt_x = lbinfo.ex+5, txt_w = tagView(cell, 50).ex-txt_x - 20;
    
    float heigt = [m_data[indexPath.row][@"row_h"] floatValue] + [m_data[indexPath.row][@"extern_h"] floatValue];
    
    textFiledTag = indexPath.row*heigt;
    
    UITextField* textField = newTextField(cell, @[@51, RECT_OBJ(txt_x, lbinfo.fy, txt_w, lbinfo.fh), RGB(0x000000), Font(Font3), @"", dataRow[@"result"]]);
    textField.delegate = self;
    textField.tag = textFiledTag;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.borderColor = RGB(0x666666).CGColor;
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 4;
}

- (void)cell_dBm:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    [self cell_number:cell IndexPath:indexPath];
    
    NSMutableDictionary* dataRow = m_data[indexPath.row];
//    CGFloat row_h = [dataRow[@"row_h"] floatValue] + [dataRow[@"extern_h"] floatValue];
    
    UIButtonEx* btnFiles = tagViewEx(cell, TAG_FILES_BTN, UIButtonEx);
    UIButtonEx* btnGuide = tagViewEx(cell, TAG_STAND_BTN, UIButtonEx);
    
    UIButtonEx* btnAutoGet = [[UIButtonEx alloc] initWithFrame:RECT(btnFiles.fx-btnFiles.fw-2, 7, btnFiles.fw*2, btnFiles.fh)];
    if (btnGuide != nil) {
        btnGuide.fw = 60;
        btnGuide.fx += 10;
        
        btnAutoGet.fw = btnGuide.fw;
        btnAutoGet.fx = btnGuide.fx - 1 - btnAutoGet.fw;
    }
    btnAutoGet.info = dataRow;
    btnAutoGet.clipsToBounds = YES;
    btnAutoGet.titleLabel.font = Font(Font3);
    [btnAutoGet setTitle:@"自动获取" forState:0];
    [btnAutoGet setTitleColor:RGB(0x000000) forState:0];
    [btnAutoGet addTarget:self action:@selector(onBtnAutoGetTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnAutoGet];
    UIView* line3 = [[UIView alloc] initWithFrame:RECT(2, btnAutoGet.fh-4, btnAutoGet.fw-4, 2)];
    line3.backgroundColor = RGB(0xf39700);
    [btnAutoGet addSubview:line3];
    [line3 release];
    [btnAutoGet release];
    
}


- (void)cell_rediobtn:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    CGFloat ext_h = [dataRow[@"extern_h"] floatValue];
    CGFloat row_h = [dataRow[@"row_h"] floatValue];
    
    CGFloat fx = 5, fh = 30, fw = 60, fy = (ext_h - fh)/2 + tagView(cell, 50).ey + 7;
    UILabel* lbinfo = newLabel(cell, @[@60, RECT_OBJ(fx, fy, fw, fh), RGB(0x456af2), Font(Font3), @"执行操作"]);
    lbinfo.hidden = m_isFirstPage;

    CGFloat txt_x = lbinfo.ex+5, txt_w = tagView(cell, 50).ex-txt_x;
    RadioBtnGroup* group = [[RadioBtnGroup alloc] initWithFrame:RECT(txt_x, lbinfo.fy, txt_w, lbinfo.fh)];
    group.writeType = dataRow[@"writeType"];
    group.currValue = dataRow[@"result"];
    group.changeBlock = ^(NSString* result) {
        [m_parentVC changeSubTask:dataRow[@"subTaskId"] Key:STK_CT Value:result];
    };
    
    if (m_isFirstPage) {
        group.frame = RECT(140, (row_h-30)/2, APP_W-5-140, 30);
    }
    [cell addSubview:group];
    [group release];
}

- (void)cell_otherBtns:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    CGFloat row_h = [dataRow[@"row_h"] floatValue] + [dataRow[@"extern_h"] floatValue];
    BOOL bIsAuto = ([dataRow[@"isAuto"] intValue] == 1);
    
    
    CGFloat btn_w = 35, btn_h = 30;
    UIButtonEx* btnFiles = [[UIButtonEx alloc] initWithFrame:RECT(APP_W-btn_w-5, row_h-btn_h-10, btn_w, btn_h)];
    btnFiles.hidden = bIsAuto;
    btnFiles.tag = TAG_FILES_BTN;
    btnFiles.info = dataRow;
    btnFiles.clipsToBounds = YES;
    btnFiles.titleLabel.font = Font(Font3);
    [btnFiles setTitle:@"附件" forState:0];
    [btnFiles setTitleColor:RGB(0x000000) forState:0];
    [btnFiles addTarget:self action:@selector(onBtnFilesTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnFiles];
    UIView* line1 = [[UIView alloc] initWithFrame:RECT(2, btnFiles.fh-4, btnFiles.fw-4, 2)];
    line1.backgroundColor = RGB(0xf39700);
    [btnFiles addSubview:line1];
    [line1 release];
    [btnFiles release];
    
    UIButtonEx* btnMemo = [[UIButtonEx alloc] initWithFrame:RECT(btnFiles.fx-btnFiles.fw-2, btnFiles.fy, btnFiles.fw, btnFiles.fh)];
    btnMemo.hidden = bIsAuto;
    btnMemo.info = dataRow;
    btnMemo.clipsToBounds = YES;
    btnMemo.titleLabel.font = Font(Font3);
    [btnMemo setTitle:@"备注" forState:0];
    [btnMemo setTitleColor:RGB(0x000000) forState:0];
    [btnMemo addTarget:self action:@selector(onBtnMemoTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnMemo];
    UIView* line2 = [[UIView alloc] initWithFrame:RECT(2, btnMemo.fh-4, btnMemo.fw-4, 2)];
    line2.backgroundColor = RGB(0xf39700);
    [btnMemo addSubview:line2];
    [line2 release];
    [btnMemo release];
    
    NSString* standard = dataRow[@"standard"];
    if ( !isNullStr(standard) ) {
        UIButtonEx* btnGuide = [[UIButtonEx alloc] initWithFrame:RECT(btnFiles.fx-btnFiles.fw-2, 7, btnFiles.fw*2, btnFiles.fh)];
        btnGuide.tag = TAG_STAND_BTN;
        btnGuide.info = dataRow;
        btnGuide.clipsToBounds = YES;
        btnGuide.titleLabel.font = Font(Font3);
        [btnGuide setTitle:@"作业规范" forState:0];
        [btnGuide setTitleColor:RGB(0x000000) forState:0];
        [btnGuide addTarget:self action:@selector(onBtnGuideTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnGuide];
        UIView* line3 = [[UIView alloc] initWithFrame:RECT(2, btnGuide.fh-4, btnGuide.fw-4, 2)];
        line3.backgroundColor = RGB(0xf39700);
        [btnGuide addSubview:line3];
        [line3 release];
        [btnGuide release];
    }
    
}


- (void)onBtnDateTouched:(UIButtonEx*)sender
{
    m_dateBtn = sender;
    m_dateSubTaskId = sender.info[@"subTaskId"];
    if ( !isNullStr(sender.titleLabel.text) ) {
        ((UIDatePicker*)m_datePicker1.contentView).date = str2date(sender.titleLabel.text, DATE_FORMAT);
    }
    [m_datePicker1 show];
}

- (void)onBtnTimeTouched:(UIButtonEx*)sender
{
    m_timeBtn = sender;
    m_dateSubTaskId = sender.info[@"subTaskId"];
    if ( !isNullStr(sender.titleLabel.text) ) {
        ((UIDatePicker*)m_timePicker1.contentView).date = str2date(sender.titleLabel.text, @"HH:mm");
    }
    [m_timePicker1 show];
}

- (void)onBtnFilesTouched:(UIButtonEx*)sender
{
    TaskFaultRisk* vc = [[TaskFaultRisk alloc] init];
    vc.subTaskId = sender.info[@"subTaskId"];
    [m_parentVC.navigationController pushViewController:vc animated:YES];
    [vc release];

}

- (void)onBtnMemoTouched:(UIButtonEx*)sender
{
    MemoInput* view = [[MemoInput alloc] init];
    view.currValue = sender.info[STK_RM];
    [view setChangeBlock:^(NSString * result) {
        sender.info[STK_RM] = result;
        [m_parentVC changeSubTask:sender.info[@"subTaskId"] Key:STK_RM Value:result];
    }];
    [getWindow() addSubview:view];
    [view release];
}

- (void)onBtnGuideTouched:(UIButtonEx*)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"作业规范"
                                                    message:format(@"%@",sender.info[@"standard"])
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)onBtnAutoGetTouched:(UIButtonEx*)sender
{
    NSMutableDictionary* dataRow = sender.info;
    
    int dBm = device_SignalLevel();
    int PCI = dBm - 5;
    if (IS_TYPE(@"场强")) {
        sender.info[STK_CT] = format(@"%d;%d", dBm, PCI);
    } else {
        sender.info[STK_CT] = format(@"%d", PCI);
    }
    tagViewEx(sender.superview, textFiledTag, UITextField).text = sender.info[STK_CT];
    [m_parentVC changeSubTask:sender.info[@"subTaskId"] Key:STK_CT Value:sender.info[STK_CT]];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight)];
    NSInteger row = parentCellIndexPath(textField).row;
    NSMutableDictionary* dataRow = m_data[row];
    [m_parentVC changeSubTask:dataRow[@"subTaskId"] Key:STK_CT Value:textField.text];
}





@end
