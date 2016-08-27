//
//  SelledFaultReceiptController.m
//  telecom
//
//  Created by SD0025A on 16/5/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SelledFaultReceiptController.h"
#import "AppDelegate.h"
#import "SelfImgeView.h"
#import "ImageAndVideoPicker.h"
#import "SelledFaultReciptView.h"
#import "FileModel.h"
#import "OptionView.h"
#import "FixReasonModel.h"
#import "FixReasonCell.h"

#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#define SelledFaultReceiptUrl  @"Trouble/SaleTroubleH"
#define SearchUrl              @"VoiceUtils/GetResultList"
@interface SelledFaultReceiptController ()<UITextFieldDelegate,UITextViewDelegate,ImageAndVideoPickerDelegate,DeleteBtnInImageViewDelegate,SelledFaultReciptViewDelegate,UITableViewDataSource,UITableViewDelegate,IFlyRecognizerViewDelegate>
;


@property (nonatomic,strong) NSMutableArray *fileArray;
@property (nonatomic,strong) ImageAndVideoPicker *picker;
@property (nonatomic,strong) UITableView *m_table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) SelledFaultReciptView *mainView;

@property(nonatomic,copy)NSString *userWords;
@end

@implementation SelledFaultReceiptController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
   // _baseScrollView.frame = CGRectMake(0, 64, APP_W, APP_H-64);
    _baseScrollView.contentSize = CGSizeMake(APP_W, 700);
    self.mainView.backView.backgroundColor = COLOR(246, 246, 246);
    self.navigationItem.title = @"回单";
    self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"SelledFaultReciptView" owner:nil options:nil] lastObject];
    self.mainView.isContact = NO;
    self.mainView.delegate  = self;
    self.mainView.backgroundColor = COLOR(246, 246, 246);
    self.mainView.frame = CGRectMake(0, 0, APP_W, 600);
    [_baseScrollView addSubview:self.mainView];
    self.mainView.descTextView.delegate = self;
    self.mainView.label1.text = self.orderNO;
    self.mainView.label2.text = UGET(U_NAME);
    //创建导航栏右边的btn
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    checkBtn.frame = CGRectMake(0, 0, 30, 30);
    [checkBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = checkItem;
    self.mainView.nameTextField.tag = 100;
    self.mainView.nameTextField.delegate = self;
    self.mainView.phoneTextField.tag = 200;
    self.mainView.phoneTextField.delegate = self;
    self.mainView.reseaonTextField.tag = 300;
    self.mainView.reseaonTextField.delegate = self;
    self.mainView.descTextView.delegate = self;
    
    self.mainView.noBtn.selected = YES;
    self.mainView.yesBtn.selected = NO;
    self.mainView.nameTextField.enabled = NO;
    self.mainView.phoneTextField.enabled = NO;
    //默认yesBtn  noBtn  背景图片
    [self.mainView.yesBtn setImage:[UIImage imageNamed:@"check_no@2x"] forState:UIControlStateNormal];
    [self.mainView.noBtn setImage:[UIImage imageNamed:@"check_ok@2x"] forState:UIControlStateSelected];
    //监听键盘的弹进弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //增加检索框
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(self.mainView.receiveBaseInfoLabel.frame.origin.x, self.mainView.chooseReasonTextField.ey+13, self.mainView.receiveBaseInfoLabel.bounds.size.width, 20) style:UITableViewStylePlain];
    self.m_table.dataSource = self;
    self.m_table.delegate = self;
    [self.mainView addSubview:self.m_table];
    
    //self.mainView.reseaonTextField 右边图片
    UIImage *voiceImage = [UIImage imageNamed:@"voiceInput.png"];
    UIImageView *voiceInputImageView = [[UIImageView alloc] initWithFrame:RECT(self.mainView.reseaonTextField.bounds.size.width-20, 0, voiceImage.size.width/1.3, voiceImage.size.height/1.3)];
    voiceInputImageView.image = voiceImage;
    voiceInputImageView.userInteractionEnabled = YES;
    [voiceInputImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceInputAction:)]];
    self.mainView.reseaonTextField.rightView = voiceInputImageView;
    self.mainView.reseaonTextField.rightViewMode =UITextFieldViewModeAlways;
   
    //创建语音听写的对象
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"552504d3"];
    [IFlySpeechUtility createUtility:initString];
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;
    
    //
    self.mainView.backView.backgroundColor = COLOR(246, 246, 246);
}
#pragma mark - 语音输入
- (void)voiceInputAction:(UITapGestureRecognizer *)ges
{
    [self loadUserWord];
    [self onUploadUserWord:ges];
    
    [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    //设置结果数据格式，可设置为json，xml，plain，默认为json。
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    [_iflyRecognizerView start];
    
}
- (void)loadUserWord
{
    httpGET2(@{URL_TYPE : kGetKeyWords,@"functionId" : @"1"}, ^(id result) {
        
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            self.userWords = result[@"detail"][@"keyWords"];
        }
        
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

/*
 * @上传用户词
 */
#define NAME @"userwords"
#define USERWORDS   self.userWords

- (void) onUploadUserWord:(id)sender
{
    
    [self.uploader setParameter:@"iat" forKey:[IFlySpeechConstant SUBJECT]];
    [self.uploader setParameter:@"userword" forKey:[IFlySpeechConstant DATA_TYPE]];
    
    
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:USERWORDS ];
    
    [self.uploader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error)
     {
         
     } name:NAME data:[iFlyUserWords toString]];
}


- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    self.mainView.reseaonTextField.text = [NSString stringWithFormat:@"%@",result];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    //    showAlert([error errorDesc]);
    
    NSLog(@"errorCode:%d",[error errorCode]);
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.mainView.descTextView.text isEqualToString:@"请输入描述信息"]) {
        self.mainView.descTextView.text = nil;
        self.mainView.descTextView.textColor = [UIColor blackColor];
    }
}
- (void)commit:(UIButton *)btn
{
    //上传
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"workNo"] = self.workNo;
    param[@"action"] = self.actionType;
    param[@"operationTime"] = operationTime;
    param[@"accessToken"] = UGET(U_TOKEN);
    NSString *isContact ;
    if (self.mainView.isContact) {
        isContact = @"1";
        
    }else{
        isContact = @"0";
    }
    param[@"isContact"] = isContact ;
    if ([self.mainView.descTextView.text isEqualToString:@"请输入描述信息"]) {
        self.mainView.descTextView.text = @"";
        param[@"description"] = @"";
        
    }else{
        param[@"description"] = self.mainView.descTextView.text;
    }
    while ((self.mainView.chooseReasonTextField.text.length == 0 )) {
        showAlert(@"请选择障碍原因！");
        return;
    }
    param[@"cause"] = self.mainView.reseaonTextField.text ;
    if (self.mainView.isContact) {
        if (self.mainView.nameTextField.text.length == 0) {
            showAlert(@"请输入联系用户姓名");
            return;
        }else{
            param[@"contactUserName"] = self.mainView.nameTextField.text;
        }
    }
    if (self.mainView.isContact) {
        if (self.mainView.phoneTextField.text.length == 0) {
            showAlert(@"请输入联系用户电话");
            return;
        }else{
            param[@"contactUserTel"] = self.mainView.phoneTextField.text;
        }
    }

    
        CGFloat fileLength = 0;
        for (FileModel *model in self.fileArray) {
            if (model.movieData) {
                fileLength  = fileLength + model.movieData.length;
                
            }else{
                NSData *data ;
                data = UIImageJPEGRepresentation(model.image, 1);
                if (nil == data) {
                    data = UIImagePNGRepresentation(model.image);
                }
                fileLength = fileLength + data.length;
            }
        }
        CGFloat fileSize = fileLength/1024.00/1024.00;
        if (fileSize <10) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, SelledFaultReceiptUrl] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
                    [[self.view viewWithTag:500+i] removeFromSuperview];
                }
                [self.fileArray removeAllObjects];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                showAlert(error);
            }];
            
        }else{
            showAlert(@"上传文件不能超过10M，请重新选择！");
            
        }

    }
    

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark - 键盘
//键盘的弹出
- (void)keyboardShow:(NSNotification *)notification
{
    
    AppDelegate *dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = dele.window;
    
    if (self.view.center.y == window.center.y ) {
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-90);
    }
    
    
}
//弹进
- (void)keyboardHide:(NSNotification *)notification
{
    AppDelegate *dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = dele.window;
    
    if (self.view.center.y == window.center.y -90 ) {
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y+90);
    }
    
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 100) {
        [self.mainView.phoneTextField becomeFirstResponder];
    }
    if (textField.tag == 200) {
        [self.mainView.reseaonTextField becomeFirstResponder];
    }
    if (textField.tag == 300) {
        [textField resignFirstResponder];
        
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 300) {
        textField.text = nil;
        textField.textColor = [UIColor blackColor];
    }
    return YES;
}
#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
    [textView resignFirstResponder]; return NO;
    }  return YES;
}
//上传
#pragma mark - SelledFaultReciptViewDelegate
- (void)uploadFile
{
    self.picker = [[ImageAndVideoPicker alloc ]init];
    self.picker.delegate  = self;
    self.picker.ctrl = self;
    [self.picker pickImageFromPhotos];
    
}
//检索条件
- (void)chooseFaultReason
{
    [self.mainView.reseaonTextField resignFirstResponder];
    self.m_table.frame = CGRectMake(self.m_table.frame.origin.x, self.m_table.frame.origin.y, self.m_table.bounds.size.width, 300);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"functionId"] = @(1);
    param[URL_TYPE] = SearchUrl;
    param[@"content"] = self.mainView.reseaonTextField.text;
    httpGET2(param, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dict in result[@"list"]) {
                FixReasonModel *model = [[FixReasonModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
        }
        [self.m_table reloadData];
        self.mainView.backView.frame = CGRectMake(self.mainView.backView.frame.origin.x, self.m_table.ey+5, self.mainView.backView.bounds.size.width, self.mainView.backView.bounds.size.height);
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
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
        [[self.mainView.backView viewWithTag:500+i] removeFromSuperview];
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
        SelfImgeView *imageView = [[SelfImgeView alloc] initWithFrame:CGRectMake(self.mainView.upLoadBtn.frame.origin.x+70+sec*(60+10), self.mainView.upLoadBtn.frame.origin.y+row*(60+10), 60, 60)];
        FileModel *model = self.fileArray[i];
        imageView.delegate = self;
        UIImage *image = model.image;
        imageView.image = image;
        imageView.tag = 500+i;
        [self.mainView.backView addSubview:imageView];
    }
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.receiveInfoLabel.bounds.size.width, 20)];
    header.backgroundColor = COLOR(224, 224, 224);
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, header.bounds.size.height)];
    greenView.backgroundColor = [UIColor greenColor];
    [header addSubview:greenView];
    
    UILabel *titleabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, header.bounds.size.width-20-20, header.bounds.size.height)];
    titleabel.text = @" 匹配结果";
    titleabel.font = [UIFont systemFontOfSize:13];
    [header addSubview:titleabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(header.bounds.size.width-20-20, 0, 20, header.bounds.size.height);
    [btn setBackgroundImage:[UIImage imageNamed:@"week_right.png"] forState:UIControlStateNormal];
    
    [header addSubview:btn];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    FixReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FixReasonCell" owner:self options:nil] firstObject];
    }
    FixReasonModel *model = self.dataArray[indexPath.row];
    [cell configWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FixReasonModel *model = self.dataArray[indexPath.row];
    self.mainView.chooseReasonTextField.text = model.resultContent;
    self.m_table.frame = CGRectMake(self.m_table.frame.origin.x, self.m_table.frame.origin.y, self.m_table.bounds.size.width, 20);
    self.mainView.backView.frame = CGRectMake(self.mainView.backView.frame.origin.x, self.m_table.ey+5, self.mainView.backView.bounds.size.width, self.mainView.backView.bounds.size.height);
    
}
@end
