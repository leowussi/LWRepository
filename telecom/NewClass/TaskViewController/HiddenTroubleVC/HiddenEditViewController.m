//
//  HiddenEditViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "HiddenEditViewController.h"
#import "ZYQAssetPickerController.h"
#import "HWBProgressHUD.h"
#import "ASIHTTPRequest.h"

#import "TemporaryHeadView.h"
#import "FiltViewController.h"
#import "AddTableViewHead.h"

@interface HiddenEditViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,AddTableViewHeadDelegate>
{
    NSString *strPath;
    NSURL *imageDataUrl;
    UILabel *placeholderLabel;
    UITextView *myTextView;
    UIImageView *addImgView;
    UIImageView *photoImgView;
    NSString *backTypeStr;//反馈类型
    NSString *backtextStr;//反馈内容
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    UITableView *myTableView;
    UIView *view;
    AddTableViewHead *_plainView;
    NSString *_regionId;
    NSString *_SelRegionid;
    NSString *_specId;
    NSString *_faultCategory;
    NSString *_faultLevel;
    NSMutableArray *_siteList;//站点
    NSMutableArray *_nuList;//网元
    UITableView *SelectTabview;
    UITableView *_mytableView;
    BOOL isOpen;
    BOOL isOpen1;
    NSString  *_faultType;
    NSString  *_typeId ;
}
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)NSMutableArray *imagesFullPathArray;
@property(nonatomic,strong)NSMutableArray *fileIdArray;
@property(nonatomic,strong)NSMutableArray *ReferenceURLs;

@property(nonatomic,strong)UIScrollView *attachmentInfo;

@end

@implementation HiddenEditViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐患编辑";
     _faultLevel=@"0";//默认为0
    _SelRegionid=nil;
    [self addNavigationLeftButton];
    [self addNavigationRightButton:@"123.png"];
    // Do any additional setup after loading the view.
    [_baseScrollView setBackgroundColor:[UIColor whiteColor]];
    
    imgArr = [[NSMutableArray alloc]initWithCapacity:10];
    imageDataUrlArr = [[NSMutableArray alloc]initWithCapacity:10];
    _baseScrollView.frame = CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height+64);
    NSLog(@"%@",self.dic);
    backTypeStr = [[self.dic objectForKey:@"dangerCategoryCode"] description];
    [self initView];

}

-(void)setTableView{
    SelectTabview = [[UITableView alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(_plainView.frame), SCREEN_W-40, 100) style:UITableViewStyleGrouped];
    
    [SelectTabview addSubview:_mytableView];
    SelectTabview.rowHeight=40;
    SelectTabview.delegate = self;
    SelectTabview.dataSource = self;
    SelectTabview.backgroundColor = [UIColor whiteColor];
    [_baseScrollView addSubview:SelectTabview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:SelectTabview]) {
        return 2;
    }else{
        
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:SelectTabview]) {
        
        if (section==0) {
            return  isOpen?_nuList.count:0;
        }else if (section==1) {
            
            return  isOpen1?_siteList.count:0;
        }
        return 0;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:SelectTabview]) {
        static NSString *ID = @"tabcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            UIImage *im = [UIImage imageNamed:@"新增自定义任务-手动输入-箭头-右-灰.png"];
            UIImage *imH = [UIImage imageNamed:@"新增自定义任务-手动输入-箭头-右-白"];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            UIImageView *access = [[UIImageView alloc]initWithImage:im highlightedImage:imH];
            access.bounds=CGRectMake(0, 0, 15, 15);
            cell.accessoryView = access;
            UIView *backview = [[UIView alloc]initWithFrame:cell.frame];
            backview.backgroundColor = RGBCOLOR(122, 228, 0);
            cell.selectedBackgroundView = backview;
            
        }
        if (indexPath.section==0) {
            cell.textLabel.text = _nuList[indexPath.row][@"name"];
        }
        if (indexPath.section==1) {
            cell.textLabel.text = _siteList[indexPath.row][@"name"];
        }
        return cell;
    }else{
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TemporaryHeadView *headv = [[TemporaryHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headv.backgroundColor = RGBCOLOR(226, 226, 226);
    
    if (section == 0) {
        headv.label1.text = [NSString stringWithFormat:@"匹配网元   %lu",(unsigned long)_nuList.count];
    }
    if (section == 1) {
        headv.label1.text = [NSString stringWithFormat:@"匹配局站   %lu",(unsigned long)_siteList.count];
    }
    
    headv.label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    headv.bgBtn.tag = 1000+section;
    
    [headv.bgBtn addTarget:self action:@selector(expButton:) forControlEvents:UIControlEventTouchUpInside];
    return headv;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:SelectTabview]) {
        if (indexPath.section==0) {//网元
            _faultType = @"0";
            _typeId = _nuList[indexPath.row][@"id"];
            _SelRegionid =_nuList[indexPath.row][@"regionId"];
            _plainView.textK.text =_nuList[indexPath.row][@"name"];
        }
        if (indexPath.section==1) {//站点
            _faultType = @"1";
            _typeId = _siteList[indexPath.row][@"id"];
            _SelRegionid =_siteList[indexPath.row][@"regionId"];
            _plainView.textK.text =_siteList[indexPath.row][@"name"];
        }
    }
}

-(void)expButton:(UIButton*)btn
{
    if (btn.tag == 1000) {
        isOpen =!isOpen;
    }
    if (btn.tag == 1001) {
        isOpen1 =!isOpen1;
    }
    [SelectTabview reloadData];
}

-(void)BMbtnClick:(NSArray *)array{
    FiltViewController *vc = [[FiltViewController alloc]init];
    _regionId = nil;
    vc.array = array;
    vc.bloc = ^(NSString *str,NSString *ID){
        NSString *st = [NSString stringWithFormat:@"     %@",str];
        _regionId =ID;
        _plainView.BMbtn.titleLabel.text = st;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//
-(void)ZYbtnClick:(NSArray *)array{
    FiltViewController *vc = [[FiltViewController alloc]init];
    _specId = nil;
    vc.array = array;
    vc.bloc = ^(NSString *str,NSString *ID){
        NSString *st = [NSString stringWithFormat:@"     %@",str];
        _specId = ID;
        _plainView.ZYbtn.titleLabel.text = st;
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)YinHuanGroup:(NSString *)str{
    _faultCategory = str;
}
-(void)YinHuanSelsct:(NSString *)str{
    _faultLevel=str;
}
-(void)YanZhenBtnCick{
    
    
    if (_specId==nil || _regionId==nil || [_plainView.textK.text isEqualToString:@""]) {
        
        HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
        //弹出框的类型
        hud.mode = HWBProgressHUDModeText;
        //弹出框上的文字
        hud.detailsLabelText = @"必须选择部门和专业！隐患部位也要填哦！";
        //弹出框的动画效果及时间
        [hud showAnimated:YES whileExecutingBlock:^{
            //执行请求，完成
            sleep(2.5);
        } completionBlock:^{
            //完成后如何操作，让弹出框消失掉
            [hud removeFromSuperview];
        }];
    }else{
        
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        [par setObject:@"MyTask/SearchSiteNuInfo" forKey:URL_TYPE];
        [par setObject:_regionId forKey:@"regionId"];
        [par setObject:_specId forKey:@"specId"];
        [par setObject:_plainView.textK.text forKey:@"inName"];
        DLog(@"%@",par);
        
        httpPOST(par, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                _siteList = result[@"siteList"];
                _nuList = result[@"nuList"];
                [SelectTabview reloadData];
            }
            
        }, ^(id result) {
            
        });
    }
}

-(void)initView
{
    
    _plainView = [[[NSBundle mainBundle]loadNibNamed:@"AddTableViewHead" owner:nil options:nil]lastObject];
    _plainView.delegate=self;
    _plainView.nomalBtn.selected=YES;
    _plainView.frame =CGRectMake(0, 133, _plainView.frame.size.width, _plainView.frame.size.height);
    [_baseScrollView addSubview:_plainView];
    
    NSArray *leftArr = @[@"隐患编号:",@"当前状态:",@"提交时间:"];
    
    for (int i = 0; i < leftArr.count; i++) {
        UILabel *leftLable = [UnityLHClass initUILabel:[leftArr objectAtIndex:i] font:12.0 color:[UIColor blackColor] rect:CGRectMake(20, 74+i*25, 65, 20)];
        [_baseScrollView addSubview:leftLable];
    }
    //隐患编号
    UILabel *yhNumLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(88, 74, 205, 20)];
    yhNumLable.text = [self.dic objectForKey:@"dangerNum"];
    [_baseScrollView addSubview:yhNumLable];
    
    //当前状态
    UILabel *ztLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(88, 99, 205, 20)];
    ztLable.text = [self.dic objectForKey:@"dangerStatusName"];
    [_baseScrollView addSubview:ztLable];
    
    //提交时间
    UILabel *dateLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(88, 124, 205, 20)];
    dateLable.text = [self.dic objectForKey:@"commiteTime"];
    [_baseScrollView addSubview:dateLable];
    
    DLog(@"%@",self.dic);
    if ([self.dic[@"dangerCategoryCode"] isEqualToString:@"2"]) {//安全环境
        _plainView.SafeAndState.selected = YES;
        _faultCategory = @"2";
    }else{
        _plainView.sheBei.selected = YES;
        _faultCategory = @"1";
    }
    
    if ([self.dic[@"dangerLevelCode"] isEqualToString:@"0"]) {//一般
        _plainView.nomalBtn.selected =YES;
        _faultLevel = @"0";
    }else{
        _plainView.zhongDa.selected =YES;
        _faultLevel = @"1";
        _plainView.nomalBtn.selected =NO;
    }
    
    
    
    _plainView.BMbtn.titleLabel.text = [NSString stringWithFormat:@"     %@",self.dic[@"dangerRegionName"]];
    _regionId =self.dic[@"dangerRegionCode"];
    
    _plainView.ZYbtn.titleLabel.text =[NSString stringWithFormat:@"     %@",self.dic[@"dangerSpecName"]];
    _specId = self.dic[@"dangerSpecCode"];
    
    
    if ([self.dic[@"nuName"] isEqualToString:@""]) {
        _plainView.textK.text =self.dic[@"siteName"];
    }else{
        _plainView.textK.text =self.dic[@"nuName"];
    }
    

    
    
    
    
    [self setTableView];
    
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(SelectTabview.frame)+10, 60, 20)];
    lab.text = @"隐患现象";
    lab.font = [UIFont systemFontOfSize:12];
    [_baseScrollView addSubview:lab];
    

    myTextView = [[UITextView alloc] initWithFrame:RECT(75, CGRectGetMinY(lab.frame), APP_W-96, 70)];
    myTextView.layer.borderWidth = 1;
    myTextView.layer.borderColor = [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0] CGColor];
    myTextView.font = [UIFont systemFontOfSize:13.0];
    myTextView.delegate = self;
    [_baseScrollView addSubview:myTextView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(myTextView.frame)+5, kScreenWidth-20, 20)];
    lineView.backgroundColor = RGBCOLOR(16, 219, 232);
    [_baseScrollView addSubview:lineView];
    
    placeholderLabel = [UnityLHClass initUILabel:@"请输入内容..." font:10.0 color:[UIColor grayColor] rect:CGRectMake(5, 5, 100, 15)];
    [myTextView addSubview:placeholderLabel];
    
    if ([self.dic objectForKey:@"dangerContent"] == nil || [[self.dic objectForKey:@"dangerContent"] length] <= 0) {
        myTextView.text = @"";
        backtextStr = [NSString stringWithFormat:@"%@",myTextView.text];
        placeholderLabel.hidden = NO;
    }else{
        myTextView.text = [self.dic objectForKey:@"dangerContent"];
        backtextStr = [NSString stringWithFormat:@"%@",myTextView.text];
        placeholderLabel.hidden = YES;
    }
    
    UILabel *yhInfoLable = [UnityLHClass initUILabel:@"附件信息" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(10, 0, 70, 20)];
    yhInfoLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [lineView addSubview:yhInfoLable];
    
    
    UIView *headView = [self tableHeadView];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame)+10, kScreenWidth, kScreenHeight-267) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = headView;
    myTableView.scrollEnabled = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    [myTableView setBackgroundColor:[UIColor whiteColor]];
    _baseScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(myTableView.frame));
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
        
        photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*(img4.size.width/2+16), 10, img4.size.width/2, img4.size.height/2)];
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
        [deleteBtn setFrame:CGRectMake(6+i*(img4.size.width/2+16), 0, deleteImg.size.width/2, deleteImg.size.height/2)];
        deleteBtn.tag = 100+i;
        deleteBtn.hidden = YES;
        [deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteBtn];
        
        if (i == 3) {
            [photoImgView setFrame:CGRectMake(10, 10+img4.size.width/2, img4.size.width/2, img4.size.height/2)];
            [deleteBtn setFrame:CGRectMake(6, 0+img4.size.width/2, deleteImg.size.width/2, deleteImg.size.height/2)];
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
    
    return view;
}

#pragma mark == 右上方按钮
-(void)rightAction
{
    [myTextView resignFirstResponder];
    if (_faultCategory == nil ) {
        [self showAlertWithTitle:@"提示" :@"请选择隐患分类" :@"确定" :@"取消"];
    }else if(_faultType ==nil || _typeId ==nil) {
        [self showAlertWithTitle:@"提示" :@"请选择匹配网元或者匹配局站" :@"确定" :@"取消"];
    }else{
        NSString *url = [NSString stringWithFormat:@"http://%@/%@/MyTask/DisposeDangerOperate.json",ADDR_IP,ADDR_DIR];
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        par[@"accessToken"]=UGET(U_TOKEN);
        par[@"opreatinTime"]=date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        par[@"dangerId"] = self.strDangerId;
        par[@"actionStatus"] = @"1";// 	动作执行状态: 1表示编辑、2表示撤销、3整改隐患
        par[@"dangerCatetory"] =_faultCategory;
        par[@"faultLevel"] =_faultLevel;
        par[@"regionId"] = _SelRegionid;
        par[@"specId"] =_specId;
        par[@"faultType"] = _faultType;
        par[@"typeId"] =_typeId;
        par[@"dangerContent"] = backtextStr;

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
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

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.error);
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"-----%@",request.responseString);
    id myResult =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dic=(NSDictionary*)myResult;
    NSLog(@"%@",dic);
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

- (void)textViewDidEndEditing:(UITextView *)textView
{
    backtextStr = [NSString stringWithFormat:@"%@",textView.text];
}

- (void)upImgBtn
{
    [myTextView resignFirstResponder];
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


@end
