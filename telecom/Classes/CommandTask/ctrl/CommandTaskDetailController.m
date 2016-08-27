//
//  CommandTaskDetailController.m
//  telecom
//
//  Created by SD0025A on 16/5/16.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "CommandTaskDetailController.h"
#import "CommandTaskDetailCell.h"
#import "CommandTaskDetailModel.h"
#import "TZImagePickerController.h"
#import "achiveTextView.h"
#import "backTextView.h"
#import "VRGCalendarView.h"
#import "AppDelegate.h"
#import "NSDate+convenience.h"
//#import "WebViewController.h"
#define CommandTaskDetailUrl   @"task/SearchTaskInfo"
#define AcceptCommandTaskList  @"task/AcceptSubTask"
#define ReturnedCommandTaskList  @"task/ReturnSubTask"
#define FinishCommandTaskList    @"task/CompleteSubTask"
#define uploadFileUrl  @"task/uploadPic"
@interface CommandTaskDetailController ()<UITableViewDataSource,UITableViewDelegate,CommandTaskDetailCellDelegate,TZImagePickerControllerDelegate,achiveTextViewDelegate,backTextViewDelegate,VRGCalendarViewDelegate>
@property (nonatomic,strong) UITableView *m_table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) CommandTaskDetailCell *cell;
@property (nonatomic,copy) NSString *condition;//执行情况
@property (nonatomic,copy) NSString *backReason;//退回理由
@property (nonatomic,strong) UIView *rightMenuList;
@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,strong) achiveTextView *achiveTextView;
@property (nonatomic,strong) backTextView *backTextView ;
@property (nonatomic,strong) NSMutableArray *fileArray;
@end

@implementation CommandTaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self createUI];
    [self downloadData];
    
    
}
- (void)downloadData
{
    UIButton *btn = [self.view viewWithTag:100];
    UIButton *btn2 = [self.view viewWithTag:200];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[URL_TYPE] = CommandTaskDetailUrl;
    params[@"upTaskId"] = self.upTaskId;
    params[@"taskId"] = self.taskId;
    httpGET2(params, ^(id result) {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = result[@"detail"];
            CommandTaskDetailModel *model = [[CommandTaskDetailModel alloc] initWithDictionary:dict error:nil];
            if ([model.status isEqualToString:@"0"]) {
                [btn setTitle:@"接单" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"acceptJiedan.png"] forState:UIControlStateNormal];
                [btn2 setTitle:@"退回" forState:UIControlStateNormal];
                [btn2 setImage:[UIImage imageNamed:@"tuihui.png"] forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }else{
                [btn setTitle:@"完成" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"wancheng.png"] forState:UIControlStateNormal];
                [btn2 setTitle:@"取消" forState:UIControlStateNormal];
                [btn2 setImage:[UIImage imageNamed:@"quxiao.png"] forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            [self.dataArray addObject:model];
            [self.m_table reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}
- (NSMutableArray *)photoArray
{
    if (nil == _photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor =COLOR(247, 247, 247);
    self.navigationItem.title = @"指挥任务执行";
    //创建Tableview
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10, 69, APP_W-20, APP_H-69-80) style:UITableViewStylePlain];
    self.m_table.delegate = self;
    self.m_table.dataSource = self;
    [self.view addSubview:self.m_table];
    //创建  接单  和退回  按钮
    
    //接单
    UIButton *orderReceive = [UIButton buttonWithType:UIButtonTypeCustom];
    orderReceive.tag = 100;
    orderReceive.frame = CGRectMake(30, self.m_table.origin.y+self.m_table.size.height+25, 60, 30);
    [orderReceive addTarget:self action:@selector(orderReceive:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderReceive];
    
    //退回
    UIButton *orderBack = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBack.tag = 200;
    orderBack.frame = CGRectMake(APP_W-30-60, self.m_table.origin.y+self.m_table.size.height+25, 60, 30);
    [orderBack addTarget:self action:@selector(orderBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBack];
    
    //创建查看附件的item
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn setTitle:@"上传" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(uploadFile:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

}
#pragma mark - 附件列表
- (void)uploadFile:(UIButton *)rightBtn
{
   
    if (self.photoArray.count == 0) {
        showAlert(@"请选择上传的图片");
    }else{
        NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"operationTime"] = operationTime;
        dict[@"accessToken"] = accessToken;
        dict[@"taskId"] = self.taskId;
        NSString *urlString = uploadFileUrl;
        
        AFHTTPRequestOperationManager *mange = [AFHTTPRequestOperationManager manager];
        NSLog(@"URL是%@",[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, urlString]);
        
        [mange POST:[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, urlString] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (UIImage *image in self.photoArray) {
                NSData *data ;
                
                if (nil == UIImagePNGRepresentation(image)) {
                    data = UIImageJPEGRepresentation(image, 1);
                }else{
                    data = UIImagePNGRepresentation(image);
                }
                [formData appendPartWithFileData:data name:@"attachment" fileName:[NSString stringWithFormat:@"%@.jpg",operationTime] mimeType:@"image/jpeg"];
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            showAlert(responseObject[@"error"]);
            for (int i=0; i<self.photoArray.count; i++) {
                UIImageView *imageView = [self.cell.contentView viewWithTag:500+i];
                [imageView removeFromSuperview];
            }
            
            [self.photoArray removeAllObjects];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            showAlert(error);
        }];

    }
}

- (NSMutableArray *)fileArray
{
    if (nil == _fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

//创建右边菜单lsit
//- (void)createRightListView
//{
//    CommandTaskDetailModel *model = self.dataArray[0];
//   [self.fileArray addObjectsFromArray:model.attachmentList];
//    self.rightMenuList = [[UIView alloc] initWithFrame:CGRectMake(APP_W-100, 64, 100, 30*self.fileArray.count)];
//    self.rightMenuList.backgroundColor = COLOR(239, 239, 239);
//    self.rightMenuList.layer.borderWidth = 1;
//    self.rightMenuList.layer.borderColor = COLOR(239, 239, 239).CGColor;
//    [self.view addSubview:self.rightMenuList];
//    for (int i=0; i<self.fileArray.count; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [btn setTitle:[NSString stringWithFormat:@"  附件%@",self.fileArray[i]] forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor blueColor];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:13];
//        btn.frame = CGRectMake(0, 30*i, 100, 30);
//        [btn addTarget:self action:@selector(chooseRightListBtn:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag = 500+i;
//        [self.rightMenuList addSubview:btn];
//        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29+30*i, 100, 1)];
//        lineView.backgroundColor = [UIColor grayColor];
//        lineView.alpha = 0.5;
//        [self.rightMenuList addSubview:lineView];
//    }
//    [self.view bringSubviewToFront:self.rightMenuList];
//}
- (void)orderReceive:(UIButton *)btn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"taskId"] = self.taskId;
    NSString *title = btn.titleLabel.text;
    //NSLog(@"===当前标题%@",title);
    if ([title isEqualToString:@"接单"]) {
        //接单
        params[URL_TYPE] = AcceptCommandTaskList;
        httpGET2(params, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                showAlert(@"接单成功");
            }else{
                showAlert(@"接单失败");
            }
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"wancheng.png"] forState:UIControlStateNormal];
            UIButton *changeBtn = [self.view viewWithTag:200];
            [changeBtn setTitle:@"取消" forState:UIControlStateNormal];
            [changeBtn setImage:[UIImage imageNamed:@"quxiao.png"] forState:UIControlStateNormal];
        }, ^(id result) {
            showAlert(result[@"error"]);
             self.navigationItem.rightBarButtonItem.enabled = YES;
        });
    }else{
        //弹出完成对话框
        btn.enabled = NO;
      self.achiveTextView = [[[NSBundle mainBundle] loadNibNamed:@"achiveTextView" owner:nil options:nil]lastObject];
        self.achiveTextView.isAffectUser = @"0";
        self.achiveTextView.chooseView.hidden = NO;
        self.achiveTextView.delegate = self;
        self.achiveTextView.frame = CGRectMake((APP_W-280)/2, 64, 280, 200);
        [self.view addSubview:self.achiveTextView];
       
    }
    
    
}

- (void)orderBack:(UIButton *)btn
{
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"退回"]) {
        //弹出退回对话框
        btn.enabled = NO;
       self.backTextView = [[[NSBundle mainBundle] loadNibNamed:@"backTextView" owner:nil options:nil]lastObject];
        self.backTextView.frame = CGRectMake((APP_W-280)/2, 64, 280, 160);
        self.backTextView.delegate = self;
        [self.view addSubview:self.backTextView];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.cell.isShowBtn.selected) {
        CommandTaskDetailModel *model = self.dataArray[indexPath.row];
        return [model configHeight];
    }else{
        CommandTaskDetailModel *model = self.dataArray[indexPath.row];
        return [model configHeight]-130;
    }
    
}
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CommandTaskDetailCell";
    CommandTaskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommandTaskDetailCell" owner:self options:nil]lastObject];
    }
    cell.delegate = self;
    self.cell = cell;
    CommandTaskDetailModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
}
#pragma mark - CommandTaskDetailCellDelegate
- (void)showMoreView:(UIView *)moreView
{
    [self.m_table reloadData];
}
//文件上传功能
- (void)uploadFile
{
    
    
    TZImagePickerController *TZI = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    [TZI setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        for (int i=0; i<self.photoArray.count; i++) {
            UIImageView *imageView = [self.cell.contentView viewWithTag:500+i];
            [imageView removeFromSuperview];
        }

        [self.photoArray removeAllObjects];
        [self.photoArray addObjectsFromArray:photos];
        [self showImage];
    }];
    
    [self presentViewController:TZI animated:YES completion:nil];
}
- (void)showImage
{

    for (int i=0; i<self.photoArray.count; i++) {
        int row  = i/3;
        int sec  = i%3;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.cell.uploadBtn.frame.origin.x+70+sec*(60+10), self.cell.uploadBtn.frame.origin.y+row*(60+10), 60, 60)];
        UIImage *image = self.photoArray[i];
        imageView.image = image;
        imageView.tag = 500+i;
        
        [self.cell.contentView addSubview:imageView];
    }
 }
#pragma mark - achiveTextViewDelegate
- (void)goActionWithText:(NSString *)fillNote isAffectUser:(NSString *)isAffectUser startTime:(NSString *)startTime endTime:(NSString *)endTime
{
    
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"operationTime"] = operationTime;
    dict[@"accessToken"] = accessToken;
    dict[@"taskId"] = self.taskId;
    dict[@"fillNote"] = fillNote;
    dict[@"affectUser"] = isAffectUser;
    dict[@"startTime"] = self.achiveTextView.startTimeBtn.titleLabel.text;
    dict[@"endTime"] = self.achiveTextView.endTimeBtn.titleLabel.text;
    
    NSString *urlString = FinishCommandTaskList;
    
    AFHTTPRequestOperationManager *mange = [AFHTTPRequestOperationManager manager];
    NSLog(@"URL是%@",[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, urlString]);
    
    [mange POST:[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, urlString] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (UIImage *image in self.photoArray) {
            NSData *data ;
           
            if (nil == UIImagePNGRepresentation(image)) {
                data = UIImageJPEGRepresentation(image, 1);
            }else{
                data = UIImagePNGRepresentation(image);
            }
            [formData appendPartWithFileData:data name:@"attachment" fileName:[NSString stringWithFormat:@"%@.jpg",operationTime] mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        showAlert(responseObject[@"error"]);
        for (int i=0; i<self.photoArray.count; i++) {
            UIImageView *imageView = [self.cell.contentView viewWithTag:500+i];
            [imageView removeFromSuperview];
        }
        
        [self.photoArray removeAllObjects];
        
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        showAlert(error);
    }];
}
- (void)choooseBeginDate
{
    AppDelegate *myDele = (id)[UIApplication sharedApplication].delegate;
    UIWindow *window = myDele.window;
    UIView *backView = [[UIView alloc] initWithFrame:window.bounds];
    backView.tag = 500;
    backView.backgroundColor = [UIColor whiteColor];
    [window addSubview:backView];
    VRGCalendarView * calendar = [[VRGCalendarView alloc] init];
    calendar.frame = CGRectMake(0, 50, APP_W, 300);
    calendar.delegate=self;
    calendar.tag = 300;
    backView.userInteractionEnabled = YES;
    [backView addSubview:calendar];
}
- (void)choooseEndDate
{
    AppDelegate *myDele = (id)[UIApplication sharedApplication].delegate;
    UIWindow *window = myDele.window;
    window.backgroundColor = [UIColor whiteColor];
    UIView *backView = [[UIView alloc] initWithFrame:window.bounds];
    backView.tag = 500;
    backView.backgroundColor = [UIColor whiteColor];
    [window addSubview:backView];
    VRGCalendarView * calendar = [[VRGCalendarView alloc] init];
    calendar.frame = CGRectMake(0, 50, APP_W, 300);
    calendar.delegate=self;
    calendar.tag = 400;
    backView.userInteractionEnabled = YES;
    [backView addSubview:calendar];
}

#pragma mark - backTextViewDelegate
- (void)backOrderWithText:(NSString *)text
{
    //退回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[URL_TYPE] = ReturnedCommandTaskList;
    params[@"rejectNote"] = nil;
    params[@"taskId"] = self.taskId;
    params[@"rejectNote"] = text;
    httpGET2(params, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            showAlert(@"退回成功");
        }else{
            showAlert(@"退回失败");
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}
#pragma mark - VRGCalendarViewDelegate
- (void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date

{
    NSTimeZone *timezone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-d"];
    //设定时区
    [formatter setTimeZone:timezone];
    //时间格式正规化并做时区校正
    NSString *correctDate = [formatter stringFromDate:date];
    if (calendarView.tag == 300) {
        [self.achiveTextView.startTimeBtn setTitle:correctDate forState:UIControlStateNormal];
    }
    if (calendarView.tag == 400) {
        [self.achiveTextView.endTimeBtn setTitle:correctDate forState:UIControlStateNormal];
    }
    
    AppDelegate *myDele = (id)[UIApplication sharedApplication].delegate;
    UIWindow *window = myDele.window;
    UIView *backView = [window viewWithTag:500];
    [backView removeFromSuperview];
}


- (void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated

{
    
}

@end
