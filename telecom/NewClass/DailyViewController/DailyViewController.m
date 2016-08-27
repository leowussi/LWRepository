//
//  DailyViewController.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "DailyViewController.h"
#import "TaskCollectionViewCell.h"
#import "SearchViewController.h"
#import "LeftViewController.h"
#import "DailyDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface DailyViewController ()
{
    UICollectionView * colectionView;
    NSMutableArray *_dailyAuthorityArray;
}
@end

@implementation DailyViewController

-(void)viewWillAppear:(BOOL)animated
{
     self.backBtn.hidden = YES;
    [self hiddenBottomBar:NO];
}

- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [self hiddenBottomBar:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addSearchBar];
    [self addNavigationRightButton:@"头像.png"];

    [self addMessageAndSaoSao:@"message"];
    
    _dailyAuthorityArray = [NSMutableArray array];
    _dailyAuthorityArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"authorityDailyList"];

    [self initView];
}

- (void)rightAction
{
    NSLog(@"点击了头像");
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.menuController showRightController:YES];
}

- (void)leftAction
{
    LeftViewController *leftController = [[LeftViewController alloc] init];
    [self.navigationController pushViewController:leftController animated:YES];
}

#pragma mark == 中间搜索框
-(void)seachButton
{
    NSLog(@"asd");
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
    colectionView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
    [colectionView registerClass:[TaskCollectionViewCell class] forCellWithReuseIdentifier:@"dailyCell"];
    colectionView.showsVerticalScrollIndicator = NO;
    [backView addSubview:colectionView];
    _baseScrollView.scrollEnabled = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dailyAuthorityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dailyCell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[TaskCollectionViewCell alloc]init];
    }
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/ywglAppFunctionRole/%@/",ADDR_IP,ADDR_DIR,_dailyAuthorityArray[indexPath.item][@"functionId"] ]]];
    cell.titleLable.text = _dailyAuthorityArray[indexPath.item][@"functionName"];

    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    NSString *functionId = _dailyAuthorityArray[indexPath.item][@"locationIos"];
    NSString *iosPackage = _dailyAuthorityArray[indexPath.item][@"iosPackage"];
//    NSDictionary *functionSiteDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FunctionSite.plist" ofType:nil]];
    if ([iosPackage isEqualToString:@"0"]) {
        UIViewController *vc = [[NSClassFromString(functionId) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
//    DailyDetailViewController *deilyVC = [[DailyDetailViewController alloc]init];
//    [self.navigationController pushViewController:deilyVC animated:YES];
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
