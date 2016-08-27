//
//  YZResourcesChangeDetailViewController.h
//  CheckResourcesChange
//
//  Created by 锋 on 16/4/29.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZResourcesChangeDetailViewController : SXABaseViewController


@property (nonatomic, copy) NSString *infoId;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageArray;




@end
