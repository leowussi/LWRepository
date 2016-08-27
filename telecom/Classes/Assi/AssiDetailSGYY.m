//
//  AssiDetailSGYY.m
//  telecom
//
//  Created by ZhongYun on 15-1-5.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AssiDetailSGYY.h"

#define ROW_H   55
#define ROW_E   15

#define TITLES  @[@"工程编号", @"工程名称", @"施工时间", @"施工内容", @"施工区局", @"施工状态", @"施工地点", @"施工人员"]
#define VALUES  @[@"projectNo", @"projectName", @"taskTime", @"reason", @"regionName", @"status", @"taskAddress", @"constructor"]

@interface AssiDetailSGYY ()
{
    NSDictionary* m_data;
    UIScrollView* m_scroll;
}
@end

@implementation AssiDetailSGYY

- (void)dealloc
{
    [m_data release];
    [m_scroll release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"施工任务";
    
    m_scroll = [[UIScrollView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, SCREEN_H-self.navBarView.ey)];
    m_scroll.contentSize = m_scroll.bounds.size;
    m_scroll.showsVerticalScrollIndicator = NO;
    m_scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_scroll];
    
    
    UIView* banner = [[UIView alloc] initWithFrame:RECT(10, ROW_E, APP_W-20, 320)];
    banner.tag = 100;
    banner.backgroundColor = [UIColor whiteColor];
    banner.layer.borderColor = COLOR(190, 190, 190).CGColor;
    banner.layer.borderWidth = 0.5;
    banner.layer.cornerRadius = 3;
    [m_scroll addSubview:banner];
    
    UIView* line = [[UIView alloc] init];
    line.frame = RECT(2, ROW_H, banner.fw-4, 0.5);
    line.backgroundColor = COLOR(221, 221, 221);
    [banner addSubview:line];
    [line release];
    
    int btag = 150, vtag = 1100;
    CGFloat pos_y = (ROW_H - Font1)/2;
    UILabel* tlb = newLabel(banner, @[@(btag++), RECT_OBJ(10, pos_y, 80, Font1), RGB(0xff5e36), FontB(Font1), @"任务详情"]);
    
    pos_y = ROW_H + 10;
    for (NSString* title in TITLES) {
        tlb = newLabel(banner, @[@(btag++), RECT_OBJ(10, pos_y, 75, Font3), RGB(0x313131), Font(Font3), format(@"%@：", title)]);
        newLabel(banner, @[@(vtag++), RECT_OBJ(tlb.ex, pos_y, banner.fw-tlb.ex - 10, Font3*3), RGB(0x313131), Font(Font3), @""]);
        pos_y = tlb.ey + 20;
    }
    banner.fh = pos_y;
    m_scroll.contentSize = CGSizeMake(m_scroll.fw, banner.ey+10);
    
    
    [banner release];
    
    [self loadData];
}

- (void)updateLabels
{
    int vtag = 1100;
    for (NSString* key in VALUES) {
        tagViewEx(self.view, vtag, UILabel).text = m_data[key];
        [tagViewEx(self.view, vtag++, UILabel) sizeToFit];
    }
}

- (void)loadData
{
    httpGET1(@{URL_TYPE:NW_TaskAppointmentInfo, @"appointmentId":self.appointmentId}, ^(id result) {
        m_data = [result[@"detail"] mutableCopy];
        mainThread(updateLabels, nil);
    });
}

@end
