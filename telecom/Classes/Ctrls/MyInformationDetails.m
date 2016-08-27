//
//  MyInformationDetails.m
//  telecom
//
//  Created by 郝威斌 on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyInformationDetails.h"

@interface MyInformationDetails ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
}
@end
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH          [UIScreen mainScreen].applicationFrame.size.width
//#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
@implementation MyInformationDetails

- (void)dealloc
{
    [myTableView release];
    [_dataArray release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息详情";
    // Do any additional setup after loading the view.
    [self initView];
}

-(void)initView
{
    myTableView = [[UITableView alloc] initWithFrame:RECT(0, 64, APP_W, (SCREEN_H-64))
                                           style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.bounces = YES;
    myTableView.rowHeight = Font2+20;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:myTableView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    NSDictionary* dataRow = self.dataArray[indexPath.row];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = FontB(Font2);
        newLabel(cell, @[@50, RECT_OBJ(15, 10, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
        
        newLabel(cell, @[@150, RECT_OBJ(15, 17+Font2, APP_W-40, Font2), [UIColor blackColor], Font(Font3), @""]);
    }
    
    
    
    NSString *text = dataRow[@"content"];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{
                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]
                                                                                                     }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    [attributedText release];
    
    
    [tagViewEx(cell, 150, UILabel) setFrame:CGRectMake(15, 15+Font2, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 40.0f))];
    
    tagViewEx(cell, 50, UILabel).text = dataRow[@"title"];
    tagViewEx(cell, 150, UILabel).text = text;
    
//    tagViewEx(cell, 150, UILabel).text = dataRow[@"content"];
//
//    cell.nameLable.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"UserName"];
    
//    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return myTableView.rowHeight+20;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* dataRow = self.dataArray[indexPath.row];
    NSString *text = dataRow[@"content"];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:FONT_SIZE] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    [attributedText release];
    
    CGFloat height = MAX(size.height+16, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
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
