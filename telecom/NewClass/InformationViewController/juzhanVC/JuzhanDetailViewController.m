//
//  JuzhanDetailViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "JuzhanDetailViewController.h"
#import "JuzhanDetailTableViewCell.h"

@interface JuzhanDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *dataArr;
    UIView *backV;
}
@end

@implementation JuzhanDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    self.title = @"局站详细信息";
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
//    NSArray *arr = @[@"所属区局 :",@"局站名称 :",@"局站地址 :",@"产权性质 :",@"层数 :",@"启用时间 :",@"局站外观 :",@"主要用途 :",@"经纬度 :",@"是否在用 :"];
    
//    NSArray *rightArr = @[@"浦东电信局",@"东昌",@"浦东南路/弄700号",@"自有",@"7",@"1987/01/04",@"",@"枢纽",@"",@"在用"];
    dataArr = [self.dic objectForKey:@"viewRegionResult"];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight-64) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    [_baseScrollView addSubview:myTableView];
    _baseScrollView.scrollEnabled = NO;
    
    [self setExtraCellLineHidden:myTableView];
//    backV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight-64)];
//    backV.backgroundColor = [UIColor whiteColor];
//    [_baseScrollView addSubview:backV];
//    
//    for (int i = 0; i < dataArr.count; i++) {
//        
//        
//        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 20+30*i, kScreenWidth-40, 20)];
//        lineV.backgroundColor = RGBCOLOR(250, 250, 250);
//        lineV.hidden = YES;
//        [backV addSubview:lineV];
//        
//        UILabel *leftLable = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor colorWithRed:11.0/255.0 green:161.0/255.0 blue:229.0/255.0 alpha:1.0] rect:CGRectMake(10, 20+30*i, 80, 20)];
//        leftLable.text = [NSString stringWithFormat:@"%@ :",[[dataArr objectAtIndex:i] objectForKey:@"name"]];
//        leftLable.tag = 10+i;
//        [backV addSubview:leftLable];
//        
//        UILabel *rightLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 20+30*i, 200, 20)];
//        rightLable.numberOfLines = 0;
//        rightLable.text = [[[dataArr objectAtIndex:i] objectForKey:@"value"] description];
//        rightLable.tag = 100+i;
//        [backV addSubview:rightLable];
//        
//        
////        NSLog(@" == %f",with.height);
////        lineV.frame = CGRectMake(10, with.height+30*i, kScreenWidth-40, with.height+5);
////        leftLable.frame = CGRectMake(10, with.height+30*i, 80, 20);
////        rightLable.frame = CGRectMake(80, with.height+3+30*i, 200, with.height);
//    
//        [self updateLable];
//        if (i%2==0){
//            lineV.hidden = NO;
//        }else{
//            lineV.hidden = YES;
//        }
//    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"jzdetailCell";
    JuzhanDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[JuzhanDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.rightLable.numberOfLines = 0;
    
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
    
    cell.rightLable.frame = CGRectMake(80, 7, kScreenWidth-120, with.height);
    
    cell.leftLable.text = [NSString stringWithFormat:@"%@ :",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    cell.rightLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"value"] description];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = RGBCOLOR(250, 250, 250);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
    return 15+with.height;
}

- (CGSize)labelHight:(NSString*)str
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
