//
//  AddTemporaryViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AddTemporaryViewController.h"
#import "AddTemporaryDetailViewController.h"

#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"

#import "HWBProgressHUD.h"
//forward declare
@class IFlyDataUploader;
@class IFlyRecognizerView;

@interface AddTemporaryViewController ()<IFlyRecognizerViewDelegate,IFlySpeechSynthesizerDelegate>
{
    UIImageView *bigView;
    NSString *plistPath;
    NSData *data1;
    NSURL *stream;
    NSURL *streamUrl;
    NSString *testPath;
}

//带界面的听写识别对象
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;
//数据上传对象
@property (nonatomic, strong) IFlyDataUploader * uploader;

//声明语音合成的对象
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@end

@implementation AddTemporaryViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
    UIColor * color = [UIColor colorWithRed:0.0/255.0 green:133.0/255.0 blue:169.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = color;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    
    self.title = @"新增临时任务";
    // Do any additional setup after loading the view.
//    [self audio];
    
   
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"552504d3"];
    [IFlySpeechUtility createUtility:initString];
    
    self.iflyRecognizerView = [[IFlyRecognizerView alloc]initWithCenter:self.view.center];
    self.iflyRecognizerView.delegate = self;
    [self.iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名,默认目录是documents
    [self.iflyRecognizerView setParameter: @"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置返回的数据格式为默认plain
    [self.iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    [self initView];
}


-(void)leftAction
{
    UIColor *color = [UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = color;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView
{
    UIImageView *backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    backImgView.image = [UIImage imageNamed:@"新增临时任务-选择局站-语音-背景"];
    backImgView.userInteractionEnabled = YES;
    [self.view addSubview:backImgView];
    
    bigView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
//    bigView.image = [UIImage imageNamed:@"新增临时任务-选择局站-语音7-14-12"];
    bigView.userInteractionEnabled = YES;
//    bigView.hidden = YES;
    [self.view addSubview:bigView];
    
    UIImage *btnImg = [UIImage imageNamed:@"新增临时任务-选择局站-语音-按钮"];
    UIButton *yuyinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yuyinBtn setFrame:CGRectMake(kScreenWidth/2-btnImg.size.width/4, kScreenHeight-64-btnImg.size.height/5, btnImg.size.width/2, btnImg.size.height/2)];
    [yuyinBtn setImage:btnImg forState:UIControlStateNormal];
    [yuyinBtn addTarget:self action:@selector(yuyinBtn) forControlEvents:UIControlEventTouchUpInside];
    
//    [yuyinBtn addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [yuyinBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
//    
//    [yuyinBtn addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDragExit];
    
    [self.view addSubview:yuyinBtn];
    
    UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeBtn setFrame:CGRectMake(kScreenWidth-90, kScreenHeight-70, 70, 25)];
    [writeBtn setBackgroundColor:RGBCOLOR(0, 153, 176)];
    writeBtn.layer.masksToBounds = YES;
    writeBtn.layer.cornerRadius = 5;
    [writeBtn setTitle:@"手工写入" forState:UIControlStateNormal];
    [writeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    writeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [writeBtn addTarget:self action:@selector(writeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:writeBtn];
}


#pragma mark == 语言按钮
-(void)yuyinBtn
{
    bigView.hidden = NO;
    
    [self.iflyRecognizerView start];
    
}



-(void)btnDown:(id)sender
{
    NSLog(@"12");

    //创建录音文件，准备录音
    if ([recorder prepareToRecord]) {
        //开始
        [recorder record];
    }
    
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];

}

-(void)btnUp:(id)sender
{
    [bigView setImage:[UIImage imageNamed:@""]];
    double cTime = recorder.currentTime;
    if (cTime > 1) {//如果录制时间<2 不发送
        NSLog(@"发出去");
        [self submitVoice];
    }else {
        //删除记录的文件
        [recorder deleteRecording];
        //删除存储的
    }
    [recorder stop];
    [timer invalidate];
}

-(void)btnDragUp:(id)sender
{
    NSLog(@"34");
    [bigView setImage:[UIImage imageNamed:@""]];
    //删除录制文件
    [recorder deleteRecording];
    [recorder stop];
    [timer invalidate];

    HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
    //弹出框的类型
    hud.mode = HWBProgressHUDModeText;
    //弹出框上的文字
    hud.detailsLabelText = @"取消发送";
    //弹出框的动画效果及时间
    [hud showAnimated:YES whileExecutingBlock:^{
        //执行请求，完成
        sleep(1);
    } completionBlock:^{
        //完成后如何操作，让弹出框消失掉
        [hud removeFromSuperview];
    }];

}


- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
//    NSLog(@"%@",[NSString stringWithFormat:@"%@",result]);
    
    NSString *documentsPath =[self dirDoc];
    NSString *testPath1 = [documentsPath stringByAppendingPathComponent:@"/msc/asrview.pcm"];
//    NSData *data = [NSData dataWithContentsOfFile:testPath];
    
    stream = [NSURL fileURLWithPath:testPath1];
    NSLog(@"文件读取成功: %@",testPath1);
    
    if (stream == nil) {
        
    }else{
        [_iflyRecognizerView cancel];
        NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/myTask/GetRegionForMyTask.json?operationTime=%@&accessToken=%@",ADDR_IP,ADDR_DIR,opreatinTime,accessToken];
        
        NSLog(@"uid == %@",requestUrl);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileURL:stream name:@"file" error:nil];
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Success: %@", responseObject);
            if ([[responseObject objectForKey:@"result"]isEqualToString:@"0000000"]) {
                AddTemporaryDetailViewController *addVC = [[AddTemporaryDetailViewController alloc]init];
                addVC.dic = [responseObject objectForKey:@"detail"];
                [self.navigationController pushViewController:addVC animated:YES];
                UIColor *color = [UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0];
                self.navigationController.navigationBar.barTintColor = color;
            }else{
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            
        }];

    }

   
    
}

-(NSString *)dirDoc{
//    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%d",[error errorCode]);
}

#pragma mark == 
-(void)writeBtn
{
    AddTemporaryDetailViewController *addDetailVC = [[AddTemporaryDetailViewController alloc]init];
    [self.navigationController pushViewController:addDetailVC animated:YES];
    UIColor *color = [UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = color;
}


- (void)audio
{
    
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setObject:[NSNumber numberWithInt:16000] forKey:AVEncoderBitRateKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    

//    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];

    
    NSString *documentsPath =[self dirDoc];
    NSString *testPath1 = [documentsPath stringByAppendingPathComponent:@"record1.pcm"];
    NSLog(@"%@",testPath1);
    
    streamUrl = [NSURL fileURLWithPath:testPath1];
    data1 = [NSData dataWithContentsOfURL:streamUrl];
    
    NSError *error;
    NSError *error1;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error1];
    [session setActive:YES error:&error1];
    
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:streamUrl settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
//    NSLog(@"%lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [bigView setImage:[UIImage imageNamed:@""]];
    }else if (0.06<lowPassResults<=0.13) {
        [bigView setImage:[UIImage imageNamed:@""]];
    }else if (0.13<lowPassResults<=0.20) {
        [bigView setImage:[UIImage imageNamed:@"vioce1.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [bigView setImage:[UIImage imageNamed:@"vioce1.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [bigView setImage:[UIImage imageNamed:@"vioce1.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [bigView setImage:[UIImage imageNamed:@"vioce2.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [bigView setImage:[UIImage imageNamed:@"vioce2.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [bigView setImage:[UIImage imageNamed:@"vioce2.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [bigView setImage:[UIImage imageNamed:@"vioce2.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [bigView setImage:[UIImage imageNamed:@"vioce2.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [bigView setImage:[UIImage imageNamed:@"vioce3.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [bigView setImage:[UIImage imageNamed:@"vioce3.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [bigView setImage:[UIImage imageNamed:@"vioce3.png"]];
    }else {
        [bigView setImage:[UIImage imageNamed:@"vioce3.png"]];
    }
}



-(void)submitVoice
{
    if (streamUrl == nil) {
        
    }else{

        NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/myTask/GetRegionForMyTask.json?operationTime=%@&accessToken=%@",ADDR_IP,ADDR_DIR,opreatinTime,accessToken];
        
        NSLog(@"uid == %@",requestUrl);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
//            [formData appendPartWithFileURL:streamUrl name:@"voiceContent" error:nil];
            [formData appendPartWithFormData:data1 name:@"voiceContent"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Success: %@", responseObject);
            if ([[responseObject objectForKey:@"result"]isEqualToString:@"0000000"]) {
                AddTemporaryDetailViewController *addVC = [[AddTemporaryDetailViewController alloc]init];
                addVC.dic = [responseObject objectForKey:@"detail"];
                [self.navigationController pushViewController:addVC animated:YES];
                UIColor *color = [UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0];
                self.navigationController.navigationBar.barTintColor = color;
            }else{
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            
        }];
        
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
