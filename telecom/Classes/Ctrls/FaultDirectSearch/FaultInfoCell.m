//
//  FaultInfoCell.m
//  telecom
//
//  Created by liuyong on 15/10/27.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "FaultInfoCell.h"

@implementation FaultInfoCell

- (void)awakeFromNib {
    
    [self.sharePersonInfoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSharePersonInfo:)]];
}

- (void)showSharePersonInfo:(UITapGestureRecognizer *)ges
{
    if (self.delegate) {
        [self.delegate showSharePersonInfoWith:ges];
    }
}

- (void)configFaultInfoCell:(FaultInfoModel *)model
{
    if (model.sharedUser.length == 0) {
        self.sharePersonInfoImageView.hidden = YES;
    }
    
    NSArray *cellConfigInfo = [self getShowInfo:model];
    
    self.backgroundColor = cellConfigInfo[0];
    self.leftImageView.image = [UIImage imageNamed:cellConfigInfo[1]];
    
    self.orderNoLabel.text = model.orderNo;
    self.orderNoLabel.textColor = RGB(0xdc8911);
    
    self.workTypeLabel.text = [NSString stringWithFormat:@"%@(%@)",model.workType,model.spec];
    self.workTypeLabel.textColor = cellConfigInfo[2];
    
    self.workStatusLabel.text = model.workStatus;
    self.workStatusLabel.textColor = cellConfigInfo[3];
    
    int leftTime = [model.acceptTime intValue];
    self.leftTimeLabel.text = leftTime > 60 ? [NSString stringWithFormat:@"(余%d时%d分)",leftTime/60,leftTime%60] : [NSString stringWithFormat:@"(余%d分)",leftTime];
    self.leftTimeLabel.textColor = RGB(0x000000);
    
    self.acceptTimeLabel.text = model.acceptTime;
    
    NSString *workContent = model.workContent;
    CGRect bound = [workContent boundingRectWithSize:CGSizeMake(self.descriptionLabel.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil];
    CGRect tempFrame = self.descriptionLabel.frame;
    tempFrame.size.height = bound.size.height;
    self.descriptionLabel.frame = tempFrame;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.text = workContent;
    self.descriptionLabel.textColor = RGB(0x000000);
}


- (NSArray*)getShowInfo:(FaultInfoModel *)model
{
    UIColor* cellColor = RGB(0xffffff);
    UIColor* workStatusColor = RGB(0x000000);
    NSString* workStatusIcon = @"";
    UIColor* workLevelColor = RGB(0x000000);
    
    if ([model.workStatus isEqualToString:@"挂起"]) workStatusColor = RGB(0xfa3300);
    if ([model.workStatus isEqualToString:@"处理中"]) workStatusColor = RGB(0x1b7200);
    if ([model.workStatus isEqualToString:@"观察"]) workStatusColor = RGB(0xfa6602);
    
    if (model.faultLevel != nil) {
        if ([model.faultLevel isEqualToString:@"一般"]){
            workLevelColor = RGB(0x0454ad);
        }
        if ([model.faultLevel isEqualToString:@"严重"]) {
            workLevelColor = RGB(0xcc035f);
        }
        if ([model.faultLevel isEqualToString:@"重大"]) {
            workLevelColor = RGB(0xef0000);
        }
        if ([model.faultLevel isEqualToString:@"关键"]) {
            workLevelColor = RGB(0xff4d06);
        }
    }
    
    int all_num = [model.faultTimeLimit intValue];     //总限制
    int finish_num = [model.finishTimeLimit intValue]; //剩余时限
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
    
    BOOL isSuspend = [model.workStatus isEqualToString:@"挂起"];
    if (isSuspend) {
        cellColor = RGB(0xffffff);
    }
    return @[cellColor, workStatusIcon, workLevelColor, workStatusColor];
}
@end
