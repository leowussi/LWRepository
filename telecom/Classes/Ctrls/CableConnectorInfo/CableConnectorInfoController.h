//
//  CableConnectorInfoController.h
//  telecom
//
//  Created by liuyong on 15/11/11.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CableConnectorInfoController : UIViewController
@property (nonatomic,copy)NSString *cableName;
- (void)loadDataWithSearchCondition:(NSString *)condition curPage:(NSInteger)curPage pageSize:(NSInteger)pageSize;
@end
