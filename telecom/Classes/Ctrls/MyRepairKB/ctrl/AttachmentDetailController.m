//
//  AttachmentDetailController.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AttachmentDetailController.h"
#import "AttaFileDetailModel.h"
#import "AttachDetailCell.h"

@interface AttachmentDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isEditing;
}
@property(nonatomic,strong)NSMutableArray *attachDetailArray;
@end

@implementation AttachmentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附件详情";
    self.view.backgroundColor = [UIColor whiteColor];
    _isEditing = NO;
    
    self.attachDetailArray = [NSMutableArray array];
//    [self setUpRightBarButton];
    [self loadAttachFileDetailWithURL:kGetFileList];
}

#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:self.rightBtn];
//    [self.rightBtn release];
}

- (void)editAction
{
    if (_isEditing == NO) {
        
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        _isEditing = YES;
    }else{
        
        
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _isEditing  = NO;
    }
}

- (void)loadAttachFileDetailWithURL:(NSString *)urlString
{
    httpGET2(@{URL_TYPE : urlString,
               @"commentId" : self.commentId}, ^(id result) {
                   if ([result[@"result"] isEqualToString:@"0000000"]) {
                       for (NSDictionary *dict in result[@"list"]) {
                           AttaFileDetailModel *model = [[AttaFileDetailModel alloc] init];
                           [model setValuesForKeysWithDictionary:dict];
                           [self.attachDetailArray addObject:model];
                       }
                   }
                   [self.attachDetailTbView reloadData];
               }, ^(id result) {
                   showAlert(result[@"error"]);
               });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attachDetailArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuseCell";
    AttachDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AttachDetailCell" owner:self options:nil] lastObject];
    }
    AttaFileDetailModel *model  = self.attachDetailArray[indexPath.row];
    [cell config:model];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AttaFileDetailModel *model = self.attachDetailArray[indexPath.row];
        [self.attachDetailArray removeObjectAtIndex:indexPath.row];
    
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = kDeleteFile;
        paraDict[@"fileId"] = model.fileId;
        httpGET2(paraDict, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                showAlert(@"附件已删除!");
            }
        }, ^(id result) {
            showAlert(result[@"error"]);
        });
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [_attachDetailTbView release];
//    [super dealloc];
//}
@end
