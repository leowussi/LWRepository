//
//  LeftViewController.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftTableViewCell.h"
@interface LeftViewController ()
{
    NSMutableArray *titleArray;
    NSMutableArray *contentArray;
    NSMutableArray *dataArray;
    NSMutableDictionary *dataDic;
}
@end

@implementation LeftViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self hiddenBottomBar:YES];
    [self myInfoGetData];
}


#pragma mark == 全部标为已读
-(void)rightAction
{
    
    
    for (int i = 0; i < dataArray.count; i++) {
        
        if ([[[dataArray objectAtIndex:i] objectForKey:@"flag"] intValue] == 0){
            NSString *strValue = [[dataArray objectAtIndex:i] objectForKey:@"messageId"];
            NSString *strKey = [NSString stringWithFormat:@"%d",i];
            [dataDic setObject:strValue forKey:strKey];
        }else{
            
        }
    }
    NSLog(@"%@",[dataDic allValues]);
    
    NSString *typeStr = [[dataDic allValues] componentsJoinedByString:@","];
    
    if ([[dataDic allValues] count] == 0) {
        
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyMessage/ChangeMessageStatus";
        paraDict[@"messageId"] = typeStr;
        paraDict[@"type"] = [NSString stringWithFormat:@"1"];
        httpGET2(paraDict, ^(id result) {
            NSLog(@"%@",result);
            
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                NSLog(@"%@",result);
                [UIApplication sharedApplication] .applicationIconBadgeNumber = 0;
                [self myInfoGetData];
            }
        }, ^(id result) {
            
        });

    }
    

}

-(void)myInfoGetData
{
    httpGET2(@{URL_TYPE : @"MyMessage/GetAllMessage"}, ^(id result) {
        NSLog(@"%@",result);
        dataArray = (NSMutableArray *)[result objectForKey:@"list"];
        
         NSLog(@"dataArray == %@",dataArray);
        
        [self.tableView reloadData];
        
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            
            NSLog(@"%@",result);
            
            
        }
        
    }, ^(id result) {
        
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    [self addNavigationLeftButton];
    [self addLeftNavTitle:@"我的消息"];
    [self addNavigationRightButtonForStr:@"全部标为已读"];
    dataDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [self initView];
}
-(void)initView
{
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 80, kScreenWidth-40, kScreenHeight-110) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    _baseScrollView.scrollEnabled = NO;
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    CGSize titleWith = [self labelHight:[NSString stringWithFormat:@"%@   %@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"theme"],[[dataArray objectAtIndex:indexPath.row] objectForKey:@"createdDate"]]];
    
    cell.titleLable.numberOfLines = 0;
    [cell.titleLable setFrame:CGRectMake(20,10,kScreenWidth-60,titleWith.height+10)];
    
    cell.titleLable.text = [NSString stringWithFormat:@"%@   %@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"theme"],[[dataArray objectAtIndex:indexPath.row] objectForKey:@"createdDate"]];
    
    //    cell.dataLable.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"createdDate"];
    
    cell.contentLable.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"messageContent"];
    
    
    
    if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"flag"] intValue] == 0) {
        cell.infoImgView.hidden = NO;
    }else{
        cell.infoImgView.hidden = YES;
    }
    
    cell.contentLable.numberOfLines = 0;
    CGSize sizeWith = [self labelHight:[contentArray objectAtIndex:indexPath.row]];
    
    CGSize labelsize = [cell.contentLable.text sizeWithFont:[UIFont systemFontOfSize:12.0]	constrainedToSize:CGSizeMake(sizeWith.width+20, [cell.contentLable.text length])lineBreakMode:NSLineBreakByWordWrapping];
    
    [cell.contentLable setFrame:CGRectMake(cell.contentLable.frame.origin.x,cell.titleLable.frame.size.height+5,kScreenWidth-80,labelsize.height+10)];
    return cell;
    
}

- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeWith = [self labelHight:[contentArray objectAtIndex:indexPath.row]];
    NSString *str = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"messageContent"];
    CGSize labelsize = [str sizeWithFont:[UIFont systemFontOfSize:12.0]	constrainedToSize:CGSizeMake(sizeWith.width+20, [str length])lineBreakMode:NSLineBreakByWordWrapping];
    return 70+labelsize.height;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"flag"] intValue] == 0) {
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyMessage/ChangeMessageStatus";
        paraDict[@"messageId"] = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"messageId"]];
        paraDict[@"type"] = [NSString stringWithFormat:@"1"];
        httpGET2(paraDict, ^(id result) {
            NSLog(@"%@",result);
            
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                NSLog(@"%@",result);
                 [UIApplication sharedApplication] .applicationIconBadgeNumber--;
                LeftTableViewCell *cell=(LeftTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                cell.infoImgView.image = [UIImage imageNamed:@""];
                [self myInfoGetData];
            }
        }, ^(id result) {
            
        });
    }else{
        
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
