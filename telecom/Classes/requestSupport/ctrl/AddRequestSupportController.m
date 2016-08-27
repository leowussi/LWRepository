//
//  AddRequestSupportController.m
//  telecom
//
//  Created by SD0025A on 16/5/25.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "AddRequestSupportController.h"
#import "AddRequestSupportView.h"
#import "IQKeyboardManager.h"
#import "VRGCalendarView.h"
#import "AppDelegate.h"
#import "NSDate+convenience.h"
#import "TZImagePickerController.h"
#import "DatePickerController.h"
#import "SelfImgeView.h"
#import "FileModel.h"
#define AddRequestSupportUrl  @"task/AddSupportTask"
#define SearchComboxUrl  @"task/SearchCombbox"
#define SearchPerson   @"task/SearchAccountByOrg"
@interface AddRequestSupportController ()<UITextViewDelegate,AddRequestSupportViewDelegate,TZImagePickerControllerDelegate,DatePickerControllerDelegate,DeleteBtnInImageViewDelegate,UITextViewDelegate>
@property (nonatomic,strong) AddRequestSupportView *mainView;
@property (nonatomic,strong) NSMutableArray *fileArray;
@property (nonatomic,strong) NSMutableArray *sceneTypeList;
@property (nonatomic,strong) NSMutableArray *oneTypeList;
@property (nonatomic,strong) NSMutableArray *twoTypeList;
@property (nonatomic,strong) NSMutableArray *orgList;
@property (nonatomic,copy) NSString *accountId;

@end

@implementation AddRequestSupportController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainView.descTextView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self downloadData];
    
    
}
#pragma mark -UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请填写请求描述..."]) {
        textView.text = nil;
    }
    self.mainView.center = CGPointMake(self.mainView.center.x, self.mainView.center.y-45);
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.mainView.center = CGPointMake(self.mainView.center.x, self.mainView.center.y+45);
}
- (void)downloadData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[URL_TYPE] = SearchComboxUrl;
    httpGET2(dict, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result[@"detail"];
            self.sceneTypeList = dict[@"sceneTypeList"];
            self.oneTypeList = dict[@"oneTypeList"];
            self.twoTypeList = dict[@"twoTypeList"];
            self.orgList = dict[@"orgList"];
            [self createUI];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}
//禁用IQKeyboard
- (void)viewDidAppear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
- (NSMutableArray *)fileArray
{
    if (nil == _fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"新增请求支撑";
    _baseScrollView.contentSize = CGSizeMake(APP_W, 573);
    self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"AddRequestSupportView" owner:nil options:nil]lastObject];
    self.mainView.delegate = self;
    self.mainView.frame = CGRectMake(10, 64, APP_W-20, 430);
    self.mainView.sceneTypeList = self.sceneTypeList;
    self.mainView.oneTypeList = self.oneTypeList;
    self.mainView.twoTypeList = self.twoTypeList;
    self.mainView.orgList = self.orgList;
    self.mainView.source = self.source;
    _baseScrollView.bounces = NO;
    self.mainView.alpha = 0.8;
    self.mainView.groupBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_baseScrollView addSubview:self.mainView];
    
    self.mainView.descTextView.delegate = self;
    if ([self.source isEqualToString:@"1"]) {
        for (NSDictionary *dict in self.sceneTypeList) {
            if ([dict[@"key"] isEqualToString:@"8"]) {
                [self.mainView.requestBtn setTitle:dict[@"value"] forState:UIControlStateNormal];
            }
        }
        self.mainView.applicantTextField.text = UGET(U_NAME);
        [self.mainView.groupBtn setTitle:@"楼宇支撑班组" forState:UIControlStateNormal];
        self.mainView.groupBtn.enabled = NO;
        
    }
    
    //申请
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.tag = 100;
    [applyBtn setTitle:@"申请" forState:UIControlStateNormal];
    applyBtn.frame = CGRectMake(30, self.mainView.origin.y+self.mainView.size.height+25, 60, 30);
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyBtn.backgroundColor = COLOR(66, 123, 196);
    [applyBtn addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:applyBtn];
    
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.tag = 200;
    cancelBtn.frame = CGRectMake(APP_W-30-60, self.mainView.origin.y+self.mainView.size.height+25, 60, 30);
    cancelBtn.backgroundColor = COLOR(0, 183, 70);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:cancelBtn];
}
//申请
- (void)apply:(UIButton *)btn
{
    if (self.mainView.requestBtn.titleLabel.text.length == 0) {
        showAlert(@"请选择适用场景类型！");
        return;
    }
    if (self.mainView.handleServeBtn.titleLabel.text.length == 0) {
        showAlert(@"请选择一级类别！");
        return;
    }
    if (self.mainView.handleComplaintBtn.titleLabel.text.length == 0) {
        showAlert(@"请选择二级类别！");
        return;
    }
    if ([self.mainView.groupBtn.titleLabel.text isEqualToString:@"  帮组"] ) {
        showAlert(@"请选择帮组！");
        return;
    }
    
    if (self.mainView.nameTextField.text.length == 0) {
        showAlert(@"请输入名称！");
        return;
    }
    if (self.mainView.applicantTextField.text.length == 0) {
        showAlert(@"请输入工单申请人！");
        return;
    }
    if (self.mainView.beginDateBtn.titleLabel.text.length == 0) {
        showAlert(@"请选择任务限时的开始时间！");
        return;
    }
    if (self.mainView.endDateBtn.titleLabel.text.length == 0) {
        showAlert(@"请选择任务限时的结束时间！");
        return;
    }
    if (self.mainView.descTextView.text.length == 0 || [self.mainView.descTextView.text isEqualToString:@"请填写请求描述..."]) {
        showAlert(@"请输入任务描述！");
        return;
    }
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"operationTime"] = operationTime;
    dict[@"accessToken"] = accessToken;
    for (NSDictionary *subDict in self.sceneTypeList) {
        if ([subDict[@"value"] isEqualToString:self.mainView.requestBtn.titleLabel.text]) {
            dict[@"sceneType"] = subDict[@"key"];
        }
    }
    dict[@"name"] = self.mainView.nameTextField.text;
    dict[@"createPerson"] = self.mainView.applicantTextField.text;
    for (NSDictionary *subDict in self.oneTypeList) {
        if ([subDict[@"value"] isEqualToString:self.mainView.handleServeBtn.titleLabel.text]) {
            dict[@"oneType"] = subDict[@"key"];
        }
    }
    
    for (NSDictionary *subDict in self.twoTypeList) {
        if ([subDict[@"value"] isEqualToString:self.mainView.handleComplaintBtn.titleLabel.text]) {
            dict[@"twoType"] = subDict[@"key"];
        }
    }
    
    if ([self.source isEqualToString:@"1"]) {
        dict[@"orgId"] = @"10000820";
    }else{
        for (NSDictionary *subDict in self.orgList) {
            if ([subDict[@"value"] isEqualToString:self.mainView.groupBtn.titleLabel.text]) {
                dict[@"orgId"] = subDict[@"key"];
            }
        }
        
    }
    if (![self.mainView.groupBtn.titleLabel.text isEqualToString:@"  人"] ) {
        
        dict[@"accountId"] = self.accountId;
    }
    dict[@"beginDate"] = self.mainView.beginDateBtn.titleLabel.text;
    dict[@"endDate"] = self.mainView.endDateBtn.titleLabel.text;
    dict[@"remark"] = self.mainView.descTextView.text;
    dict[@"source"] = self.source;
    NSString *urlString = AddRequestSupportUrl;
    NSLog(@"URL是%@",[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, urlString]);
    AFHTTPRequestOperationManager *mange = [AFHTTPRequestOperationManager manager];
    
    [mange POST:[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, urlString] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (FileModel *model in self.fileArray) {
            NSData *data ;
            
            if (nil == UIImagePNGRepresentation(model.image)) {
                data = UIImageJPEGRepresentation(model.image, 1);
            }else{
                data = UIImagePNGRepresentation(model.image);
            }
            [formData appendPartWithFileData:data name:@"attachment" fileName:[NSString stringWithFormat:@"%@.jpg",operationTime] mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        showAlert(responseObject[@"error"]);
        [self.fileArray removeAllObjects];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        showAlert(error);
    }];
    
}

//取消
- (void)cancelBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
- (void)getAccountId:(NSArray *)accountIdArray
{
    for (NSDictionary *subDict in accountIdArray) {
        if ([subDict[@"value"] isEqualToString:self.mainView.personBtn.titleLabel.text]) {
            self.accountId = subDict[@"key"];
        }
    }
    
}
- (void)choooseBeginDate
{
    DatePickerController *date1 = [[DatePickerController alloc] initWithNibName:@"DatePickerController" bundle:nil];
    date1.type = @"begin";
    date1.delegate = self;
    [self.navigationController pushViewController:date1 animated:YES];
}
- (void)choooseEndDate
{
    DatePickerController *date2 = [[DatePickerController alloc] initWithNibName:@"DatePickerController" bundle:nil];
    date2.type = @"end";
    date2.delegate = self;
    [self.navigationController pushViewController:date2 animated:YES];
}
- (void)chooseAddRequestPhoto
{
    TZImagePickerController *TZI = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    [TZI setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        for (UIImage *image in photos) {
            FileModel *model = [[FileModel alloc] init];
            model.image = image;
            [self.fileArray addObject:model];
        }
        [self showImage];
    }];
    
    [self presentViewController:TZI animated:YES completion:nil];
}
- (void)showImage
{
    
    for (int i=0; i<self.fileArray.count; i++) {
        int row  = i/3;
        int sec  = i%3;
        SelfImgeView *imageView = [[SelfImgeView alloc] initWithFrame:CGRectMake(self.mainView.uploadBtn.frame.origin.x+70+sec*(60+10), self.mainView.uploadBtn.frame.origin.y+row*(60+10), 60, 60)];
        FileModel *model = self.fileArray[i];
        UIImage *image = model.image;
        imageView.delegate = self;
        imageView.image = image;
        imageView.tag = 500+i;
        [self.mainView addSubview:imageView];
    }
}
- (void)deleteBtnInImageView:(SelfImgeView *)imgeView
{
    for (int i =0; i<self.fileArray.count; i++) {
        [[self.mainView viewWithTag:500+i] removeFromSuperview];
    }
    NSInteger index = imgeView.tag - 500;
    FileModel *model = self.fileArray[index];
    [self.fileArray removeObject:model];
    [self showImage];
}
#pragma mark -UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请填写请求描述..."]) {
        textView.text = nil;
    }
    
    _baseScrollView.center = CGPointMake(_baseScrollView.center.x, _baseScrollView.center.y-120);
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    _baseScrollView.center = CGPointMake(_baseScrollView.center.x, _baseScrollView.center.y+120);
    
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - DatePickerControllerDelegate
- (void)choosedDate:(NSString *)date picker:(DatePickerController *)picker
{
    if ([picker.type isEqualToString:@"begin"]) {
        self.mainView.beginDateBtn.titleLabel.text = date;
        [self.mainView.beginDateBtn setTitle:date forState:UIControlStateNormal];
    }else{
        self.mainView.endDateBtn.titleLabel.text = date;
        [self.mainView.endDateBtn setTitle:date forState:UIControlStateNormal];
    }
}
@end
