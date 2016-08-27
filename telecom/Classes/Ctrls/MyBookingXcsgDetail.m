//
//  MyBookingXcsgDetail.m
//  telecom
//
//  Created by ZhongYun on 15-1-3.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyBookingXcsgDetail.h"
#import "MyBookingXcsgExec.h"
#import "RecordCell.h"
#import "ImageDetailController.h"
#import "YZAcceptanceApplicationViewController.h"

#define ROW_E           26
#define LINE_E          7
#define TITLE_H         48
#define TAG_BTN_DRAWDOWN    2300
#define TAG_BTN_EXEC        2310
#define TAG_BTN_CANCEL      2320

@interface MyBookingXcsgDetail ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,RecordCellDelegate>
{
    UIView* m_banInfo;
    UIView* m_banList;
    UIView* m_banBtn;
    UIScrollView* m_scroll;
    
    NSMutableDictionary* m_data;
    NSMutableArray* m_excuteList;
    
    UITableView *_excuteTableView;
    NSString *strTel;
    
}
@end

@implementation MyBookingXcsgDetail

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"随工任务详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    m_scroll = [[UIScrollView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, SCREEN_H-self.navBarView.ey)];
    m_scroll.contentSize = m_scroll.bounds.size;
    m_scroll.showsVerticalScrollIndicator = NO;
    m_scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_scroll];
    
    
    m_banInfo = [self newBannerView:15 :890 :@"任务详情"];
    m_banList = [self newBannerView:m_banInfo.ey+15 :0 :@"执行记录"];
    m_banBtn = [self newBannerView:m_banList.ey+(m_banList.fh==0 ? 0 : 15) :41 :NULL];
    
    [self addBanInfoObjs];
    [self addBanBtnObjs];
    
    m_scroll.contentSize = CGSizeMake(APP_W, m_banBtn.ey+15);
    
    [self loadData];
}

- (UIView*)newBannerView:(CGFloat)pos_y :(CGFloat)height :(NSString*)title
{
    if (title == NULL) {
        UIView* banner = [[UIView alloc] initWithFrame:RECT(0, pos_y, APP_W, height)];
        [m_scroll addSubview:banner];
        return banner;
    }
    
    UIView* banner = [[UIView alloc] initWithFrame:RECT(10, pos_y, APP_W-20, height)];
    banner.clipsToBounds = YES;
    banner.backgroundColor = [UIColor whiteColor];
    banner.layer.borderColor = COLOR(190, 190, 190).CGColor;
    banner.layer.borderWidth = 0.5;
    banner.layer.cornerRadius = 3;
    [m_scroll addSubview:banner];
    
    newLabel(banner, @[@10, RECT_OBJ(10, (TITLE_H-Font1)/2, 120, Font1), RGB(0xff6d45), FontB(Font1), title]);
    
    UIView* line = [[UIView alloc] initWithFrame:RECT(0, TITLE_H, banner.fw, 0.5)];
    line.backgroundColor = COLOR(221, 221, 221);
    [banner addSubview:line];
    return banner;
}

- (void)addBanInfoObjs
{
    int ttag = 100, vtag = 200;
    CGFloat pos_y = (TITLE_H + 14);

    UILabel *newAddTitle = nil;
    
    
    newAddTitle = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 100, Font3), RGB(0x2f2f2f), FontB(Font3), @"适用场景类型："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(newAddTitle.ex, pos_y, m_banInfo.fw-10-newAddTitle.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    newAddTitle = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"配合任务："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(newAddTitle.ex, pos_y, m_banInfo.fw-10-newAddTitle.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    pos_y += (Font3 + ROW_E);
    newAddTitle = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"专      业："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(newAddTitle.ex, pos_y, m_banInfo.fw-10-newAddTitle.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    pos_y += (Font3 + ROW_E);
    
    UILabel* title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"工程编号："]);
    
    UILabel* title1 = newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, title.height), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    [title1 layoutIfNeeded];
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"工程名称："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"随工时间："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"随工内容："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"工程数量："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"特殊要求："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"施工单位："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 100, Font3), RGB(0x2f2f2f), FontB(Font3), @"工程联系人："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 120, Font3), RGB(0x2f2f2f), FontB(Font3), @"施工人联系电话："]);
//    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(title.ex, pos_y-10, m_banInfo.fw-10-title.ex, Font3*3)];
    textView.tag = 888;
    textView.font = [UIFont systemFontOfSize:Font3];
    textView.textColor = RGB(0x2f2f2f);
    textView.text = @"";
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        
    {
        
        textView.selectable = YES;//用法：决定UITextView 中文本是否可以相应用户的触摸，主要指：1、文本中URL是否可以被点击；2、UIMenuItem是否可以响应
        
    }
    textView.editable = NO;
    vtag++;
    [m_banInfo addSubview:textView];
    
    pos_y += ( textView.frame.size.height);
//    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 100, Font3), RGB(0x2f2f2f), FontB(Font3), @"施工审核人："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 100, Font3), RGB(0x2f2f2f), FontB(Font3), @"客保工单编号："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"随工状态："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"监护人员："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"随工地点："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"难度等级："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"经验耗时："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"积      分："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"技能要求："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
}

- (void)addBanListObjs
{
    int status = [m_data[@"statusId"] intValue];
    if (status != 2) {
        if (!m_excuteList || m_excuteList.count==0) return;
        m_banBtn.hidden = NO;
        _excuteTableView = [[UITableView alloc] initWithFrame:RECT(0, TITLE_H+10, m_banList.bounds.size.width, 280) style:UITableViewStylePlain];
        _excuteTableView.backgroundColor = [UIColor whiteColor];
        _excuteTableView.delegate = self;
        _excuteTableView.dataSource = self;
        _excuteTableView.scrollEnabled = NO;
        [m_banList addSubview:_excuteTableView];
        
        [m_banList setFh:210 * m_excuteList.count + TITLE_H + 10 + 10];
        
        [m_banBtn setFy:m_banList.ey + 15];
        
    } else {
        NSString* cancelReason = NoNullStr(m_data[@"cancelReason"]);
        UILabel* lbDesc = newLabel(m_banList, @[@(1532), RECT_OBJ(10, TITLE_H+10, m_banList.fw-20, 500), RGB(0x2f2f2f), FontB(Font3), cancelReason]);
        lbDesc.attributedText = getLineSpaceStr(cancelReason, 5);
        [lbDesc sizeToFit];
        
        tagViewEx(m_banList, 10, UILabel).text = @"取消原因";
        
        m_banList.fh = lbDesc.fy + MAX(lbDesc.fh,TITLE_H) + 10;
        m_banBtn.fh = 0;
        m_banBtn.hidden = YES;
    }
    
    m_scroll.contentSize = CGSizeMake(APP_W, m_banBtn.ey+m_banList.fh);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fy = 0;
    for (NSDictionary *dict in m_excuteList) {
        CGFloat hei = [RecordCell heightForCell:dict];
        fy += hei;
    }
    [_excuteTableView setFh:fy];
    [m_banList setFh:_excuteTableView.fh+TITLE_H+10];
    [m_banBtn setFy:m_banList.ey+15];
    m_scroll.contentSize = CGSizeMake(APP_W, m_banBtn.ey+5);
    
    NSDictionary *dict = m_excuteList[indexPath.row];
    CGFloat height = [RecordCell heightForCell:dict];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_excuteList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = m_excuteList[indexPath.row];
    cell.fileIdDict = dict;
    [cell configCell:dict];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDetailImageWithIndex:(NSInteger)index fileIdDict:(NSDictionary *)dict
{
    NSArray *fileIdArr = dict[@"fileList"];
    ImageDetailController *imageDetailCtrl = [[ImageDetailController alloc] init];
    imageDetailCtrl.fileIdArray = fileIdArr;
    imageDetailCtrl.pageIndex = index;
    [self.navigationController pushViewController:imageDetailCtrl animated:YES];
}

- (void)addBanBtnObjs
{
    UIButton* btn2 = [[UIButton alloc] initWithFrame:RECT(10, m_banBtn.fh-40, (APP_W-40)/2, 40)];
    [btn2 setBackgroundImage:color2Image(COLOR(74, 130, 198)) forState:0];
    [btn2 addTarget:self action:@selector(onExceuteBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn2.layer.cornerRadius = 5;
    btn2.clipsToBounds = YES;
    btn2.tag = TAG_BTN_EXEC;
    [btn2 setTitle:@"领    取" forState:0];
    [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.titleLabel.font = FontB(Font0);
    [m_banBtn addSubview:btn2];
    
    UIButton* btn3 = [[UIButton alloc] initWithFrame:RECT(btn2.ex+20, m_banBtn.fh-40, (APP_W-40)/2, 40)];
    [btn3 setBackgroundImage:color2Image(COLOR(0, 165, 78)) forState:0];
    [btn3 addTarget:self action:@selector(onCancelBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn3.layer.cornerRadius = 5;
    btn3.clipsToBounds = YES;
    btn3.tag = TAG_BTN_CANCEL;
    [btn3 setTitle:@"取    消" forState:0];
    [btn3 setTitleColor:[UIColor whiteColor] forState:0];
    btn3.titleLabel.font = FontB(Font0);
    [m_banBtn addSubview:btn3];
}

- (void)updateLabels:(NSDictionary*)info
{

    
    int vtag = 200;
    //    工程编号
    
    
    
    UILabel *lable_type =tagViewEx(m_banInfo, vtag, UILabel);
    lable_type.text = @"工程现场配合";
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    lable_type.height=Font3;
    
    UILabel *matchTask =tagViewEx(m_banInfo, vtag, UILabel);
    matchTask.text = NoNullStr(info[@"matchTask"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    matchTask.height=Font3;
    
    
    UILabel *specName =tagViewEx(m_banInfo, vtag, UILabel);
    specName.text = NoNullStr(info[@"specName"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    specName.height=Font3;
    

    UILabel *temp =tagViewEx(m_banInfo, vtag, UILabel);
    temp.text = NoNullStr(info[@"projectNo"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    temp.height=Font3;
    
    //    工程名称
    UILabel *tempName =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"projectName"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempName.height=Font3;
    //    随工时间
    UILabel *tempTime =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskTime"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempTime.height=Font3;
    //    随工内容
    UILabel *tempContent =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"reason"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempContent.height=Font3;
    
    //    工程数量
    UILabel *tempNumber =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"projectNum"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempNumber.height = Font3;
    //    特殊要求
    UILabel *tempYaoQiu =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskInfo"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempYaoQiu.height = Font3;
    //    施工单位
    UILabel *tempComp =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskCompany"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempComp.height = Font3;
    //    工程联系人
    UILabel *tempPhone =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"constructor"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempPhone.height = Font3;
    //    施工人联系电话
    //之前注释掉了  2016.4.25号打开
    UILabel *tempPhoneNumber =tagViewEx(m_banInfo, vtag, UILabel);
//        tagViewEx(m_banInfo, vtag, UITextView).text = NoNullStr(info[@"constructorMobile"]);
//        [tagViewEx(m_banInfo, vtag++, UITextView) sizeToFit];
    tempPhoneNumber.height = Font3;
    if (vtag == 211) {
        NSString *str = [NSString stringWithFormat:@"%@",NoNullStr(info[@"constructorMobile"])];
        strTel = [str
                  stringByReplacingOccurrencesOfString:@"," withString:@" "];
        tagViewEx(m_banInfo, vtag, UILabel).hidden = YES;
        
        tagViewEx(m_banInfo, 888, UITextView).text = strTel;
        [tagViewEx(m_banInfo, 888, UITextView) sizeToFit];
        vtag++;
    }
    
    //    施工审核人[3]	(null)	@"executeUserName" : @"张仕波"	[13]	(null)	@"examinedPeople" : @"张仕波"
    UILabel *tempPerson =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"examinedPeople"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempPerson.height = Font3;
    
    //    客保工单编号
    UILabel *tempGongNumber =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"kbNo"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempGongNumber.height = Font3;
    
    //    随工状态
    UILabel *tempStates =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"status"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempStates.height = Font3;
    
    //    监护人员
    UILabel *tempJianPerson =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"executeUserName"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempJianPerson.height = Font3;
    
    //    随工地点
    UILabel *tempSuiAddress =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskAddress"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempSuiAddress.height = Font3;
    
//    UILabel *sceneType =tagViewEx(m_banInfo, vtag, UILabel);
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskAddress"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    sceneType.height = Font3;
    UILabel *level =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"level"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    level.height = Font3;

    
    UILabel *costTime =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"costTime"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    costTime.height = Font3;

    
    UILabel *score =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"score"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    score.height = Font3;

    UILabel *skill =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"skill"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    skill.height = Font3;

    
}

- (void)loadData
{
    httpGET1(@{URL_TYPE:NW_TaskInfo, @"appointmentId":self.taskId}, ^(id result) {
        NSLog(@"%@",result);
        m_data = [result[@"detail"] mutableCopy];
        m_excuteList = [m_data[@"excuteList"] mutableCopy];
        mainThread(updateLabels:, result[@"detail"]);
        mainThread(updateBtnObj, nil);
        mainThread(addBanListObjs, nil);
    });
}

- (void)updateBtnObj
{
    int status = [m_data[@"statusId"] intValue];
    
    if (![m_data[@"executeUserName"] isEqualToString:@""]) {
        if (status == 0) {//待执行
            tagView(m_banBtn, TAG_BTN_EXEC).hidden = NO;
            UIButton *execBtn = (UIButton *)tagView(m_banBtn, TAG_BTN_EXEC);
            [execBtn setTitle:@"执    行" forState:UIControlStateNormal];
            tagView(m_banBtn, TAG_BTN_CANCEL).hidden = NO;
        }else if (status == 1){//已执行
            tagView(m_banBtn, TAG_BTN_EXEC).hidden = YES;
            tagView(m_banBtn, TAG_BTN_CANCEL).hidden = YES;
            if ([[m_data objectForKey:@"checkId"] isEqualToString:@""]) {
                [self addAcceptanceButton];
            }
            
        }else if (status == 2) {//已取消
            tagView(m_banBtn, TAG_BTN_EXEC).hidden = YES;
            tagView(m_banBtn, TAG_BTN_CANCEL).hidden = YES;
        } else if (status == 3) {//开始执行,未结束
            tagView(m_banBtn, TAG_BTN_EXEC).hidden = NO;
            tagView(m_banBtn, TAG_BTN_EXEC).fx = 10;
            tagView(m_banBtn, TAG_BTN_EXEC).fw = APP_W - 20;
            UIButton *execBtn = (UIButton *)tagView(m_banBtn, TAG_BTN_EXEC);
            [execBtn setTitle:@"执    行" forState:UIControlStateNormal];
            tagView(m_banBtn, TAG_BTN_CANCEL).hidden = YES;
        }else{//执行中
            tagView(m_banBtn, TAG_BTN_EXEC).hidden = NO;
            tagView(m_banBtn, TAG_BTN_EXEC).fx = 10;
            tagView(m_banBtn, TAG_BTN_EXEC).fw = APP_W - 20;
            UIButton *execBtn = (UIButton *)tagView(m_banBtn, TAG_BTN_EXEC);
            [execBtn setTitle:@"执    行" forState:UIControlStateNormal];
            tagView(m_banBtn, TAG_BTN_CANCEL).hidden = YES;
        }
    }
}

#pragma mark -- 验收按钮
- (void)addAcceptanceButton
{
    UIButton* acceptanceButton = [[UIButton alloc] initWithFrame:RECT(20, m_banBtn.fh-44, (APP_W-40), 40)];
    acceptanceButton.backgroundColor = [UIColor colorWithRed:48/255.0 green:107/255.0 blue:180/255.0 alpha:1];    [acceptanceButton addTarget:self action:@selector(acceptanceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    acceptanceButton.layer.cornerRadius = 4;
    acceptanceButton.clipsToBounds = YES;
//    acceptanceButton.tag = TAG_BTN_CANCEL;
    [acceptanceButton setTitle:@"验  收  申  请" forState:0];
    [acceptanceButton setTitleColor:[UIColor whiteColor] forState:0];
    acceptanceButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [m_banBtn addSubview:acceptanceButton];

}

- (void)acceptanceButtonClicked
{
    YZAcceptanceApplicationViewController *acceptanceApplicationVC = [[YZAcceptanceApplicationViewController alloc] init];
    NSString *specName = m_data[@"specName"];
    if (specName == nil) {
        specName = @"";
    }
    
    acceptanceApplicationVC.dataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"工程现场配合",@"0",m_data[@"taskAppointmentSerialNo"],@"1",m_data[@"projectName"],@"2",m_data[@"appointmentId"],@"3",m_data[@"siteName"],@"4",m_data[@"taskAddress"],@"5",specName,@"6",m_data[@"executeUserName"],@"7",m_data[@"orgName"],@"8",m_data[@"constructorMobile"],@"9", nil];
    [self.navigationController pushViewController:acceptanceApplicationVC animated:YES];

}

- (void)onExceuteBtnTouched:(id)sender
{
    if ([m_data[@"executeUserName"] isEqualToString:@""]) {
        //领取任务
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyTask/WithWork/TaskReceive";
        paraDict[@"appointmentId"] = m_data[@"appointmentId"];
        httpGET1(paraDict, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                [UIView animateWithDuration:0.3f animations:^{
                    UIButton *execBtn = (UIButton *)tagView(m_banBtn, TAG_BTN_EXEC);
                    [execBtn setTitle:@"执    行" forState:UIControlStateNormal];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        });
    }else{
        MyBookingXcsgExec* vc = [[MyBookingXcsgExec alloc] init];
        vc.opType = 1;
        vc.task = m_data;
        vc.listVC = self.listVC;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (void)onCancelBtnTouched:(id)sender
{
    MyBookingXcsgExec* vc = [[MyBookingXcsgExec alloc] init];
    vc.opType = 2;
    vc.task = m_data;
    vc.listVC = self.listVC;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
