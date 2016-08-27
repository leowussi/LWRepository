//
//  SelledFaultReceiptController.h
//  telecom
//
//  Created by SD0025A on 16/5/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@class IFlyDataUploader;
@class IFlyRecognizerView;
@interface SelledFaultReceiptController : SXABaseViewController
@property (nonatomic,copy) NSString *workNo;
@property (nonatomic,copy) NSString *orderNO;
@property (nonatomic,copy) NSString *actionType;
//带界面的听写识别对象
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;
//数据上传对象
@property (nonatomic, strong) IFlyDataUploader * uploader;
@end
