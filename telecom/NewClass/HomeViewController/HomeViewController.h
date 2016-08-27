//
//  HomeViewController.h
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "SXABaseViewController.h"
#import "UICollectionViewWaterfallLayout.h"
@interface HomeViewController : SXABaseViewController<UIScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDelegateWaterfallLayout>
@property (nonatomic,copy)NSString *memoryItem;
@property (nonatomic,copy)NSString *urlFlag;
@property(strong,nonatomic)UIScrollView *topScoreView;
@property(strong,nonatomic)UIScrollView *midScoreView;

//- (void)pushToCtrlWith:(NSString *)workNo;

@end
