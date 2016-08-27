//
//  MemoInput.h
//  telecom
//
//  Created by ZhongYun on 15-4-15.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoInput : UIView
@property(nonatomic,copy)NSString* currValue;
@property(nonatomic,copy)void(^changeBlock)(NSString* result);
@end
