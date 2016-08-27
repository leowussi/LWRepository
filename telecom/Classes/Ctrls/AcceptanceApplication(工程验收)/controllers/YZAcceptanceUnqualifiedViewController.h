//
//  YZAcceptanceUnqualifiedViewController.h
//  telecom
//
//  Created by 锋 on 16/6/1.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZAcceptanceUnqualifiedViewController : SXABaseViewController

@property (nonatomic ,copy) NSString *checkId;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *recordArray;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *showMoreTitleArray;

//图片
@property (nonatomic, strong) NSMutableArray *imageArray;
//保存图片的URL
@property (nonatomic, strong) NSMutableArray *imageURLArray;



//保存任务说明的文字高度
@property (nonatomic, assign) CGFloat taskDescHeight;

@property (nonatomic, assign) BOOL isFromDetailVC;

@end
