//
//  HIddenDetailViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"
#import "HiddenEditViewController.h"

@interface HIddenDetailViewController : SXABaseViewController<hiddendelegate>

@property(strong,nonatomic)NSDictionary *dic;
@property(strong,nonatomic)NSString *strDangerId;
@property(strong,nonatomic)NSString *Vctag;
@end
