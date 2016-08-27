//
//  FilterCompSelect.m
//  telecom
//
//  Created by ZhongYun on 14-6-13.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "FilterCompSelect.h"

@interface FilterCompSelect ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    UIButton* m_checkBtn;
    NSMutableArray* m_multiSelected;
}
@end

@implementation FilterCompSelect

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择";
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    m_checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                      (NAV_H-checkIcon.size.height)/2,
                                                      checkIcon.size.width, checkIcon.size.height)];
    [m_checkBtn setBackgroundImage:checkIcon forState:0];
    [m_checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    m_checkBtn.hidden = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:m_checkBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    self.view.backgroundColor = [UIColor whiteColor];
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, 10, APP_W, APP_H)
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = 40;
    m_table.delegate = self;
    m_table.dataSource = self;
    [self.view addSubview:m_table];
    
//    NSLog(@"%@",self.data);
}

- (void)onCheckBtnTouched:(UIButton*)sender
{
    if (self.respMultiBlock) {
        self.respMultiBlock(m_multiSelected);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setMultiSelected:(NSMutableArray *)multiSelected
{
    _multiSelected = [multiSelected retain];
    m_multiSelected = [multiSelected mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (m_data.count == 0) {
        [m_data addObjectsFromArray:self.data];
    }
    if (self.multiModule && self.multiSelected.count>0) {
        m_checkBtn.hidden = NO;
    }
}

- (void)onCancelBtnTouched:(id)sender
{
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
    
    if (self.multiModule) {
        if ([m_multiSelected containsObject:@(indexPath.row)]) {
            [m_multiSelected removeObject:@(indexPath.row)];
        } else {
            [m_multiSelected addObject:@(indexPath.row)];
        }
        m_checkBtn.hidden = (m_multiSelected.count == 0);
        
        UITableViewCell* cell = [m_table cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        
        if (self.respBlock) {
            self.respBlock(indexPath.row);
//            self.respBlock([[[self.data objectAtIndex:indexPath.row] objectForKey:@"conditionId"] intValue]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[self.idKey]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (self.multiModule) {
            if ([m_multiSelected containsObject:@(indexPath.row)]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        } else {
            if (self.selected == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        cell.textLabel.font = FontB(Font3);
    }
    
    cell.textLabel.text = dataRow[self.nameKey];
    
    return cell;
}

@end
