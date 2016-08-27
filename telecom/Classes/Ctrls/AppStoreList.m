//
//  AppStoreList.m
//  telecom
//
//  Created by ZhongYun on 14-7-23.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "AppStoreList.h"
#import "UIImageView+WebCache.h"
#import "AppStoreDetail.h"

#define ROW_H   80
@interface AppStoreList ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView* m_table;
    NSMutableArray* m_data;
}
@end

@implementation AppStoreList

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"i运维子应用管理";
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, APP_H-NAV_H) style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = ROW_H;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:m_table];
    
    [self updateSelfAppVersion];
    
    httpGET1(@{URL_TYPE:NW_getAppList, @"deviceType":@"1"}, ^(id result) {
        mainThread(updateData:, result[@"list"]);
    });
}

- (void)updateSelfAppVersion
{
    NSMutableDictionary* appState = UGET(U_VERION);
    if (!appState) appState = [NSMutableDictionary dictionary];
    appState[@"telecom"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    USET(U_VERION, appState);
}

- (void)updateData:(NSArray*)appList
{
    [m_data removeAllObjects];
    
    NSMutableDictionary* appState = UGET(U_VERION);
    
    for (NSDictionary* appInfo in appList) {
        NSMutableDictionary* item = [appInfo mutableCopy];
        item[V_STATE] = @VSTATE_NONE;
        
        NSString* appLocalVersion = appState[item[@"appLocation"]];
        NSURL* openURL = [NSURL URLWithString:format(@"%@://", item[@"appLocation"])];
        BOOL bExistApp = [[UIApplication sharedApplication] canOpenURL: openURL];
        if (bExistApp==NO || appLocalVersion==nil) {
            item[V_STATE] = @VSTATE_NONE;
        } else {
            NSComparisonResult compResult = compareVersion(appLocalVersion, item[@"currentVersion"]);
            if (compResult == NSOrderedAscending) {
                item[V_STATE] = @VSTATE_NEW;
            } else if (compResult == NSOrderedDescending) {
                item[V_STATE] = @VSTATE_SAME;
            } else {
                item[V_STATE] = @VSTATE_SAME;
            }
        }
        [m_data addObject:item];
        [item release];
    }
    [m_table reloadData];
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    
    AppStoreDetail* vc = [[AppStoreDetail alloc] init];
    vc.dataRow = m_data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"appLocation"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = FontB(Font1);

        
        NSString* imgURL = format(@"http://%@/%@/%@", ADDR_IP, ADDR_DIR, dataRow[@"imgUrl"]);
        UIImageView* webImage = [[UIImageView alloc] initWithFrame:RECT(15, 10, 60, 60)];
        webImage.backgroundColor = [UIColor clearColor];
        [webImage sd_setImageWithURL:[NSURL URLWithString:imgURL]
                                         placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        webImage.clipsToBounds = YES;
        webImage.tag = 50;
        [cell addSubview:webImage];
        [webImage release];
        
        CGFloat pos_x = tagView(cell, 50).ex+10;
        newLabel(cell, @[@51, RECT_OBJ(pos_x, 14, APP_W-pos_x-10, Font2), [UIColor blackColor], FontB(Font2), NoNullStr(dataRow[@"appName"])]);
        
        CGFloat pos_y = tagView(cell, 51).ey+8;
        newLabel(cell, @[@52, RECT_OBJ(pos_x, pos_y, APP_W-pos_x-10, Font4), [UIColor darkGrayColor], Font(Font4), format(@"版本号：v%@", NoNullStr(dataRow[@"currentVersion"]))]);
        
        pos_y = tagView(cell, 52).ey+8;
        newLabel(cell, @[@53, RECT_OBJ(pos_x, pos_y, APP_W-pos_x-10, Font4), [UIColor darkGrayColor], Font(Font4), format(@"发布时间：%@", NoNullStr(dataRow[@"releaseDate"]))]);
        
        CGFloat btn_w = 70, btn_h = 30;
        UIButton* btn = [[UIButton alloc] initWithFrame:RECT(APP_W-btn_w-15, (m_table.rowHeight-btn_h)/2, btn_w, btn_h)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = RGB(0x007aff).CGColor;
        btn.layer.cornerRadius = 3;
        btn.titleLabel.font = Font(Font4);
        
        NSString* btnTitle = @"下载";
        if ([dataRow[V_STATE] intValue] == VSTATE_NONE) btnTitle = @"安装";
        if ([dataRow[V_STATE] intValue] == VSTATE_NEW) btnTitle = @"更新";
        if ([dataRow[V_STATE] intValue] == VSTATE_SAME) btnTitle = @"已最新";
        
        [btn setTitle:btnTitle forState:0];
        [btn setTitleColor:RGB(0x007aff) forState:0];
        [btn addTarget:self action:@selector(onUpdateBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
        
        if ([dataRow[V_STATE] intValue] == VSTATE_SAME) {
            //btn.enabled = NO; //即使是最新版本，也要支持安装更新.
            [btn setTitleColor:[UIColor lightGrayColor] forState:0];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
    return cell;
}

- (void)onUpdateBtnTouched:(id)sender
{
    NSInteger rowNo = parentCellIndexPath(sender).row;
    NSDictionary* dataRow = m_data[rowNo];
    NSInteger appState = [dataRow[V_STATE] intValue];
    
    NSMutableDictionary* appVersion = UGET(U_VERION);
    if (appVersion == nil)
        appVersion = [NSMutableDictionary dictionary];
    
    if (appState==VSTATE_NONE || appState==VSTATE_NEW || appState==VSTATE_SAME) {
        NSURL* appUrl = [NSURL URLWithString:format(VERS_FMT, dataRow[@"downloadLocation"])];
        [[UIApplication sharedApplication] openURL:appUrl];
        NSLog(@"install APP:%@", appUrl);
        appVersion[dataRow[@"appLocation"]] = dataRow[@"currentVersion"];
    }
    
    USET(U_VERION, appVersion);
}

@end

NSComparisonResult compareVersion(NSString* app_v, NSString* net_v)
{
    NSArray* appV_info = [app_v componentsSeparatedByString:@"."];
    NSArray* netV_info = [net_v componentsSeparatedByString:@"."];
    
    for (int i = 0; i < netV_info.count; i++) {
        if ([netV_info[i] intValue] > [appV_info[i] intValue]) {
            return NSOrderedAscending;
        } else if ([netV_info[i] intValue] < [appV_info[i] intValue]) {
            return NSOrderedDescending;
        }
    }
    return NSOrderedSame;
}