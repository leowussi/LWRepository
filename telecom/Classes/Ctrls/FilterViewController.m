//
//  FilterViewController.m
//  telecom
//
//  Created by ZhongYun on 14-6-13.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterCompSelect.h"

@interface FilterViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    NSMutableDictionary* m_dic;
   
}

@end

@implementation FilterViewController

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
//    [self.navBarView addSubview:clearBtn];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:clearBtn.frame];
    checkBtn.fx = clearBtn.fx - 10 - checkIcon.size.width;
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItems = @[barBtnItem1,barBtnItem2];
    [barBtnItem1 release];
    [barBtnItem2 release];
//    [self.navBarView addSubview:checkBtn];

    m_data = [[NSMutableArray alloc] init];
    m_dic = [[NSMutableDictionary alloc]initWithCapacity:10];
    
    m_table = [[UITableView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, (SCREEN_H-self.navBarView.ey))
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = 40;
    m_table.delegate = self;
    m_table.dataSource = self;
    [self.view addSubview:m_table];

    httpGET1(@{URL_TYPE:NW_GetFilterCondictions}, ^(id result) {
        [m_data addObjectsFromArray:result[@"list"]];
        [m_table reloadData];
    });
}


- (void)onClearBtnTouched:(id)sender
{
    for (NSMutableDictionary* item in m_data) {
        item[@"selected"] = @0;
    }
    [m_table reloadData];
}

- (void)onCheckBtnTouched:(id)sender
{
    NSMutableString *string = [[NSMutableString alloc]init];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<4; i++) {
        NSString *str = [NSString stringWithFormat:@"choose%d",i];
        NSString *srt= [[NSUserDefaults standardUserDefaults]objectForKey:str];
        if (srt==nil) {
            srt=@"0";
        }
        [array addObject:srt];
    }
    DLog(@"%@",array);
     NSUserDefaults *UserDefault = [NSUserDefaults standardUserDefaults];
     [UserDefault setObject:array forKey:@"chooseArray"];
    if (!(array==nil)) {
        for (int i = 0; i<array.count; i++) {
            if (i==3) {
                if ([array[i]intValue] ==1) {
                    [array removeLastObject];
                    [array addObject:@"-1"];
                }else if ([array[i]intValue] ==2){
                    [array removeLastObject];
                    [array addObject:@"204481"];
                }else{
                    [array removeLastObject];
                    [array addObject:@"0"];
                }
            }
       
            [string appendString:[NSString stringWithFormat:@"%@,",array[i]]];
           
            [UserDefault setObject:string forKey:@"chooseString"];
            [UserDefault synchronize];
            DLog(@"%@+++++++++++++++++++++",string);
        }
    }
    
    
    if (self.respBlock) {
        self.respBlock(string);
    }
  
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    
    FilterCompSelect* vc = [[FilterCompSelect alloc] init];
    NSArray *arrayA = [[NSUserDefaults standardUserDefaults]objectForKey:@"chooseArray"];
    vc.selected = [arrayA[indexPath.row]intValue];



    vc.data = m_data[indexPath.row][@"listCondition"];
    vc.idKey = @"conditionId";
    vc.nameKey = @"conditionName";
    vc.respBlock = ^(NSInteger selected){
        m_data[indexPath.row][@"selected"] = @(selected);
        NSArray* subList = m_data[indexPath.row][@"listCondition"];
        m_dic = [subList objectAtIndex:selected];
        NSLog(@"subList == %@",subList);
        NSUserDefaults *userChoose = [NSUserDefaults standardUserDefaults];
        
        NSString *str = [NSString stringWithFormat:@"choose%ld",(long)indexPath.row];
        [userChoose setObject:@(selected) forKey:str];
        [userChoose synchronize];
        DLog(@"%@",[userChoose objectForKey:str] );
        ((UILabel*)[[m_table cellForRowAtIndexPath:indexPath] viewWithTag:51]).text = subList[selected][@"conditionName"];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"conditionsId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = FontB(Font3);
        
        newLabel(cell, @[@51, RECT_OBJ(210, (m_table.rowHeight-Font4)/2, 80, Font4), [UIColor blackColor], Font(Font4), @""]).textAlignment = NSTextAlignmentRight;
    }
    
    cell.textLabel.text = dataRow[@"conditionsName"];
    
    NSInteger selected = [m_data[indexPath.row][@"selected"] intValue];
    NSArray* subList = m_data[indexPath.row][@"listCondition"];
    NSArray *ayy =  [[NSUserDefaults standardUserDefaults]objectForKey:@"chooseArray"];
    DLog(@"%@",ayy);
   selected = [ayy[indexPath.row] intValue];

    ((UILabel*)[cell viewWithTag:51]).text = subList[selected][@"conditionName"];
    return cell;
}


@end
