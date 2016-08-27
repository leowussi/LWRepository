//
//  MyEngineRoomDetailView.m
//  telecom
//
//  Created by ZhongYun on 14-8-22.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyEngineRoomDetailView.h"
#import "UIImageView+WebCache.h"

@interface MyEngineRoomDetailView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* m_data;
    UITableView* m_table;
    UIImageView* m_roomImg;
    
    NSInteger m_typeId;
}
@end

@implementation MyEngineRoomDetailView

- (void)dealloc
{
    [m_roomImg release];
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (void)buildView
{
    if (m_data != nil) return;
    m_typeId = [self.typeInfo[@"typeId"] intValue];
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = 34;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    m_table.hidden = (m_typeId == TI_ROOM_FRAME);
    [self addSubview:m_table];
    
    m_roomImg = [[UIImageView alloc] initWithFrame:RECT(10, 10, self.fw-20, self.fh-20)];
    m_roomImg.clipsToBounds = YES;
    m_roomImg.hidden = (m_typeId != TI_ROOM_FRAME);
    m_roomImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:m_roomImg];
    
    [self loadData];
}

- (void)loadData
{
    if (m_typeId == TI_ROOM_FRAME)  {
        NSString* imgURL = format(@"http://%@/%@/%@?accessToken=%@&roomID=%@", ADDR_IP, ADDR_DIR, NW_GetRoomPatternData, UGET(U_TOKEN), self.roomId);
        [m_roomImg sd_setImageWithURL:[NSURL URLWithString:imgURL]
                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        NSString* url = NW_GetRegionDetailData;
        if (m_typeId == TI_ROOM_INFO) url = NW_GetRoomDetailData;
        httpGET1(@{URL_TYPE:url, @"roomID":self.roomId}, ^(id result) {
            [m_data addObjectsFromArray:result[@"list"]];
            [m_table reloadData];
        });
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"title"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        
        CGFloat title_w = 90, content_x = 15+title_w+2;
        newLabel(cell, @[@50, RECT_OBJ(15, 10, title_w, Font3), [UIColor blackColor], FontB(Font3), @""]);
        newLabel(cell, @[@51, RECT_OBJ(content_x, 10, APP_W-10-content_x, Font3), [UIColor darkGrayColor], Font(Font3), @""]);
    }
    tagViewEx(cell, 50, UILabel).text = NoNullStr(dataRow[@"title"]);
    tagViewEx(cell, 51, UILabel).text = NoNullStr(dataRow[@"content"]);

    return cell;
}

@end
