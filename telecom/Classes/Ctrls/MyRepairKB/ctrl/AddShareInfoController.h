//
//  AddShareInfoController.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface AddShareInfoController : BaseViewController
@property (nonatomic,copy)NSString *faultId;
@property (retain, nonatomic) IBOutlet UITextField *inputShareInfo;
@property (retain, nonatomic) IBOutlet UIScrollView *attachmentInfo;

@end
