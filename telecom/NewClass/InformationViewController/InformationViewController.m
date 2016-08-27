//
//  InformationViewController.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "InformationViewController.h"
#import "TaskCollectionViewCell.h"
#import "SearchViewController.h"
#import "LeftViewController.h"
#import "InfoDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "NetworkViewController.h"
#import "ResourcesViewController.h"
#import "RoomViewController.h"
#import "PersonalWorkInfoViewController.h"//个人工作信息

@interface InformationViewController ()
{
    UICollectionView * colectionView;
    NSMutableArray *_infoAuthorityArray;
}

@end

@implementation InformationViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.backBtn.hidden=YES;
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
    
    [self addMessageAndSaoSao:@"message.png"];
    
    _infoAuthorityArray = [NSMutableArray array];
    
    _infoAuthorityArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"authorityInfoList"];
    DLog(@"%@",_infoAuthorityArray);
    [self initView];
}

-(void)rightAction
{
    NSLog(@"点击了头像");
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
    [colectionView registerClass:[TaskCollectionViewCell class] forCellWithReuseIdentifier:@"infomationCell"];
    colectionView.showsVerticalScrollIndicator = NO;
    [backView addSubview:colectionView];
    _baseScrollView.scrollEnabled = NO;
    
    //    imageArray = [[NSMutableArray alloc]initWithObjects:@"jz.png",@"jf.png",@"wy.png",@"wxLTEzy.png",@"jhzy.png",@"wxLTEwg.png",@"EPONxx.png",@"glgd.png",@"动力资源.png",@"动力网管.png",@"所有任务.png", nil];
    //
    //    titleArray = [[NSMutableArray alloc]initWithObjects:@"局站",@"机房",@"网元",@"无线LTE资源",@"交换资源",@"无线LTE网管",@"EPON信息",@"光路工单",@"动力资源",@"动力网管",@"所有任务", nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _infoAuthorityArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"infomationCell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[TaskCollectionViewCell alloc]init];
    }
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/ywglAppFunctionRole/%@/",ADDR_IP,ADDR_DIR,_infoAuthorityArray[indexPath.item][@"functionId"]]]];
    
    
    cell.titleLable.text = _infoAuthorityArray[indexPath.item][@"functionName"];
    return cell;
}

/**
 *  如果装了i动力 可执行跳转
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    NSString *functionId = _infoAuthorityArray[indexPath.item][@"locationIos"];
    NSString *iosPackage = _infoAuthorityArray[indexPath.item][@"iosPackage"];
    
    DLog(@"%@",_infoAuthorityArray[indexPath.item]);
    DLog(@"%s____________________%d_____________",__func__,__LINE__);
    //    应用间跳转
    if ([iosPackage isEqualToString:@"1"]) {
        NSString* strUrl = format(@"iPower://%@?accessToken=%@", functionId,UGET(U_POWER_TOKEN));
        
        NSString *unicodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:unicodeURL]];
    }
    if ([iosPackage isEqualToString:@"0"]){
        UIViewController *vc = [[NSClassFromString(functionId) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
