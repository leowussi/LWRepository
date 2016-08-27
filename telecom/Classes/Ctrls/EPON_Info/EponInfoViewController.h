//
//  EponInfoViewController.h
//  telecom
//
//  Created by liuyong on 15/10/19.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EponInfoViewController : UIViewController
@property (nonatomic,copy)NSString *externalEquipKind;
@property (nonatomic,copy)NSString *flag;
- (void)searchEponInfoWithEquipCode:(NSString *)equipCode equipKind:(NSString *)equipKind flag:(NSString *)flag;
@end
