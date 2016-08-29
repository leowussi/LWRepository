//
//  PostPhotoController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/23.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@interface PostPhotoController : UIViewController

@property (nonatomic,strong) ZYFSaleList *cleanDefectSale;
@property (nonatomic,copy) NSString *cleanTaskId;

//上传照片的url
@property (nonatomic,copy) NSString *urlString;

@end
