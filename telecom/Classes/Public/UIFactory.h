//
//  UIFactory.h
//  telecom
//
//  Created by ZhongYun on 14-6-11.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define newImageView(x)         [[UIImageView alloc] initWithImage:[UIImage imageNamed:x]]

UILabel* newLabel(UIView* view, NSArray* p);
UITextField* newTextField(UIView* view, NSArray* p);
UITextView* newTextView(UIView* view, NSArray* p);
UIImageView* newImageView(UIView* v, NSArray* p);


