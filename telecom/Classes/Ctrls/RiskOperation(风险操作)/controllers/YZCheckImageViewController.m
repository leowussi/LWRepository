//
//  YZCheckImageViewController.m
//  telecom
//
//  Created by 锋 on 16/6/27.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZCheckImageViewController.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface YZCheckImageViewController ()

@end

@implementation YZCheckImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"riskOperation/GetAttachment";
    paraDict[@"workNo"] = _workNo;
    paraDict[@"attachmentId"] = _attachmentId;
    httpPOST(paraDict, ^(id result) {
        NSString *fileId = [[result objectForKey:@"detail"] objectForKey:@"fileId"];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.center = self.view.center;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/riskAttachment/%@/",ADDR_IP,ADDR_DIR,fileId]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                return ;
            }
            imageView.bounds = CGRectMake(0, 0, kScreenWidth, kScreenWidth * image.size.height/image.size.width > kScreenHeight ? kScreenHeight : kScreenWidth * image.size.height/image.size.width);
        }];
        [self.view addSubview:imageView];
        [self.view sendSubviewToBack:imageView];

        
    }, ^(id result) {
        NSLog(@"%@",result);
    });

    [self addBackButton];
}

- (void)addBackButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(18,20,44,44);
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    
    [self.view addSubview:leftButton];
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
