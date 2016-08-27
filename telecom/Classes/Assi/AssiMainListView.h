//
//  AssiMainListView.h
//  telecom
//
//  Created by ZhongYun on 15-1-5.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YY_SGRW       1
#define YY_SGYY       2

@interface AssiMainListView : UIView
@property (nonatomic, retain)NSDictionary* typeInfo;
- (void)viewDidLoad;
- (void)loadData;
- (void)openAssiDetailById:(NSString*)appointmentId;
@end
