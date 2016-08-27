//
//  Categorys.h
//  quanzhi
//
//  Created by ZhongYun on 14-1-9.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Postion)
@property(nonatomic,assign)CGFloat fx;
@property(nonatomic,assign)CGFloat fy;
@property(nonatomic,assign)CGFloat fw;
@property(nonatomic,assign)CGFloat fh;
@property(nonatomic,assign)CGFloat bx;
@property(nonatomic,assign)CGFloat by;
@property(nonatomic,assign)CGFloat bw;
@property(nonatomic,assign)CGFloat bh;
@property(nonatomic,assign, readonly)CGFloat ex;
@property(nonatomic,assign, readonly)CGFloat ey;
@end



@interface NSDictionary (MutableDeepCopy)
-(NSMutableDictionary *)mutableDeepCopy;
@end





#pragma mark - NSString Categories
@interface NSString (NoNullString)
@property(nonatomic, readonly)NSString* noNull;
@end

@interface NSString (StringToJson)
@property(nonatomic, readonly)id jsonValue;
@end





typedef void(^UIAlertViewButtonClick) (NSInteger btnIndex);
@interface UIAlertView (Block)<UIAlertViewDelegate>
- (void)showWithBlock:(UIAlertViewButtonClick)block;
@end


typedef void (^ActionBlock)();
@interface UIButton(Block)
@property (readonly) NSMutableDictionary *event;
//- (void) clickBlock:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;
- (void) clickBlock:(ActionBlock)block;
@end





