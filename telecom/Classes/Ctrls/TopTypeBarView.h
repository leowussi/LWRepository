//
//  TopTypeBarView.h
//  telecom
//
//  Created by 郝威斌 on 15/9/9.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopTypeBarView;

@protocol TopTypeBarDelegate<NSObject>

@optional

- (void)changeBefore:(TopTypeBarView*)sender;

- (void)changeAfter:(TopTypeBarView*)sender;


@end


@interface TopTypeBarView : UIView

@property(nonatomic,assign)BOOL isWireless;

@property(nonatomic,strong)NSMutableArray* typeList;

@property(nonatomic,assign)NSInteger selected;

@property(nonatomic,assign)NSInteger vcTag;

@property(nonatomic,assign)NSInteger buttonWidth;

@property (nonatomic, assign)id<TopTypeBarDelegate> delegate;

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count;

@end
