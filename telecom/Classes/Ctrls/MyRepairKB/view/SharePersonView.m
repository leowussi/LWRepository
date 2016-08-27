//
//  SharePersonView.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SharePersonView.h"
#import "SharePersonModel.h"

@interface SharePersonView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *sharePersonArray;

@end

@implementation SharePersonView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        
        
    }
    return self;
}

- (void)loadTableView
{
    self.sharePersonArray = [NSMutableArray array];
    self.sharePersonInfoTbView.dataSource = self;
    self.sharePersonInfoTbView.delegate = self;
}


- (void)loadSharePersonInfoWithURL:(NSString *)urlString
{
    httpGET2(@{URL_TYPE : urlString}, ^(id result) {
        if ([result[@"result" ] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                SharePersonModel *model = [[SharePersonModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.sharePersonArray addObject:model];
            }
        }
        [self.sharePersonInfoTbView reloadData];
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sharePersonArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *reuse = @"reuse";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        cell.textLabel.text = @"解除";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        UIImage *image = [UIImage imageNamed:@"person.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, image.size.width/1.4, image.size.height/1.4)];
        imageView.image = image;
        cell.accessoryView = imageView;
        return cell;
    }else{
        static NSString *reuse = @"reuse";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        SharePersonModel *model = self.sharePersonArray[indexPath.row];
        cell.textLabel.text = model.userName;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        UIImage *image = [UIImage imageNamed:@"person.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, image.size.width/1.4, image.size.height/1.4)];
        imageView.image = image;
        cell.accessoryView = imageView;
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharePersonModel *model = self.sharePersonArray[indexPath.row];
    if (indexPath.row == 0) {
        if (self.delegate) {
            [self.delegate cancelSharePerson];
        }
    }else{
        if (self.delegate) {
            [self.delegate deliverSharePersonName:model.userName];
            [self.delegate setSharePerson:model.userId];
        }
    }
    
}


@end
