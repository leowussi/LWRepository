//
//  YZConditionSiftView.m
//  AlertView
//
//  Created by 锋 on 16/5/10.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZConditionSiftView.h"

@interface YZConditionSiftView ()

@end

@implementation YZConditionSiftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView_accessory = [[UIImageView alloc] init];
        _imageView_accessory.image = [UIImage imageNamed:@"select_none"];
        _imageView_accessory.bounds = CGRectMake(0, 0, 20, 20);
        [self.contentView addSubview:_imageView_accessory];
        
        _label_desc = [[UILabel alloc] init];
        _label_desc.font = [UIFont boldSystemFontOfSize:15];
        _label_desc.textColor = [UIColor grayColor];
        _label_desc.numberOfLines = 0;
        [self.contentView addSubview:_label_desc];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        _imageView_accessory.image = [UIImage imageNamed:@"select"];
    }else{
        _imageView_accessory.image = [UIImage imageNamed:@"select_none"];
    }
}

@end

@implementation YZConditionSiftView

- (instancetype)initWithFrame:(CGRect)frame tableViewFrame:(CGRect)tFrame dataArray:(NSArray *)dataArray title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowRadius = 8;
        self.layer.shadowOpacity = .3;
        _title_desc = [[NSMutableString alloc] initWithCapacity:0];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tFrame.size.width, tFrame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 8;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return self;
}


- (void)setDataArray:(NSMutableArray *)dataArray
{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:dataArray];
    if (!_isSingleSelect) {
        [_dataArray addObject:@"全选"];
    }else{
        CGRect rect = _tableView.frame;
        rect.size.height = rect.size.height - 28;
        _tableView.frame = rect;
        
    }
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZConditionSiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZConditionSiftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.label_desc.text = _dataArray[indexPath.row];
    cell.label_desc.frame = CGRectMake(28, 4, _tableView.frame.size.width - 32, 20);
    cell.imageView_accessory.center = CGPointMake(14, cell.label_desc.center.y);
    if ([_selectedIndexArray containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZConditionSiftTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([_selectedIndexArray containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
        cell.isSelected = NO;
        [_selectedIndexArray removeObject:[NSString stringWithFormat:@"%d",indexPath.row]];
    }else{
        cell.isSelected = YES;
        [_selectedIndexArray addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    
    if (_isSingleSelect) {
        if (cell.isSelected && _selectedIndexArray.count > 1) {
            NSInteger previousCellTag = [[_selectedIndexArray firstObject] integerValue];
            YZConditionSiftTableViewCell *previousCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:previousCellTag inSection:0]];
            previousCell.isSelected = NO;
            [_selectedIndexArray removeObjectAtIndex:0];
        }
        
        return;
    }
    if (indexPath.row == _dataArray.count -1) {
        if ([_selectedIndexArray containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
            [_selectedIndexArray removeAllObjects];
            for (int i = 0; i < _dataArray.count; i++) {
                [_selectedIndexArray addObject:[NSString stringWithFormat:@"%d",i]];
                
            }
            [_tableView reloadData];
            return;
        }else{
            [_selectedIndexArray removeAllObjects];
            [_tableView reloadData];
        }
        return;
    }
    
    
    YZConditionSiftTableViewCell *allSelectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]];
    if (cell.isSelected) {
        if (_selectedIndexArray.count == _dataArray.count - 1) {
            
            allSelectedCell.isSelected = YES;
            [_selectedIndexArray addObject:[NSString stringWithFormat:@"%d",_dataArray.count - 1]];
        }
    }else{
        if (_selectedIndexArray.count == _dataArray.count - 1) {
            
            allSelectedCell.isSelected = NO;
            [_selectedIndexArray removeObject:[NSString stringWithFormat:@"%d",_dataArray.count - 1]];
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        UILabel *label_header = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, _tableView.frame.size.width - 10, 20)];
        label_header.font = [UIFont boldSystemFontOfSize:16];
        label_header.tag = 300;
        label_header.text = [NSString stringWithFormat:@"请选择\"%@\"",_title_desc];
        label_header.textColor = [UIColor grayColor];
        label_header.textAlignment = NSTextAlignmentCenter;
        [headerView.contentView addSubview:label_header];
    }
    UILabel *label = (UILabel *)[self viewWithTag:300];
    label.text = [NSString stringWithFormat:@"请选择\"%@\"",_title_desc];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footer"];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(16, 0, 50, 36);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [headerView.contentView addSubview:cancelButton];
        
        UIButton *tureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        tureButton.frame = CGRectMake(100, 0, 50, 36);
        [tureButton setTitle:@"确定" forState:UIControlStateNormal];
        [tureButton addTarget:self action:@selector(tureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        tureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [headerView.contentView addSubview:tureButton];
        
    }
    return headerView;
}
//取消,确定按钮
- (void)cancelButtonClicked
{
    [self removeFromSuperview];
}

- (void)tureButtonClicked
{
    if (!_isSingleSelect) {
        if (_selectedIndexArray.count == _dataArray.count) {
            _completionBlock(@"全部");
            [self cancelButtonClicked];
            return;
        }
        //        [_dataArray removeLastObject];
    }
    
    NSMutableString *mutString = [NSMutableString string];
    for (NSString *indexStr in _selectedIndexArray) {
        NSString *obj = [_dataArray objectAtIndex:[indexStr integerValue]];
        if ([mutString isEqualToString:@""]) {
            [mutString appendFormat:@"%@",obj];
        }else{
            [mutString appendFormat:@"\n%@",obj];
        }
        
    }
    if ([mutString isEqualToString:@""]) {
        
        if (_isSingleSelect) {
            [mutString appendString:@"我的资源变更工单"];
        }else{
            [mutString appendString:@"全部"];
        }
    }
    _completionBlock(mutString);
    
    [self cancelButtonClicked];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  28;
}

- (CGFloat)calculateTextHeight:(NSString *)text width:(CGFloat)width
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil];
    return ceilf(rect.size.height);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
