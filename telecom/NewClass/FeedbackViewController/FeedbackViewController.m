//
//  FeedbackViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/5/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "FeedbackViewController.h"
#import "ZYQAssetPickerController.h"
#import "HWBProgressHUD.h"

@interface FeedbackViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString *strPath;
    NSURL *imageDataUrl;
    UILabel *placeholderLabel;
    UIImageView *addImgView;
    UIImageView *photoImgView;
    NSString *backTypeStr;//反馈类型
    NSString *backtextStr;//反馈内容
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    UITableView *myTableView;
    UIView *view;
}
@end

@implementation FeedbackViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    [self addLeftTitle:@"反馈"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    imgArr = [[NSMutableArray alloc]initWithCapacity:10];
    imageDataUrlArr = [[NSMutableArray alloc]initWithCapacity:10];
    [self initView];
}

-(void)initView
{
//    imgArr = [[NSMutableArray alloc]initWithCapacity:10];
//    imageDataUrlArr = [[NSMutableArray alloc]initWithCapacity:10];
    if (kScreenHeight >480) {
        _baseScrollView.scrollEnabled = NO;
    }else{
        _baseScrollView.scrollEnabled = YES;
        [_baseScrollView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight+20)];
    }
    
    UIImage *img1 = [UIImage imageNamed:@"type"];
    UIImage *img2 = [UIImage imageNamed:@"content"];
    UIImage *img3 = [UIImage imageNamed:@"content_area"];
    UIImage *img4 = [UIImage imageNamed:@"upload_btn"];
    UIImage *img5 = [UIImage imageNamed:@"upImg"];
    
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, img1.size.width-10, img1.size.height-10)];
    imgView1.image = img1;
    imgView1.backgroundColor = [UIColor clearColor];
    [_baseScrollView addSubview:imgView1];
    
    UILabel *lable1 = [UnityLHClass initUILabel:@"反馈类型" font:12.0 color:[UIColor blackColor] rect:CGRectMake(40, 17, 60, 20)];
    [_baseScrollView addSubview:lable1];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(100, 26, kScreenWidth-120, 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
    [_baseScrollView addSubview:lineView1];
    
    NSArray *btnArray = @[@"APP使用",@"工作量",@"问题",@"提议",@"其他"];
    UIImage *btnImg = [UIImage imageNamed:@"type_tag_bg"];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(40+70*i, 50, btnImg.size.width/2+5, btnImg.size.height/2+5)];
        [button setBackgroundImage:btnImg forState:UIControlStateNormal];
        [button setTitle:[btnArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11.0];
        button.tag = 10+i;
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        [_baseScrollView addSubview:button];
        
        if (i == 4) {
            [button setFrame:CGRectMake(40, 80, btnImg.size.width/2+5, btnImg.size.height/2+5)];
        }
    }
    
    
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120, img2.size.width-10, img2.size.height-10)];
    imgView2.image = img2;
    imgView2.backgroundColor = [UIColor clearColor];
    [_baseScrollView addSubview:imgView2];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(100, 126, kScreenWidth-120, 1)];
    lineView2.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
    [_baseScrollView addSubview:lineView2];
    
    UILabel *lable2 = [UnityLHClass initUILabel:@"反馈内容" font:12.0 color:[UIColor blackColor] rect:CGRectMake(40, 117, 60, 20)];
    [_baseScrollView addSubview:lable2];
    
    //    UIImageView *imgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(40, 140, kScreenWidth-60, img3.size.height/2)];
    //    imgView3.image = img3;
    //    [_baseScrollView addSubview:imgView3];
    
    UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(40, 145, kScreenWidth-60, img3.size.height/2)];
    textV.font = [UIFont systemFontOfSize:11.0];
    textV.textColor = [UIColor blackColor];
    textV.backgroundColor = [UIColor whiteColor];
    textV.delegate = self;
    [_baseScrollView addSubview:textV];
    
    placeholderLabel = [UnityLHClass initUILabel:@"你的反馈内容..." font:10.0 color:[UIColor grayColor] rect:CGRectMake(5, 5, 100, 15)];
    [textV addSubview:placeholderLabel];
    
    UIImageView *imgView4 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 262, img5.size.width/2.5, img5.size.height/2.5)];
    imgView4.image = img5;
    [_baseScrollView addSubview:imgView4];
    
    UILabel *lable3 = [UnityLHClass initUILabel:@"图片" font:12.0 color:[UIColor blackColor] rect:CGRectMake(40, 267, 60, 20)];
    [_baseScrollView addSubview:lable3];

    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(70, 276, kScreenWidth-90, 1)];
    lineView3.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
    [_baseScrollView addSubview:lineView3];
    
    UIView *headView = [self tableHeadView];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 350-64, kScreenWidth, kScreenHeight-267) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = headView;
    myTableView.scrollEnabled = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    [_baseScrollView addSubview:myTableView];
}

#pragma mark ==  UITableView
-(UIView *)tableHeadView
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImage *img4 = [UIImage imageNamed:@"upload_btn"];
    UIImage *addImg = [UIImage imageNamed:@"addImage"];
    UIImage *deleteImg = [UIImage imageNamed:@"delete-circular"];//
    
    
    for (int i = 0; i < imgArr.count+1; i++) {
        
        photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(40+i*(img4.size.width/2+16), 30, img4.size.width/2, img4.size.height/2)];
        if (imgArr.count == 0) {
            photoImgView.image = addImg;
        }else if (i == imgArr.count) {
        }
        else{
           photoImgView.image = [imgArr objectAtIndex:i];
        }
        
        photoImgView.userInteractionEnabled = YES;
        [view addSubview:photoImgView];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setBackgroundImage:deleteImg forState:UIControlStateNormal];
        [deleteBtn setFrame:CGRectMake(36+i*(img4.size.width/2+16), 20, deleteImg.size.width/2, deleteImg.size.height/2)];
        deleteBtn.tag = 100+i;
        deleteBtn.hidden = YES;
        [deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteBtn];
        
        if (i == 3) {
            [photoImgView setFrame:CGRectMake(40, 30+img4.size.width/2, img4.size.width/2, img4.size.height/2)];
            [deleteBtn setFrame:CGRectMake(36, 20+img4.size.width/2, deleteImg.size.width/2, deleteImg.size.height/2)];
        }
        
        
        
        
        UIButton *upImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [upImgBtn setFrame:CGRectMake(0, 0, img4.size.width/2, img4.size.height/2)];
        [upImgBtn setBackgroundImage:img4 forState:UIControlStateNormal];
        [upImgBtn addTarget:self action:@selector(upImgBtn) forControlEvents:UIControlEventTouchUpInside];
        [photoImgView addSubview:upImgBtn];
 
        if (imgArr.count == 4) {
            photoImgView.hidden = NO;
            upImgBtn.hidden = YES;
            deleteBtn.hidden = NO;
        }else{
            if (i == imgArr.count) {
                //                photoImgView.hidden = YES;
                upImgBtn.hidden = NO;
                deleteBtn.hidden = YES;
            }else{
                upImgBtn.hidden = YES;
                deleteBtn.hidden = NO;
                photoImgView.hidden = NO;
                
            }
        }
        
    }
    
    UIImage *subImg = [UIImage imageNamed:@"button_bg"];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setFrame:CGRectMake(20, 450-275, kScreenWidth-40, subImg.size.height/2)];
    [submitBtn setBackgroundImage:subImg forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    [submitBtn addTarget:self action:@selector(submitBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitBtn];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}




-(void)submitBtn
{

    
    if (backTypeStr == nil ) {
        [self showAlertWithTitle:@"提示" :@"请选择反馈类型" :@"确定" :@"取消"];
    }else if (backtextStr == nil){
        [self showAlertWithTitle:@"提示" :@"请输入反馈内容" :@"确定" :@"取消"];
    }else{
        
        NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/myInfo/AddFeedBackinfo.json?operationTime=%@&accessToken=%@&backType=%@&backValue=%@",ADDR_IP,ADDR_DIR,opreatinTime,accessToken,backTypeStr,backtextStr];

        NSLog(@"uid == %@",requestUrl);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [manager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

            for (int i = 0; i < imageDataUrlArr.count; i++) {
                
                
                if (imageDataUrlArr.count == 0) {
                    
                }else{
                    NSURL *imgUrl = [imageDataUrlArr objectAtIndex:i];
                    [formData appendPartWithFileURL:imgUrl name:[NSString stringWithFormat:@"image%d",i] error:nil];
                }

                
            }
            
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Success: %@", responseObject);
            if ([[responseObject objectForKey:@"result"]isEqualToString:@"0000000"]) {
                HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
                //弹出框的类型
                hud.mode = HWBProgressHUDModeText;
                //弹出框上的文字
                hud.detailsLabelText = @"反馈成功";
                //弹出框的动画效果及时间
                [hud showAnimated:YES whileExecutingBlock:^{
                    //执行请求，完成
                    sleep(1);
                } completionBlock:^{
                    //完成后如何操作，让弹出框消失掉
                    [hud removeFromSuperview];
                }];

            }else{
                HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
                //弹出框的类型
                hud.mode = HWBProgressHUDModeText;
                //弹出框上的文字
                hud.detailsLabelText = @"反馈失败";
                //弹出框的动画效果及时间
                [hud showAnimated:YES whileExecutingBlock:^{
                    //执行请求，完成
                    sleep(1);
                } completionBlock:^{
                    //完成后如何操作，让弹出框消失掉
                    [hud removeFromSuperview];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
        }];
    }
}

-(void)button:(UIButton *)sender
{
    UIImage *wxzBtnImg = [UIImage imageNamed:@"type_tag_bg"]; //未选中button的图片
    UIImage *xzBtnImg = [UIImage imageNamed:@"type_tag_bg_cur"];  //选中button的图片
    UIButton* btn1 = (UIButton*)[_baseScrollView viewWithTag:10];
    UIButton* btn2 = (UIButton*)[_baseScrollView viewWithTag:11];
    UIButton* btn3 = (UIButton*)[_baseScrollView viewWithTag:12];
    UIButton* btn4 = (UIButton*)[_baseScrollView viewWithTag:13];
    UIButton* btn5 = (UIButton*)[_baseScrollView viewWithTag:14];
    
    if (sender.tag == 10) {
        NSLog(@"0");
        backTypeStr = @"1";
        [btn1 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn4 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn5 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }else if (sender.tag == 11) {
        NSLog(@"1");
        backTypeStr = @"2";
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn4 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn5 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }else if (sender.tag == 12) {
        NSLog(@"2");
        backTypeStr = @"3";
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn4 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn5 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }else if (sender.tag == 13) {
        NSLog(@"3");
        backTypeStr = @"4";
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn4 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn5 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }else if (sender.tag == 14){
        NSLog(@"4");
        backTypeStr = @"5";
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn4 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn5 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
}

-(void)leftAction
{
    if (self.tag == 10) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=110;
    frame.size.height +=110;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backtextStr = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{    if (![text isEqualToString:@""])
    
    {
        
        placeholderLabel.hidden = YES;
        
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        placeholderLabel.hidden = NO;
        
    }
    
    return YES;
    
}

- (void)upImgBtn
{
    
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [chooseImageSheet showInView:self.view];
    
    
    
}

#pragma mark -照片功能
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://拍照
        {
            [self takePhoto];
        }
            break;
        case 1://本地相册
        {
            [self LocalPhoto];
        }
            break;
        case 2:
        {
        }
            break;
        default:
            break;
    }
}




//从相册选择
-(void)LocalPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 4-imgArr.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 4-imgArr.count;
        } else {
            return YES;
        }
        
    }];
    
    [self presentViewController:picker animated:NO completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{

    NSLog(@"%@",assets.description);
    
    for (int i=0; i<assets.count; i++) {
        
        ALAsset *asset = assets[i];
        
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"yyyy-MM-dd-hh:mm:ss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *imageName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            [self saveImage:tempImg WithName:imageName];
            
            
        });
    }
   
}


//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:NO];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 创建imdge 接收图片
    UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    image = [UIImage imageWithData:imageData];
    UIImage *imageInfo = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* imageResult = [self imageWithImageSimple:image scaledToSize:CGSizeMake(imageInfo.size.width, 320)];
    addImgView.hidden = NO;
    addImgView.image = image;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd-hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"%@.png",dateString];
    [self saveImage:imageResult WithName:imageName];
    
    // 关闭picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
#pragma mark -保存图片的路径
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSLog(@"%@",imageName);
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSURL *url = [NSURL fileURLWithPath:fullPathToFile];
    imageDataUrl = url;
    strPath = fullPathToFile;
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    [imgArr addObject:tempImage];
    [imageDataUrlArr addObject:imageDataUrl];
    
    
    UIView *headView = [self tableHeadView];
    myTableView.tableHeaderView = headView;
    [myTableView reloadData];
    
}

-(void)deleteBtn:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    [imgArr removeObjectAtIndex:sender.tag-100];
    [imageDataUrlArr removeObjectAtIndex:sender.tag-100];
    UIView *headView = [self tableHeadView];
    myTableView.tableHeaderView = headView;
    [myTableView reloadData];
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


#pragma mark == 上传图片请求
-(void)editUserPhoto
{
    NSLog(@"strPath == %@",strPath);
    
    
    if (strPath == nil || strPath.length <= 0){
        
        [self showAlertWithTitle:@"提示" :@"请选择上传的图片" :@"OK" :nil];
        
    } else{
        
        ASIFormDataRequest *request = [[ASIFormDataRequest  alloc]initWithURL:[NSURL URLWithString:@"http://i.duc.cn/setting/setUserInfo?"]];
        request.delegate=self;
        [request addFile:strPath forKey:@"file"]; // 路径
        
        [request startAsynchronous];
    }
}


@end
