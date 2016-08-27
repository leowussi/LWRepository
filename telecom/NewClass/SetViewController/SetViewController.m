//
//  SetViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/5/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SetViewController.h"
#import "VersionInformationViewController.h"
#import "BDKNotifyHUD.h"
@interface SetViewController ()
{
    UISwitch *switchView;
    UILabel *fileLable;
//    UIButton *swichBtn;
    UIButton *onBtn;
    NSString *flowStr;
}
@property (strong, nonatomic) BDKNotifyHUD *notify;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *notificationText;

@end

@implementation SetViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self hiddenBottomBar:YES];
    [self getLiuLiang];
}

-(void)getLiuLiang
{
    httpGET2(@{URL_TYPE : @"myInfo/GetUserFlow"}, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            
            self.flowNum = [result objectForKey:@"flowNum"];
            [self upLable:self.flowNum];
        }
    }, ^(id result) {
        [self upLable:@"0"];
    });
    
}

-(void)upLable:(NSString *)str
{
    UILabel *liuliangLable = (UILabel *)[_baseScrollView viewWithTag:888];
    liuliangLable.text = [NSString stringWithFormat:@"%.2fM",str.floatValue];;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    // Do any additional setup after loading the view.
    [self addLeftTitle:@"设置"];
    self.notificationText = @"清除成功";
    self.imageName = @"Checkmark@2x.png";
    
    
    [self initView];
}


-(void)initView
{
    UIImage *cleanImg = [UIImage imageNamed:@"clear_bg"];
    NSArray *leftArray = @[@"流量超过2M仅在WLAN下可用",@"清除缓存(5.6M)",@"当月流量统计",@"版本信息"];
    for (int i = 0; i < leftArray.count; i++) {
        UIView *kuanView = [[UIView alloc]initWithFrame:CGRectMake(20, 20+50*i, kScreenWidth-40, 40)];
        kuanView.backgroundColor = [UIColor whiteColor];
        kuanView.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0].CGColor;
        kuanView.layer.borderWidth = 1.0;
        [_baseScrollView addSubview:kuanView];
        
        
        UILabel *leftLable = [UnityLHClass initUILabel:[leftArray objectAtIndex:i] font:13.0 color:[UIColor blackColor] rect:CGRectMake(10, 10, kScreenWidth-120, 20)];
        leftLable.backgroundColor = [UIColor clearColor];
        [kuanView addSubview:leftLable];
        
        if (i == 0) {
            
            onBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [onBtn setFrame:CGRectMake(kScreenWidth-100, 10, 50, 20)];
            [onBtn setBackgroundImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
            [onBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
            onBtn.backgroundColor = [UIColor clearColor];
            [kuanView addSubview:onBtn];
            
        }
        
        if (i == 1) {
            leftLable.hidden = YES;
            fileLable = [UnityLHClass initUILabel:@"1.5M" font:13.0 color:[UIColor blackColor] rect:CGRectMake(30, 30+50*i, kScreenWidth-40, 20)];
            [_baseScrollView addSubview:fileLable];
            fileLable.text = [ NSString stringWithFormat : @"清除缓存(%.2fM)" , [ self filePath]];
            
            UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [cleanBtn setFrame:CGRectMake(kScreenWidth-80, 30+50, 50, 20)];
            [cleanBtn setBackgroundImage:cleanImg forState:UIControlStateNormal];
            [cleanBtn setTitle:@"清理" forState:UIControlStateNormal];
            [cleanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cleanBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [cleanBtn addTarget:self action:@selector(cleanBtn) forControlEvents:UIControlEventTouchUpInside];
            [_baseScrollView addSubview:cleanBtn];
        }
        
        if (i == 2) {
            UILabel *rightLable = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor grayColor] rect:CGRectMake(kScreenWidth-85, 30+50*i, 50, 20)];
            rightLable.tag = 888;
            rightLable.textAlignment = NSTextAlignmentRight;
//            rightLable.text = [NSString stringWithFormat:@"%.2fM",self.flowNum.floatValue];
            [_baseScrollView addSubview:rightLable];
        }
        
        if (i == 3) {
            
            UILabel *rightLable = [UnityLHClass initUILabel:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] font:13.0 color:[UIColor grayColor] rect:CGRectMake(kScreenWidth-100, 10, 50, 20)];
            [kuanView addSubview:rightLable];
            
            UIImage *rightImg = [UIImage imageNamed:@"right_jtbtn"];
            UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-55, 13, rightImg.size.width/1.5, rightImg.size.height/1.5)];
            rightView.image = rightImg;
            [kuanView addSubview:rightView];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 170, kScreenWidth-40, 40)];
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
            [_baseScrollView addSubview:button];
            
        }
    }
    

    
//    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-50, 5, 100, 20)];
//    rightLable.text = [ NSString stringWithFormat : @"%.2fM" , [ self filePath]];
//    rightLable.textColor = [UIColor blueColor];

}


#pragma mark == WLAN开关
-(void)onBtn:(UIButton *)sender
{
    NSLog(@"开");
    sender.selected = !sender.selected;
    
    if (sender.selected == YES){
        [sender setBackgroundImage:[UIImage imageNamed:@"19.png"] forState:UIControlStateNormal];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"switch.png"] forState:UIControlStateNormal];
    }
}

#pragma mark == 版本信息
-(void)button
{
    NSLog(@"版本信息");
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"appUpdate/GetAppList";
    paraDict[@"deviceType"] = [NSString stringWithFormat:@"1"];
    httpGET2(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
           
            VersionInformationViewController *versionVC = [[VersionInformationViewController alloc]init];
            versionVC.dataArr = [result objectForKey:@"list"];
            [self.navigationController pushViewController:versionVC animated:YES];
        }
    }, ^(id result) {

    });

}
#pragma mark == 清除缓存
-(void)cleanBtn
{
    NSLog(@"清除缓存");
    [self clearFile];
    fileLable.text = @"";
    fileLable.text = [ NSString stringWithFormat : @"清除缓存(%.2fM)" , [ self filePath]];
    [fileLable reloadInputViews];
    
}



///////////////////////////////////////////////////////////////////////////////////
- (float) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
        
    }
    
    return 0 ;
    
}
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}

- ( float )filePath

{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}

- ( void )clearFile

{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}

- ( void )clearCachSuccess
{
    
    NSLog (@"清理成功");
    [self switchImages];
    [self displayNotification];
    
}

- (BDKNotifyHUD *)notify {
    if (_notify != nil) return _notify;
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:self.imageName] text:self.notificationText];
    _notify.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notify;
}



- (void)switchImages {
    
    self.notify.image = [UIImage imageNamed:self.imageName];
    self.notify.text = self.notificationText;
}

- (void)displayNotification {
    if (self.notify.isAnimating) return;
    
    [self.view addSubview:self.notify];
    [self.notify presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [self.notify removeFromSuperview];
    }];
}

///////////////////////////////////////////////////////////////////////////////////

-(void)leftAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
