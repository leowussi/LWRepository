//
//  PeopleNumViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/8/17.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "PeopleNumViewController.h"
#import "PeopleNumDetailViewController.h"
#import "PeopleNumTableViewCell.h"

@interface PeopleNumViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
}
@end

@implementation PeopleNumViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@-人员任务数",self.strTitle];
    NSLog(@"%@",self.strTitle);
    // Do any additional setup after loading the view.
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];

    [self initView];
}

-(void)initView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 84, kScreenWidth-20, kScreenHeight-104)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight-104) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [bgView addSubview:myTableView];
    [self setExtraCellLineHidden:myTableView];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataDic.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"myCell";
    PeopleNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[PeopleNumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }

    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = RGBCOLOR(250, 250, 250);
    }
    
    
    CGSize leftLableSize = [self cellLeftLabelHight:[[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"userName"]];
    
    cell.leftLable.text = [[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"userName"];
    
    NSArray *infoArr = [[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"siteInfo"];
    NSMutableArray *siteNameArr = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i = 0; i < infoArr.count; i++) {
        NSString *siteName = [[infoArr objectAtIndex:i] objectForKey:@"siteName"];
        [siteNameArr addObject:siteName];
    }
    
    CGSize nameLableSize = [self cellLabelHight:[siteNameArr componentsJoinedByString:@","]:kScreenWidth-leftLableSize.width+25-110];
    
    cell.nameLable.frame = CGRectMake(leftLableSize.width+15,10, kScreenWidth-leftLableSize.width+25-110, nameLableSize.height+5);
    cell.nameLable.numberOfLines = 0;
    
    cell.nameLable.text = [siteNameArr componentsJoinedByString:@","];

    cell.numLable.text = [NSString stringWithFormat:@"%@ 项",[[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"taskNum"]];
    
    cell.numLable.textColor = [UIColor blackColor];
    
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:cell.numLable.text];
    NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@" "].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:119.0/255.0 blue:53.0/255.0 alpha:1.0] range:redRange];
    cell.numLable.attributedText = noteStr;
    
    return cell;
}

- (CGSize)cellLeftLabelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize constraint = CGSizeMake(kScreenWidth-160, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (CGSize)cellLabelHight:(NSString*)str :(float )strWith
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(strWith, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize leftLableSize = [self cellLeftLabelHight:[[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"userName"]];
    
    NSArray *infoArr = [[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"siteInfo"];
    NSMutableArray *siteNameArr = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i = 0; i < infoArr.count; i++) {
        NSString *siteName = [[infoArr objectAtIndex:i] objectForKey:@"siteName"];
        [siteNameArr addObject:siteName];
    }
    
    CGSize nameLableSize = [self cellLabelHight:[siteNameArr componentsJoinedByString:@","]:kScreenWidth-leftLableSize.width+25-110];
    
    return 25+nameLableSize.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSArray *infoArr = [[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"siteInfo"];
//    
//    NSMutableArray *siteNameArr = [[NSMutableArray alloc]initWithCapacity:10];
//    
//    for (int i = 0; i < infoArr.count; i++) {
//        NSString *siteName = [[infoArr objectAtIndex:i] objectForKey:@"siteId"];
//        [siteNameArr addObject:siteName];
//    }
//    
//    NSString *strUserId = [[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"userId"];
    
//    NSString *strSiteId = [siteNameArr componentsJoinedByString:@","];
    NSString *strTaskId = [[[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"taskId"] description];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myInfo/GetPeopleTaskDetail";
    paraDict[@"taskId"] = strTaskId;
    paraDict[@"typeId"] = self.typeId;
    
    
    NSLog(@"传参 %@",paraDict);
    
    httpGET2(paraDict, ^(id result) {
        
        NSLog(@"%@",result);
        
        if ([result[@"result"] isEqualToString:@"0000000"]){
            
            PeopleNumDetailViewController *peopVC = [[PeopleNumDetailViewController alloc]init];
            peopVC.dataArr = result[@"list"];
            peopVC.strTitle = self.strTitle;
            peopVC.strDate = self.dateStr;
            peopVC.regionName = self.regionName;
            peopVC.userName = [[self.dataDic objectAtIndex:indexPath.row] objectForKey:@"userName"];
            [self.navigationController pushViewController:peopVC animated:YES];

        }
        
    }, ^(id result) {
        
    });
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
