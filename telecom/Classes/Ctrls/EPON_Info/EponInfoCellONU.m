//
//  EponInfoCellONU.m
//  telecom
//
//  Created by liuyong on 15/10/21.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "EponInfoCellONU.h"
#import "BottomListModel.h"

@implementation EponInfoCellONU

- (void)awakeFromNib
{
    [self.upperSetImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUpperSetInfo:)]];
    [self.bottomSetImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBottomSetInfo:)]];
}

- (void)configONUCell:(EponInfoModelONU *)model
{
    self.info_1.text  = model.equipName;
    self.info_2.text  = model.equipCode;
    self.info_3.text  = model.equipType;
    self.info_4.text  = model.equipSubType;
    self.info_5.text  = model.cycle;
    self.info_6.text  = model.address;
    self.info_7.text  = model.inputTime;
    self.info_8.text  = model.upPortNo;
    
    if ([model.upEquipCode isEqualToString:@""] && [model.upEquipKind isEqualToString:@""]) {
        self.upperSetCode.hidden = YES;
        self.upperSetImage.hidden = YES;
    }
    
    if (model.bottomList.count == 0) {
        self.bottomSetImage.hidden = YES;
        self.bottomSetInfo.hidden = YES;
    }
}

- (void)showUpperSetInfo:(UITapGestureRecognizer *)ges
{
    NSLog(@"上联设备");
    if (self.delegate) {
        [self.delegate showUpperSetsInfoOfGes:ges];
    }
}

- (void)showBottomSetInfo:(UITapGestureRecognizer *)ges
{
    NSLog(@"下联设备");
    if (self.delegate) {
        [self.delegate showBottomSetsInfoOfGes:ges];
    }
}
@end
