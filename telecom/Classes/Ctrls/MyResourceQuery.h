//
//  MyResourceQuery.h
//  telecom
//
//  Created by 郝威斌 on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
@interface MyResourceQuery : BaseViewController<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@property(assign,nonatomic)NSInteger vcTag;
@property (nonatomic,copy)NSString *searchCondition;
- (void)loadData:(NSString*)keyword;
@end
