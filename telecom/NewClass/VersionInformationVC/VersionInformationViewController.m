//
//  VersionInformationViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/5/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "VersionInformationViewController.h"

@interface VersionInformationViewController ()

@end


@implementation VersionInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    [self addLeftTitle:@"版本信息"];
    // Do any additional setup after loading the view.
    _baseScrollView.backgroundColor = [UIColor whiteColor];
    NSLog(@"self.dataArr == %@",self.dataArr);
    [self initView];
}

-(void)initView
{
    UIImage *img1 = [UIImage imageNamed:@"kuang1"];
    UIImage *img2 = [UIImage imageNamed:@"kuang2"];
    UIImage *img3 = [UIImage imageNamed:@"icon"];
    UIImage *img4 = [UIImage imageNamed:@"download"];
    
    UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, kScreenWidth-30,img1.size.height/2+10)];
    imagview.image = img1;
    imagview.userInteractionEnabled = YES;
    [_baseScrollView addSubview:imagview];
    
    NSString *verison = [NSString stringWithFormat:@"当前版本%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSArray *leftArray = @[verison,@"无新版本"];
    for (int i = 0; i < 2; i++) {
        UILabel *leftLable = [UnityLHClass initUILabel:[leftArray objectAtIndex:i] font:12.0 color:[UIColor grayColor] rect:CGRectMake(30, 45+25*i, 180, 20)];
        [_baseScrollView addSubview:leftLable];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-90, 40, 1, img1.size.height/2-25)];
    lineView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
    [_baseScrollView addSubview:lineView];
    
    UIImageView *imagview1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, img1.size.height/2+50, kScreenWidth-30,img2.size.height/2+20)];
    imagview1.image = img2;
    imagview1.userInteractionEnabled = YES;
    [_baseScrollView addSubview:imagview1];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];

    for (int i = 0; i < self.dataArr.count; i++) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(25, 205+70*i, kScreenWidth-50, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
        [_baseScrollView addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-90, 150+70*i, 1, img1.size.height/2-40)];
        lineView1.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
        [_baseScrollView addSubview:lineView1];
        
        UIImageView *imagview1 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 155+70*i, img3.size.height/2+5,img3.size.height/2+5)];
//        imagview1.image = img3;
        
        NSString *strUrl = [NSString stringWithFormat:@"http://%@/%@/%@",ADDR_IP,ADDR_DIR,[[self.dataArr objectAtIndex:i] objectForKey:@"imgUrl"]];
        
        NSLog(@"%@",strUrl);
        NSURL *url = [NSURL URLWithString:strUrl];
        [imagview1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
        imagview1.userInteractionEnabled = YES;
        [_baseScrollView addSubview:imagview1];
        
        UIImageView *downImagview = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-73, 150+70*i, img4.size.height/1.5,img4.size.height/1.5)];
        downImagview.image = img4;
        downImagview.userInteractionEnabled = YES;
        [_baseScrollView addSubview:downImagview];
        
        UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,img4.size.height/1.5,img4.size.height/1.5)];
        downBtn.backgroundColor = [UIColor clearColor];
        downBtn.tag = 100+i;
        [downBtn addTarget:self action:@selector(downBtn:) forControlEvents:UIControlEventTouchUpInside];
        [downImagview addSubview:downBtn];
        
        UILabel *downLable = [UnityLHClass initUILabel:@"下载" font:10.0 color:[UIColor grayColor] rect:CGRectMake(kScreenWidth-100, 180+70*i, 85, 20)];
        downLable.textAlignment = NSTextAlignmentCenter;
        [_baseScrollView addSubview:downLable];
        
        if (i == 0) {
            lineView.hidden = NO;
            lineView.frame = CGRectMake(25, 210, kScreenWidth-50, 1);
        }
        if (i == 1) {
            lineView.hidden = NO;
            imagview1.frame = CGRectMake(30, 155+70*i-3, img3.size.height/2+5,img3.size.height/2+5);
        }
        if (i == 2) {
            lineView.hidden = YES;
            imagview1.frame = CGRectMake(30, 155+70*i-5, img3.size.height/2+5,img3.size.height/2+5);
        }
    }
    
    NSArray *nameLableArray = @[@"i运维外协版",@"i运维外协版",@"i运维外协版"];
    NSArray *numArray = @[@"版本3.0.3  32.4M  2015/05/21",@"版本3.0.3  32.4M  2015/05/21",@"版本3.0.3  32.4M  2015/05/21"];
    for (int i = 0; i < self.dataArr.count; i++) {
        UILabel *upLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor blackColor] rect:CGRectMake(75, 150+70*i, 150, 20)];
        upLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"appName"];
        [_baseScrollView addSubview:upLable];
        
        NSString *strLab = [NSString stringWithFormat:@"版本%@  %.2fM  %@",[[self.dataArr objectAtIndex:i] objectForKey:@"currentVersion"],([[[self.dataArr objectAtIndex:i] objectForKey:@"fileSize"] floatValue])/(1024*1024),[[self.dataArr objectAtIndex:i] objectForKey:@"releaseDate"]];
        
        CGSize labelsize = [strLab sizeWithFont:[UIFont systemFontOfSize:11.0]	constrainedToSize:CGSizeMake(150, [strLab length])lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *downLable = [UnityLHClass initUILabel:[numArray objectAtIndex:i] font:11.0 color:[UIColor grayColor] rect:CGRectMake(75, 170+70*i, 150, labelsize.height+15)];
        downLable.numberOfLines = 0;
        downLable.text = strLab;
        
        [_baseScrollView addSubview:downLable];
        
        
        if (i == 0) {
            upLable.frame = CGRectMake(75, 155+70*i, 150, 20);
            downLable.frame = CGRectMake(75, 175+70*i, 150, labelsize.height+10);
        }
        
//        if (i == 1) {
//            downLable.frame = CGRectMake(75, 170+70*i, 150, labelsize.height+10);
//        }
//
//        if (i == 2) {
//            downLable.frame = CGRectMake(75, 170+70*i, 150, labelsize.height+10);
//        }
    }
    
    _baseScrollView.scrollEnabled = NO;
    
}

- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(void)downBtn:(UIButton *)sender
{
    NSMutableString *downloadStr= [NSMutableString string];
    [downloadStr appendString:@"itms-services://?action=download-manifest&url="];
    NSLog(@"%d",sender.tag);
    if (sender.tag == 100) {
        NSString *downStr = [[self.dataArr objectAtIndex:(sender.tag -100)] objectForKey:@"downloadLocation"];
        [downloadStr appendString:downStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
    }else if(sender.tag == 101){
        NSString *downStr1 = [[self.dataArr objectAtIndex:(sender.tag -100)] objectForKey:@"downloadLocation"];
        [downloadStr appendString:downStr1];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
    }else if (sender.tag == 102){
        NSString *downStr2 = [[self.dataArr objectAtIndex:(sender.tag -100)] objectForKey:@"downloadLocation"];
        [downloadStr appendString:downStr2];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
    }
    
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
