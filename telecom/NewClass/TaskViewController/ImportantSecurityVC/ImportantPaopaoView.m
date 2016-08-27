//
//  ImportantPaopaoView.m
//  telecom
//
//  Created by 郝威斌 on 15/10/26.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "ImportantPaopaoView.h"
#import "fashion.h"

@implementation ImportantPaopaoView

static const float kBorderWidth = 10.0f;
static const float kEndCapWidth = 20.0f;
static const float kMaxLabelWidth = 220.0f;

@synthesize infoDict = _infoDict;
@synthesize index,rightButton;
@synthesize arr,arr1,arr2,arr3,arr4,arr5,arr6;
@synthesize detailArr;
@synthesize myTableView;
#define btns 7
#define column 4

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        
        detailLabel = [[UILabel alloc] init];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.numberOfLines = 0;
        detailLabel.font = [UIFont systemFontOfSize:12.0f];
        detailLabel.hidden = YES;
        [self addSubview:detailLabel];
        
        arr = [[NSMutableArray alloc]initWithCapacity:10];
        arr1 = [[NSMutableArray alloc]initWithCapacity:10];
        arr2 = [[NSMutableArray alloc]initWithCapacity:10];
        arr3 = [[NSMutableArray alloc]initWithCapacity:10];
        arr4 = [[NSMutableArray alloc]initWithCapacity:10];
        arr5 = [[NSMutableArray alloc]initWithCapacity:10];
        arr6 = [[NSMutableArray alloc]initWithCapacity:10];
        detailArr = [[NSMutableArray alloc]initWithCapacity:10];
        
        
        UIView *headView = [self tableHeadView];
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 30, 205, 65) style:UITableViewStylePlain];
        myTableView.dataSource = self;
        myTableView.delegate = self;
        myTableView.backgroundColor = [UIColor clearColor];
        myTableView.tableHeaderView = headView;
        myTableView.scrollEnabled = NO;
        [self addSubview:myTableView];
        
        [myTableView reloadData];
        
//        rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
//        [rightButton setTitle:@"关闭" forState:UIControlStateNormal];
//        [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        rightButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        //        [rightButton addTarget:self action:@selector(detai) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:rightButton];
        
        UIImage *imageNormal, *imageHighlighted;
        imageNormal = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_left.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        imageHighlighted = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_left_highlighted.png"]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        UIImageView *leftBgd = [[UIImageView alloc] initWithImage:imageNormal
                                                 highlightedImage:imageHighlighted];
        leftBgd.tag = 11;
        
        imageNormal = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_right.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        imageHighlighted = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_right_highlighted.png"]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        UIImageView *rightBgd = [[UIImageView alloc] initWithImage:imageNormal
                                                  highlightedImage:imageHighlighted];
        rightBgd.tag = 12;
        
        [self addSubview:leftBgd];
        [self sendSubviewToBack:leftBgd];
        [self addSubview:rightBgd];
        [self sendSubviewToBack:rightBgd];
        
    }
    
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



#pragma mark == 表头
-(UIView *)tableHeadView
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 30, 200, 60)];
    view.backgroundColor = [UIColor clearColor];
    NSArray *imgArra = [NSArray arrayWithObjects:@"map_icn3.png",@"map_icon8.png", nil];
    
    NSArray *titleArra = @[@"局站",@"网元"];
    NSArray *numArr = @[@"0",@"0"];
    
    UIImage *image = [UIImage imageNamed:@"map_icn3.png"];
    
    CGFloat width = image.size.width;
    CGFloat hight = image.size.height;
    
    for (int i = 0; i<imgArra.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5+50*i, 10, width/1.3, hight/1.3)];
        imgView.image = [UIImage imageNamed:[imgArra objectAtIndex:i]];
        imgView.userInteractionEnabled = YES;
        [view addSubview:imgView];
        
//        if (i == 2) {
//            imgView.frame = CGRectMake(6+50*i, 13, width/1.8, hight/1.8);
//        }
        
        UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(width/1.3+50*i-2, 10, 14, 14)];
        numLable.layer.masksToBounds = YES;
        numLable.layer.cornerRadius = 7;
        numLable.tag = 100+i;
        numLable.font = [UIFont systemFontOfSize:11.0];
        numLable.backgroundColor = [UIColor redColor];
        numLable.text = [numArr objectAtIndex:i];
        numLable.textColor = [UIColor whiteColor];
        numLable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:numLable];
        
        UILabel *titLable = [[UILabel alloc]initWithFrame:CGRectMake(5+50*i, hight/1.3+5, width/1.3, 20)];
        titLable.font = [UIFont systemFontOfSize:11.0];
        titLable.text = [titleArra objectAtIndex:i];
        titLable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titLable];
        
        UIButton *imgViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width/1.3, hight/1.3)];
        imgViewBtn.backgroundColor = [UIColor clearColor];
        imgViewBtn.tag = 10+i;
        [imgViewBtn addTarget:self action:@selector(imgViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:imgViewBtn];
        
        if (i == 0) {
            titLable.frame = CGRectMake(2, hight/1.3+5, width/1.3+5, 20);
        }
        
//        if (i == 2) {
//            numLable.frame = CGRectMake(width/1.3+50*i-6, 10, 14, 14);
//        }
        
        
        
        
    }
    
    NSString* nameStr;
    NSString* nameStr1;
    NSString* nameStr2;
    
    NSNumber *sum;
    NSNumber *sum1;
    NSNumber *sum2;
    
    UILabel *lab = (UILabel *)[view viewWithTag:100];
    UILabel *lab1 = (UILabel *)[view viewWithTag:101];
    UILabel *lab2 = (UILabel *)[view viewWithTag:102];
    
    
    detailArr = [_infoDict objectForKey:@"trackedEnsureList"];
    for (int i = 0; i < detailArr.count; i++) {
        if ([[[[detailArr objectAtIndex:i]objectForKey:@"typeId"] description] isEqualToString:@"1"]) {
            nameStr = [[detailArr objectAtIndex:i]objectForKey:@"content"];
            [arr addObject:nameStr];
            
            sum = [arr valueForKeyPath:@"@sum.floatValue"];
            NSLog(@"1 = %@",sum);
            
            lab.text = @"";
            lab.text = [NSString stringWithFormat:@"%@",sum];
            
        }else if ([[[[detailArr objectAtIndex:i]objectForKey:@"typeId"] description] isEqualToString:@"2"]) {
            nameStr1 = [[detailArr objectAtIndex:i]objectForKey:@"content"];
            [arr1 addObject:nameStr1];
            
            sum1 = [arr1 valueForKeyPath:@"@sum.floatValue"];
            NSLog(@"2 = %@",sum1);
            
            lab1.text = @"";
            lab1.text = [NSString stringWithFormat:@"%@",sum1];
            
        }else if ([[[[detailArr objectAtIndex:i]objectForKey:@"typeId"] description] isEqualToString:@"3"]) {
            nameStr2 = [[detailArr objectAtIndex:i]objectForKey:@"content"];
            [arr2 addObject:nameStr2];
            
            sum2 = [arr2 valueForKeyPath:@"@sum.floatValue"];
            NSLog(@"3 = %@",sum2);
            
            lab2.text = @"";
            lab2.text = [NSString stringWithFormat:@"%@",sum2];
            
        }
        
    }
    
    
    return view;
}


- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierCell = @"identifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    
    return cell;
}

- (BOOL)showFromRect:(CGRect)rect
{
    if (self.infoDict == nil) {
        return NO;
    }
    NSLog(@"infoDict == %@",self.infoDict);
    titleLabel.text = [NSString stringWithFormat:@"%@ 附近",[_infoDict objectForKey:@"siteName"]];
    CGSize sizeWith = [self labelHight:[_infoDict objectForKey:@"siteName"]];
    CGSize labelsize = [titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12.0]	constrainedToSize:CGSizeMake(sizeWith.width+20, [titleLabel.text length])lineBreakMode:NSLineBreakByWordWrapping];
    
    [titleLabel setFrame:CGRectMake(10,5,150,labelsize.height+10)];
    
    [titleLabel sizeToFit];
    CGRect rect1 = titleLabel.frame;
    
    NSString *addr = [_infoDict objectForKey:@"address"];
    detailLabel.hidden = YES;
    detailLabel.text = [NSString stringWithFormat:@"地址：%@", addr];
    
    view.frame = CGRectMake(0, 30, 150, 60);
    view.backgroundColor = [UIColor clearColor];
    [view sizeToFit];
    CGRect rect2 = view.frame;
    
    view.frame = rect2;
    
    
    
    [arr removeAllObjects];
    [arr1 removeAllObjects];
    [arr2 removeAllObjects];
    [arr3 removeAllObjects];
    [arr4 removeAllObjects];
    [arr5 removeAllObjects];
    [arr6 removeAllObjects];
    //    [detailArr removeAllObjects];
    
    detailArr = [_infoDict objectForKey:@"trackedEnsureList"];
    
    
    myTableView.tableHeaderView = [self tableHeadView];
    [myTableView reloadData];
    
//    [rightButton setFrame:CGRectMake(180, 130, 30, 20)];
    
    CGFloat longWidth = (rect1.size.width > rect2.size.width) ? rect1.size.width : rect2.size.width;
    CGRect rect0 = self.frame;
    rect0.size.height = rect1.size.height + rect2.size.height + 2*kBorderWidth + kEndCapWidth;
    rect0.size.width = longWidth + 2*kBorderWidth;
    self.frame = rect0;
    
    
    CGFloat halfWidth = rect0.size.width/2;
    UIView *image = [self viewWithTag:11];
    CGRect iRect = CGRectZero;
    iRect.size.width = halfWidth;
    iRect.size.height = rect0.size.height;
    image.frame = iRect;
    image = [self viewWithTag:12];
    iRect.origin.x = halfWidth;
    image.frame = iRect;
    
    return YES;
}

- (void)makePhoneCall {
    UIWebView *webView = (UIWebView*)[self viewWithTag:123];
    if (webView == nil) {
        webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    NSString *url = [NSString stringWithFormat:@"tel://%@", [_infoDict objectForKey:@"Phone"]];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(void)imgViewBtn:(UIButton *)sender
{
    UILabel *lab = (UILabel *)[view viewWithTag:100];
    UILabel *lab1 = (UILabel *)[view viewWithTag:101];
//    UILabel *lab2 = (UILabel *)[view viewWithTag:102];

    
    
    if (sender.tag == 10) {
        
        if ([lab.text isEqualToString:@"0"]) {
            
        }else if ([lab.text isEqualToString:@"1"]) {
            [self.delegate tagBtn:100];//跳详情页面
        }else{
            [self.delegate tagBtn:0];//跳列表页面
        }
        
    }else if (sender.tag == 11){
        
        if ([lab1.text isEqualToString:@"0"]) {
            
        }else if ([lab1.text isEqualToString:@"1"]) {
            [self.delegate tagBtn:110];//跳详情页面
        }else{
            [self.delegate tagBtn:1];//跳列表页面
        }
        
        
    }
//    else if (sender.tag == 12){
//        
//        if ([lab2.text isEqualToString:@"0"]) {
//            
//        }else if ([lab2.text isEqualToString:@"1"]) {
//            [self.delegate tagBtn:120];//跳详情页面
//        }else{
//            [self.delegate tagBtn:2];
//        }
//        
//        
//    }
}

@end
