//
//  TaskWirelessInputText.h
//  telecom
//
//  Created by ZhongYun on 15-3-24.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

#define INPUT_TEXT          1
#define INPUT_DATE          2
#define INPUT_DATE_TIME     3
#define INPUT_NUMBER        4
#define INPUT_MEMO          5

@interface TaskWirelessInputText : BaseViewController
+(void)show:(NSArray*)params;
@end
