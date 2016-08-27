//
//  SoureSearchController.m
//  telecom
//
//  Created by Sundear on 16/3/11.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SoureSearchController.h"
#import "ZYQAssetPickerController.h"
#import "HWBProgressHUD.h"

@interface SoureSearchController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ZYQAssetPickerControllerDelegate,UIAlertViewDelegate>{
    
    NSString *_str;
    
    
    
    NSString *strPath;
    NSURL *imageDataUrl;
    UIImageView *addImgView;
    UIImageView *photoImgView;
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    UITableView *myTableView;
    UIView *view;
    UILabel *_label;
}
@property(nonatomic,strong)UILabel *placeHlabel;

@end

@implementation SoureSearchController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addNavigationRightButtonForStr:nil WithImage:@"checkBtn.png"];
    [self.view addSubview:[UnityLHClass initUILabel:@"现场情况描述:" Font:12.0 Color:[UIColor blackColor] Rect:RECT(20, 70, 150, 25)]];
    
    UITextView *Textview = [[UITextView alloc]initWithFrame:RECT(20, 100, self.view.frame.size.width-40, 80)];
    Textview.layer.borderWidth = 1.2;
    Textview.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:Textview];
    Textview.delegate = self;
    self.placeHlabel = [UnityLHClass initLabel:@"请简要描述你的问题和意见" font:12.0 color:[UIColor lightGrayColor]  color:[UIColor clearColor] rect:RECT(1, 5, 150, 25) radius:0];
    [Textview addSubview:self.placeHlabel];
    _label = [UnityLHClass initUILabel:@"附件(选填，提供问题截图)" Font:12.0 Color:[UIColor lightGrayColor] Rect:RECT(20, CGRectGetMaxY(Textview.frame)+10, 150, 25)];
    [self.view addSubview:_label];
    
    [self initView];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeHlabel.hidden=YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{    if (![text isEqualToString:@""]){
    self.placeHlabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        self.placeHlabel.hidden = NO;
    }
    return YES;
    
}
-(void)textViewDidChange:(UITextView *)textView{
        _str = textView.text;
}
#pragma mark 下面都是选择图片的======================
-(void)initView
{
    imgArr = [NSMutableArray array];
    imageDataUrlArr = [NSMutableArray array];
    if (kScreenHeight >480) {
        _baseScrollView.scrollEnabled = NO;
    }else{
        _baseScrollView.scrollEnabled = YES;
        [_baseScrollView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight+20)];
    }
    
    
    UIImage *img4 = [UIImage imageNamed:@"upload_btn"];
    
    UIView *headView = [self tableHeadView];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,150, kScreenWidth, kScreenHeight-267) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = headView;
    myTableView.scrollEnabled = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.backgroundColor = [UIColor redColor];
    [_baseScrollView addSubview:myTableView];
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
                upImgBtn.hidden = NO;
                deleteBtn.hidden = YES;
            }else{
                upImgBtn.hidden = YES;
                deleteBtn.hidden = NO;
                photoImgView.hidden = NO;
                
            }
        }
        
    }
    return view;
}

#pragma mark 提交按钮
-(void)rightAction
{
    if ([_str isEqualToString:@""] ) {
        showAlert(@"请输入您宝贵的意见和建议");
    }else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"http://%@/%@/MyTask/AddFualtRisk.json",ADDR_IP,ADDR_DIR];
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        par[@"accessToken"]=UGET(U_TOKEN);
        par[@"opreatinTime"]=date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");

        [manager POST:url parameters:par constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
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
                hud.detailsLabelText = @"提交成功";
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
                hud.detailsLabelText = @"提交失败";
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
        //        [request addPostValue:strID forKey:@"userId"]; //用户名
        [request addFile:strPath forKey:@"file"]; // 路径
        [request startAsynchronous];
    }
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
