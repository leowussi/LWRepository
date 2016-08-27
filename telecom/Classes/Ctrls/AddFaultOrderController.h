//
//  AddFaultOrderController.h
//  telecom
//
//  Created by liuyong on 15/5/15.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"
//forward declare
@class IFlyDataUploader;
@class IFlyRecognizerView;

@interface AddFaultOrderController : BaseViewController
//带界面的听写识别对象
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;

@property(nonatomic,strong)NSDictionary *callBackInfoDict;

@property (retain, nonatomic) IBOutlet UILabel *majorLabel;
@property (retain, nonatomic) IBOutlet UILabel *kindOfWorkLabel;
@property (retain, nonatomic) IBOutlet UILabel *faultLevelLabel;
@property (retain, nonatomic) IBOutlet UILabel *zoneAreaInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *stationInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *machineRoomInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *wangYuanInfoLabel;
@property (retain, nonatomic) IBOutlet UITextField *descOfFaultText;
@property (retain, nonatomic) IBOutlet UIImageView *voiceInputImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *attachmentImage;

@end
