//
//  ZYFEditStringController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/8.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFEditableCell.h"

@class ZYFEditStringController;

@protocol ZYFEditStringControllerDelegate <NSObject>

-(void)editStringController:(ZYFEditStringController*)ctrl editString: (NSString*)editString;

@end

@interface ZYFEditStringController : UITableViewController

@property (nonatomic,weak) ZYFEditableCell *cell;
@property (nonatomic,strong) NSArray *cellData;

@property (nonatomic,copy) NSString *info;

//为真只显示数字键盘，否则不进行限制
@property (nonatomic,assign,getter=isShowNumKeyboard) BOOL showNumKeyboard;


@property (nonatomic,assign) id<ZYFEditStringControllerDelegate> delegate;

@end
