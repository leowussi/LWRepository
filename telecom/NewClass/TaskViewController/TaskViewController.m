//
//  TaskViewController.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskCollectionViewCell.h"
#import "SearchViewController.h"
#import "LeftViewController.h"
#import "TaskDatailViewController.h"
#import "MyBookingAdd.h"
//#import "MyBookingList2.h"
#import "UIImageView+WebCache.h"
#import "AllTaskViewController.h"
#import "AddTemporaryViewController.h"
#import "TemporaryViewController.h"
#import "HiddenTroubleViewController.h"
#import "MyFindHiddenViewController.h"
#import "ImportantSecurityViewController.h"

@interface TaskViewController ()
{
    UICollectionView *colectionView;
    NSMutableArray *_taskAuthorityArray;
}
@end

@implementation TaskViewController

-(void)viewWillAppear:(BOOL)animated
{   self.backBtn.hidden=YES;
    [self hiddenBottomBar:NO];
    UIColor *color = [UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = color;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _baseScrollView.backgroundColor = [UIColor whiteColor];
    _taskAuthorityArray = [NSMutableArray array];
    [self addSearchBar];
    [self addNavigationRightButton:@"头像.png"];
    
    [self addMessageAndSaoSao:@"message.png"];
    
    _taskAuthorityArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"authorityTaskList"];
    DLog(@"%@",_taskAuthorityArray);
    
    [self initView];
}

-(void)rightAction
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.menuController showRightController:YES];
}

-(void)leftAction
{
    LeftViewController *leftController = [[LeftViewController alloc] init];
    [self.navigationController pushViewController:leftController animated:YES];
}

#pragma mark == 中间搜索框
-(void)seachButton
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)initView
{
    UICollectionViewWaterfallLayout * layout = [[UICollectionViewWaterfallLayout alloc] init];
    layout.delegate  = self;
    layout.columnCount = 3;
    layout.itemWidth = 75;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight-100)];
    backView.backgroundColor = [UIColor whiteColor];
    [_baseScrollView addSubview:backView];
    
    colectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight-100) collectionViewLayout:layout];
    
    colectionView.delegate =  self;
    colectionView.dataSource = self;
    colectionView.alwaysBounceVertical = YES;
    colectionView.backgroundColor = [UIColor whiteColor];
    colectionView.showsVerticalScrollIndicator = NO;
    [colectionView registerClass:[TaskCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [backView addSubview:colectionView];
    _baseScrollView.scrollEnabled = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _taskAuthorityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[TaskCollectionViewCell alloc] init];
    }
    
    
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/ywglAppFunctionRole/%@/",ADDR_IP,ADDR_DIR,_taskAuthorityArray[indexPath.item][@"functionId"] ]]];
    
    cell.titleLable.text = _taskAuthorityArray[indexPath.item][@"functionName"];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    NSLog(@"wwwwww..%@",_taskAuthorityArray);
    NSString *locationIos = _taskAuthorityArray[indexPath.item][@"locationIos"];
    DLog(@"%@",_taskAuthorityArray);
    NSString *iosPackage = _taskAuthorityArray[indexPath.item][@"iosPackage"];
    if ([iosPackage isEqualToString:@"0"]) {//页面间跳转 默认为0 可不用判断
        if ([locationIos isEqualToString:@"HiddenTroubleViewController"]){//隐患清单
            
            HiddenTroubleViewController *hiddenVC = [[HiddenTroubleViewController alloc]init];
            [self.navigationController pushViewController:hiddenVC animated:YES];
            
        }else{
            
            DLog(@"%s_______________%d__________%@______",__func__,__LINE__,locationIos);
            UIViewController *vc = [[NSClassFromString(locationIos) alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    if ([iosPackage isEqualToString:@"1"]) {
        NSString* strUrl = format(@"iPower://%@?accessToken=%@", locationIos,UGET(U_POWER_TOKEN));
        NSString *unicodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:unicodeURL]];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 30);
}

//每个cell高度指定代理
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end
