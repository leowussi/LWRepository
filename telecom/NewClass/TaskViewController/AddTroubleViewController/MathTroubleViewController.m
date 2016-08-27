//
//  AddTroubleViewController.m
//  telecom
//
//  Created by Sundear on 16/2/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "MathTroubleViewController.h"
#import "TroubleHeaderFooterView.h"
#import "TemporaryHeadView.h"
#import "AddTableViewHead.h"
#import "FiltViewController.h"
#import "HWBProgressHUD.h"
#import "IQKeyboardManager.h"
#import "ZYQAssetPickerController.h"


typedef void(^MathBlock)(NSString * , NSString *);
@interface MathTroubleViewController()<UITableViewDelegate,UITableViewDataSource,AddTableViewHeadDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>{
    AddTableViewHead *_plainView;
    UITableView *_mytableView;
    BOOL isOpen;//第0区是否展开
    BOOL isOpen1;//第1区是否展开
    
    NSString *_faultCategory ;//隐患分类ID；
    NSString *_faultLevel  ;//隐患等级ID；
    NSString *_regionId ;//区局ID；
    NSString *_specId  ;//区局ID；
    NSString *_faultType ;// 	隐患部位类型：0表示网元 1表示站点
    NSString *_typeId  ;//隐患部位ID：即用户选择数据的网元ID或者站点ID,此字段和faultType匹配使用,当用户选择网元数据时,faultType要传入0,当选择站点数据时,faultType要传入1
    NSString *_content;//隐患现象
    NSString *_sitRegionId;//出参对应专业id
    NSString *_nuRegionId;//出参对应网元id
    NSString *_TiJiaoRegionId;//最后提交对应部门id 部门区局ID:此字段传入为勾选网元或者站点时所在的区局ID信息、不是下拉框的值
    
    
    //    NSMutableArray *_siteList;//站点json数据
    //    NSMutableArray *_nuList;//网元json数据
    UIButton *yhInfoLable;
    UITextField *checkFiled;
    UILabel *placeholderLabel;
    UITableView *SelectTabview;
    
    
    
#pragma mark 提交图片必须数据
    NSString *strPath;
    NSURL *imageDataUrl;
    UIImageView *addImgView;
    UIImageView *photoImgView;
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    UITableView *myTableView;
    UIView *view;
}
@property(nonatomic,strong)NSMutableArray *arrSitList;//站点json数据
@property(nonatomic,strong)NSMutableArray *arrNuList;//网元json数据
@property(nonatomic,weak)UITextView *taskTextView;
@end

@implementation MathTroubleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable=NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.title = @"新增隐患";
    _TiJiaoRegionId = nil;
    [self setUpRightBarButton];
#pragma mark 添加头部控件
    [self setUpHeadView];
#pragma mark 添加tableview
    [self setTableView];
#pragma mark 添加隐患
    [self setYinHuan];
#pragma mark 添加附件
    
    [self setFuJian];
    [self initView];
    
}


-(void)setUpHeadView{
    _faultLevel=@"0";//默认为0
    _plainView= [[[NSBundle mainBundle] loadNibNamed:@"AddTableViewHead" owner:nil options:nil] lastObject];
    _plainView.frame = CGRectMake(0, 0,SCREEN_W-40, _plainView.frame.size.height);
    _plainView.nomalBtn.selected=YES;
    _plainView.delegate =self;
    [_baseScrollView addSubview:_plainView];
}
#pragma mark addTableviewDelegate
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

#pragma mark 添加table
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
            return  isOpen?self.arrNuList.count:0;
        }else if (section==1) {
            
            return  isOpen1?self.arrSitList.count:0;
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
            cell.textLabel.text = self.arrNuList[indexPath.row][@"name"];
        }
        if (indexPath.section==1) {
            cell.textLabel.text = self.arrSitList[indexPath.row][@"name"];
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
        headv.label1.text = [NSString stringWithFormat:@"匹配网元   %lu",(unsigned long)self.arrNuList.count];
    }
    if (section == 1) {
        headv.label1.text = [NSString stringWithFormat:@"匹配局站   %lu",(unsigned long)self.arrSitList.count];
    }
    
    headv.label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    headv.bgBtn.tag = 1000+section;
    
    [headv.bgBtn addTarget:self action:@selector(expButton:) forControlEvents:UIControlEventTouchUpInside];
    return headv;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
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
#pragma mark 验证按钮点击
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
        self.arrSitList = [NSMutableArray array];
        self.arrNuList = [NSMutableArray array];
        httpPOST(par, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                [self.arrSitList addObjectsFromArray:result[@"siteList"]];
                [self.arrNuList addObjectsFromArray: result[@"nuList"]];
                [SelectTabview reloadData];
            }
            
        }, ^(id result) {
            
        });
    }
}

-(void)setYinHuan{
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(SelectTabview.frame)+10, 60, 20)];
    lab.text = @"隐患现象";
    lab.font = [UIFont systemFontOfSize:12];
    [_baseScrollView addSubview:lab];
    CGFloat taskX =CGRectGetMaxX(lab.frame)+5;
    UITextView *taskTextView = [[UITextView alloc]initWithFrame:CGRectMake(taskX, CGRectGetMaxY(SelectTabview.frame)+10, CGRectGetMaxX(SelectTabview.frame)-taskX, 60)];
    taskTextView.font = [UIFont systemFontOfSize:13.0];
    taskTextView.delegate = self;
    taskTextView.layer.borderWidth = 1.0;
    taskTextView.layer.borderColor = [RGBCOLOR(236, 236, 236) CGColor];
    self.taskTextView = taskTextView;
    
    [_baseScrollView addSubview:self.taskTextView];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:self.taskTextView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBegFrame:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillEndFrame:) name:UITextViewTextDidEndEditingNotification object:nil];
    
    placeholderLabel = [UnityLHClass initUILabel:@"请输入隐患内容" font:12.0 color:[UIColor grayColor] rect:CGRectMake(5, 3, 100, 20)];
    [self.taskTextView addSubview:placeholderLabel];
    [_baseScrollView addSubview:self.taskTextView];
    
}
#pragma mark - 监听方法
- (void)keyboardWillBegFrame:(NSNotification *)note
{
    self.view.window.backgroundColor = [UIColor whiteColor];
    
    // 0.取出键盘动画的时间
    CGFloat duration = 0.25;
    
    // 1.需要向上移动的距离
    CGFloat transformY = -(kScreenHeight -CGRectGetMaxY(self.taskTextView.frame));

    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}
- (void)keyboardWillEndFrame:(NSNotification *)note
{
    self.view.window.backgroundColor = [UIColor whiteColor];
    
    // 0.取出键盘动画的时间
    CGFloat duration = 0.25;

    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    UIImage* filterimage = [UIImage imageNamed:@"123.png"];
    UIButton* filter = [[UIButton alloc] initWithFrame:RECT((APP_W-10-30), (NAV_H-30)/2,                                                        30, 30)];
    [filter setBackgroundImage:filterimage forState:0];
    [filter addTarget:self action:@selector(submitBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem1 = [[UIBarButtonItem alloc] initWithCustomView:filter];
    self.navigationItem.rightBarButtonItem=barBtnItem1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:SelectTabview]) {
        DLog(@"%@,%@",self.arrSitList,self.arrNuList);
        if (indexPath.section==0) {//网元
            _faultType = @"0";
            _typeId = self.arrNuList[indexPath.row][@"id"];
            _TiJiaoRegionId = self.arrNuList[indexPath.row][@"regionId"];
            _plainView.textK.text =self.arrNuList[indexPath.row][@"name"];
        }
        if (indexPath.section==1) {//站点
            _faultType = @"1";
            _typeId = self.arrSitList[indexPath.row][@"id"];
            _TiJiaoRegionId = self.arrSitList[indexPath.row][@"regionId"];
            _plainView.textK.text =self.arrSitList[indexPath.row][@"name"];
        }
    }
}
#pragma mark - 添加附件label
-(void)setFuJian{
    CGFloat Y =  CGRectGetMaxY(self.taskTextView.frame)+10;
    CGFloat W =  CGRectGetMaxX(SelectTabview.frame)-17;
    yhInfoLable =[UIButton buttonWithType:UIButtonTypeCustom];
    yhInfoLable.frame =CGRectMake(17,Y, W, 20);
    yhInfoLable.backgroundColor = RGBCOLOR(86, 207, 222);
    [yhInfoLable setTitle:@"附件信息" forState:UIControlStateNormal];
    yhInfoLable.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    yhInfoLable.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    yhInfoLable.titleLabel.font = [UIFont systemFontOfSize:13];
    yhInfoLable.userInteractionEnabled = NO;
    [_baseScrollView addSubview:yhInfoLable];
    
}



#pragma mark 下面都是选择图片的======================
-(void)initView
{
    imgArr = [[NSMutableArray alloc]initWithCapacity:10];
    imageDataUrlArr = [[NSMutableArray alloc]initWithCapacity:10];
    if (kScreenHeight >480) {
        _baseScrollView.scrollEnabled = NO;
    }else{
        _baseScrollView.scrollEnabled = YES;
        [_baseScrollView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight+20)];
    }
    
    
    UIImage *img4 = [UIImage imageNamed:@"upload_btn"];
    
    UIView *headView = [self tableHeadView];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(yhInfoLable.frame)+5, kScreenWidth, kScreenHeight-267) style:UITableViewStylePlain];
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
-(void)submitBtn
{
    if (_faultCategory == nil ) {
        [self showAlertWithTitle:@"提示" :@"请选择隐患分类" :@"确定" :@"取消"];
    }else if(_TiJiaoRegionId==nil) {
        [self showAlertWithTitle:@"提示" :@"请选择匹配网元或者匹配局站" :@"确定" :@"取消"];
    }else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"http://%@/%@/MyTask/AddFualtRisk.json",ADDR_IP,ADDR_DIR];
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        par[@"accessToken"]=UGET(U_TOKEN);
        par[@"opreatinTime"]=date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        par[@"faultCategory"] =_faultCategory;
        par[@"faultLevel"] =_faultLevel;
        par[@"regionId"] = _TiJiaoRegionId;
        par[@"specId"] =_specId;
        par[@"faultType"] = _faultType;
        par[@"typeId"] =_typeId;
        par[@"content"] = _content;
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
-(void)textViewDidChange:(UITextView *)textView{
    _content = textView.text;
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
        
        //        [request addPostValue:strID forKey:@"userId"]; //用户名
        [request addFile:strPath forKey:@"file"]; // 路径
        
        [request startAsynchronous];
        
        
    }
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
