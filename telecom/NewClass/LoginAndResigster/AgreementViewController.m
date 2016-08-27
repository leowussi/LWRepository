//
//  AgreementViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/1.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()<UITextViewDelegate,UIWebViewDelegate>
{
    UITextView *agreementTextView;
}
@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationLeftButton];
    [self initView];
}

-(void)initView
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Agreement" ofType:@"rtf"];
//    NSError *error;
//    NSString *stringFromFileAtPath = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//    if (stringFromFileAtPath == nil)
//    {        // an error occurred
////        NSLog(@"Error reading file at %@\n%@",path, [error localizedFailureReason]);
//        // implementation continues ...
//    }else
//    {
////        NSLog(@"stringFromFile is: %@",stringFromFileAtPath);
//    }
//    
//    agreementTextView  = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
//    agreementTextView.backgroundColor = [UIColor whiteColor];
//    agreementTextView.editable = NO;
//    agreementTextView.text = stringFromFileAtPath;
//    agreementTextView.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:agreementTextView];

    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 69, self.view.frame.size.width, self.view.frame.size.height-69)];
   [webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"agreement.htm" ofType:nil]isDirectory:NO]]];
    webview.backgroundColor = [UIColor clearColor];
    webview.superview.backgroundColor =  [UIColor whiteColor];
    
    [self.view addSubview:webview];
}



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
