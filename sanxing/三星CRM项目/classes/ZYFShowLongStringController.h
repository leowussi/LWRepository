//
//  ZYFShowLongStringController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/25.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZYFShowLongStringController;


@protocol ZYFShowLongStringControllerDelegate <NSObject>

-(void)showLongStringController:(ZYFShowLongStringController*)ctrl editString: (NSString*)editString;

@end


//用来显示较长的字符串,默认不可以编辑
@interface ZYFShowLongStringController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,copy) NSString *textString;

@property (nonatomic,assign,getter=isEditable) BOOL editable;

//键盘类型
@property (nonatomic,assign) NSInteger keyType;

//如果是UITableviewCell类型空间触发的，则为了区分是点击的哪一行，所以传入该行的indexpath
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id<ZYFShowLongStringControllerDelegate> delegate;


@end
