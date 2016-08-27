//
//  RespondViewController.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface RespondViewController : BaseViewController
@property (nonatomic,copy)NSString *workNum;
@property (nonatomic,copy)NSString *orderNo;
@property (retain, nonatomic) IBOutlet UILabel *workNo;
@property (retain, nonatomic) IBOutlet UILabel *handlePerson;
@end
