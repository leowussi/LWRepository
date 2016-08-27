//
//  AccessoryListController.m
//  telecom
//
//  Created by SD0025A on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "AccessoryListController.h"
#import "AccessoryListCell.h"
#import "AccessoryListModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ImageAndVideoPicker.h"
#import "SelfImgeView.h"
#import "HWBProgressHUD.h"
#import "WebViewController.h"
#import "FileModel.h"
#define AccessoryListUrl @"Medium/seeAffixlist"//附件查看
#define AccessoryLinkUrl @"Medium/seeAffixSingle"//附件链接
#define AccessoryDeleteUrl  @"Medium/delAffixlist"//附件删除
#define  AccessoryUploadUrl      @"Medium/addAffixs"//附件添加

#define SelledAccessoryListUrl @"Trouble/seeAffixlist"//附件查看
#define SelledAccessoryLinkUrl @"Trouble/seeAffixSingle"//附件链接
#define SelledAccessoryDeleteUrl  @"Trouble/delAffixlist"//附件删除
#define  SelledAccessoryUploadUrl      @"Trouble/AddAffixs"//附件添加

@interface AccessoryListController ()<UITableViewDataSource,UITableViewDelegate,AccessoryDeleteBtnDelegate,ImageAndVideoPickerDelegate,DeleteBtnInImageViewDelegate,UIAlertViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UIButton *upBtn;
@property (nonatomic,strong) UITableView *m_table;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *fileArray;
@property (nonatomic,strong) NSMutableArray *deleteArray;

@property (nonatomic,strong) AccessoryListModel *model;
@property (nonatomic,strong) NSIndexPath *index;
@property (nonatomic,strong) ImageAndVideoPicker *picker;

@end

@implementation AccessoryListController
//附件列表 控制器
- (void)viewDidLoad {
    [super viewDidLoad];
    _baseScrollView.contentSize = CGSizeMake(APP_W, 700);
    [self createUI];
    [self downloadData];
}
-(void)downloadData
{
    [self.dataArray removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *urlString;
    if ([self.type isEqualToString:@"selledDetail"]) {
        urlString = SelledAccessoryListUrl;
    }else{
        urlString = AccessoryListUrl;
    }
    
    param[URL_TYPE] = urlString;
    param[@"workNo"] = self.workNo;
    httpGET2(param, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result;
            NSArray *array = dict[@"return_data"];
            self.dataArray = [AccessoryListModel arrayOfModelsFromDictionaries:array error:nil];
            [self.m_table reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
}
- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)deleteArray
{
    if (nil == _deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (void)createUI
{
    self.navigationItem.title = @"附件列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, APP_W-20, APP_H-74) style:UITableViewStylePlain];
    self.m_table.dataSource = self;
    self.m_table.delegate = self;
    self.m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_baseScrollView addSubview:self.m_table];
    
    
    
    //创建导航栏右边的btn
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    checkBtn.frame = CGRectMake(0, 0, 30, 30);
    [checkBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = checkItem;
}
- (void)commit:(UIButton *)btn
{
    
    if (self.fileArray.count == 0) {
        showAlert(@"请选择图片或视频");
    }else{
        
        CGFloat fileLength = 0;
        for (FileModel *model in self.fileArray) {
            if (model.movieData) {
                fileLength  = fileLength + model.movieData.length;
                
            }else{
                NSData *data ;
                data = UIImageJPEGRepresentation(model.image, 1);
                if (data == nil) {
                    data = UIImagePNGRepresentation(model.image);
                }
                fileLength = fileLength + data.length;
            }
        }
        CGFloat fileSize = fileLength/1024.00/1024.00;
        //NSLog(@"文件大小为%fM",fileLength/1024.00/1024.00);
        if (fileSize < 10) {
            
            NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
            NSString *accessToken = UGET(U_TOKEN);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"operationTime"] = operationTime;
            dict[@"accessToken"] = accessToken;
            dict[@"workNo"] = self.workNo;
            NSString *urlString;
            if ([self.type isEqualToString:@"selledDetail"]) {
                urlString = SelledAccessoryUploadUrl;;
            }else{
                urlString = AccessoryUploadUrl;
            }
            
            AFHTTPRequestOperationManager *mange = [AFHTTPRequestOperationManager manager];
            DLog(@"URL是%@",[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, urlString]);
            
            [mange POST:[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, urlString] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (FileModel *model in self.fileArray) {
                    if (model.movieData) {
                        [formData appendPartWithFileData:model.movieData name:@"attachment" fileName:[NSString stringWithFormat:@"%@.mp4",operationTime] mimeType:@"video/mp4"];
                        
                    }else{
                        NSData *data ;
                        UIImage *originalImage = model.image;
                        if (nil == UIImagePNGRepresentation(originalImage)) {
                            data = UIImageJPEGRepresentation(originalImage, 1);
                        }else{
                            data = UIImagePNGRepresentation(originalImage);
                        }
                        [formData appendPartWithFileData:data name:@"attachment" fileName:[NSString stringWithFormat:@"%@.jpg",operationTime] mimeType:@"image/jpeg"];
                    }
                    
                }
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                showAlert(responseObject[@"error"]);
                for (int i =0; i<self.fileArray.count; i++) {
                    [[self.upBtn.superview viewWithTag:500+i] removeFromSuperview];
                }
                [self.fileArray removeAllObjects];
                [self downloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                showAlert(error);
            }];
            
            
        }else{
            showAlert(@"上传文件不能超过10M，请重新选择！");
        }

    }
    
    }
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count) {
        return 230;
    }else{
        AccessoryListModel *model = self.dataArray[indexPath.row];
        return  [model configHeight];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.dataArray.count) {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        //创建 upBtn
        self.upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.upBtn.frame = CGRectMake(5, 20, 60, 60);
        [self.upBtn setBackgroundImage:[UIImage imageNamed:@"upload_btn"] forState:UIControlStateNormal];
        [self.upBtn addTarget:self action:@selector(upLoad:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.upBtn];
        
        return cell;
    }else{
        static NSString *cellId = @"accessoryListCell";
        AccessoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AccessoryListCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        AccessoryListModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        cell.indexPath = indexPath;
        return cell;
    }
    
}
#pragma mark - alertViewDelegate
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            NSString *urlString;
            if ([self.type isEqualToString:@"selledDetail"]) {
                urlString = SelledAccessoryDeleteUrl;
            }else{
                urlString = AccessoryDeleteUrl;
            }
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[URL_TYPE] = urlString;
            param[@"workNo"] = self.workNo;
            
            param[@"attachmentId"] = self.model.attachmentId;
            httpGET2(param, ^(id result) {
                showAlert(result[@"error"]);
                [self downloadData];
            }, ^(id result) {
                showAlert(result[@"error"]);
            });

        }
            break;
            
        default:
            break;
    }
}
#pragma mark - AccessoryDeleteBtnDelegate
- (void)deleteBtnWasClicked:(AccessoryListModel *)model path:(NSIndexPath *)indexPath
{
    self.model = model;
    self.index = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除该文件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (void)fileNameLabelWasTaped:(NSString *)fileName attachmentId:(NSString *)attachmentId
{
   NSString *urlString;
    if ([self.type isEqualToString:@"selledDetail"]) {
        urlString = SelledAccessoryLinkUrl;
    }else{
        urlString = AccessoryLinkUrl;
    }
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
   
    NSString *urlStr = [[NSString stringWithFormat:@"http://%@/%@/%@?attachmentId=%@&workNo=%@&accessToken=%@", ADDR_IP, ADDR_DIR, urlString,attachmentId,self.workNo,accessToken] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"=====%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    WebViewController *web = [[WebViewController alloc] init];
    web.url = url;
    [self.navigationController pushViewController:web animated:YES];
   }
#pragma mark - 上传功能
//上传
- (void)upLoad:(UIButton *)upBtn
{
    self.picker = [[ImageAndVideoPicker alloc ]init];
    self.picker.delegate  = self;
    self.picker.ctrl = self;
    [self.picker pickImageFromPhotos];
    
}
- (NSMutableArray *)fileArray
{
    if (nil == _fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

#pragma mark - DeleteBtnInImageViewDelegate
- (void)deleteBtnInImageView:(SelfImgeView *)imgeView
{
    for (int i =0; i<self.fileArray.count; i++) {
        [[self.upBtn.superview viewWithTag:500+i] removeFromSuperview];
    }
    NSInteger index = imgeView.tag - 500;
    FileModel *model = self.fileArray[index];
    [self.fileArray removeObject:model];
    [self showImage];
  
    
}

#pragma mark - ImageAndVideoPickerDelegate
- (void)addImageFromTZI:(NSArray *)array
{
    for (UIImage *image in array) {
        FileModel *model = [[FileModel alloc] init];
        model.image = image;
        [self.fileArray addObject:model];
        
    }
    [self showImage];
    
}
- (void)addVedioFromTZI:(NSData *)movieData coverImage:(UIImage *)coverImage
{
    FileModel *model = [[FileModel alloc] init];
    model.image = coverImage;
    model.movieData = movieData;
    [self.fileArray addObject:model];
    [self showImage];
}
- (void)showImage
{
    for (int i=0; i<self.fileArray.count; i++) {
        int row  = i/3;
        int sec  = i%3;
        SelfImgeView *imageView = [[SelfImgeView alloc] initWithFrame:CGRectMake(self.upBtn.frame.origin.x+70+sec*(60+10), self.upBtn.frame.origin.y+row*(60+10), 60, 60)];
        FileModel *model = self.fileArray[i];
        UIImage *image = model.image;
        imageView.delegate = self;
        imageView.image = image;
        imageView.tag = 500+i;
        [self.upBtn.superview addSubview:imageView];
    }
    
}


@end
