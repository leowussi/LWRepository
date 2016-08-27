//
//  MyEngineRoomDetailView.h
//  telecom
//
//  Created by ZhongYun on 14-8-22.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TI_SITE_INFO       1
#define TI_ROOM_INFO       2
#define TI_ROOM_FRAME      3

@interface MyEngineRoomDetailView : UIView
@property (nonatomic, retain)NSDictionary* typeInfo;
@property (nonatomic, copy)NSString* roomId;
- (void)buildView;
@end
