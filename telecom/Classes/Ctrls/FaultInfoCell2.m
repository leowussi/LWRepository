//
//  FaultInfoCell2.m
//  telecom
//
//  Created by liuyong on 15/11/6.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "FaultInfoCell2.h"

@implementation FaultInfoCell2

- (void)awakeFromNib {
    [self.sharePersonInfoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSharePersonInfo:)]];
}

- (void)showSharePersonInfo:(UITapGestureRecognizer *)ges
{
    if (self.delegate) {
        [self.delegate showSharePersonInfoWithFaultInfoCell2:ges];
    }
}

- (void)configFaultInfoCell:(NSDictionary *)dict
{
    if ([(NSString *)dict[@"sharedUser"] length] == 0) {
        self.sharePersonInfoImageView.hidden = YES;
    }
    
    NSArray *cellConfigInfo = [self getShowInfo:dict];
    
    self.backgroundColor = cellConfigInfo[0];
    self.leftImageView.image = [UIImage imageNamed:cellConfigInfo[1]];
    
    self.orderNoLabel.text = dict[@"orderNo"];
    self.orderNoLabel.textColor = RGB(0xdc8911);
    
    self.specInfoLabel.text = [NSString stringWithFormat:@"%@(%@)",dict[@"workType"],dict[@"spec"]];
    self.specInfoLabel.textColor = cellConfigInfo[2];
    
    self.statusInfoLabel.text = dict[@"workStatus"];
    self.statusInfoLabel.textColor = cellConfigInfo[3];

    int leftTime = [dict[@"finishTimeLimit"] intValue];
    self.leftTimeInfoLabel.text = leftTime > 60 ? [NSString stringWithFormat:@"(余%d时%d分)",leftTime/60,leftTime%60] : [NSString stringWithFormat:@"(余%d分)",leftTime];
    self.leftTimeInfoLabel.textColor = RGB(0x000000);
    
    self.acceptTimeInfoLabel.text = dict[@"acceptTime"];
    
    self.descInfoLabel.text = dict[@"workContent"];
    self.descInfoLabel.textColor = RGB(0x000000);
}

- (NSArray*)getShowInfo:(NSDictionary *)dict
{
    UIColor* cellColor = RGB(0xffffff);
    UIColor* workStatusColor = RGB(0x000000);
    NSString* workStatusIcon = @"";
    UIColor* workLevelColor = RGB(0x000000);
    
    if ([dict[@"workStatus"] isEqualToString:@"挂起"]) workStatusColor = RGB(0xfa3300);
    if ([dict[@"workStatus"] isEqualToString:@"处理中"]) workStatusColor = RGB(0x1b7200);
    if ([dict[@"workStatus"] isEqualToString:@"观察"]) workStatusColor = RGB(0xfa6602);
    
    if (dict[@"faultLevel"] != nil) {
        if ([dict[@"faultLevel"] isEqualToString:@"一般"]){
            workLevelColor = RGB(0x0454ad);
        }
        if ([dict[@"faultLevel"] isEqualToString:@"严重"]) {
            workLevelColor = RGB(0xcc035f);
        }
        if ([dict[@"faultLevel"] isEqualToString:@"重大"]) {
            workLevelColor = RGB(0xef0000);
        }
        if ([dict[@"faultLevel"] isEqualToString:@"关键"]) {
            workLevelColor = RGB(0xff4d06);
        }
    }
    
    int all_num = [dict[@"faultTimeLimit"] intValue];     //总限制
    int finish_num = [dict[@"finishTimeLimit"] intValue]; //剩余时限(修改前是faultTimeLimit)
    if (all_num > 0) {
        int num = (all_num - finish_num) * 100 / all_num;
        if (num < 50){
            workStatusIcon = @"icon0.png";
        }
        if (num >= 50) {
            workStatusIcon = @"icon50.png";
            cellColor = RGB(0xf0cc4e); //黄色
        }
        if (num >= 75) {
            workStatusIcon = @"icon75.png";
            cellColor = RGB(0xf3abab); //较浅的红色
        }
        if (num >= 100) {
            workStatusIcon = @"icon100.png";
            cellColor = RGB(0xf8975b); //较深的红色
        }
        if (num >= 200) {
            workStatusIcon = @"icon2bei.png";
            cellColor = RGB(0xf8975b);//较深的红色
        }
        if (num >= 400) {
            workStatusIcon = @"icon4bei.png";
            cellColor = RGB(0xf8975b);//较深的红色
        }
    }
    
    BOOL isSuspend = [dict[@"workStatus"] isEqualToString:@"挂起"];
    if (isSuspend) {
        cellColor = RGB(0xffffff);
    }
    return @[cellColor, workStatusIcon, workLevelColor, workStatusColor];
}

@end
