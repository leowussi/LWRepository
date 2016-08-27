//
//  MyWorkListViewController.m
//  telecom
//
//  Created by Sundear on 15/12/22.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "MyWorkListViewController.h"
#import "HWBProgressHUD.h"
#import "RNCachingURLProtocol.h"

@interface MyWorkListViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webview;
@end

@implementation MyWorkListViewController
-(UIWebView *)webview{
    if (_webview  == nil) {
        _webview  = [[UIWebView alloc]initWithFrame:CGRectMake(0, 69, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-69)];
        _webview.dataDetectorTypes = UIDataDetectorTypeAll;
        _webview.delegate = self;
        [self.view addSubview:_webview];
    }
    return _webview;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [[UIButton  alloc] initWithFrame:RECT((APP_W-10-30), (NAV_H-30)/2,30, 30)];

    [btn setBackgroundImage:[UIImage imageNamed:@"刷新.png"] forState:0];
    [btn addTarget:self action:@selector(btncleck) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
    
    NSURL *url = [NSURL URLWithString:self.string];
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:0.5];

    [self.webview loadRequest:request];

}
-(void)btncleck{
 
    HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
    //弹出框的类型
    hud.mode = HWBProgressHUDModeText;
    //弹出框上的文字
    hud.detailsLabelText = @"缓存清理成功 即将刷新页面！";
    //弹出框的动画效果及时间

    
    __weak typeof(self) daiti;
    [hud showAnimated:YES whileExecutingBlock:^{
        //执行请求，完成
//        [daiti.webview reload];
        sleep(2);
        //刷新页面
        
//        NSURL *url = [NSURL URLWithString:self.string];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:0.5];
//        
//        [self.webview loadRequest:request];
        

    } completionBlock:^{
        [hud removeFromSuperview];

    }];
    [self.webview reload];

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
