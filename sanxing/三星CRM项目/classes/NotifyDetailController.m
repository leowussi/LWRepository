//
//  NotifyDetailController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/24.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "NotifyDetailController.h"
#import "ZYFHttpTool.h"
#import "ZYFUrl.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFURLTableSearch.h"
#import "LookupController.h"


#define kOpened @"51"

@interface NotifyDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation NotifyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentTextView.layer.borderWidth = 1;
    self.contentTextView.editable = NO;
    self.contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentTextView.layer.cornerRadius = 5;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"详细信息" style:UIBarButtonItemStyleDone target:self action:@selector(detail)];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self postMessageStatus];
    [self showContent];
}

- (void)detail
{
    NSString *newFormId = nil;
    NSString *newFormXml = nil;
    for (ZYFAttributes *attr in self.message.attrArray) {
        if ([attr.myKey isEqualToString:@"new_formid"]) {
             newFormId = attr.myValueString;
        }else if ([attr.myKey isEqualToString:@"new_formxml"]){
             newFormXml = attr.myValueString;
        }
    }
    NSString *urlStr = kTableSearchMain;
//    NSString *schemName = form.relateEntity.scheamname;
//    NSString *urlString = [NSString stringWithFormat:@"%@?%@=%@&formxml=%@&entityid=%@",urlStr,schemName,attr.lookUp.Id,form.relateEntity.formxml,attr.lookUp.Id];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?formxml=%@&entityid=%@",urlStr,newFormId,newFormXml];

    
    LookupController *lookupCtrl = [[LookupController alloc]init];
    lookupCtrl.urlString = [CRMHelper translateRegularUrlWithString:urlString];
    [self.navigationController pushViewController:lookupCtrl animated:YES];
}

- (void)postMessageStatus
{
    NSString *urlStr = kMessageStatus;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"new_app_messid"] = self.message.Id;
    params[@"new_status"] = kOpened;
    [ZYFHttpTool postWithURL:urlStr params:params success:^(id json) {
        ZYFLog(@"update message status success");
    } failure:^(NSError *error) {
        ZYFLog(@"update message status failure");
    }];
    
}

- (void)showContent
{
    for (ZYFAttributes *attr in self.message.attrArray) {
        if ([attr.myKey isEqualToString:@"new_name"]) {
            self.subjectLabel.text = attr.myValueString;
        }else if ([attr.myKey isEqualToString:@"createdon"]){
//            self.timeLabel.text = attr.myDateTime;
        }else if ([attr.myKey isEqualToString:@"new_content"]){
            self.contentTextView.text = attr.myValueString;
        }
    }
    
    for (ZYFFormattedValue *format in self.message.formatValueArray) {
        self.timeLabel.text = format.myValueString;
    }

}

@end
