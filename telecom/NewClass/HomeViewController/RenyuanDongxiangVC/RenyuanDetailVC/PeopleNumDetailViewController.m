//
//  PeopleNumDetailViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/8/17.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "PeopleNumDetailViewController.h"
#import "PeopleNumDetailTableViewCell.h"

@interface PeopleNumDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
}


@end

@implementation PeopleNumDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人员任务详细";
    // Do any additional setup after loading the view.
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    [self initView];
    NSLog(@"%@",self.dataArr);
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
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"myCell";
    PeopleNumDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[PeopleNumDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = RGBCOLOR(250, 250, 250);
    }
    
    
    CGSize titleSize = [self cellTitleHight:[NSString stringWithFormat:@"%@ :",self.strTitle]];
    cell.titleLable.text = [NSString stringWithFormat:@"%@:",self.strTitle];
    
    CGSize size = [self cellLabelHight:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"taskContent"]];
    
    [cell.nameLable setFrame:CGRectMake(titleSize.width+10, 10, kScreenWidth-110, size.height+5)];
    cell.nameLable.numberOfLines = 0;
    cell.nameLable.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"taskContent"];
    
    
    CGSize contentSize = [self cellContentLableHight:[NSString stringWithFormat:@"%@ %@ %@",self.regionName,[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"siteName"],self.userName]];
    
    [cell.contentLable setFrame:CGRectMake(10, 20+size.height, kScreenWidth-120, contentSize.height+5)];
    
    [cell.dateLable setFrame:CGRectMake(kScreenWidth-100, 20+size.height, 100, 20)];
    
    cell.contentLable.numberOfLines = 0;
    cell.contentLable.text = [NSString stringWithFormat:@"%@ %@ %@",self.regionName,[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"siteName"],self.userName];
    
    cell.dateLable.text = [NSString stringWithFormat:@"%@",self.strDate];
//    [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"dealTime"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGSize)cellTitleHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize constraint = CGSizeMake(100, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (CGSize)cellLabelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(kScreenWidth-110, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (CGSize)cellContentLableHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(kScreenWidth-120, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    return size;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self cellLabelHight:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"taskContent"]];
    
    CGSize contentSize = [self cellContentLableHight:[NSString stringWithFormat:@"%@ %@ %@",self.regionName,[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"siteName"],self.userName]];
    
    return 30+size.height+contentSize.height;
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
