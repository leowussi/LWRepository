//
//  RightViewController.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "RightViewController.h"
#import "TaskViewController.h"
#import "LeftViewController.h"
#import "PWSliderViewController.h"
#import "SetViewController.h"
#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "LoginView.h"
#import <ShareSDK/ShareSDK.h>
#import "LoginViewController.h"
#import "HWBProgressHUD.h"

@interface RightViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    NSString *strPath;
    NSURL *imageDataUrl;
    UIImageView *userImgView;
    UILabel *telLable;
    NSMutableDictionary *dataDic;
    NSMutableDictionary *infoDic;
}
@end

@implementation RightViewController

-(void)getData
{
    [self clearCache];
    httpGET2(@{URL_TYPE : @"GetUserInfo"}, ^(id result) {

        if ([result[@"result"] isEqualToString:@"0000000"]) {
            
            [dataDic removeAllObjects];
            dataDic = [result objectForKey:@"detail"];
            
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
        }
    }, ^(id result) {
        
    });
}

-(void)GetAffiliatedInfo
{
    httpGET2(@{URL_TYPE : @"myInfo/GetAffiliatedInfo"}, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {

            infoDic = [result objectForKey:@"detail"];
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
        }
    }, ^(id result) {
        
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self clearCache];
//    [self getData];
}

- (void)clearCache
{
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _baseScrollView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:111.0/255.0 blue:180.0/255.0 alpha:1.0];
    
    dataDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    infoDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [self GetAffiliatedInfo];
    [self clearCache];
    [self getData];
    UIView *heardView = [self tableHeadView];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:111.0/255.0 blue:180.0/255.0 alpha:1.0];
    myTableView.tableHeaderView = heardView;
    [self.view addSubview:myTableView];
    
}

#pragma mark == 表头
-(UIView *)tableHeadView
{
    [self clearCache];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImage *bgImg = [UIImage imageNamed:@"rightV.png"];
    UIImageView *backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backImgView.image = bgImg;
    [view addSubview:backImgView];

    if (kScreenHeight > 480) {
        myTableView.scrollEnabled = NO;
    }else{
        myTableView.scrollEnabled = YES;
        [view setFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight+120)];
        [backImgView setFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight+120)];
    }
    
    
    userImgView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-60)/2+10, 25, 100, 100)];
    userImgView.layer.masksToBounds = YES;
    userImgView.layer.cornerRadius = 50;
//    userImgView.image = [UIImage imageNamed:@"用户登陆-5-29默认_03(1)"];
    NSString *strurl = [NSString stringWithFormat:@"http://%@/%@/attachment/ywglUserInfo/%@",ADDR_IP,ADDR_DIR,[dataDic objectForKey:@"userId"]];
    NSLog(@"头像链接 == %@",strurl);
    [userImgView sd_setImageWithURL:[NSURL URLWithString:strurl] placeholderImage:[UIImage imageNamed:@"用户登陆-5-29默认_03(1).png"]];
    userImgView.userInteractionEnabled = YES;
    [view addSubview:userImgView];
    
    
    
    UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    userBtn.backgroundColor = [UIColor clearColor];
    [userBtn addTarget:self action:@selector(editor) forControlEvents:UIControlEventTouchUpInside];
    
    [userImgView addSubview:userBtn];
    
    UILabel *nameLable = [UnityLHClass initUILabel:@"张三丰" font:18.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-180, 135, 100, 20)];
    if ([dataDic objectForKey:@"name"] == nil) {
        nameLable.text = @"";
    }else{
        nameLable.text = [dataDic objectForKey:@"name"];
    }
    nameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    nameLable.textAlignment = NSTextAlignmentCenter;
    [view addSubview:nameLable];
    
    NSArray *infoArray = @[@"Lv.2",@"360"];
    for (int i = 0; i < infoArray.count; i++) {
        UILabel *infoLable = [UnityLHClass initUILabel:@"张三丰" font:14.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-180, 210+i*30, 100, 20)];
//        infoLable.text = [infoArray objectAtIndex:i];
        [view addSubview:infoLable];
        
        if (i == 0) {
            [infoLable setFrame:CGRectMake(kScreenWidth-210, 155+i*30, 100, 20)];
//            infoLable.text = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:i]];
            if (infoDic == nil) {
                infoLable.text = @"";
            }else{
                infoLable.text = [NSString stringWithFormat:@"等级:%@",[infoDic objectForKey:@"userLevel"]];
            }
            
        }
        
        if (i == 1) {
            [infoLable setFrame:CGRectMake(kScreenWidth-130, 155, 100, 20)];
//            infoLable.text = [NSString stringWithFormat:@"经验值 %@",[infoArray objectAtIndex:i]];
            if (infoDic == nil) {
                infoLable.text = @"";
            }else{
                infoLable.text = [NSString stringWithFormat:@"经验值: %@",[infoDic objectForKey:@"userEmpValue"]];
            }
        }
        
    }
    
    NSArray *titleArray = @[@"工程总里程:9999公里",@"完成总任务数:2012个",@"当前排名:第50名"];
    for (int i = 0; i < 4; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 200+i*45, kScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:83.0/255.0 green:144.0/255.0 blue:195.0/255.0 alpha:1.0];
        [view addSubview:lineView];
    }
    
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *lable = [UnityLHClass initUILabel:@"" font:14.0 color:[UIColor whiteColor] rect:CGRectMake(60, 215+i*45, kScreenWidth-60, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lable];
        
        if (i == 0) {
            lable.text = [NSString stringWithFormat:@"工程总里程:%@",[infoDic objectForKey:@"countDistance"]];
        }
        
        if (i == 1) {
            lable.text = [NSString stringWithFormat:@"完成总任务数:%@",[infoDic objectForKey:@"countTask"]];
        }
        
        if (i == 2) {
           lable.text = [NSString stringWithFormat:@"当前排名:第%@名",[infoDic objectForKey:@"myRank"]];
        }
        
        
    }
    
    NSArray *btnArray = @[@"反馈",@"绑定微信",@"绑定易信",@"设置",@"退出登录"];
    UIImage *wechatImage = [UIImage imageNamed:@"weixin"];
    UIImage *yixImage = [UIImage imageNamed:@"yixin"];
    for (int i = 0; i < btnArray.count; i++) {
        UILabel *lable = [UnityLHClass initUILabel:[btnArray objectAtIndex:i] font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth-200, 360+i*35, 150, 25)];
        lable.layer.borderColor = [UIColor whiteColor].CGColor;
        lable.layer.borderWidth = 1.0;
        lable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lable];
        
        if (i == 4) {
            lable.backgroundColor = [UIColor orangeColor];
        }
        
        if (i == 1) {
            UIImageView *wechatImageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 3, wechatImage.size.height/1.5,wechatImage.size.height/1.5)];
            wechatImageview.backgroundColor = [UIColor clearColor];
            wechatImageview.image = wechatImage;
            wechatImageview.userInteractionEnabled = YES;
            [lable addSubview:wechatImageview];
        }
        
        if (i == 2) {
            UIImageView *yxImageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 3, yixImage.size.height/1.5,yixImage.size.height/1.5)];
            yxImageview.image = yixImage;
            yxImageview.backgroundColor = [UIColor clearColor];
            yxImageview.userInteractionEnabled = YES;
            [lable addSubview:yxImageview];
        }
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-200, 360+i*35, 150, 25)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        
        
    }
    UIImage *telImg = [UIImage imageNamed:@"tel"];
    UIImageView *telImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-200, 360+5*35, telImg.size.width/2, telImg.size.height/2)];
    telImgView.image = telImg;
    [view addSubview:telImgView];
    
    UILabel *severLable = [UnityLHClass initUILabel:@"技术服务热线 :" font:10.0 color:[UIColor colorWithRed:0.0/255.0 green:72.0/255.0 blue:113.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-180, 360+5*35, 100, 20)];
    [view addSubview:severLable];
    
    telLable = [UnityLHClass initUILabel:@"55666608" font:10.0 color:[UIColor colorWithRed:0.0/255.0 green:72.0/255.0 blue:113.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-110, 360+5*35, 100, 20)];
    telLable.userInteractionEnabled = YES;
    [view addSubview:telLable];
    
    
    UIButton *callBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    callBtn.backgroundColor = [UIColor clearColor];
    [callBtn addTarget:self action:@selector(callBtn) forControlEvents:UIControlEventTouchUpInside];
    [telLable addSubview:callBtn];
    
    return view;
}


-(void)callBtn
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",telLable.text];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [self.view addSubview:callWebview];
}

-(void)button:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    NSInteger tag = sender.tag - 1000;
    
    id<ISSContent>publishContent= [ShareSDK content:@"测试一下"
                                     defaultContent:@"shareSDK" image:[ShareSDK imageWithPath:[[NSBundle mainBundle]pathForResource:@"i_logo@2x" ofType:@"png"]]
                                              title:@"shareSDK" url:@"http://www.baidu.com"
                                        description:@"shareSDK" mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tag == 0) {
        
        FeedbackViewController *feedVC = [[FeedbackViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:feedVC];
//        [self presentViewController:nav animated:NO completion:nil];
        
        [appDelegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
        
    }else if (tag == 1){
        
//        [ShareSDK shareContent:publishContent
//                          type:ShareTypeWeixiSession
//                   authOptions:authOptions
//                 statusBarTips:YES
//                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                            if (state == SSPublishContentStateSuccess)
//                            {
//                                NSLog(@"分享成功");
//                                
//                            }else if (state == SSPublishContentStateFail)
//                            {
//                                NSLog(@"111分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
//                                
//                            }
//                        }];

        HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
        //弹出框的类型
        hud.mode = HWBProgressHUDModeText;
        //弹出框上的文字
        hud.detailsLabelText = @"正在建设中...";
        //弹出框的动画效果及时间
        [hud showAnimated:YES whileExecutingBlock:^{
            //执行请求，完成
            sleep(1);
        } completionBlock:^{
            //完成后如何操作，让弹出框消失掉
            [hud removeFromSuperview];
        }];
        
    }else if (tag == 2){
        
        HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
        //弹出框的类型
        hud.mode = HWBProgressHUDModeText;
        //弹出框上的文字
        hud.detailsLabelText = @"正在建设中...";
        //弹出框的动画效果及时间
        [hud showAnimated:YES whileExecutingBlock:^{
            //执行请求，完成
            sleep(1);
        } completionBlock:^{
            //完成后如何操作，让弹出框消失掉
            [hud removeFromSuperview];
        }];
        
    }else if (tag == 3){
        [self GetUserFlow];
//        SetViewController *setVC = [[SetViewController alloc]init];
//        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:setVC];
//        [appDelegate.window.rootViewController presentViewController:nav1 animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要退出登录吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
        
    }
}


-(void)GetUserFlow
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SetViewController *setVC = [[SetViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:setVC];
    [appDelegate.window.rootViewController presentViewController:nav1 animated:YES completion:nil];
//    httpGET2(@{URL_TYPE : @"myInfo/GetUserFlow"}, ^(id result) {
//        NSLog(@"%@",result);
//        if ([result[@"result"] isEqualToString:@"0000000"]) {
//            SetViewController *setVC = [[SetViewController alloc]init];
//            UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:setVC];
//            setVC.flowNum = [result objectForKey:@"flowNum"];
//            [appDelegate.window.rootViewController presentViewController:nav1 animated:YES completion:nil];
//
//        }
//    }, ^(id result) {
//
//    });
}

#pragma mark - 登出
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            
        }else{
            
            USET(U_CONFIG, nil);
            
            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.menuController showRootController:YES];
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"logoutapp";
            paraDict[@"accessToken"] = UGET(U_TOKEN);
            
            httpGET1(paraDict, ^(id result) {
                if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
                    
             #if !TARGET_IPHONE_SIMULATOR
                    if ((NSString *)UGET(DEVICE_TOKEN) != nil) {
                        doDeviceTokenWhenAppLogout(2);
                    }
             #endif

                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user removeObjectForKey:@"sucess"];
                    [user removeObjectForKey:@"entrance"];
                    [user removeObjectForKey:@"authorityViewList"];
                    [user removeObjectForKey:@"authorityTaskList"];
                    [user removeObjectForKey:@"authorityInfoList"];
                    [user removeObjectForKey:@"authorityDailyList"];
                    [user removeObjectForKey:@"authorityHomeList"];
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    LoginViewController* rootVc = [[LoginViewController alloc] init];
                    
                    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:rootVc];
                    appDelegate.menuController = rootController;
                    
                    //添加右边的
                    RightViewController *rightController = [[RightViewController alloc] init];
                    rootController.rightViewController = rightController;
                    
                    [appDelegate.window setBackgroundColor:[UIColor whiteColor]];
                    [appDelegate.window makeKeyAndVisible];
                    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0]];
                    
                    appDelegate.window.rootViewController = rootController;
                }
            });
        }
    }
}

void doDeviceTokenWhenAppLogout(int opType)
{
    NSString* url = (opType==1 ? NW_bindDeviceToken : NW_unBindDeviceToken);
    
    NSLog(@"%@",UGET(DEVICE_TOKEN));
    
    
    httpGET1(@{URL_TYPE:url, @"deviceToken":UGET(DEVICE_TOKEN)}, ^(id result) {
        USET(DEVICE_BIND_OK, (opType==1 ? @"OK" : nil));
    });
}

- (void)toLogout
{
    doDeviceToken(2);
    USET(U_TOKEN, nil);
    USET(U_POWER_TOKEN, nil);
    USET(U_CONFIG, nil);
    showLogin();
}


-(void)donghua
{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.3f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromRight;
    
    transition.delegate = self;
    
    [self.view.layer addAnimation:transition forKey:nil];
    
}

- (void)editor
{
    
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [chooseImageSheet showInView:self.view];
    
    
    
}

#pragma mark -照片功能
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://拍照
        {
            [self takePhoto];
        }
            break;
        case 1://本地相册
        {
            [self LocalPhoto];
        }
            break;
        case 2:
        {
        }
            break;
        default:
            break;
    }
}




//从相册选择
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.allowsEditing = YES;
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.view.frame = CGRectMake(0, 0, kScreenWidth, 40);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController presentModalViewController:picker animated:YES];
}

//拍照
-(void)takePhoto
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
//        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [appDelegate.window.rootViewController presentModalViewController:picker animated:YES];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 创建imdge 接收图片
    UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    image = [UIImage imageWithData:imageData];
//    userImgView.image = image;
    UIImage *imageInfo = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* imageResult = [self imageWithImageSimple:image scaledToSize:CGSizeMake(imageInfo.size.width, 320)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"%@.png",dateString];
    [self saveImage:imageResult WithName:imageName];
    
    
    // 关闭picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self upPhoto]; //上图片
    
}
#pragma mark -保存图片的路径
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSLog(@"%@",imageName);
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.1);
//    userImgView.image = [UIImage imageWithData:imageData];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSURL *url = [NSURL fileURLWithPath:fullPathToFile];
    strPath = fullPathToFile;
    imageDataUrl = url;
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

-(void)upPhoto
{
    NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/myInfo/UploadPhoto.json?operationTime=%@&accessToken=%@",ADDR_IP,ADDR_DIR,opreatinTime,accessToken];
    NSLog(@"uid == %@",requestUrl);
    NSLog(@"%@",imageDataUrl);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        
        BOOL success = [formData appendPartWithFileURL:imageDataUrl name:@"realFormFile(FN_IMAGE_1)" error:&error];
        if (!success){
            NSLog(@"appendPartWithFileURL error: %@", error);
        }else{
            NSLog(@"==>error: %@", error);
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        id myResult =[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic=(NSDictionary*)myResult;
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"result"] isEqualToString:@"0000000"]) {
            [self getUserPhoto];
//            [self clearCache];
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        NSLog(@"error == %@", error);
        [self showAlertWithTitle:@"提示" :@"请求失败" :@"确定" :nil];
    }];
}

-(void)getUserPhoto
{
    [self clearCache];
    httpGET2(@{URL_TYPE : @"GetUserInfo"}, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            NSLog(@"updata == %@",result);
            
            [dataDic removeAllObjects];
            dataDic = [result objectForKey:@"detail"];
            
            UIView *heardView = [self tableHeadView];
            myTableView.tableHeaderView = heardView;
            [myTableView reloadData];
        }
        
        UIView *heardView = [self tableHeadView];
        myTableView.tableHeaderView = heardView;
        [myTableView reloadData];
    }, ^(id result) {
        
    });
}


#pragma mark == UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identiCell = @"identiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identiCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiCell];
        cell.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:111.0/255.0 blue:180.0/255.0 alpha:1.0];
    }
    return cell;
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
