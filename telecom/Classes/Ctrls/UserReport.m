//
//  UserReport.m
//  telecom
//
//  Created by ZhongYun on 14-9-21.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "UserReport.h"
#import "UserReportFilter.h"

@interface UserReport ()

@end

@implementation UserReport

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        httpGET1(@{URL_TYPE:NW_RptGetSite}, ^(id result) {
            self.sites = [result[@"list"] mutableCopy];
            NOTIF_POST(RPT_SITE_DOWN, nil);
        });
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"统计报表";
    
    UIImage* filterIcon = [UIImage imageNamed:@"nav_filter.png"];
    UIButton* m_filterBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-filterIcon.size.width),
                                                                 (NAV_H-filterIcon.size.height)/2,
                                                                 filterIcon.size.width, filterIcon.size.height)];
    [m_filterBtn setBackgroundImage:filterIcon forState:0];
    [m_filterBtn addTarget:self action:@selector(onFilterBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:m_filterBtn];

    [self addInfoLabel];
}

- (void)onFilterBtnTouched:(id)sender
{
    UserReportFilter* vc = [[UserReportFilter alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)addInfoLabel
{
    CGFloat top_y = self.navBarView.ey, txt_h=30;
    
#define addLabel(h, tag, txt) \
newLabel(self.view, @[@(tag), RECT_OBJ(10, top_y, APP_W-20, h), [UIColor darkGrayColor], Font(Font4), txt]);\
top_y += (h);
    
    addLabel(   20, 20, @" 筛选条件：");
    tagViewEx(self.view, 20, UILabel).fx = 0;
    tagViewEx(self.view, 20, UILabel).fw = APP_W;
    tagViewEx(self.view, 20, UILabel).textColor = [UIColor whiteColor];
    tagViewEx(self.view, 20, UILabel).backgroundColor = [UIColor darkGrayColor];
    
    
    addLabel(txt_h, 21, @"");
    addLabel(txt_h, 22, @"");
    addLabel(txt_h, 23, @"");
    addLabel(txt_h, 24, @"");
    addLabel(txt_h, 25, @"");
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showReportData:(NSArray*)list
{
    NSDictionary* row = list[0];
    
    tagViewEx(self.view, 20, UILabel).text = format(@" 筛选条件：%@", list[1]);
    
    tagViewEx(self.view, 21, UILabel).text = format(@"计划完成任务数%@个,实际完成任务数%@个。",
                                                    row[@"planTaskNumber"],
                                                    row[@"actualTaskNumber"]);
    
    tagViewEx(self.view, 22, UILabel).text = format(@"完成周期任务%@个,历史%@小时,占总任务数%@%%。",
                                                    row[@"periodTaskNumber"],
                                                    row[@"periodTaskTime"],
                                                    row[@"periodTaskPercent"]);
    
    tagViewEx(self.view, 23, UILabel).text = format(@"完成周期任务%@个,历史%@小时,占总任务数%@%%。",
                                                    row[@"randomTaskNumber"],
                                                    row[@"randomTaskTime"],
                                                    row[@"randomTaskPercent"]);

    tagViewEx(self.view, 24, UILabel).text = format(@"完成故障任务%@个,历史%@小时,占总任务数%@%%。",
                                                    row[@"faultTaskNumber"],
                                                    row[@"faultTaskTime"],
                                                    row[@"faultTaskPercent"]);
    
    tagViewEx(self.view, 25, UILabel).text = format(@"机房时间%@", row[@"machineRoomTime"]);
}

@end
