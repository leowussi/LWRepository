//
//  TaskJiaohunList.m
//  telecom
//
//  Created by ZhongYun on 14-7-5.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "TaskJiaohunList.h"
#import "MyTaskCallBackController.h"
#import "AddFaultOrderController.h"
#import "AddShareInfoController.h"
#import "AddTroubleViewController.h"
#import "RectifyResourceController.h"

#define ROW1_H      55
#define ROW2_H      55
#define HEAD_H      40

@interface TaskJiaohunList ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    UIButton* m_checkBtn;
    
    NSIndexPath *_indexPath;

    BOOL _isAddtionalOperationViewHiden;
}
@property(nonatomic,strong)UIButton *rightAddtionalBtn;
@property(nonatomic,strong)UIView *addtionalView;

@property(nonatomic,strong)NSDictionary *infoDict;
@end

@implementation TaskJiaohunList

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [m_checkBtn release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"交换专业";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _isAddtionalOperationViewHiden = YES;
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-NAV_H) style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor clearColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = ROW1_H;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:m_table];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    m_checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                      (NAV_H-checkIcon.size.height)/2,
                                                      checkIcon.size.width, checkIcon.size.height)];
    [m_checkBtn setBackgroundImage:checkIcon forState:0];
    [m_checkBtn addTarget:self action:@selector(onCommitBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:m_checkBtn];
    
    self.rightAddtionalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightAddtionalBtn.frame = CGRectMake(APP_W-80, 7, 30, 30);
    [self.rightAddtionalBtn setBackgroundImage:[UIImage imageNamed:@"nav_add@2x"] forState:UIControlStateNormal];
    [self.rightAddtionalBtn addTarget:self action:@selector(addtionalAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:self.rightAddtionalBtn];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    [item1 release];
    [item2 release];
}

#pragma mark - 添加故障单等操作
- (void)addtionalAction
{
    if (_isAddtionalOperationViewHiden) {
        _addtionalView = [[UIView alloc] initWithFrame:RECT(APP_W-120, 64, 80, 90)];
        self.addtionalView.backgroundColor = COLOR(239, 239, 239);
        self.addtionalView.layer.borderWidth = 0.5;
        self.addtionalView.layer.borderColor = COLOR(215, 215, 215).CGColor;
        [self.view addSubview:self.addtionalView];
        
        NSArray *titleArray = @[@"添加故障单",@"新增隐患",@"矫正资源"];
        for (int i=0; i<titleArray.count; i++) {
            UIButton *addtionalBtn = [MyUtil createBtnFrame:RECT(0, 30*i, 80, 30) bgImage:nil image:nil title:titleArray[i] target:self action:@selector(addtionalOperation:)];
            [addtionalBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            addtionalBtn.tag = 28888 + i;
            addtionalBtn.layer.borderColor = COLOR(215, 215, 215).CGColor;
            addtionalBtn.layer.borderWidth = 0.5;
            [self.addtionalView addSubview:addtionalBtn];
        }
        
        _isAddtionalOperationViewHiden = NO;
    }else{
        self.addtionalView.hidden = YES;
        _isAddtionalOperationViewHiden = YES;
    }
}

- (void)addtionalOperation:(UIButton *)btn
{
    NSInteger index = btn.tag - 28888;
    if (index == 0) {
        AddFaultOrderController *addOrderCtrl = [[AddFaultOrderController alloc] init];
        addOrderCtrl.callBackInfoDict = self.detail;
        [self.navigationController pushViewController:addOrderCtrl animated:YES];
        [addOrderCtrl release];
    }else if (index == 1){
        AddTroubleViewController *addTroubleCtrl = [[AddTroubleViewController alloc] init];
//        addTroubleCtrl.callBackInfoDict = self.detail;
        NSMutableDictionary *par =[NSMutableDictionary dictionary];
        [par setObject:@"MyTask/GetRiskBasicInfo" forKey:URL_TYPE];
        [par setObject:self.detail[@"taskId"] forKey:@"taskId"];
        httpGET2(par, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
              addTroubleCtrl.callBackInfoDict = result[@"detail"];
                addTroubleCtrl.subTaskId =self.detail[@"taskId"];
                DLog(@"%@",result[@"detail"]);
            [self.navigationController pushViewController:addTroubleCtrl animated:YES];
                [addTroubleCtrl release];
            }
        }, ^(id result) {
            
        });
        
        
    }else{
        RectifyResourceController *rectifyCtrl = [[RectifyResourceController alloc] init];
        rectifyCtrl.callBackInfoDict = self.detail;
        [self.navigationController pushViewController:rectifyCtrl animated:YES];
        [rectifyCtrl release];
    }
}

- (void)setDetail:(NSMutableDictionary *)detail
{
    _detail = [detail retain];
    [self loadData];
    
}

- (void)loadData
{
    NSString* taskId = self.detail[@"taskId"];
    NSString *planDate = [self.planDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDictionary* params = @{URL_TYPE:NW_GetSpecSecondaryTaskList, @"taskFstID":taskId};
    if (self.planDate != nil) {
        params = @{URL_TYPE:NW_GetSpecSecondaryTaskList, @"taskFstID":taskId, @"planDate":planDate};
    }
    
    
    httpGET2(params, ^(id result) {
        mainThread(updateViewData:, result);
    }, ^(id result) {
        mainThread(updateViewData:, nil);
    });
}

- (void)updateViewData:(id)result
{
    [m_data removeAllObjects];
    for (NSDictionary* item in result[@"list"]) {
        NSMutableDictionary* tmp = [item mutableCopy];
        tmp[@"selected"] = @0;
        [m_data addObject:tmp];
        [tmp release];
    }
    [m_table reloadData];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"taskID"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        cell.textLabel.font = FontB(Font1);
        
        CGFloat row_h = ROW1_H;
        newLabel(cell, @[@51, RECT_OBJ(10, 10, APP_W-10-25, Font2), [UIColor lightGrayColor], Font(Font2), @""]);
        newLabel(cell, @[@52, RECT_OBJ(10, 32, 215, Font3), [UIColor lightGrayColor], Font(Font3), @""]);
        newLabel(cell, @[@53, RECT_OBJ(232, 32, 50, Font3), [UIColor lightGrayColor], Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        
        UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT(APP_W-40, (row_h-40)/2, 40, 40)];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"check_no.png"] forState:0];
        [checkBtn addTarget:self action:@selector(onCellCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.tag = 54;
        [cell addSubview:checkBtn];
        [checkBtn release];
    }
    
    BOOL isOver = ([dataRow[@"taskStatus"] intValue] == 1);
    tagViewEx(cell, 51, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : [UIColor darkGrayColor]);
    tagViewEx(cell, 51, UILabel).text = dataRow[@"taskName"];
    
    tagViewEx(cell, 52, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : [UIColor darkGrayColor]);
    tagViewEx(cell, 52, UILabel).text = NoNullStr(dataRow[@"date"]);
    
    tagViewEx(cell, 53, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : [UIColor redColor]);
    tagViewEx(cell, 53, UILabel).text = (isOver ? @"已完成" : @"未完成");
    
    NSString* imgName = ([dataRow[@"selected"] intValue]==1 ? @"check_ok.png" : @"check_no.png");
    [tagViewEx(cell, 54, UIButton) setBackgroundImage:[UIImage imageNamed:imgName] forState:0];
    
    cell.selectionStyle = (isOver ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray);
    
    NSString* today = date2str([NSDate date], DATE_FORMAT);
    BOOL isToday = ([dataRow[@"date"] isEqualToString:today] && !isOver);
    cell.backgroundColor = (isToday ? COLOR(255, 176, 176) : [UIColor whiteColor]);
    
    
    if (isOver) {
      [cell.contentView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(callBackAction:) ] ];
    }
    
    return cell;
}

- (void)callBackAction:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [ges locationInView:m_table];
        NSIndexPath* indexPath = [m_table indexPathForRowAtPoint:point];
        self.infoDict = m_data[indexPath.row];
        NSLog(@"%@",self.infoDict);
        if (indexPath == nil)  return;
        _indexPath = indexPath;
        
        UIAlertView *chooseAlert = [ [UIAlertView alloc] initWithTitle:@"是否要召回重做?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [chooseAlert show];
        [chooseAlert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"不召回重做");
    }else if (buttonIndex == 1){
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = NW_CallBackTaskLevelTwo;
        paraDict[@"taskId"] = self.infoDict[@"taskID"];
        paraDict[@"workContent"] = [NSString stringWithFormat:@"%@--%@(%@)",self.detail[@"taskName"],self.infoDict[@"taskName"],self.siteName];
        paraDict[@"finishedAmount"] = @"1";//self.detail[@"undoUnitAmount"]
        paraDict[@"foundProblem"] = @"";
        paraDict[@"handledProblem"] = @"";
        httpGET2(paraDict, ^(id result) {
            showAlert(@"已召回重做");
        }, ^(id result) {
            showAlert(result[@"error"]);
        });
    }
}

- (void)onCellCheckBtnTouched:(UIButton*)sender
{
    UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
    NSIndexPath* indexPath = [m_table indexPathForCell:cell];
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    
    BOOL isOver = ([dataRow[@"taskStatus"] intValue] == 1);
    if (isOver) {
        return;
    }
    
    int status = [dataRow[@"selected"] intValue];
    status = (status==0 ? 1 : 0);
    dataRow[@"selected"] = @(status);
    [m_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
}


- (void)onCommitBtnTouched:(id)sender
{
    NSMutableArray* commitList = [NSMutableArray array];
    NSMutableArray* taskIds = [NSMutableArray array];
    
    for (int i = 0; i < m_data.count; i++) {
        NSDictionary* item = m_data[i];
        if ([item[@"selected"] intValue] == 1) {
            [taskIds addObject:item[@"taskID"]];
            [commitList addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    
    if (taskIds.count > 0) {
        NSString* list = [taskIds componentsJoinedByString:@","];
        httpGET1(@{URL_TYPE:NW_BatchFinishTasks, @"taskIdList":list}, ^(id result) {
            mainThread(onCommitAfter:, commitList);
        });
    }
}

- (void)onCommitAfter:(NSArray*)commitList
{
    for (NSIndexPath* indexPath in commitList) {
        m_data[indexPath.row][@"selected"] = @0;
        m_data[indexPath.row][@"taskStatus"] = @1;
    }
    [m_table reloadRowsAtIndexPaths:commitList withRowAnimation:0];
    
    int num = 0;
    for (NSDictionary* item in m_data) {
        if ([item[@"taskStatus"] intValue] == 0) {
            num++;
        }
    }
    if (self.respBlock) {
        self.respBlock(num);
    }
}

@end
