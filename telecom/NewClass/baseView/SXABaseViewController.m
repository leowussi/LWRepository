//
//  SXABaseViewController.m
//  ShanXiApple
//
//  Created by Alvin on 14-1-8.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SXABaseViewController.h"
#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>

#import <ifaddrs.h>
#import <arpa/inet.h>

#import "LeftViewController.h"
#import "QrReadView.h"
#import "MBProgressHUD+MJ.h"
#import "GoodsViewController.h"
#import "ZiChanViewController.h"
#import "MJExtension.h"
#import "GoodsModel.h"
#import "PickerGoodsViewController.h"
#import "RootTAMViewController.h"
#import "ZiChanTabViewDetailVc.h"

@interface SXABaseViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *naviBar;
    UILabel *titleLabel;
    UITextField *searchField;
}
@property (nonatomic ,strong) AFHTTPRequestOperationManager *manager;//AFNetWorking
@end

@implementation SXABaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //         self.navigationController.navigationItem.hidesBackButton = YES;
        
    }
    return self;
}

-(UIView *)addSearchBarWithTitle:(NSString *)string{
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 24, 24)];
    leftImageView.image = [UIImage imageNamed:@"search_btn.png"];
    [searchImgView addSubview:leftImageView];
    
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(29, 0, kScreenWidth-149, searchImg.size.height/3+5)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.text = string;
    searchField.textColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.userInteractionEnabled = NO;
    searchField.enablesReturnKeyAutomatically = YES;
    searchField.font = [UIFont systemFontOfSize:15.0];
    [searchImgView addSubview:searchField];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(5,0 ,kScreenWidth-125 , searchImg.size.height/3+5)];
    [searchBtn setBackgroundColor:[UIColor clearColor]];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchImgView addSubview:searchBtn];
    
    return searchImgView;
}
//留zi类实现
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchAction:textField.text];
    [self.view endEditing:YES];
    return YES;
}
-(void)searchAction:(NSString *)string{
    [self becomeFirstResponder];
}
#pragma mark - 系统方法


- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                    UITextAttributeFont : [UIFont fontWithName:@"Helvetica-Bold" size:15]};
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    if (VersionNumber_iOS_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        _baseScrollView=[[BaseScrollView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kContentHeight+70)];
        //        _baseScrollView=[[BaseScrollView alloc] initWithFrame:CGRectMake(0,64,kScreenWidth,kContentHeight)];
    }
    
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    //    _baseScrollView.backgroundColor = [UIColor whiteColor];
    //        [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    [_baseScrollView setBackgroundColor:[UIColor whiteColor]];
    //    _baseScrollView.contentSize = _baseScrollView.bounds.size;
    _baseScrollView.userInteractionEnabled = YES;
    [self.view addSubview:_baseScrollView];
    
    
    
    if (VersionNumber_iOS_6) {
        _baseScrollView.frame =  CGRectMake(0, 0, kScreenWidth, kScreenHeight-44);
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    
    //    [self initNavigationBar];
    [self addNavigationLeftButton];
    
    
}
#pragma mark 下面是扫码相关；
-(void)tuodong{
    self.backBtn.hidden=YES;
}
-(void)addMessageAndSaoSao:(NSString *)str
{
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame = CGRectMake(kScreenWidth-[UIImage imageNamed:str].size.width/2, 12,[UIImage imageNamed:str].size.width-3,[UIImage imageNamed:str].size.height-3);//@"jf1.png"  扫码图标《图片宽度60*60》
    [forwardButton setBackgroundImage:[UIImage imageNamed:@"jf1.png"] forState:UIControlStateNormal];
    //      [forwardButton setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    
    [self addListView];
    
    [forwardButton addTarget:self action:@selector(MessageAndSaoSao) forControlEvents:UIControlEventTouchUpInside];
    //    [forwardButton addTarget:self action:@selector(messageBtnDicClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}
-(void)MessageAndSaoSao{
    self.backBtn.hidden=!self.backBtn.hidden;
}
-(void)addListView{
    UIView *backView = [[UIView alloc]init];
    backView.frame = RECT(0, 0, 100, 65);
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = RECT(0, 5, 100, 30);
    [messageBtn addTarget:self action:@selector(messageBtnDicClick) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn setTitle:@"消息" forState:UIControlStateNormal];
    messageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [messageBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [messageBtn setImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    [messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookBtn.frame = RECT(0, 35, 100, 30);
    UIImageView *im = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jf1.png"]];
    im.frame = RECT(10, 1.5, 27, 27);
    [lookBtn addSubview:im];
    [lookBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [lookBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    lookBtn.imageView.contentMode = UIViewContentModeCenter;
    lookBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    [lookBtn addTarget:self action:@selector(lookBtnBtnDicClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:messageBtn];
    [backView addSubview:lookBtn];
    backView.backgroundColor =  COLOR(239, 239, 239);
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.backgroundColor = [UIColor clearColor];
    self.backBtn.frame =RECT(0, 64, kScreenWidth, kScreenHeight-64-44);
    [self.backBtn addSubview:backView];
    [self.backBtn addTarget:self action:@selector(tuodong) forControlEvents:UIControlEventTouchDown];
    [self.view bringSubviewToFront:self.backBtn];
    
    self.backBtn.hidden=YES;
    [self.view addSubview:self.backBtn];
}
-(void)messageBtnDicClick{
            LeftViewController *leftController = [[LeftViewController alloc] init];
//    GoodsViewController *leftController = [[GoodsViewController alloc]init];
//         ZiChanViewController *leftController = [[ZiChanViewController alloc]init];
    [self.navigationController pushViewController:leftController animated:YES];
}
#pragma mark 扫描结果都在这边处理
-(void)lookBtnBtnDicClick{
    if ([QrReadView checkCamera]) {
        QrReadView* vc = [[QrReadView alloc] init];
        vc.WZBlock = ^(NSString *Sresult,NSString *TAG){
            NSMutableDictionary *par = [NSMutableDictionary dictionary];
            par[URL_TYPE] = @"myInfo/ScanCodeList";
            par[@"code"] = Sresult;
            par[@"tag"] = TAG;
            httpPOST2(par, ^(id result) {
                NSString *tempStr = [NSString stringWithFormat:@"%@",result[@"list"][@"typeId"]];
                
                if ([tempStr isEqualToString:@"2"]) {//物资借用归还
                    if (result[@"list"][@"resourceId"]) {//二维码才有resourceid
                        //                      [self httpSend:result[@"list"][@"resourceId"]];
                        [self performSelectorOnMainThread:@selector(httpSend:) withObject:result[@"list"][@"resourceId"] waitUntilDone:NO];
                    }else{//条形码只有 barCode 把这个也当做物资主键用
                        [self httpSend:result[@"list"][@"barCode"]];
                    }
                }else if ([tempStr isEqualToString:@"3"]){//资产查询页面
//                    if (result[@"list"][@"resourceId"]) {
//                    
//                    }else{//条形码只有 barCode 资产只有条形码扫描
                    
                        NSString *str= result[@"list"][@"barCode"];
                        if ([str rangeOfString:@"-"].location == NSNotFound) {
                            [self ZiChanhttpSend:str type:@"2"];
                            NSLog(@"string 不存在 -");
                        } else {
                            NSLog(@"string 包含 -");
                            NSArray *array = [str componentsSeparatedByString:@"-"];
                            NSString *codeStr = [array lastObject];
                            /*
                            NSRange range = [str rangeOfString:@"-"]; //现获取要截取的字符串位置
                            NSString * resultStr = [str substringFromIndex:range.location]; //截取字符串
                            NSLog(@"%@",resultStr);
                            NSMutableString *mStr = [NSMutableString stringWithString:resultStr];
                            NSString *codeStr = [mStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
                            NSLog(@"%@",codeStr);
                             */
                            
                            NSString *type = array.count == 2 ? @"1" : @"2";
                            
                            [self ZiChanhttpSend:codeStr type:type];
                        }
//                    }
                
                }
             
            }, ^(id result) {
                NSLog(@"%@",result);
                [MBProgressHUD showError:@"不是可用的二维码或条形码"];
            });
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)ZiChanhttpSend:(NSString *)String type:(NSString *)type
{
    ZiChanTabViewDetailVc *vc = [[ZiChanTabViewDetailVc alloc]init];
    vc.assetDes = String;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)httpSend:(NSString *)string{
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    par[@"resourceId"] = string;
    par[URL_TYPE]=@"wzResource/GetWZList";
    
    httpGET2(par, ^(id result) {
        GoodsModel *model = [GoodsModel objectWithKeyValues:result[@"list"]];
        PickerGoodsViewController *vc = [[PickerGoodsViewController alloc]init];
        vc.model= model;
        [self.navigationController pushViewController:vc animated:YES];
    }, ^(id result) {
        [MBProgressHUD showError:@"扫码失败！"];
    }) ;
    
}

-(AFHTTPRequestOperationManager *)manager{
    
    if (_manager == nil) {
        
        _manager = [AFHTTPRequestOperationManager manager];
        
        // 设置超时时间
        
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        
        _manager.requestSerializer.timeoutInterval = 15.0f;
        
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        
    }
    
    return _manager;
    
}
-(void)SetSearchBarWithPlachTitle:(NSString *)str{
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectZero];
    rightLable.text = @"      ";
    [rightLable setFont:[UIFont systemFontOfSize:13.0]];
    rightLable.alpha = 0.5;
    [rightLable sizeToFit];
    
    UITextField *seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(30, 80, kScreenWidth-80, 28)];
    seaFiled.backgroundColor = [UIColor whiteColor];
    seaFiled.rightViewMode = UITextFieldViewModeAlways;
    seaFiled.rightView = rightLable;
    seaFiled.placeholder = str;
    seaFiled.font = [UIFont systemFontOfSize:13.0];
    seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    seaFiled.layer.borderWidth = 0.6f;
    seaFiled.layer.cornerRadius = 14.0f;
    seaFiled.delegate = self;
    seaFiled.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:seaFiled];
    
    UIImage *btnImg = [UIImage imageNamed:@"2.9.png"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(kScreenWidth-30-btnImg.size.width/2, 80, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];
    
    [self.view addSubview:searchBtn];
}

-(UIView *)SetsSearchBarWithPlachTitle:(NSString *)str{
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectZero];
    rightLable.text = @"      ";
    [rightLable setFont:[UIFont systemFontOfSize:13.0]];
    rightLable.alpha = 0.5;
    [rightLable sizeToFit];
    
    UITextField *seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-80, 28)];
    seaFiled.tag = 500;
    seaFiled.backgroundColor = [UIColor whiteColor];
    seaFiled.rightViewMode = UITextFieldViewModeAlways;
    seaFiled.rightView = rightLable;
    seaFiled.placeholder = str;
    seaFiled.font = [UIFont systemFontOfSize:13.0];
    seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    seaFiled.layer.borderWidth = 0.6f;
    seaFiled.layer.cornerRadius = 14.0f;
    seaFiled.delegate = self;
    seaFiled.returnKeyType = UIReturnKeySearch;
    //    [self.view addSubview:seaFiled];
    
    UIImage *btnImg = [UIImage imageNamed:@"2.9.png"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(kScreenWidth-30-btnImg.size.width, 0, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];
    
    
    UIView *backview = [[UIView alloc]init];
    backview.frame = RECT(30, 80, kScreenWidth, 28);
    [backview addSubview:seaFiled];
    [backview addSubview:searchBtn];
    return backview;
    //    [self.view addSubview:searchBtn];
}

-(void)searchBtn{
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

-(void)addTitle :(NSString *)str
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel* titlelabel = [UnityLHClass initUILabel:str font:16.0 color:[UIColor whiteColor] rect:CGRectMake(60, 0, kScreenWidth-130, 44)];
    [titleView addSubview:titlelabel];
    self.navigationItem.titleView = titleView;
    titlelabel.textAlignment=NSTextAlignmentCenter;
}

-(void)addMiddleTitle :(NSString *)str
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    
    //    UILabel* titlelabel = [UnityLHClass initUILabel:str font:16.0 color:[UIColor whiteColor] rect:CGRectMake(60, 0, kScreenWidth-220, 44)];
    UILabel* titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, kScreenWidth-190, 44)];
    titlelabel.text = str;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [titleView addSubview:titlelabel];
    self.navigationItem.titleView = titleView;
    titlelabel.textAlignment=NSTextAlignmentCenter;
}

-(void)addLeftTitle :(NSString *)str
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    
    //    UILabel* titlelabel = [UnityLHClass initUILabel:str font:16.0 color:[UIColor whiteColor] rect:CGRectMake(60, 0, kScreenWidth-220, 44)];
    UILabel* titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-190, 44)];
    titlelabel.text = str;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [titleView addSubview:titlelabel];
    self.navigationItem.titleView = titleView;
    titlelabel.textAlignment=NSTextAlignmentCenter;
}



-(void)addMiddleImageView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [UIImage imageNamed:@"index_logo.png"];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 13, img.size.width/2, img.size.height/2)];
    imgView.image = img;
    imgView.userInteractionEnabled = YES;
    [titleView addSubview:imgView];
    self.navigationItem.titleView = titleView;
}

-(void)addLeftMiddleImageView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [UIImage imageNamed:@"index_logo.png"];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 13, img.size.width/2, img.size.height/2)];
    imgView.image = img;
    imgView.userInteractionEnabled = YES;
    [titleView addSubview:imgView];
    self.navigationItem.titleView = titleView;
}


-(void)addNavTitle :(NSString *)str
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel* titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-160, 44)];
    titlelabel.text = str;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [titleView addSubview:titlelabel];
    self.navigationItem.titleView = titleView;
    titlelabel.textAlignment=NSTextAlignmentCenter;
    
}


-(void)addLeftNavTitle :(NSString *)str
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel* titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-190, 44)];
    titlelabel.text = str;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    [titleView addSubview:titlelabel];
    self.navigationItem.titleView = titleView;
    titlelabel.textAlignment=NSTextAlignmentCenter;
    
}



#pragma mark - 用户自定义方法
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}
- (void)addNavigationLeftButton:(NSString *)str
{
    UIImageView *imageView = [UnityLHClass initUIImageView:str rect:CGRectMake(0, 12,[UIImage imageNamed:str].size.width/2,[UIImage imageNamed:str].size.height/2)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

-(void)addNavLeftButton:(NSString *)str
{
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame = CGRectMake(kScreenWidth-[UIImage imageNamed:str].size.width/2, 12,[UIImage imageNamed:str].size.width-3,[UIImage imageNamed:str].size.height-3);
    [forwardButton setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)addNavigationRightButton:(NSString *)str
{
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame = CGRectMake(kScreenWidth-[UIImage imageNamed:str].size.width/2, 12,[UIImage imageNamed:str].size.width/2,[UIImage imageNamed:str].size.height/2);
    [forwardButton setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}
- (void)addNavigationRightButtonForStr:(NSString *)str{
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame =CGRectMake(kScreenWidth-50, 12, 80, 30);
    [forwardButton setTitle:str forState:UIControlStateNormal];
    forwardButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [forwardButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
- (void)addNavigationRightButtonForStr:(NSString *)str WithImage:(NSString *)imageName{
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame =CGRectMake(kScreenWidth-[UIImage imageNamed:str].size.width/2, 12,[UIImage imageNamed:str].size.width/2,[UIImage imageNamed:str].size.height/2);
    [forwardButton setTitle:str forState:UIControlStateNormal];
    forwardButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [forwardButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    forwardButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}
-(void)addSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    [titleView addSubview:searchImgView];
    
    UITextField *searchFiled = [[UITextField alloc]initWithFrame:CGRectMake(50, 0,kScreenWidth-170, searchImg.size.height/3+5)];
    searchFiled.backgroundColor = [UIColor clearColor];
    searchFiled.text = @"输入局站、地址";
    searchFiled.textColor = [UIColor whiteColor];
    searchFiled.font = [UIFont systemFontOfSize:15.0];
    searchFiled.userInteractionEnabled = NO;
    [searchImgView addSubview:searchFiled];
    
    UIImage *seaBtnImg = [UIImage imageNamed:@"search_btn.png"];
    UIImageView *searchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, seaBtnImg.size.width/2.5, seaBtnImg.size.height/2.5)];
    searchBtn.image = seaBtnImg;
    searchBtn.userInteractionEnabled = YES;
    [searchImgView addSubview:searchBtn];
    
    UIButton *seachButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 3, kScreenWidth-130, searchImg.size.height/3+5)];
    [seachButton setBackgroundColor:[UIColor clearColor]];
    [seachButton addTarget:self action:@selector(seachButton) forControlEvents:UIControlEventTouchUpInside];
    [searchImgView addSubview:seachButton];
    
    self.navigationItem.titleView = titleView;
}
-(void)addLeftSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 7, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    [titleView addSubview:searchImgView];
    
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-130, searchImg.size.height/3+5)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.backgroundColor = [UIColor clearColor];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.placeholder = @"输入局站、地址";
    searchField.textColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.enablesReturnKeyAutomatically = YES;
    searchField.font = [UIFont systemFontOfSize:15.0];
    [searchImgView addSubview:searchField];
    
    self.navigationItem.titleView = titleView;
}

-(void)addMidSearchBar
{
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-125, searchImg.size.height/3+5)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.placeholder = @"输入地址";
    searchField.textColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.enablesReturnKeyAutomatically = YES;
    searchField.font = [UIFont systemFontOfSize:15.0];
    [searchImgView addSubview:searchField];
    
    self.navigationItem.titleView = searchImgView;
}


-(void)seachButton
{
    
}



-(void)rightAction
{
    
}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nohiddenBottomBar:(BOOL)hide
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CGRect rect = delegate.bottomBarView.frame;
    rect.origin.y = hide ? kScreenHeight : kScreenHeight - 62;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        rect.origin.y = rect.origin.y - 20;
    }
    
    [UIView animateWithDuration:0.1f animations:^(void) {
        delegate.bottomBarView.frame = rect;
    } completion:^(BOOL finished) {
    }];
}


- (void)hiddenBottomBar:(BOOL)hide
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CGRect rect = delegate.bottomBarView.frame;
    rect.origin.y = hide ? kScreenHeight : kScreenHeight - 49;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        rect.origin.y = rect.origin.y - 20;
    }
    
    [UIView animateWithDuration:0.1f animations:^(void) {
        delegate.bottomBarView.frame = rect;
    } completion:^(BOOL finished) {
    }];
}
//自适应(UILabel)高度
-(float)heightForCellWithWid:(NSString *)str width:(float)wid
{
    CGSize constraint = CGSizeMake(12.0f, 20000.0f);
    CGSize size = [@"测" sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGSize titleSize = [str sizeWithFont:[UIFont fontWithName:@"Arial" size:12] constrainedToSize:CGSizeMake(MAXFLOAT, size.height)];
    
    
    float width = titleSize.width;
    float h = width/wid;
    return size.height*h+20;
}

//ios 7 适配自适应高度
- (float)AutomaticIOS7UILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor  rectWidth:(float)labelWid rectHeight:(float)labelHgh lines:(int)lines
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = strTitle;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = lines;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    //labelHgh 高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(labelWid,labelHgh);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName,nil];
    CGSize actualsize =[strTitle boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    return actualsize.height;
}

- (void)backViewcolour
{
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)navigl:(NSString *)str
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];//allocate titleView
    titleView.backgroundColor=[UIColor clearColor];
    //Create UILable
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 15, kScreenWidth-130, 30)];//allocate titleText
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setText:str];
    titleText.textColor = [UIColor whiteColor];
    //    titleText.font = [UIFont systemFontOfSize:20.0];
    titleText.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    titleText.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;
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
//利用正则表达式验证手机号
- (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    NSString *gu =@"^((010|021|022|023|024|025|026|027|028|029|852)|(\(010)|\(021)|\(022)|\(023)|\(024)|\(025)|\(026)|\(027)|\(028)|\(029)|\(852)))\\D\\d{8}|(0[3-9][1-9]{2})|(\(0[3-9][1-9]{2})\\d{7,8}))\\d\\d{1,4}$";//@"^(\\d{3,4}-)?\\d{7,8})$|(13[0-9]{9}";
    /**
     20         * 中国电信：China ;Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestgu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestgu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//利用正则表达式验证邮箱
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 自适应UILabel的高
- (CGSize)labelHight:(NSString*)str withSize:(CGFloat)newFloat withWide:(CGFloat)newWide
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:newFloat];
    CGSize constraint = CGSizeMake(newWide, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}



- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

//提示框
-(void)showAlertWithTitle:(NSString *)title :(NSString *)messageStr :(NSString *)cancelBtn :(NSString *)otherBtn {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:messageStr delegate:self cancelButtonTitle:cancelBtn otherButtonTitles:otherBtn, nil];
    [alert show];
}


- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


- (NSString *) platformString
{
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}




@end
