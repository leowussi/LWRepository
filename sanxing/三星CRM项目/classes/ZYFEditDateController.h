//
//  ZYFEditDateController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/8.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYFEditDateController;

@protocol ZYFEditDateControllerDelegate <NSObject>

-(void)editDateChanged:(ZYFEditDateController*)editDateCtrl dateStr:(NSString*)dateString;

@end

@interface ZYFEditDateController : UIViewController

@property (nonatomic,copy) NSString *date;

//如果是uitalbeview，区别该控件中选中的是某一行
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id<ZYFEditDateControllerDelegate> delegate;

@end
