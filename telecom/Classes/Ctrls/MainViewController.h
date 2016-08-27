//
//  MainViewController.h
//  telecom
//
//  Created by ZhongYun on 14-6-11.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface MainViewController : BaseViewController
- (void)apsToMyBookingList;
- (void)apsToMyBookingDetail:(NSString*)detailId WithType:(int)type;
@end
