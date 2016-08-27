//
//  AlarmInfoViewController.h
//  telecom
//
//  Created by liuyong on 9/14/15.
//  Copyright (c) 2015 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *workNo;
@property (nonatomic,copy)NSString *orderNo;
@end
