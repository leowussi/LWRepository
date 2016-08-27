
//
//  RoomDetailViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "RoomDetailViewController.h"
#import "JuZhanTableViewCell.h"
#import "JiFangTableViewCell.h"

@interface RoomDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *bgView;
    UIView *bgView1;
    UIView *bgView2;
    UIImageView *jiImgView;
    NSArray *jzInfoArr;
    NSArray *jfInfoArr;
    UITableView *myTableView;
    UITableView *myTableView1;
}
@end

@implementation RoomDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"机房详细信息";
    [self addNavigationLeftButton];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);

    [self initView];
}

- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(void)initView
{
    NSArray* array1  = [NSArray arrayWithObjects:@"局站信息",@"机房信息",@"机房格局", nil];
    UIImage *btnImg = [UIImage imageNamed:@"tab_bg"];
    for (int i = 0; i<array1.count; i++) {
        
        UIButton* butt = [UIButton buttonWithType:UIButtonTypeCustom];
        [butt setFrame:CGRectMake(10+i*(btnImg.size.width/2+10), 15, btnImg.size.width/2+10, 30)];
        [butt setTag:10+i];
        [butt setBackgroundImage:btnImg forState:UIControlStateNormal];
        [butt addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_baseScrollView addSubview:butt];
        
        CGSize sizeWith = [self labelHight:[array1 objectAtIndex:i]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, sizeWith.width+5, 25)];
        label.text = [array1 objectAtIndex:i];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
        label.tag = 20+i;
        label.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        [butt addSubview:label];
        
        if (i == 0) {
            [butt setBackgroundImage:[UIImage imageNamed:@"tab_bg_white"] forState:UIControlStateNormal];
            label.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        }
    }
    
//    bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 45, kScreenWidth-20, 40+22*7)];
//    bgView.backgroundColor = [UIColor whiteColor];
//    bgView.layer.borderWidth = 1;
//    bgView.layer.borderColor = [RGBCOLOR(237, 237, 237)CGColor];
//    
//    [_baseScrollView addSubview:bgView];
    
    jzInfoArr = [self.dataArr objectForKey:@"viewRegionResult"];
    
    jfInfoArr = [self.dataArr objectForKey:@"viewRoomResult"];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 45, kScreenWidth-20, kScreenHeight-64-45) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    [_baseScrollView addSubview:myTableView];
    
    [self setExtraCellLineHidden:myTableView];
    
    myTableView1 = [[UITableView alloc]initWithFrame:CGRectMake(10, 45, kScreenWidth-20, kScreenHeight-64-45) style:UITableViewStylePlain];
    myTableView1.dataSource = self;
    myTableView1.delegate = self;
    myTableView1.hidden = YES;
    myTableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView1.showsVerticalScrollIndicator = NO;
    [_baseScrollView addSubview:myTableView1];
    [self setExtraCellLineHidden:myTableView1];
    _baseScrollView.scrollEnabled = NO;
    
//    for (int i = 0; i < jzInfoArr.count; i++) {
//        
//        UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(10, 20+22*i, kScreenWidth-40, 20)];
//        backV.backgroundColor = RGBCOLOR(240, 240, 240);
//        [bgView addSubview:backV];
//        
//        UILabel *leftLable = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 20+22*i, 80, 20)];
//        
//        [bgView addSubview:leftLable];
//        
//        UILabel *rightLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(90, 20+22*i, 200, 20)];
//        rightLable.numberOfLines = 0;
//        [bgView addSubview:rightLable];
//        
//        
//        
//        if (jzInfoArr.count == 0) {
//            
//            
//        }else{
//            
//            CGSize with = [self labelHight:[[[jzInfoArr objectAtIndex:i] objectForKey:@"value"] description]];
//            backV.frame = CGRectMake(10, with.height+22*i, kScreenWidth-40, with.height+5);
//            leftLable.frame = CGRectMake(10, with.height+22*i, 80, 20);
//            rightLable.frame = CGRectMake(leftLable.frame.size.width+10, with.height+2+22*i, 200, with.height);
//           
//            
//            leftLable.text = [NSString stringWithFormat:@"%@ :",[[[jzInfoArr objectAtIndex:i] objectForKey:@"name"] description]];
//            
//            rightLable.text = [[[jzInfoArr objectAtIndex:i] objectForKey:@"value"] description];
//        }
//        
//        if (i%2==0){
//            backV.hidden = NO;
//        }else{
//            backV.hidden = YES;
//        }
//        
//    }
    
  ///////////////////////////////////////////////////////////////////////////////////
    
//    bgView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 45, kScreenWidth-20, 40+22*15)];
//    bgView1.backgroundColor = [UIColor whiteColor];
//    bgView1.layer.borderWidth = 1;
//    bgView1.layer.borderColor = [RGBCOLOR(237, 237, 237)CGColor];
//    bgView1.hidden = YES;
//    [_baseScrollView addSubview:bgView1];
    
//    jfInfoArr = [self.dataArr objectForKey:@"viewRoomResult"];
    
//    for (int i = 0; i < jfInfoArr.count; i++) {
//        
//        UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(10, 20+22*i, kScreenWidth-40, 20)];
//        backV.backgroundColor = RGBCOLOR(240, 240, 240);
//        backV.hidden = YES;
//        [bgView1 addSubview:backV];
//        
//        UILabel *leftLable = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 20+22*i, 80, 20)];
//        leftLable.text = [NSString stringWithFormat:@"%@ :",[[[jfInfoArr objectAtIndex:i] objectForKey:@"name"] description]];
//        [bgView1 addSubview:leftLable];
//        
//        UILabel *rightLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(80, 20+22*i, 220, 20)];
//        rightLable.text = [[[jfInfoArr objectAtIndex:i] objectForKey:@"value"] description];
//        [bgView1 addSubview:rightLable];
//        
//        if (i%2==0){
//            backV.hidden = NO;
//        }else{
//            backV.hidden = YES;
//        }
//        
//    }

    ///////////////////////////////////////////////////////////////////////////////////
    
    bgView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 45, kScreenWidth-20, kScreenHeight)];
    bgView2.backgroundColor = [UIColor whiteColor];
    bgView2.layer.borderWidth = 1;
    bgView2.layer.borderColor = [RGBCOLOR(237, 237, 237)CGColor];
    bgView2.hidden = YES;
    [_baseScrollView addSubview:bgView2];

    jiImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight-105)];
    jiImgView.image = [UIImage imageNamed:@"jfxq.png"];
    [bgView2 addSubview:jiImgView];
    
    NSLog(@"%@",self.dataArr);
}


-(void)clickBtn:(UIButton *)sender
{
    UIImage *wxzBtnImg = [UIImage imageNamed:@"tab_bg"]; //未选中button的图片
    UIImage *xzBtnImg = [UIImage imageNamed:@"tab_bg_white"];  //选中button的图片

    UIButton* btn1 = (UIButton*)[_baseScrollView viewWithTag:10];
    UIButton* btn2 = (UIButton*)[_baseScrollView viewWithTag:11];
    UIButton* btn3 = (UIButton*)[_baseScrollView viewWithTag:12];
    
    UILabel *titleLable1 = (UILabel *)[_baseScrollView viewWithTag:20];
    UILabel *titleLable2 = (UILabel *)[_baseScrollView viewWithTag:21];
    UILabel *titleLable3 = (UILabel *)[_baseScrollView viewWithTag:22];
    
    if (sender.tag == 10) {
        NSLog(@"0");
        [btn1 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        titleLable1.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        titleLable2.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable3.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        
        myTableView.hidden = NO;
        myTableView1.hidden = YES;
        [myTableView reloadData];
        bgView.hidden = NO;
        bgView1.hidden = YES;
        bgView2.hidden = YES;
        
    }else if (sender.tag == 11) {
        NSLog(@"1");
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        titleLable2.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        titleLable1.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable3.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        
        myTableView.hidden = YES;
        myTableView1.hidden = NO;
        [myTableView1 reloadData];
        bgView1.hidden = NO;
        bgView.hidden = YES;
        bgView2.hidden = YES;
        
    }else if (sender.tag == 12) {
        NSLog(@"1");
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        
        titleLable3.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        titleLable1.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable2.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        
        bgView2.hidden = NO;
        bgView1.hidden = YES;
        bgView.hidden = YES;

        NSString *strUrl = [NSString stringWithFormat:@"http://%@/%@/MyRoom/GetRoomPatternData.stream?roomID=%@",ADDR_IP,ADDR_DIR,[self.dataArr objectForKey:@"roomId"]];
        
        NSLog(@"%@",strUrl);
        NSURL *url = [NSURL URLWithString:strUrl];
        [jiImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"jfxq.png"]];

    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        return jzInfoArr.count;
    }else{
        return jfInfoArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myTableView) {
        
        static NSString *juzcell = @"juzCell";
        JuZhanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:juzcell];
        if (!cell) {
            cell = [[JuZhanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:juzcell];
        }
        
        cell.rightLable.numberOfLines = 0;
        
        CGSize with = [self labelHight:[[[jzInfoArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
        
        cell.rightLable.frame = CGRectMake(80, 7, kScreenWidth-120, with.height);
        
        cell.leftLable.text = [NSString stringWithFormat:@"%@ :",[[jzInfoArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        cell.rightLable.text = [[[jzInfoArr objectAtIndex:indexPath.row] objectForKey:@"value"] description];
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = RGBCOLOR(250, 250, 250);
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }

        return cell;
        
    }else{
        
        static NSString *jifcell = @"jifCell";
        JiFangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jifcell];
        if (!cell) {
            cell = [[JiFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jifcell];
        }
        cell.rightLable.numberOfLines = 0;
        
        CGSize with = [self labelHight:[[[jfInfoArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
        
        cell.rightLable.frame = CGRectMake(80, 7, kScreenWidth-120, with.height);
        
        cell.leftLable.text = [NSString stringWithFormat:@"%@ :",[[jfInfoArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        cell.rightLable.text = [[[jfInfoArr objectAtIndex:indexPath.row] objectForKey:@"value"] description];
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = RGBCOLOR(250, 250, 250);
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myTableView) {
        
        CGSize with = [self labelHight:[[[jzInfoArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
        return 15+with.height;
        
    }else{
        
        CGSize with = [self labelHight:[[[jfInfoArr objectAtIndex:indexPath.row] objectForKey:@"value"] description]];
        return 15+with.height;
        
    }
    
}

- (CGSize)labelHight1:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(200, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping| NSLineBreakByTruncatingTail];
    return size;
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
