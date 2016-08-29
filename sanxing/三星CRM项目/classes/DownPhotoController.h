//
//  DownPhotoController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/31.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@interface DownPhotoController : UIViewController

//任务内容的saleList
@property (nonatomic,strong) ZYFSaleList *cleanDefectSale ;

@property (nonatomic,copy) NSString *cleanTaskId;

//查看照片url
@property (nonatomic,copy) NSString *urlString;


@end
