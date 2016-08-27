//
//  AttachmentDetailController.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface AttachmentDetailController : BaseViewController
@property (nonatomic,copy)NSString *commentId;
@property (retain, nonatomic) IBOutlet UITableView *attachDetailTbView;
@end
