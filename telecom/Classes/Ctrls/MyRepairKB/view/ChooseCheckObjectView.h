//
//  ChooseCheckObjectView.h
//  telecom
//
//  Created by liuyong on 15/8/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ChooseCheckObjectViewDelegate<NSObject>
- (void)deliverCheckObjectChooseString:(NSString *)chooseString targetGroupId:(NSString *)targetGroupId;
@end

@interface ChooseCheckObjectView : UIView
@property(nonatomic,weak)id <ChooseCheckObjectViewDelegate> delegate;
- (void)loadDataWithURL:(NSString *)urlString workNo:(NSString *)workNo;
@end
