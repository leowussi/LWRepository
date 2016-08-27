//
//  LinkingSetsInfoView.m
//  telecom
//
//  Created by liuyong on 15/11/2.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "LinkingSetsInfoView.h"
#import "BottomListModel.h"
#import "UpperListModel.h"

@interface LinkingSetsInfoView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_setsInfoTableView;
    NSMutableArray *_setsInfoArray;
}
@end

@implementation LinkingSetsInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _setsInfoArray = [NSMutableArray array];
    }
    return self;
}

- (void)setUpSetsInfoTableViewWith:(NSArray *)infoArray
{
    [_setsInfoArray removeAllObjects];
    _setsInfoArray = (NSMutableArray *)infoArray;
    
    _setsInfoTableView = [[UITableView alloc] initWithFrame:RECT(0, 0, self.fw, self.fh) style:UITableViewStyleGrouped];
    _setsInfoTableView.delegate = self;
    _setsInfoTableView.dataSource = self;
    [self addSubview:_setsInfoTableView];
    
    [_setsInfoTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _setsInfoArray.count;
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.willShowView isEqualToString:@"UPPER"]) {
        return @"上联设备信息";
    }else if([self.willShowView isEqualToString:@"BOTTOM"]){
        return @"下联设备信息";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.willShowView isEqualToString:@"UPPER"]) {
        static NSString *reuseId = @"reuse";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        UpperListModel *model = _setsInfoArray[indexPath.row];
        cell.textLabel.text = model.upEquipCode;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        return cell;
    }else if([self.willShowView isEqualToString:@"BOTTOM"]){
        static NSString *reuseId = @"reuse";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        BottomListModel *model = _setsInfoArray[indexPath.row];
        cell.textLabel.text = model.btmEquipCode;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.willShowView isEqualToString:@"UPPER"]) {
        UpperListModel *model = _setsInfoArray[indexPath.row];
        if (self.delegate) {
            [self.delegate upperSetInfoWithEquipCode:model.upEquipCode EquipKind:model.upEquipKind];
        }
    }else if([self.willShowView isEqualToString:@"BOTTOM"]){
        BottomListModel *model = _setsInfoArray[indexPath.row];
        if (self.delegate) {
            [self.delegate bottomSetInfoWithEquipCode:model.btmEquipCode EquipKind:model.btmEquipKind];
        }
    }
}

@end
