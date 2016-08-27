//
//  YZResourcesResultCommentViewController.m
//  telecom
//
//  Created by 锋 on 16/7/21.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZResourcesResultCommentViewController.h"
#import "CheckLevelButton.h"
@interface YZResourcesResultCommentViewController ()
{
    UITextView *_commentTextView;
    UIButton *_previousButton;
}
@end

@implementation YZResourcesResultCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"点评";
    [self addRightBarButtonItem];
    [self addNavigationLeftButton];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *expression = [[UILabel alloc] initWithFrame:CGRectMake(16, 86, 120, 22)];
    expression.textColor = [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1];
    expression.text = @"满     意     度:";
    expression.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:expression];
    
    UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(16, 160, 120, 22)];
    comment.textColor = [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1];
    comment.text = @"点  评  内  容:";
    comment.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:comment];
    
    NSArray *imageNameArr = @[@"非常满意1",@"满意1",@"不满意1"];
    NSArray *selectedImageNameArr = @[@"非常满意2",@"满意2",@"不满意2"];
    NSArray *titleArr = @[@"非常满意",@"满意",@"不满意"];
    
    NSInteger space = (kScreenWidth - 130 - 180) /2 ;
    
    for (int i = 0; i < titleArr.count; i++) {
        CheckLevelButton *checkLevelButton = [[CheckLevelButton alloc] initWithFrame:CGRectMake(116 + (space + 60) * i, 86, 60, 60) title:titleArr[i] imageName:imageNameArr[i] selectedImageName:selectedImageNameArr[i] target:self action:@selector(changeSatisfiedLevelAction:)];
        checkLevelButton.layer.cornerRadius = 5;
        checkLevelButton.tag = i + 1;
        [self.view addSubview:checkLevelButton];
    }

    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(116, 156, kScreenWidth - 130, 80)];
    _commentTextView.font = [UIFont systemFontOfSize:14];
    _commentTextView.layer.cornerRadius = 4;
    _commentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _commentTextView.layer.borderWidth = .5;
    _commentTextView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_commentTextView];

    
}

- (void)changeSatisfiedLevelAction:(UIButton *)sender
{
    _previousButton.selected = NO;
    _previousButton.backgroundColor = [UIColor clearColor];
    _previousButton = sender;
    _previousButton.selected = YES;

    switch (_previousButton.tag) {
        case 1:
            _previousButton.backgroundColor = RGBCOLOR(240, 141, 38);
            break;
        case 2:
            _previousButton.backgroundColor = RGBCOLOR(254, 227, 46);
            break;
        case 3:
            _previousButton.backgroundColor = RGBCOLOR(193, 193, 193);
            break;
            
        default:
            break;
    }
}

#pragma mark -- 导航条按钮
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)addRightBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- 导航条按钮被点击
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClicked
{
    if (_commentTextView.text == nil || [_commentTextView.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入点评内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithCapacity:0];
    paraDict[URL_TYPE] = @"adjustRes/CommentBill";
    paraDict[@"id"] = _workOrderId;
    paraDict[@"comment"] = _commentTextView.text;
    paraDict[@"satisfact"] = _previousButton ? [NSString stringWithFormat:@"%d",_previousButton.tag] : _previousButton;
    NSLog(@"%@",_workOrderId);
    httpPOST(paraDict, ^(id result) {
         NSLog(@"%@",result);
        NSString *error = [result objectForKey:@"error"];
        if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];

        }
    }, ^(id result) {
        NSLog(@"%@",result);
    });
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self leftAction];
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
