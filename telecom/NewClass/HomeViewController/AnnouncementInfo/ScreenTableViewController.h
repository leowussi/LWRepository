//
//  ScreenTableViewController.h
//  telecom
//
//  Created by Sundear on 16/1/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ScreenBlock)(NSString *noteType ,NSString *specType);
@interface ScreenTableViewController : BaseViewController
@property (nonatomic,strong)ScreenBlock screen;
@end
