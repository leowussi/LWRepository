//
//  RootTAMViewController.m
//  TianAnMonitor
//
//  Created by chenliang on 13-12-27.
//  Copyright (c) 2013年 sundear. All rights reserved.
//

#import "RootTAMViewController.h"
#import "UIViewController+JASidePanel.h"
#import "HomeViewController.h"
#import "TaskViewController.h"
#import "DailyViewController.h"
#import "InformationViewController.h"
#import "MapViewController.h"
#import "JASidePanelController.h"
///////
#import "AppDelegate.h"
/////////

@interface RootTAMViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    JASidePanelController *_sidePanelController;
}
@end

@implementation RootTAMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]setObject:@"RootTAMViewController" forKey:@"selectRootVC"];//记住每次登陆的是i运维还是i楼宇
    _sidePanelController = [[JASidePanelController alloc] init];
    _sidePanelController.style = JASidePanelSingleActive;
    _sidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
    _sidePanelController.allowLeftSwipe = NO;
    _sidePanelController.allowRightSwipe = NO;
    _sidePanelController.bounceOnSidePanelOpen = NO;
    _sidePanelController.bounceOnSidePanelClose = NO;
    _sidePanelController.bounceOnCenterPanelChange = NO;

    _sidePanelController.view.frame = CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height);
    
    [self.view addSubview:_sidePanelController.view];
    
    [self initBottomBar];
	// Do any additional setup after loading the view.
}
- (void)initBottomBar
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    BMCustomBottomBarView *bottomBar = [[BMCustomBottomBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight -  49, kScreenWidth, 49)];
    bottomBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"02-dibulan"]];
    bottomBar.btnImageArray = [NSMutableArray arrayWithObjects:@"index.png",@"tasks.png",@"near.png",@"messages.png",@"day",@"", nil];
    bottomBar.btnTitleArray = @[@"首页",@"任务",@"附近",@"信息",@"日常",@""];
    bottomBar.btnSImageArray = [NSMutableArray arrayWithObjects:@"index_cur.png",@"tasks_cur.png",@"near_cur.png",@"messages_cur.png",@"day_cur.png",@"",nil];
    bottomBar.delegate = self;
    appDelegate.bottomBarView = bottomBar;
    
    [bottomBar initButtonAlloc];
    [self.view addSubview:bottomBar];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    [bottomBar addSubview:lineView];
    
    if ([appDelegate.bottomBarView.btnArray count] != 0)
    {
        [appDelegate.bottomBarView selectButtonClick:[appDelegate.bottomBarView.btnArray objectAtIndex:0]];
    }
}



//选中底部bar
- (void)selectBottomButtonClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            if (nil == naviFirst)
            {
                HomeViewController* viewVc = [[HomeViewController alloc] init];
                naviFirst = [[UINavigationController alloc] initWithRootViewController:viewVc];
            }
            _sidePanelController.centerPanel = naviFirst;
        }
            break;
        case 1:
        {
            if (nil == naviSecond)
            {
                TaskViewController * viewVc = [[TaskViewController alloc] init];
                naviSecond = [[UINavigationController alloc] initWithRootViewController:viewVc];
            }
            _sidePanelController.centerPanel = naviSecond;
        }
            break;
        case 2:
        {
            if (nil == naviThird)
            {
                MapViewController* viewVc = [[MapViewController alloc] init];
                naviThird = [[UINavigationController alloc] initWithRootViewController:viewVc];
            }
            _sidePanelController.centerPanel = naviThird;
        }
            break;
        case 3:
        {
            if (nil == naviFour)
            {
                InformationViewController* viewVc = [[InformationViewController alloc] init];
                naviFour = [[UINavigationController alloc] initWithRootViewController:viewVc];
            }
            _sidePanelController.centerPanel = naviFour;
        }
            break;
        case 4:
        {
            if (nil == naviFive)
            {
                DailyViewController* viewVc = [[DailyViewController alloc] init];
                naviFive = [[UINavigationController alloc] initWithRootViewController:viewVc];
            }
            _sidePanelController.centerPanel = naviFive;
        }
            break;
        default:{
            if (nil == naviSix)
            {
                HomeViewController *homePageVc = [[HomeViewController alloc] init];
                naviSix = [[UINavigationController alloc] initWithRootViewController:homePageVc];
            }
            _sidePanelController.centerPanel = naviSix;
        }
            break;
    }

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
