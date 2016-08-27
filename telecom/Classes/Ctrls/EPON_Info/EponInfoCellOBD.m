//
//  EponInfoCell.m
//  telecom
//
//  Created by liuyong on 15/10/20.
//  Copyright © 2015年 ZhongYun. All rights reserved.
/*
 @property(nonatomic,strong)NSString *searchResult;
 @property(nonatomic,strong)NSString *kind;
 @property(nonatomic,strong)NSString *equipName;
 @property(nonatomic,strong)NSString *equipCode;
 @property(nonatomic,strong)NSString *room;
 @property(nonatomic,strong)NSString *rack;
 @property(nonatomic,strong)NSString *equipType;
 @property(nonatomic,strong)NSString *factory;
 @property(nonatomic,strong)NSString *type;
 @property(nonatomic,strong)NSString *region;
 @property(nonatomic,strong)NSString *site;
 @property(nonatomic,strong)NSString *subType;
 @property(nonatomic,strong)NSString *obdLevel;
 @property(nonatomic,strong)NSString *upPortNo;
 @property(nonatomic,strong)NSString *equipSubType;
 @property(nonatomic,strong)NSString *cycle;
 @property(nonatomic,strong)NSString *address;
 @property(nonatomic,strong)NSString *inputTime;
 @property(nonatomic,strong)NSString *upEquipKind;
 @property(nonatomic,strong)NSString *upEquipCode;
 @property(nonatomic,strong)NSArray  *bottomList;
 */

#import "EponInfoCellOBD.h"
#import "BottomListModel.h"

@interface EponInfoCellOBD ()
{
    NSString *_cableName;
}
@end

@implementation EponInfoCellOBD

- (void)awakeFromNib
{
    [self.upperSet addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUpperSetInfo:)]];
    [self.bottomSetImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBottomSetInfo:)]];
    [self.info_5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToShowOBDPanel:)]];
}


- (void)configOBDCell:(EponInfoModelOBD *)model
{
    if (model.cableName != nil) {
        _cableName = model.cableName;
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:model.equipCode attributes:@{NSForegroundColorAttributeName : [UIColor redColor],  NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
        self.info_5.attributedText = attributeStr;
    }else{
        self.info_5.text = model.equipCode;
    }
    
    self.info_1.text  = model.upPortNo;
    self.info_2.text  = model.equipType;
    self.info_3.text  = model.obdLevel;
    self.info_4.text  = model.equipName;
    
    self.info_6.text  = model.region;
    self.info_7.text  = model.site;
    self.info_8.text  = model.room;
    self.info_9.text  = model.subType;
    self.info_10.text = model.factory;
    
    if ([model.upEquipCode isEqualToString:@""] && [model.upEquipKind isEqualToString:@""]) {
        self.upperSet.hidden = YES;
        self.upperSetInfo.hidden = YES;
    }
    
    if (model.bottomList.count == 0) {
        self.bottomSetImage.hidden = YES;
        self.bottomSetInfo.hidden = YES;
    }
}

- (void)clickToShowOBDPanel:(UITapGestureRecognizer *)ges
{
    if (self.delegate && _cableName != nil) {
        [self.delegate hRefToShowOBDPanelOf:_cableName];
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
