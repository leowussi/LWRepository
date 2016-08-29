//
//  MJFriendCell.m
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJFriendCell.h"
#import "ZYFForm.h"
#import "CRMHelper.h"
#import "UIImageView+WebCache.h"
#import "ZYFURLTableSearch.h"

static const NSInteger kLineHeight = 1;

@implementation MJFriendCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"friend";
    MJFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MJFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //在每个cell的最下面加一根黑色(grayColor)的线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height + kLineHeight,kSystemScreenWidth , kLineHeight)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineView];
    }
    return cell;
}

- (void)setForm:(ZYFForm *)form
{
    _form = form;
    self.textLabel.text = form.relateEntity.scheamname;
    NSString *iconUrlString = [NSString stringWithFormat:@"%@%@",kIcon,form.relateEntity.icon];
    NSURL *url = [NSURL URLWithString:iconUrlString];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRetryFailed];
}

@end
