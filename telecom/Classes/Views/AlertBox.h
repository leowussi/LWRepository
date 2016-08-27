//
//  AlerBox.h
//  telecom
//
//  Created by ZhongYun on 14-6-15.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BTN_NO  0
#define BTN_OK  1

typedef void(^AlertBoxBlock)(int index);
@interface AlertBox : UIView
@property(nonatomic,strong)UIView* contentView;
@property(nonatomic,strong)AlertBoxBlock respBlock;
@property(nonatomic,copy)NSString*  title;

- (id)initWithContentSize:(CGSize)contentSize Btns:(NSArray*)names;
- (void)show;
@end
