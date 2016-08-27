//
//  NetworkDetailViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "NetworkDetailViewController.h"
#import "NetworkDetailTableViewCell.h"

@interface NetworkDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
    NSArray *infoArr;
    NSArray *dataArr;
}
@end

@implementation NetworkDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    self.title = @"网元详细信息";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    [self initView];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)initView
{
//    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight)];
//    View.backgroundColor = [UIColor whiteColor];
//    [_baseScrollView addSubview:View];
    
    infoArr = [self.dictionary objectForKey:@"viewNuResult"];
    dataArr = [self.dictionary objectForKey:@"viewNuPirvateResult"];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight-64) style:UITableViewStyleGrouped];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    [_baseScrollView addSubview:myTableView];
    _baseScrollView.scrollEnabled = NO;
    [self setExtraCellLineHidden:myTableView];
    
//    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(5, 30, 25, 1)];
//    lineV.backgroundColor = RGBCOLOR(240, 240, 240);
//    [_baseScrollView addSubview:lineV];
//    
//    UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(35, 25, 5, 15)];
//    lineV1.backgroundColor = RGBCOLOR(255, 194, 19);
//    [_baseScrollView addSubview:lineV1];
//    
//    UILabel *titleLable = [UnityLHClass initUILabel:@"公共信息" font:13.0 color:RGBCOLOR(160, 160, 160) rect:CGRectMake(45, 22, 80, 20)];
//    titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    [_baseScrollView addSubview:titleLable];
//
//    UIView *lineV2 = [[UIView alloc]initWithFrame:CGRectMake(110, 30, kScreenWidth-140, 1)];
//    lineV2.backgroundColor = RGBCOLOR(240, 240, 240);
//    [_baseScrollView addSubview:lineV2];
//    
//    for (int i = 0; i < infoArr.count; i++) {
//        
//        CGSize rightWith = [self labelHight1:[[[infoArr objectAtIndex:i] objectForKey:@"value"] description]];
//        
//        UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(10, 50+22*i, kScreenWidth-40, 20)];
//        backV.backgroundColor = RGBCOLOR(240, 240, 240);
//        backV.frame = CGRectMake(10, 51+(rightWith.height+15)*i, kScreenWidth-40, rightWith.height+2);
//        backV.hidden = YES;
//        [View addSubview:backV];
//        
//        
//        CGSize with = [self labelHight:[[[infoArr objectAtIndex:i]objectForKey:@"name"] description]];
//        
//        UILabel *leftLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(10, 50+22*i, with.width+10, 20)];
//        leftLable.frame = CGRectMake(10, 50+(rightWith.height+15)*i, with.width+10, 20);
//        
//        leftLable.text = [NSString stringWithFormat:@"%@ :",[[[infoArr objectAtIndex:i] objectForKey:@"name"] description]];
//        [View addSubview:leftLable];
//        
//        
//        
//        UILabel *rightLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(with.width+20, 53+22*i, 200, rightWith.height)];
//        rightLable.frame = CGRectMake(leftLable.frame.size.width+10, 60+22*i, 200, rightWith.height);
//        rightLable.numberOfLines = 0;
//        [View addSubview:rightLable];
//        
//        NSLog(@"rightWith.height == %f",rightWith.height);
//        
//        
//        
//        
//        
//        
//        rightLable.text = [[[[infoArr objectAtIndex:i] objectForKey:@"value"] description] description];
//
//        
//        if (i%2==0){
//            backV.hidden = NO;
//        }else{
//            backV.hidden = YES;
//        }
//
//    }
//    
//    
//    UIView *lineVi = [[UIView alloc]initWithFrame:CGRectMake(5, 380, 25, 1)];
//    lineVi.backgroundColor = RGBCOLOR(240, 240, 240);
//    [_baseScrollView addSubview:lineVi];
//    
//    UIView *lineVi1 = [[UIView alloc]initWithFrame:CGRectMake(35, 295+80, 5, 15)];
//    lineVi1.backgroundColor = RGBCOLOR(0, 231, 0);
//    [_baseScrollView addSubview:lineVi1];
//    
//    UILabel *titleLable1 = [UnityLHClass initUILabel:@"私有属性" font:13.0 color:RGBCOLOR(160, 160, 160) rect:CGRectMake(45, 292+80, 80, 20)];
//    titleLable1.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//    [_baseScrollView addSubview:titleLable1];
//    
//    UIView *lineVi2 = [[UIView alloc]initWithFrame:CGRectMake(110, 380, kScreenWidth-140, 1)];
//    lineVi2.backgroundColor = RGBCOLOR(240, 240, 240);
//    [_baseScrollView addSubview:lineVi2];
//    
//    
//    dataArr = [self.dictionary objectForKey:@"viewNuPirvateResult"];
//    
//    for (int i = 0; i < dataArr.count; i++) {
//        
//        UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(10, 400+22*i, kScreenWidth-40, 20)];
//        backV.backgroundColor = RGBCOLOR(240, 240, 240);
//        backV.hidden = YES;
//        [View addSubview:backV];
//     
//        CGSize with = [self labelHight:[[[dataArr objectAtIndex:i]objectForKey:@"name"] description]];
//        
//        UILabel *leftLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(10, 400+22*i, with.width+10, 20)];
//        leftLable.text = [NSString stringWithFormat:@"%@ :",[[[dataArr objectAtIndex:i]objectForKey:@"name"] description]];
//        [View addSubview:leftLable];
//        
//        CGSize rightWith = [self labelHight1:[[[dataArr objectAtIndex:i] objectForKey:@"value"] description]];
//        
//        UILabel *rightLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(with.width+30, 400+22*i, kScreenWidth-40-(with.width+40), rightWith.height)];
//        rightLable.numberOfLines = 0;
//        
//        if (dataArr.count == 0) {
//            rightLable.text = @"";
//        }else{
//            
//            backV.frame = CGRectMake(10, 380+rightWith.height+22*i, kScreenWidth-40, rightWith.height+5);
//            leftLable.frame = CGRectMake(10, 380+rightWith.height+22*i, with.width+10, 20);
//            rightLable.frame = CGRectMake(leftLable.frame.size.width+10, 380+rightWith.height+2+22*i, kScreenWidth-40-(with.width+40), rightWith.height);
//            rightLable.text = [[[dataArr objectAtIndex:i] objectForKey:@"value"] description];
//        }
//        
//        
//                
//        [View addSubview:rightLable];
//        
//        if (i%2==0){
//            backV.hidden = NO;
//        }else{
//            backV.hidden = YES;
//        }
//        
//    }
//    
//    float height = dataArr.count*20;
//    View.frame = CGRectMake(10, 0, kScreenWidth-20, kScreenHeight+height);
//    [_baseScrollView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight+height)];
//    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return infoArr.count;
    }else if (section == 1){
        return dataArr.count;
    }
    return 0;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 44)];
    headV.backgroundColor = [UIColor whiteColor];
    
//    UILabel *lable = [UnityLHClass initUILabel:@"公共信息" font:13.0 color:[UIColor blackColor] rect:CGRectMake(10, 5, 100, 20)];
//    [headV addSubview:lable];
    
    if (section == 0) {
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 15, 25, 1)];
        lineV.backgroundColor = RGBCOLOR(240, 240, 240);
        [headV addSubview:lineV];
        
        UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(30, 8, 5, 15)];
        lineV1.backgroundColor = RGBCOLOR(255, 194, 19);
        [headV addSubview:lineV1];
        
        UILabel *titleLable = [UnityLHClass initUILabel:@"公共信息" font:13.0 color:RGBCOLOR(160, 160, 160) rect:CGRectMake(45, 6, 80, 20)];
        titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [headV addSubview:titleLable];

    }else{
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 15, 25, 1)];
        lineV.backgroundColor = RGBCOLOR(240, 240, 240);
        [headV addSubview:lineV];
        
        UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(30, 8, 5, 15)];
        lineV1.backgroundColor = RGBCOLOR(255, 194, 19);
        [headV addSubview:lineV1];
        
        UILabel *titleLable = [UnityLHClass initUILabel:@"私有属性" font:13.0 color:RGBCOLOR(160, 160, 160) rect:CGRectMake(45, 6, 80, 20)];
        titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [headV addSubview:titleLable];
    }
    
    return headV;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"netDetailCell";
    NetworkDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[NetworkDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    if (indexPath.section == 0) {
       
        cell.rightLable.numberOfLines = 0;
        
        CGSize with = [self labelHight:[[[infoArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
        
        CGSize with1 = [self labelHight:[NSString stringWithFormat:@"%@ :",[[infoArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
        cell.leftLable.text = [NSString stringWithFormat:@"%@ :",[[infoArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        cell.rightLable.frame = CGRectMake(with1.width+20, 7, kScreenWidth-120, with.height);
        cell.rightLable.text = [[[infoArr objectAtIndex:indexPath.row] objectForKey:@"value"] description];
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = RGBCOLOR(250, 250, 250);
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }

    }else{
        
        cell.rightLable.numberOfLines = 0;
        
        CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
        
        CGSize with1 = [self labelHight:[NSString stringWithFormat:@"%@ :",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
       
        
        cell.leftLable.text = [NSString stringWithFormat:@"%@ :",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        cell.rightLable.frame = CGRectMake(with1.width+20, 7, kScreenWidth-120, with.height);
        
        cell.rightLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"value"] description];
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = RGBCOLOR(250, 250, 250);
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        CGSize with = [self labelHight:[[[infoArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
        return 15+with.height;
    }else if (indexPath.section == 1) {
        CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
        return 15+with.height;
    }
    return 0;
}

- (CGSize)labelHight1:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(kScreenWidth-120, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
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
