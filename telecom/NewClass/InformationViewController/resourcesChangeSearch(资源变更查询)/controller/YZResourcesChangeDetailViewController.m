//
//  YZResourcesChangeDetailViewController.m
//  CheckResourcesChange
//
//  Created by 锋 on 16/4/29.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZResourcesChangeDetailViewController.h"
#import "YZResourcesInfoDetailTableViewCell.h"
#import "YZImageCollectionViewCell.h"
#import "YZLiuShuiTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "YZLiuShuiViewController.h"
#import "YZResourcesChangeViewController.h"
#import "YZPhotoBrowserViewController.h"
#import "YZResourcesChangeRevokeViewController.h"
#import "YZResourcesResultCommentViewController.h"
#import "YZMenuView.h"

@interface YZResourcesChangeDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,YZMenuViewDelegate>
{
    CALayer *_selectedLineLayer;
    CGRect _markImageFrame;
    BOOL _isInfoDetail;
    NSMutableArray *_detailInfoHeightArray;
    
    //底部的scrollView
    UIScrollView *_basicScrollView;
    //导航条右侧的按钮
    UIBarButtonItem *_rightItem;
    
    UIView *_footerView;
    
    //显示更多
    
    NSArray *_sectionOneTitleArray;
    
    NSMutableArray *_jurisdictionArray;
    
    YZMenuView *_menuView;
}
@end

@implementation YZResourcesChangeDetailViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_menuView.isShow) {
        [_menuView removeFromSuperview];
        CGRect rect = _menuView.frame;
        rect.origin.x = kScreenWidth;
        _menuView.frame = rect;
        _menuView.isShow = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"资源变更详情信息";
    _isInfoDetail = YES;
    [self loadData];
    [self createHeaderView];
    
    [self createBasicScrollView];
    [self createTableView];
    [self addNavigationLeftButton];
}

- (void)createBasicScrollView
{
    _basicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 107, kScreenWidth, kScreenHeight - 107)];
    _basicScrollView.pagingEnabled = YES;
    _basicScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - 107);
    _basicScrollView.directionalLockEnabled = YES;
    _basicScrollView.showsHorizontalScrollIndicator = NO;
    _basicScrollView.delegate = self;
    [self.view addSubview:_basicScrollView];
    
    YZLiuShuiViewController *liuShuiVC = [[YZLiuShuiViewController alloc] init];
    liuShuiVC.infoId = self.infoId;
    [self addChildViewController:liuShuiVC];
    liuShuiVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 107);
    [_basicScrollView addSubview:liuShuiVC.view];
    
}

//导航条右侧的按钮
- (void)addNavigationRightButtonWithEditable:(NSString *)editable cancelable:(NSString *)cancelable commentable:(NSString *)commentable
{
    _jurisdictionArray = [[NSMutableArray alloc] initWithCapacity:0];
    if ([cancelable isEqualToString:@"0"]) {
        [_jurisdictionArray addObject:@"撤销"];
    }
    if ([editable isEqualToString:@"0"]) {
        [_jurisdictionArray addObject:@"变更"];
    }
    if ([commentable isEqualToString:@"0"]) {
        [_jurisdictionArray addObject:@"点评"];
    }
    if (_jurisdictionArray.count == 0) {
        _jurisdictionArray = nil;
        return;
    }
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"3_1"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 30, 32);
    [rightButton addTarget:self action:@selector(rightBarbuttonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = _rightItem;
}

- (void)rightBarbuttonItemClicked
{
    if (_menuView.isShow) {
        [UIView animateWithDuration:.2 animations:^{
            _menuView.frame = CGRectMake(kScreenWidth, 64, 80, _menuView.frame.size.height);
            
        } completion:^(BOOL finished) {
            [_menuView removeFromSuperview];
            _menuView.isShow = NO;
        }];
        return;
    }
    if (_menuView == nil) {
        _menuView = [[YZMenuView alloc] initWithFrame:CGRectMake(kScreenWidth, 64, 80, 0) titleArray:_jurisdictionArray];
        _menuView.delegate = self;
    }
    [self.view addSubview:_menuView];
    _menuView.isShow = YES;
    [UIView animateWithDuration:.2 animations:^{
        _menuView.frame = CGRectMake(kScreenWidth - 80, 64, 80, _menuView.frame.size.height);
        
    }];

}

#pragma mark -- 撤销,点评,变更
- (void)menuView:(YZMenuView *)menuView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = _jurisdictionArray[buttonIndex - 1];
    if ([title isEqualToString:@"撤销"]) {
        [self turnToYZResourcesChangeRevokeViewController];
    }else if ([title isEqualToString:@"变更"]) {
        [self turnToYZResourcesChangeViewController];
    }else if ([title isEqualToString:@"点评"]) {
        [self turnToYZResourcesResultCommentViewController];
    }
}

- (void)turnToYZResourcesChangeRevokeViewController
{
    YZResourcesChangeRevokeViewController *revokeVc = [[YZResourcesChangeRevokeViewController alloc] init];
    revokeVc.workOrderId = _infoId;
    [self.navigationController pushViewController:revokeVc animated:YES];
}

- (void)turnToYZResourcesChangeViewController
{
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    resourcesChangeVC.haveSystemInfo = YES;
    NSArray *systemArray = [_dataArray[0][1] componentsSeparatedByString:@"\n"];
    resourcesChangeVC.systemArray = systemArray;
    NSMutableDictionary * dataDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *sectionArray = _dataArray[0];
    for (int i = 0; i < sectionArray.count - 8; i++) {
        [dataDict setObject:sectionArray[i+2] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [dataDict setObject:_infoId forKey:@"infoId"];
    [dataDict setObject:_dataArray[1][12] forKey:@"9"];
    resourcesChangeVC.isUpdateResources = YES;
    resourcesChangeVC.dataDict = dataDict;
    resourcesChangeVC.imageArray = [NSMutableArray arrayWithArray:_imageArray];
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *obj in _imageArray) {
        NSArray *tempArray = [obj componentsSeparatedByString:@"/"];
        [mutArray addObject:[tempArray lastObject]];
    }
    resourcesChangeVC.imageURLArray = mutArray;
    [self.navigationController pushViewController:resourcesChangeVC animated:YES];

}

- (void)turnToYZResourcesResultCommentViewController
{
    YZResourcesResultCommentViewController *commentVc = [[YZResourcesResultCommentViewController alloc] init];
    commentVc.workOrderId = _infoId;
    [self.navigationController pushViewController:commentVc animated:YES];
}

#pragma mark -- 加载数据
- (void)loadData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"adjustRes/QueryAdjustResById";
    paraDict[@"id"] = _infoId;
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        NSString *resultString = [result objectForKey:@"result"];
        if ([resultString isEqualToString:@"0000000"]) {
            NSDictionary *detailDict = [result objectForKey:@"detail"];
            NSString *orderid = [detailDict objectForKey:@"orderid"];
            NSString *sysinfo = [[detailDict objectForKey:@"sysinfo"] stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
            
            NSString *subtype = [detailDict objectForKey:@"subtype"];
            NSString *subtyperemark = [detailDict objectForKey:@"subtyperemark"];
            NSString *major = [detailDict objectForKey:@"major"];
            NSString *title = [detailDict objectForKey:@"title"];
            NSString *remarks = [detailDict objectForKey:@"remarks"];
            NSString *liveinfo = [detailDict objectForKey:@"liveinfo"];
            NSString *source = [detailDict objectForKey:@"source"];
            NSString *faulttype = [detailDict objectForKey:@"faulttype"];
            NSString *faulttyperemark = [detailDict objectForKey:@"faulttyperemark"];
            
            NSArray *sectionArray0 = [[NSArray alloc] initWithObjects:orderid,sysinfo,subtype,subtyperemark,major,title,remarks,liveinfo,source,faulttype,faulttyperemark,[detailDict objectForKey:@"dealdept"],[detailDict objectForKey:@"dealrole"],[detailDict objectForKey:@"status"],[detailDict objectForKey:@"createtime"],[detailDict objectForKey:@"username"],[detailDict objectForKey:@"dealuser"],[detailDict objectForKey:@"dealresult"], nil];
            
            
            NSArray *sectionArray1 = [[NSArray alloc] initWithObjects:[detailDict objectForKey:@"localnetnm"],[detailDict objectForKey:@"gridname"],[detailDict objectForKey:@"limittime"],[detailDict objectForKey:@"dealines"],[detailDict objectForKey:@"taskcode"],[[detailDict objectForKey:@"tasklongtitude"] stringValue],[[detailDict objectForKey:@"tasklatitude"] stringValue],[detailDict objectForKey:@"difficultylevel"],[detailDict objectForKey:@"costtime"],[detailDict objectForKey:@"score"],[detailDict objectForKey:@"needpersonnum"],[detailDict objectForKey:@"skill"],[detailDict objectForKey:@"emergency"], nil];
            
            
            _dataArray = [[NSArray alloc] initWithObjects:sectionArray0,sectionArray1, nil];
            
            NSMutableArray *sectionHeightArray0 = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *sectionHeightArray1 = [NSMutableArray arrayWithCapacity:0];
            for (NSString *text in sectionArray0) {
                
                CGFloat height = [self calculateTextheight:text withTextWidth:kScreenWidth - 140];
                height = height + 2 > 26 ? height + 2 : 26;
                [sectionHeightArray0 addObject:[NSNumber numberWithFloat:height]];
            }
            for (NSString *text in sectionArray1) {
                CGFloat height = [self calculateTextheight:text withTextWidth:kScreenWidth - 140];
                height = height + 2 > 26 ? height + 2 : 26;
                [sectionHeightArray1 addObject:[NSNumber numberWithFloat:height]];
            }
            _detailInfoHeightArray = [[NSMutableArray alloc] initWithObjects:sectionHeightArray0,sectionHeightArray1, nil];
            _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *fileArray = [detailDict objectForKey:@"fileList"];
            for (NSDictionary *dict in fileArray) {
                NSString *fileId = [dict objectForKey:@"fileId"];
                NSString *imageUrl = [NSString stringWithFormat:@"http://%@/%@/attachment/adjustResFile/(fileid)",ADDR_IP,ADDR_DIR];
                imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"(fileid)" withString:fileId];
                [_imageArray addObject:imageUrl];
            }
            
            [self setResourceChangeTitle];
            [_tableView reloadData];
            
            //判断是否有变更,撤销,点评等权限
            NSString *editable = [detailDict objectForKey:@"editable"];
            NSString *cancelable = [detailDict objectForKey:@"cancelable"];
            NSString *commentable = [detailDict objectForKey:@"commentable"];
             [self addNavigationRightButtonWithEditable:editable cancelable:cancelable commentable:commentable];
        }
        
        
    }, ^(id result) {
        NSLog(@"%@",result);
    });
    
}

- (void)setResourceChangeTitle
{
    NSArray *sectionArray0 = [[NSArray alloc] initWithObjects:@"工    单    编    号 :",@"系    统    情    况 :",@"细 化 任 务 类 型:",@"细化任务类型(其他):",@"专                    业 :",@"任    务    标    题 :",@"任    务    内    容 :",@"现    场    情    况 :",@"来                    源 :",@"错    误    类    型 :",@"错 误 类 型(其他):",@"处    理    部    门 :",@"处  理  人  角  色 :",@"工    单    状    态 :",@"工 单 受 理 时 间:",@"发        起        人 :",@"执        行        人 :",@"处    理    结    果 :", nil];
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:sectionArray0, nil];

}

- (void)createHeaderView
{
    UIButton *detailInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailInfoButton.frame = CGRectMake(0, 64, kScreenWidth/2, 40);
    [detailInfoButton setTitle:@"详情信息" forState:UIControlStateNormal];
    detailInfoButton.selected = YES;
    [detailInfoButton setTitleColor:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1] forState:UIControlStateNormal];
    [detailInfoButton setTitleColor:[UIColor colorWithRed:236/255.0 green:125/255.0 blue:29/255.0 alpha:1] forState:UIControlStateSelected];
    detailInfoButton.tag = 1;
    [detailInfoButton addTarget:self action:@selector(detailInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailInfoButton];
    
    UIButton *liuShuiInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    liuShuiInfoButton.frame = CGRectMake(kScreenWidth/2, 64, kScreenWidth/2, 40);
    [liuShuiInfoButton setTitle:@"流水信息" forState:UIControlStateNormal];
    [liuShuiInfoButton setTitleColor:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1] forState:UIControlStateNormal];
    [liuShuiInfoButton setTitleColor:[UIColor colorWithRed:236/255.0 green:125/255.0 blue:29/255.0 alpha:1] forState:UIControlStateSelected];
    liuShuiInfoButton.tag = 2;
    [liuShuiInfoButton addTarget:self action:@selector(detailInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liuShuiInfoButton];
    
    
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.frame = CGRectMake(0, 106, kScreenWidth, 1);
    lineLayer.backgroundColor = [UIColor colorWithRed:249/255.0 green:133/255.0 blue:0 alpha:1].CGColor;
    [self.view.layer addSublayer:lineLayer];
    
    _selectedLineLayer = [[CALayer alloc] init];
    _selectedLineLayer.frame = CGRectMake(0, 104, kScreenWidth/2, 2);
    _selectedLineLayer.backgroundColor = [UIColor colorWithRed:249/255.0 green:133/255.0 blue:0 alpha:1].CGColor;
    [self.view.layer addSublayer:_selectedLineLayer];
}


//按钮被点击
- (void)detailInfoButtonClicked:(UIButton *)sender
{
    
    if (sender.tag == 1) {
        UIButton *button = [self.view viewWithTag:2];
        button.selected = NO;
        _selectedLineLayer.frame = CGRectMake(0, 104, kScreenWidth/2, 2);
        [_basicScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.navigationItem.rightBarButtonItem = _rightItem;
        self.navigationItem.title = @"资源变更详情信息";
    }else{
        UIButton *button = [self.view viewWithTag:1];
        button.selected = NO;
        _selectedLineLayer.frame = CGRectMake(kScreenWidth/2, 104, kScreenWidth/2, 2);
        [_basicScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.title = @"流水信息";
    }
    sender.selected = YES;
}


#pragma mark -- tableView
- (void)createTableView
{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 107) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_basicScrollView addSubview:_tableView];
    
}

- (void)createFooterView
{
    CGFloat height = 0.0f;
    if (_imageArray.count != 0) {
        height = 112 + (_imageArray.count - 1)/3 * 74;
    }
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height + 40)];
    
    UIButton * showMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showMoreButton.frame = CGRectMake(30, _footerView.frame.size.height - 34, kScreenWidth - 60, 30);
    [showMoreButton setTitle:@"显示更多" forState:UIControlStateNormal];
    [showMoreButton setTitle:@"收起" forState:UIControlStateSelected];
    [showMoreButton setTitleColor:[UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [showMoreButton addTarget:self action:@selector(showMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    showMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_footerView addSubview:showMoreButton];
    
    if (height < 1) {
        return;
    }
    //创建collectionView
    [self createCollectionView:height];
}

#pragma mark -- 创建collectionView
- (void)createCollectionView:(CGFloat)height
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(75, 64);
    layout.minimumLineSpacing = 18;
    layout.minimumInteritemSpacing  = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 24, 10, 18);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YZImageCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
    [_footerView addSubview:_collectionView];
}

- (void)showMoreButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (_sectionOneTitleArray == nil) {
           _sectionOneTitleArray = [[NSArray alloc] initWithObjects:@"本  地  网  名  称 :",@"区域或班组名称 :",@"工    单    时    限 :",@"工 单 归 档 时 间:",@"文                    号 :",@"任 务 位 置 经 度:",@"任 务 位 置 纬 度:",@"难    度    等    级 :",@"经    验    耗    时 :",@"积                    分 :",@"需    要    人    数 :",@"技    能    要    求 :",@"紧    急    程    度 :", nil];
        }
        [_titleArray addObject:_sectionOneTitleArray];
        [_tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [_titleArray removeLastObject];
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


#pragma mark -- collectViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    [cell.imageView_upImage sd_setImageWithURL:_imageArray[indexPath.item] placeholderImage:[UIImage imageNamed:@"等待图片"]];
    cell.button_delete.hidden = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZImageCollectionViewCell *cell = (YZImageCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    
    [window addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.imageView_upImage.image];
    imageView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + _footerView.frame.origin.y - _tableView.contentOffset.y + 107 + 8, cell.frame.size.width - 8, cell.frame.size.height - 8);
    [view addSubview:imageView];
    
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [UIView animateWithDuration:.25f animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        //        view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        imageView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        CGSize imageSize = imageView.image.size;
        CGSize screenSize = self.view.frame.size;
        
        //根据屏幕的大小,调整比例
        if (imageSize.width <= screenSize.width && imageSize.height <= screenSize.height) {
            
            imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
            
        }else{
            
            imageView.bounds = CGRectMake(0, 0, screenSize.width, screenSize.width * imageSize.height/imageSize.width);
            
        }
        
    } completion:^(BOOL finished) {
        [window sendSubviewToBack:view];
        YZPhotoBrowserViewController *photoBrowserVc = [[YZPhotoBrowserViewController alloc] init];
        photoBrowserVc.imageArray = _imageArray;
        photoBrowserVc.showIndex = indexPath.item;
        photoBrowserVc.backBlock = ^(UIImage *image,CGRect frame,NSInteger index){
            [window bringSubviewToFront:view];
            imageView.image = image;
            imageView.frame = frame;
            [self imageClicked:imageView withCellIndex:index];
        };
        [self.navigationController pushViewController:photoBrowserVc animated:NO];
        
    }];

}

//图片消失
- (void)imageClicked:(UIImageView *)imageView withCellIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    CGRect imageFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + _footerView.frame.origin.y - _tableView.contentOffset.y + 107 + 8, cell.frame.size.width - 8, cell.frame.size.height - 8);
    [UIView animateWithDuration:.25f animations:^{
        imageView.superview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        imageView.frame = imageFrame;
        
    } completion:^(BOOL finished) {
        [imageView.superview removeFromSuperview];
    }];
    
    
}

#pragma mark -- tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _titleArray[section];
    return  array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YZResourcesInfoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZResourcesInfoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.label_title.frame = CGRectMake(10, 9, 120, 22);
        cell.label_title.numberOfLines =  1;
        [cell.label_title setAdjustsFontSizeToFitWidth:YES];
    }
    cell.label_title.text = _titleArray[indexPath.section][indexPath.row];
    
    cell.label_detail.text = _dataArray ? _dataArray[indexPath.section][indexPath.row] : nil;
    CGFloat height = [_detailInfoHeightArray[indexPath.section][indexPath.row] floatValue];
    cell.label_detail.frame = CGRectMake(130, 8, self.view.frame.size.width - 140, height);
    
    
    return cell;
    
}

#pragma mark -- 区尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!_imageArray) {
        return nil;
    }
    if (section == 1) {
        return nil;
    }
    if (_footerView == nil) {
        [self createFooterView];
    }
    return _footerView;
}
#pragma mark -- 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = [_detailInfoHeightArray[indexPath.section][indexPath.row] floatValue];
    return height + 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 22;
    }
    if (_footerView == nil) {
        [self createFooterView];
    }
    
    return _footerView.frame.size.height;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark -- scrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger number = scrollView.contentOffset.x/kScreenWidth;
    if (number == 0) {
        UIButton *selectedButton = [self.view viewWithTag:1];
        selectedButton.selected = YES;
        UIButton *button = [self.view viewWithTag:2];
        button.selected = NO;
        _selectedLineLayer.frame = CGRectMake(0, 104, kScreenWidth/2, 2);
        self.navigationItem.rightBarButtonItem = _rightItem;
        self.navigationItem.title = @"资源变更详情信息";
    }else{
        UIButton *selectedButton = [self.view viewWithTag:2];
        selectedButton.selected = YES;
        UIButton *button = [self.view viewWithTag:1];
        button.selected = NO;
        _selectedLineLayer.frame = CGRectMake(kScreenWidth/2, 104, kScreenWidth/2, 2);
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.title = @"流水信息";
    }
    
}


- (CGFloat)calculateTextheight:(NSString *)text withTextWidth:(CGFloat)width
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return ceilf(rect.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
