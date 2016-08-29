//
//  BusinessController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "BusinessController.h"
#import "BusinessBtn.h"
#import "WorkLogController.h"
#import "AfterSalesController.h"
#import "OperationMaintenaController.h"
#import "SignInOutController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "BusinessBtnModel.h"
#import "UIImageView+WebCache.h"
#import "CRMHelper.h"
#import "ZYFUrl.h"
#import "CRMHelper.h"
#import "BusinessButton.h"
#import "ZYFHttpTool.h"
#import "CRMHelper.h"
#import "LogsController.h"
#import "TableSearchController.h"
#import "ClientInformationController.h"
#import "ListController.h"
#import "ZYFUrlClientInformation.h"
#import "HXContactController.h"
#import "HXProjectRegisterController.h"

@interface BusinessController ()

@property (nonatomic,strong) NSArray *buttonImages;
@property (nonatomic,strong) NSArray *buttons;
@property (nonatomic,strong) NSMutableArray *localButtonsArray;

@property (nonatomic,strong) UIImage  *btnImage;

@property (nonatomic,strong) NSArray *items;

@property (nonatomic,weak) UIScrollView *scrollView;
//可以滚动的最大高度
@property (nonatomic,assign) CGFloat maxHeight;

@end

@implementation BusinessController

- (void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.alwaysBounceVertical = YES;
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    self.scrollView = scrollView;

}

- (void)test{

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"业务"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self getButtonData];
}

- (NSMutableArray *)localButtonsArray
{
    if (_localButtonsArray == nil) {
        _localButtonsArray = [NSMutableArray array];
    }
    return _localButtonsArray;
}

/**
 *  获取button的名字，图片名字，图片url等信息
 */
-(void)getButtonData
{
    //如果网络不可用
    if ( ! [CRMHelper isEnableNetWork]) {
        NSString *filePath = [CRMHelper createFilePathWithFileName:@"buttons.data"];
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ( ! [fileMgr fileExistsAtPath:filePath]) {
            [MBProgressHUD showError:@" buttons.data file is not exist"];
            return;
        }
        
        NSArray *localButtonsArray = [NSArray arrayWithContentsOfFile:filePath];
        if (localButtonsArray == nil) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"当前文件不能被打开，或者内容不能被解析"]];
        }
        
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSData *data in localButtonsArray) {
            BusinessBtnModel *btnModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [mutableArray addObject:btnModel];
        }
        self.buttons = mutableArray;
        [self setBusinessBtn];
        return;
    }else{
        if (self.buttons) {
            //将button对应的数据设置到界面上
            [self setBusinessBtn];
        }else{
            
            [MBProgressHUD showMessage:nil toView:self.view ];
            NSString *urlString = kGetButtonsUrl;
            
            [ZYFHttpTool getWithURL:urlString params:nil success:^(id json) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
                self.items = dict[@"Items"];
                NSArray *items = dict[@"Items"];
                if (items != nil && items.count > 0) {
                    NSMutableArray *buttonArray = [NSMutableArray array];
                    for (NSDictionary *dict in self.items) {
                        BusinessBtnModel *btnModel = [BusinessBtnModel businessBtnModelWithDict:dict];
                        NSData *localButtonData = [NSKeyedArchiver archivedDataWithRootObject:btnModel];
                        [buttonArray addObject:btnModel];
                        [self.localButtonsArray addObject:localButtonData];
                    }
                    self.buttons = buttonArray;
                }
                //将items数据缓存在本地
                NSString *filePath = [CRMHelper createFilePathWithFileName:@"buttons.data"];
                if([self.localButtonsArray writeToFile:filePath atomically:YES]){
                    NSLog(@"writeToFile sucess") ;
                    NSFileManager *fileMgr = [NSFileManager defaultManager];
                    if ( ! [fileMgr fileExistsAtPath:filePath]) {
                        [MBProgressHUD showError:@" file create failure"];
                        return;
                    }
                }else{
                    ZYFLog(@"write file failure");
                }
                
                //将button对应的数据设置到界面上
                [self setBusinessBtn];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [MBProgressHUD showError:@"获取数据失败"];
                NSString *errorString = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            
            }];
        }
    }
    
}

-(void)setBusinessBtn
{
//    for (int i = 0; i < self.buttons.count; i++) {
//        BusinessBtnModel *btnModel = self.buttons[i];
//        ZYFLog(@"iconName = %@",btnModel.iconName);
//        ZYFLog(@"displayName = %@",btnModel.displayName);
//
//    }
    
    for (int i = 0; i < self.buttons.count; i++) {

        BusinessBtn *btn = [[BusinessBtn alloc]init];
        //每行按钮的个数
        NSInteger rowCount = 4;
        CGFloat btnW = kSystemScreenWidth / 6.0;
        CGFloat btnH = btnW * rowCount / 3.0 + 5;
        CGFloat marginW = (kSystemScreenWidth - kSystemScreenWidth / 6.0 * rowCount) * 0.2;
        CGFloat marginH = kSystemScreenWidth / 10.0;
        
        //button的可能的最大高度
        self.maxHeight = (btnH + marginH) * (CGFloat)(self.buttons.count + 1) * 0.25 + 44;
        self.scrollView.contentSize = CGSizeMake(kSystemScreenWidth, self.maxHeight);
        
        btn.tag = i;
        btn.frame = CGRectMake(marginW + (i % 4)* (marginW + btnW) , marginH  + i / 4 * (btnH + marginH),btnW , btnH);
        BusinessBtnModel *btnModel = self.buttons[i];
        NSString *imageName = btnModel.iconName;
        if (imageName.length > 0) {
            UIImage *btnImage = [UIImage imageNamed:imageName];
            if (btnImage) {
                [btn setImage:btnImage forState:UIControlStateNormal];
            }else{
                //如果没有图标，用sign_in这个图标来填充
                [btn setImage:[UIImage imageNamed:@"111.png"] forState:UIControlStateNormal];
            }
        }else{
            //如果没有图标，用sign_in这个图标来填充
            [btn setImage:[UIImage imageNamed:@"111.png"] forState:UIControlStateNormal];
        }
        [btn setTitle:btnModel.displayName forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(businessBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

//- (void)createDict
//{
//    NSDictionary *dict = @{@"签到签退":@"SignInOutController",
//                           @"运维派工":@"OperationMaintenaController",
//                           @"售后派工":@"AfterSalesController",
//                           @"表单查询":@"TableSearchController",
//                           @"工作日志":@"WorkLogController",
//                           @"行销客户":@"SignInOutController",
//                           };
//}

-(void)businessBtnClicked:(UIButton*)button
{
    if ([button.titleLabel.text isEqualToString:@"签到签退"]) {
        SignInOutController *signInOutCtrl = [[SignInOutController alloc]init];
        [self.navigationController pushViewController:signInOutCtrl animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"运维派工"]){
        OperationMaintenaController *operatonMainCtrl = [[OperationMaintenaController alloc]init];
        [self.navigationController pushViewController:operatonMainCtrl animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"售后派工"]){
        AfterSalesController *afterSalesCtrl = [[AfterSalesController alloc]init];
        [self.navigationController pushViewController:afterSalesCtrl animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"表单查询"]){
        TableSearchController *ctrl = [[TableSearchController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"工作日志"]){
        WorkLogController *workingLogCtrl = [[WorkLogController alloc]init];
        [self.navigationController pushViewController:workingLogCtrl animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"行销客户"]){
        ClientInformationController *ctrl = [[ClientInformationController alloc]init];
        ctrl.urlString = kClientInformation;
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"联系人"]){
        HXContactController *ctrl = [[HXContactController alloc]init];
        ctrl.urlString = kContact;
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"项目登记"]){
        HXProjectRegisterController *ctrl = [[HXProjectRegisterController alloc]init];
        ctrl.urlString = kNewProject;
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"项目跟踪"]){

    }else if ([button.titleLabel.text isEqualToString:@"审批"]){

    }else if ([button.titleLabel.text isEqualToString:@"工作计划"]){
        
    }else if ([button.titleLabel.text isEqualToString:@"日报"]){
        
    }else if ([button.titleLabel.text isEqualToString:@"周报"]){
        
    }else if ([button.titleLabel.text isEqualToString:@"项目分析"]){
        
    }else if ([button.titleLabel.text isEqualToString:@"日志查询"]){
        
    }else{
        [MBProgressHUD showError:@"没有匹配的项"];
    }
    
    
}





@end
