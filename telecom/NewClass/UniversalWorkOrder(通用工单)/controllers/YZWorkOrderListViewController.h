//
//  YZWorkOrderListViewController.h
//  telecom
//
//  Created by 锋 on 16/6/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZWorkOrderList.h"
@protocol YZWorkOrderListViewControllerDelegate;

@interface YZWorkOrderListViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *workOrderTitle;

@property (nonatomic, copy) NSString *billId;
@property (nonatomic, assign) CGPoint inDicatorLocation;

@property (nonatomic, weak) id<YZWorkOrderListViewControllerDelegate> delegate;

@end

@interface YZInDicatorView : UIView

@end

@protocol YZWorkOrderListViewControllerDelegate <NSObject>

@optional

- (void)workOrderListViewController:(YZWorkOrderListViewController *)listVc workOrderDidSelected:(YZWorkOrderList *)list;

- (void)workOrderListViewControllerWillDisappear;

@end

