//
//  ZonghehuaDetailViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/9/18.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"
#import "ZhPthotoViewController.h"

@interface ZonghehuaDetailViewController : SXABaseViewController<upPhotoDlegate>

@property(strong,nonatomic)NSString *strTaskId;
@property(strong,nonatomic)NSString *strTitle;

@end
