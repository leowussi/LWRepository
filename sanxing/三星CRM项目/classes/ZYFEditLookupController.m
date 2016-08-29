//
//  ZYFEditLookupController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/12.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFEditLookupController.h"

@interface ZYFEditLookupController ()

@end

@implementation ZYFEditLookupController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lookupData.count;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/




@end
