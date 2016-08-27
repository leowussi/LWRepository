//
//  ImageDetailController.h
//  telecom
//
//  Created by liuyong on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@interface ImageDetailController : SXABaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *imageDetailScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property(nonatomic,strong)NSArray *fileIdArray;
@property(nonatomic,assign)NSInteger pageIndex;
@end
