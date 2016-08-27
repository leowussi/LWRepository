//
//  ScreenTableViewController.m
//  telecom
//
//  Created by ZhongYun on 14-6-13.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "ScreenTableViewController.h"
#import "SIAlertView.h"

@interface ScreenTableViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    NSMutableDictionary* m_dic;
    
}

@end

@implementation ScreenTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"筛选";
    
    UIImage* clearIcon = [UIImage imageNamed:@"nav_clear.png"];
    UIButton* clearBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-clearIcon.size.width), (NAV_H-clearIcon.size.height)/2,
                                                              clearIcon.size.width, clearIcon.size.height)];
    [clearBtn setBackgroundImage:clearIcon forState:0];
    [clearBtn addTarget:self action:@selector(onClearBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem1 = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:clearBtn.frame];
    checkBtn.fx = clearBtn.fx - 10 - checkIcon.size.width;
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItems = @[barBtnItem1,barBtnItem2];

    

    
    m_table = [[UITableView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, (SCREEN_H-self.navBarView.ey))
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = 40;
    m_table.delegate = self;
    m_table.dataSource = self;
    
    m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    

    [self.view addSubview:m_table];
    

}


- (void)onClearBtnTouched:(id)sender
{    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"2" forKey:@"noteType"];
    [user setObject:@"0" forKey:@"specType"];
    //回调block
    self.screen(@"2",@"0");
    
    //清空存储的筛选条件。
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i< 2; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        NSDictionary *dic =@{str:@" "};
        [arr addObject:dic];
    }
    NSArray *array = [NSArray arrayWithArray:arr];
    [user setObject:array forKey:@"GongGaoScreen"];
    [user synchronize];
    
    DLog(@"%@",[user objectForKey:@"GongGaoScreen"]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCheckBtnTouched:(id)sender
{
    NSString *noteType = [[NSString alloc]init];
    NSString *specType  = [[NSString alloc]init];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < 2 ; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        NSString *str =  ((UILabel*)[[m_table cellForRowAtIndexPath:index] viewWithTag:51]).text;

        if (i ==0) {
            if (str==nil||[str  isEqual:@" "]) {
                noteType= @"2";
            }else if([str isEqualToString:@"普通公告"]){
                noteType = @"0";
            }else{
                noteType=@"1";
                }
        }
        if (i==1) {
            if (str==nil||[str  isEqual:@" "]) {
                specType= @"0";
            }else if([str isEqualToString:@"交换"]){
               specType = @"1";
            }else if([str isEqualToString:@"传输"]){
                specType=@"2";
            }else{
                specType=@"3";
            }
        }
        if (str == nil) {
            str=@"";
        }
        NSString *strkey= [NSString stringWithFormat:@"%d",i];
        [dic setObject:str forKey:strkey];
        [arr addObject:dic];
    }
    NSArray *array = [NSArray arrayWithArray:arr];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:array forKey:@"GongGaoScreen"];
    [user setObject:noteType forKey:@"noteType"];
    [user setObject:specType forKey:@"specType"];
    [user synchronize];
    
    self.screen(noteType,specType);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"公告类别" andMessage:nil];
        [alertView addButtonWithTitle:@"普通公告"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
        ((UILabel*)[[m_table cellForRowAtIndexPath:indexPath] viewWithTag:51]).text = @"普通公告";
                              }];
        [alertView addButtonWithTitle:@"割接公告"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
        ((UILabel*)[[m_table cellForRowAtIndexPath:indexPath] viewWithTag:51]).text = @"割接公告";
                              }];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Button3 Clicked");
                              }];
        [alertView show];
    }
    if (indexPath.row==1) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"专业类别" andMessage:nil];
        [alertView addButtonWithTitle:@"交换"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  ((UILabel*)[[m_table cellForRowAtIndexPath:indexPath] viewWithTag:51]).text = @"交换";
                              }];
        [alertView addButtonWithTitle:@"传输"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  ((UILabel*)[[m_table cellForRowAtIndexPath:indexPath] viewWithTag:51]).text = @"传输";
                              }];
        [alertView addButtonWithTitle:@"数据"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  ((UILabel*)[[m_table cellForRowAtIndexPath:indexPath] viewWithTag:51]).text = @"数据";
                              }];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Button3 Clicked");
                              }];
        [alertView show];
    }
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* str = @"ScreenTableViewController";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [user objectForKey:@"GongGaoScreen"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = FontB(Font3);
        if (arr==nil||arr.count==0) {
            newLabel(cell, @[@51, RECT_OBJ(210, (m_table.rowHeight-Font4)/2, 80, Font4), [UIColor blackColor], Font(Font4), @""]).textAlignment = NSTextAlignmentRight;
        }else{
            NSString *strkey = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            NSString *str = [arr[indexPath.row]objectForKey:strkey];
            newLabel(cell, @[@51, RECT_OBJ(210, (m_table.rowHeight-Font4)/2, 80, Font4), [UIColor blackColor], Font(Font4),str]).textAlignment = NSTextAlignmentRight;
            
        }
    }
    if (indexPath.row == 0) {
        cell.textLabel.text=@"公告类别";
    }else{
        cell.textLabel.text=@"专业类别";
    }
    
    return cell;
}


@end
