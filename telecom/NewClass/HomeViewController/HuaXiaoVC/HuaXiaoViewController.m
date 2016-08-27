//
//  HuaXiaoViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/6/2.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "HuaXiaoViewController.h"

@interface HuaXiaoViewController ()
{
    UIImageView *backImgView;
    UIImageView *peopleImgView;
    UIImageView *moneyImgView;
    UIImageView *thingImgView;
    UIImageView *wuImgView;
    UIImageView *zhiImgView;
}
@end

@implementation HuaXiaoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor grayColor];
    // 设置导航默认标题的颜色及字体大小
    self.title = [NSString stringWithFormat:@"人财事物值(截止时间:%@)",
                  [self.dataArr[0] objectForKey:@"expiryDate"]] ;
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:13.0f]};
    
    [self initView];
}

-(void)initView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    UIImage *backImg = [UIImage imageNamed:@"人财事物值-底.png"];
    backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, backImg.size.width/2, backImg.size.height/2)];
    backImgView.image = backImg;
    backImgView.userInteractionEnabled = YES;
    [backView addSubview:backImgView];
    
    if (kScreenHeight >480) {
        
    }else{
        backImgView.frame = CGRectMake(0, 50, backImg.size.width/2, backImg.size.height/2);
    }
    
    for (int i = 0; i < self.dataArr.count; i++) {
        UILabel *lable = [UnityLHClass initUILab:@"" font:11.0 color:[UIColor whiteColor] rect:CGRectMake(83, 150+i, 70, 40)];
        lable.text = [NSString stringWithFormat:@"%@\n%@",@"运营队伍",@"共8270人"];
        lable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"content"];
        [backImgView addSubview:lable];
        
        NSInteger indexId = [[[self.dataArr objectAtIndex:i] objectForKey:@"id"] integerValue] - 1;

        
        if (indexId == 1) {
            [lable setFrame:CGRectMake(165, 150, 70, 40)];
        }
        
        if (indexId == 2) {
            [lable setFrame:CGRectMake(83, 290, 70, 40)];
        }
        
        if (indexId == 3) {
            [lable setFrame:CGRectMake(165, 290, 70, 40)];
        }
        
        if (indexId == 4) {
            [lable setFrame:CGRectMake(125, 220, 70, 40)];
        }
    }
    
    
    UIButton *peoBtn = [UnityLHClass initButton:CGRectMake(84, 123, 70, 70) radius:35];
    peoBtn.backgroundColor = [UIColor clearColor];
    [peoBtn addTarget:self action:@selector(peoBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:peoBtn];
    
    UIButton *moneyBtn = [UnityLHClass initButton:CGRectMake(165, 123, 70, 70) radius:35];
    moneyBtn.backgroundColor = [UIColor clearColor];
    [moneyBtn addTarget:self action:@selector(moneyBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:moneyBtn];
    
    UIButton *zhiBtn = [UnityLHClass initButton:CGRectMake(125, 195, 70, 70) radius:35];
    zhiBtn.backgroundColor = [UIColor clearColor];
    [zhiBtn addTarget:self action:@selector(zhiBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:zhiBtn];
    
    UIButton *thingBtn = [UnityLHClass initButton:CGRectMake(83, 265, 70, 70) radius:35];
    thingBtn.backgroundColor = [UIColor clearColor];
    [thingBtn addTarget:self action:@selector(thingBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:thingBtn];
    
    UIButton *wuBtn = [UnityLHClass initButton:CGRectMake(165, 265, 70, 70) radius:35];
    wuBtn.backgroundColor = [UIColor clearColor];
    [wuBtn addTarget:self action:@selector(wuBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:wuBtn];
    
   
#pragma mark - 人
    [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger indexId = [[obj objectForKey:@"id"] integerValue];
        NSArray *array = [obj objectForKey:@"detailList"];
        switch (indexId) {
            case 1:
                [self createPeopleImgViewWithSuperView:backView showArray:array];
                break;
            case 2:
                [self createMoneyImgViewWithSuperView:backView showArray:array];
                break;

            case 3:
                [self createZhiImgViewWithSuperView:backView showArray:array];
                break;
            case 4:
                [self createWuImgViewWithSuperView:backView showArray:array];
                break;

            case 5:
                [self createThingImgViewWithSuperView:backView showArray:array];
                break;
            default:
                break;
        }
    }];
    if (peopleImgView == nil) {
        [self createPeopleImgViewWithSuperView:backView showArray:nil];
    }
    if (moneyImgView == nil) {
        [self createMoneyImgViewWithSuperView:backView showArray:nil];

    }
    
    if (thingImgView == nil) {
        [self createThingImgViewWithSuperView:backView showArray:nil];
        
    }
    
    if (zhiImgView == nil) {
        [self createZhiImgViewWithSuperView:backView showArray:nil];
    }
    
    if (wuImgView == nil) {
        [self createWuImgViewWithSuperView:backView showArray:nil];
    }

}

#pragma mark --- 人视图
- (void)createPeopleImgViewWithSuperView:(UIView *)backView showArray:(NSArray *)showArray
{
    UIImage *img1 = [UIImage imageNamed:@"1.png"];
    peopleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, img1.size.width/2, img1.size.height/2+2)];
    peopleImgView.image = img1;
    peopleImgView.userInteractionEnabled = YES;
    peopleImgView.hidden = YES;
    [backView addSubview:peopleImgView];
    
    if (kScreenHeight >480) {
        
    }else{
        peopleImgView.frame = CGRectMake(0, 50, img1.size.width/2, img1.size.height/2+2);
    }
    
//        NSArray *peopleArr = [[self.dataArr objectAtIndex:0] objectForKey:@"detailList"];
        
        for (int i = 0; i < showArray.count; i++) {
            CGRect sizeWith = [[[showArray objectAtIndex:i] objectForKey:@"content"] boundingRectWithSize:CGSizeMake(70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]} context:nil];
            
            UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(40+i, 70, 75, 40)];
            lable.text = [[showArray objectAtIndex:i] objectForKey:@"content"];
            
            lable.font = [UIFont systemFontOfSize:12.0];
            [peopleImgView addSubview:lable];
            
            
            if (i == 1) {
                lable.frame = CGRectMake(122, 70, 75, 40);
            }
            
            if (i == 2) {
                lable.frame = CGRectMake(3, 138, 75, 40);
            }
            
            if (i == 3) {
                lable.frame = CGRectMake(165, 138, 72, sizeWith.size.height);
            }
            
            if (i == 4) {
                lable.frame = CGRectMake(40, 210, 75, 50);
            }
            
            if (i == 5) {
                lable.frame = CGRectMake(122, 215, 75, 40);
            }
            
        }
        
        for (NSDictionary *dict in self.dataArr) {
            NSString *title = [dict objectForKey:@"title"];
            if ([title isEqualToString:@"事"]) {
                UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(40, 70, 75, 40)];
                lable.font = [UIFont systemFontOfSize:11.0];
                [peopleImgView addSubview:lable];
                lable.frame = CGRectMake(80, 290, 75, 40);
                lable.textColor = [UIColor whiteColor];
                lable.text = [dict objectForKey:@"content"];


            }else if ([title isEqualToString:@"物"]) {
                UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(40, 70, 75, 40)];
                lable.font = [UIFont systemFontOfSize:11.0];
                [peopleImgView addSubview:lable];
                lable.frame = CGRectMake(163, 290, 75, 40);
                lable.textColor = [UIColor whiteColor];
                lable.text = [dict objectForKey:@"content"];
            }
        }
       
    UIButton *button = [UnityLHClass initButton:CGRectMake(83, 128, 70, 70) radius:35];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [peopleImgView addSubview:button];
    

}

- (void)createMoneyImgViewWithSuperView:(UIView *)backView showArray:(NSArray *)showArray
{
    UIImage *img2 = [UIImage imageNamed:@"2.png"];
    moneyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, img2.size.width/2, img2.size.height/2+2)];
    moneyImgView.image = img2;
    moneyImgView.userInteractionEnabled = YES;
    moneyImgView.hidden = YES;
    [backView addSubview:moneyImgView];
    
    if (kScreenHeight >480) {
        
    }else{
        moneyImgView.frame = CGRectMake(0, 50, img2.size.width/2, img2.size.height/2+2);
    }

        
//        NSArray *moneyArr = [[self.dataArr objectAtIndex:1] objectForKey:@"detailList"];
        
        for (int i = 0; i < showArray.count; i++) {
            
            CGSize sizeWith = [self labelHight:[[showArray objectAtIndex:i] objectForKey:@"content"]];
            
            UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(122+i, 70, 75, 40)];
            lable.text = [[showArray objectAtIndex:i] objectForKey:@"content"];
            lable.font = [UIFont systemFontOfSize:12.0];
            [moneyImgView addSubview:lable];
            
            
            if (i == 1) {
                lable.frame = CGRectMake(205, 70, 75, sizeWith.height);
                lable.font = [UIFont systemFontOfSize:11.0];
            }
            
            if (i == 2) {
                lable.frame = CGRectMake(80, 140, 75, sizeWith.height);
                lable.font = [UIFont systemFontOfSize:11.0];
            }
            
            if (i == 3) {
                lable.frame = CGRectMake(245, 140, 75, sizeWith.height);
                lable.font = [UIFont systemFontOfSize:11.0];
            }
            
            if (i == 4) {
                lable.frame = CGRectMake(122, 215, 75, sizeWith.height);
                lable.font = [UIFont systemFontOfSize:11.0];
            }
            
            if (i == 5) {
                lable.frame = CGRectMake(205, 215, 75, sizeWith.height);
                lable.font = [UIFont systemFontOfSize:11.0];
            }
        }
        
        for (NSDictionary *dict in self.dataArr) {
            NSString *title = [dict objectForKey:@"title"];
            if ([title isEqualToString:@"事"]) {
                UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(40, 70, 75, 40)];
                lable.font = [UIFont systemFontOfSize:11.0];
                [moneyImgView addSubview:lable];
                lable.frame = CGRectMake(80, 290, 75, 40);
                lable.textColor = [UIColor whiteColor];
                lable.text = [dict objectForKey:@"content"];
                
                
            }else if ([title isEqualToString:@"物"]) {
                UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(40, 70, 75, 40)];
                lable.font = [UIFont systemFontOfSize:11.0];
                [moneyImgView addSubview:lable];
                lable.frame = CGRectMake(163, 290, 75, 40);
                lable.textColor = [UIColor whiteColor];
                lable.text = [dict objectForKey:@"content"];
            }
        
        UIButton *moneyVCBtn = [UnityLHClass initButton:CGRectMake(165, 125, 70, 70) radius:35];
        moneyVCBtn.backgroundColor = [UIColor clearColor];
        [moneyVCBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
        [moneyImgView addSubview:moneyVCBtn];
    }

}

- (void)createZhiImgViewWithSuperView:(UIView *)backView showArray:(NSArray *)showArray
{
    UIImage *backImg = [UIImage imageNamed:@"人财事物值-底.png"];

    UIImage *img5 = [UIImage imageNamed:@"5.png"];
    zhiImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, img5.size.width/2, img5.size.height/2+2)];
    zhiImgView.image = img5;
    zhiImgView.userInteractionEnabled = YES;
    zhiImgView.hidden = YES;
    [backView addSubview:zhiImgView];
    
    if (kScreenHeight >480) {
        
    }else{
        zhiImgView.frame = CGRectMake(0, 50, backImg.size.width/2, backImg.size.height/2);
    }
    
//        NSArray *zhiArr = [[self.dataArr objectAtIndex:2] objectForKey:@"detailList"];
        
        for (int i = 0; i < showArray.count; i++) {
            
            //            CGSize sizeWith = [self labelHight:[[zhiArr objectAtIndex:i] objectForKey:@"content"]];
            CGRect sizeWith = [[[showArray objectAtIndex:i] objectForKey:@"content"] boundingRectWithSize:CGSizeMake(70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]} context:nil];
            
            UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(60, 70, 70, sizeWith.size.height)];
            lable.lineBreakMode = NSLineBreakByWordWrapping;
            lable.text = [[showArray objectAtIndex:i] objectForKey:@"content"];
            lable.font = [UIFont systemFontOfSize:12.0];
            lable.adjustsFontSizeToFitWidth = YES;
            [zhiImgView addSubview:lable];
            
            if (i == 0) {
                [lable setFrame:CGRectMake(45,205,70,sizeWith.size.height)];
            }
            
            if (i == 1) {
                [lable setFrame:CGRectMake(125,210,70,sizeWith.size.height)];
            }
            
            if (i == 2) {
                [lable setFrame:CGRectMake(2,285,70,sizeWith.size.height)];
            }
            
            if (i == 3) {
                [lable setFrame:CGRectMake(165,275,70,sizeWith.size.height)];
            }
            
            if (i == 4) {
                [lable setFrame:CGRectMake(45,360,70,sizeWith.size.height)];
            }
            
            if (i == 5) {
                lable.font = [UIFont systemFontOfSize:10.0];
                [lable setFrame:CGRectMake(125,345,70,sizeWith.size.height)];
            }
        }
        for (NSDictionary *dict in self.dataArr) {
            NSString *title = [dict objectForKey:@"title"];
            if ([title isEqualToString:@"人"]) {
                CGSize sizeWith = [self labelHight:[dict objectForKey:@"content"] ];
                UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(85,155,70,sizeWith.height)];
                lable.font = [UIFont systemFontOfSize:11.0];
                [zhiImgView addSubview:lable];
                
                lable.frame = CGRectMake(85,155,70,sizeWith.height);
                lable.textColor = [UIColor whiteColor];
                lable.text = [dict objectForKey:@"content"];
                
                
            }else if ([title isEqualToString:@"财"]) {
                CGSize sizeWith = [self labelHight:[dict objectForKey:@"content"] ];
                UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(85,155,70,sizeWith.height)];
                lable.font = [UIFont systemFontOfSize:11.0];
                [zhiImgView addSubview:lable];
                lable.frame = CGRectMake(165,155,70,sizeWith.height);
                lable.textColor = [UIColor whiteColor];
                lable.text = [dict objectForKey:@"content"];
            }
        }

       
    UIButton *zhiVCBtn = [UnityLHClass initButton:CGRectMake(85, 265, 70, 70) radius:35];
    zhiVCBtn.backgroundColor = [UIColor clearColor];
    [zhiVCBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [zhiImgView addSubview:zhiVCBtn];
}

- (void)createThingImgViewWithSuperView:(UIView *)backView showArray:(NSArray *)showArray
{
    UIImage *img3 = [UIImage imageNamed:@"3.png"];
    thingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, img3.size.width/2, img3.size.height/2+2)];
    thingImgView.image = img3;
    thingImgView.userInteractionEnabled = YES;
    thingImgView.hidden = YES;
    [backView addSubview:thingImgView];
    
    if (kScreenHeight >480) {
        
    }else{
        thingImgView.frame = CGRectMake(0, 50, img3.size.width/2, img3.size.height/2+2);
    }
    
//        NSArray *thingArr = [[self.dataArr objectAtIndex:4] objectForKey:@"detailList"];
        
        for (int i = 0; i < showArray.count; i++) {
            
            CGSize sizeWith = [self labelHight:[[showArray objectAtIndex:i] objectForKey:@"content"]];
            
            UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(60, 70, 70, sizeWith.height)];
            lable.lineBreakMode = NSLineBreakByWordWrapping;
            lable.text = [[showArray objectAtIndex:i] objectForKey:@"content"];
            lable.font = [UIFont systemFontOfSize:12.0];
            [thingImgView addSubview:lable];
            
            
            if (i == 0) {
                [lable setFrame:CGRectMake(85,135,70,sizeWith.height)];
            }
            
            if (i == 1) {
                [lable setFrame:CGRectMake(162,140,75,sizeWith.height+10)];
            }
            
            if (i == 2) {
                [lable setFrame:CGRectMake(45,205,70,sizeWith.height)];
            }
            
            if (i == 3) {
                [lable setFrame:CGRectMake(205,215,70,sizeWith.height)];
            }
            
            if (i == 4) {
                [lable setFrame:CGRectMake(85,280,70,sizeWith.height)];
            }
            
            if (i == 5) {
                [lable setFrame:CGRectMake(165,280,70,sizeWith.height)];
            }
        }
    UIButton *thingVCBtn = [UnityLHClass initButton:CGRectMake(125, 195, 70, 70) radius:35];
    thingVCBtn.backgroundColor = [UIColor clearColor];
    [thingVCBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [thingImgView addSubview:thingVCBtn];
}

- (void)createWuImgViewWithSuperView:(UIView *)backView showArray:(NSArray *)showArray
{
    UIImage *backImg = [UIImage imageNamed:@"人财事物值-底.png"];

    UIImage *img4 = [UIImage imageNamed:@"4.png"];
    wuImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, img4.size.width/2, img4.size.height/2+2)];
    wuImgView.image = img4;
    wuImgView.userInteractionEnabled = YES;
    wuImgView.hidden = YES;
    [backView addSubview:wuImgView];
    
    
    if (kScreenHeight >480) {
        
    }else{
        wuImgView.frame = CGRectMake(0, 50, backImg.size.width/2, backImg.size.height/2);
    }
    
    
    
//        NSArray *wuArr = [[self.dataArr objectAtIndex:3] objectForKey:@"detailList"];
        
        for (int i = 0; i < showArray.count; i++) {
            
            CGRect sizeWith = [[[showArray objectAtIndex:i] objectForKey:@"content"] boundingRectWithSize:CGSizeMake(70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]} context:nil];
            
            UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(60+i, 70, 70, sizeWith.size.height)];
            lable.lineBreakMode = NSLineBreakByWordWrapping;
            lable.text = [[showArray objectAtIndex:i] objectForKey:@"content"];
            lable.font = [UIFont systemFontOfSize:12.0];
            lable.adjustsFontSizeToFitWidth = YES;
            [wuImgView addSubview:lable];
            
            
            if (i == 0) {
                [lable setFrame:CGRectMake(125,205,70,sizeWith.size.height)];
            }
            
            if (i == 1) {
                [lable setFrame:CGRectMake(207,205,70,sizeWith.size.height)];
            }
            
            if (i == 2) {
                [lable setFrame:CGRectMake(85,285,70,sizeWith.size.height)];
            }
            
            if (i == 3) {
                [lable setFrame:CGRectMake(250,285,70,sizeWith.size.height)];
            }
            
            if (i == 4) {
                [lable setFrame:CGRectMake(125,360,70,sizeWith.size.height)];
            }
            
            if (i == 5) {
                [lable setFrame:CGRectMake(207,360,70,sizeWith.size.height)];
            }
        }
        
        
        for (NSDictionary *dict in self.dataArr) {
            NSString *title = [dict objectForKey:@"title"];
            if ([title isEqualToString:@"人"]) {
                CGSize sizeWith = [self labelHight:[dict objectForKey:@"content"] ];
                UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(85,155,70,sizeWith.height)];
                lable.font = [UIFont systemFontOfSize:11.0];
                [wuImgView addSubview:lable];
                
                lable.frame = CGRectMake(85,155,70,sizeWith.height);
                lable.textColor = [UIColor whiteColor];
                lable.text = [dict objectForKey:@"content"];
                
                
            }else if ([title isEqualToString:@"财"]) {
                CGSize sizeWith = [self labelHight:[dict objectForKey:@"content"] ];
                UILabel *lable = [UnityLHClass initUILab:@"" font:12.0 color:[UIColor colorWithRed:131.0/255.0 green:133.0/255.0 blue:135.0/255.0 alpha:1.0] rect:CGRectMake(85,155,70,sizeWith.height)];
                lable.font = [UIFont systemFontOfSize:11.0];
                [wuImgView addSubview:lable];
                lable.frame = CGRectMake(165,155,70,sizeWith.height);
                lable.textColor = [UIColor whiteColor];
                lable.text = [dict objectForKey:@"content"];
            }
        }
    UIButton *wuVCBtn = [UnityLHClass initButton:CGRectMake(165, 265, 70, 70) radius:35];
    wuVCBtn.backgroundColor = [UIColor clearColor];
    [wuVCBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [wuImgView addSubview:wuVCBtn];

}

#pragma mark == 返回按钮
-(void)backBtn
{
    backImgView.hidden = NO;
    peopleImgView.hidden = YES;
    moneyImgView.hidden = YES;
    thingImgView.hidden = YES;
    wuImgView.hidden = YES;
    zhiImgView.hidden = YES;
}

#pragma mark == 人
-(void)peoBtn
{
    NSLog(@"点击了人按钮");
    backImgView.hidden = YES;
    moneyImgView.hidden = YES;
    thingImgView.hidden = YES;
    wuImgView.hidden = YES;
    zhiImgView.hidden = YES;
    peopleImgView.hidden = NO;
    
    
}

#pragma mark == 财
-(void)moneyBtn
{
    NSLog(@"点击了财按钮");
    backImgView.hidden = YES;
    peopleImgView.hidden = YES;
    thingImgView.hidden = YES;
    wuImgView.hidden = YES;
    zhiImgView.hidden = YES;
    moneyImgView.hidden = NO;
    
    
}

#pragma mark == 事
-(void)thingBtn
{
    NSLog(@"点击了事按钮");
    backImgView.hidden = YES;
    peopleImgView.hidden = YES;
    thingImgView.hidden = YES;
    wuImgView.hidden = YES;
    zhiImgView.hidden = NO;
    moneyImgView.hidden = YES;
    
    
}

#pragma mark == 物
-(void)wuBtn
{
    NSLog(@"点击了物按钮");
    backImgView.hidden = YES;
    peopleImgView.hidden = YES;
    thingImgView.hidden = YES;
    wuImgView.hidden = NO;
    zhiImgView.hidden = YES;
    moneyImgView.hidden = YES;
    
    
}

#pragma mark == 值
-(void)zhiBtn
{
    NSLog(@"点击了值按钮");
    backImgView.hidden = YES;
    peopleImgView.hidden = YES;
    thingImgView.hidden = NO;
    wuImgView.hidden = YES;
    zhiImgView.hidden = YES;
    moneyImgView.hidden = YES;
    
    
}

- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(75, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

@end
