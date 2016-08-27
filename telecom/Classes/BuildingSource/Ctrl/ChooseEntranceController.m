//
//  ChooseEntranceController.m
//  telecom
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "ChooseEntranceController.h"
#import "BuildingResourceMapController.h"
#import "HomeViewController.h"

#import "LeftViewController.h"
#import "RightViewController.h"
#import "RootTAMViewController.h"
@interface ChooseEntranceController ()

@end

@implementation ChooseEntranceController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.welcomLabel.text = [NSString stringWithFormat:@"欢迎%@登录",UGET(U_NAME)];
}


- (IBAction)iYunWeiEntrance {
    [[NSUserDefaults standardUserDefaults]setObject:@"RootTAMViewController" forKey:@"selectRootVC"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RootTAMViewController* rootVc = [[RootTAMViewController alloc] init];

    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:rootVc];
    appDelegate.menuController = rootController;

    //添加右滑的视图
    RightViewController *rightController = [[RightViewController alloc] init];
    rootController.rightViewController = rightController;

    [appDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [appDelegate.window makeKeyAndVisible];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0]];

    appDelegate.window.rootViewController = rootController;
}

- (IBAction)buildingResourceEntrance {
    [[NSUserDefaults standardUserDefaults]setObject:@"BuildingResourceMapController" forKey:@"selectRootVC"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BuildingResourceMapController *buildingResourceCtrl = [[BuildingResourceMapController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:buildingResourceCtrl];
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navCtrl];
    appDelegate.menuController = rootController;
    
    //添加右滑的视图
    RightViewController *rightController = [[RightViewController alloc] init];
    rootController.rightViewController = rightController;
    
    [appDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [appDelegate.window makeKeyAndVisible];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0]];
    
    appDelegate.window.rootViewController = rootController;
    
}

- (IBAction)telBtnClick:(id)sender {
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",@"55666608"];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [self.view addSubview:callWebview];

}

@end
