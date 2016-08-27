//
//  GongGaoViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/5/27.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "GongGaoViewController.h"
#import "MyPageControl.h"
@interface GongGaoViewController ()<UIScrollViewDelegate>
{
    UIView *backView;
    UIScrollView *infoScroll;
    UIScrollView *infoScroll1;
    MyPageControl *myPageCtrol;
    NSInteger currentIndex;
    UILabel *numLable;
    UILabel *rightLable;
    int pageTag;
    NSMutableArray *arr;
    NSMutableArray *rightArray;
}
@end

@implementation GongGaoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self hiddenBottomBar:YES];
}

- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公告详细";
    DLog(@"%@",self.dataArr);
    [self addNavigationLeftButton];
    currentIndex = self.Index;
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    rightArray = [[NSMutableArray alloc]initWithCapacity:10];
    [self initView];
    [self addPage];
    [self scrollViewDidEndDecelerating:infoScroll :self.Index ];
}

-(void)addPage
{
    UIImage *leftImg = [UIImage imageNamed:@"左"];
    UIImage *rightImg = [UIImage imageNamed:@"右"];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight-60, leftImg.size.width/1.5, leftImg.size.height/1.5)];
    [leftBtn setBackgroundImage:leftImg forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftBtn];
    
    numLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(kScreenWidth/2-100+rightImg.size.width/1.5, kScreenHeight-60, kScreenWidth/2, 20)];
    numLable.backgroundColor = [UIColor clearColor];
    numLable.text = [NSString stringWithFormat:@"第%d条/第%d条",(self.Index+1),self.dataArr.count];
    numLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:numLable];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(kScreenWidth/2+80, kScreenHeight-60, rightImg.size.width/1.5, rightImg.size.height/1.5)];
    [rightBtn setBackgroundImage:rightImg forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rightBtn];
}

-(void)initView
{
    backView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, kScreenHeight-64)];
    backView.backgroundColor = [UIColor whiteColor];
    [_baseScrollView addSubview:backView];
    _baseScrollView.scrollEnabled = YES;
    
    infoScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-40, kScreenHeight-124)];
    infoScroll.pagingEnabled = YES;
    infoScroll.delegate = self;
    infoScroll.bounces=NO;
    infoScroll.showsHorizontalScrollIndicator = NO;
    float with = kScreenWidth-40;
    infoScroll.contentSize = CGSizeMake(with*self.dataArr.count, 0);
    [backView addSubview:infoScroll];
    
    myPageCtrol = [[MyPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight+1000, kScreenWidth-40, 10)];
    myPageCtrol.currentPage = 0;
    myPageCtrol.numberOfPages = self.dataArr.count;
    myPageCtrol.userInteractionEnabled=NO;
    myPageCtrol.hidesForSinglePage = YES;
    myPageCtrol.pageIndicatorTintColor = [UIColor grayColor];
    myPageCtrol.currentPageIndicatorTintColor = [UIColor blackColor];
    pageTag = myPageCtrol.currentPage;
    [backView addSubview:myPageCtrol];
    
    NSArray *leftArr = @[@"公告编号:",@"发布日期:",@"截止日期:",@"发  布  人:",@"发布单位:",@"公告类型:",@"区       局:",@"专       业:",@"公告主题:",@"公告内容:"];

    for (int i = 0; i < self.dataArr.count; i++) {
        
        infoScroll1 = [[UIScrollView alloc]initWithFrame:CGRectMake(with*i , 0, kScreenWidth-40, kScreenHeight-124)];
        infoScroll1.delegate = self;
        infoScroll1.bounces=NO;
        infoScroll1.showsHorizontalScrollIndicator = NO;
        

        for (int j = 0; j < leftArr.count; j++) {
            CGSize sizeWith = [self labelHight:[leftArr objectAtIndex:j]];
            
            UILabel *leftLable = [UnityLHClass initUILabel:[leftArr objectAtIndex:j] font:13.0 color:[UIColor blackColor] rect:CGRectMake(10, 20+j*20, 100, 20)];
            [infoScroll1 addSubview:leftLable];
            
            rightLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor grayColor] rect:CGRectMake(sizeWith.width+20, 20+j*20, kScreenWidth-120, 20)];
  
            rightLable.lineBreakMode = NSLineBreakByWordWrapping;
            rightLable.numberOfLines = 0;
            
            if (j == 0) {
                rightLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"wfSn"];
            }
            if (j == 1) {
                rightLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"createdDate"];
            }
            
            if (j == 2) {
                rightLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"endDate"];
            }
            
            if (j == 3) {
                rightLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"createdBy"];
            }
            if (j == 4) {
                rightLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"createdDept"];
            }
            if (j == 5) {
                rightLable.text = @"普通公告";
            }
            if (j == 6) {
                rightLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"region"];
            }
            if (j == 7) {
                rightLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"spec"];
            }
            if (j == 8) {
                rightLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"theme"];
                CGSize maxsize = CGSizeMake(kScreenWidth-120, MAXFLOAT);
                CGSize label = [self sizeWithText:rightLable.text font:[UIFont systemFontOfSize:12] maxSize:maxsize];
                [rightLable setFrame:CGRectMake(rightLable.frame.origin.x,leftLable.frame.origin.y+3,kScreenWidth-120,label.height)];
                rightLable.tag=105+i;
            }
            
            if (j == 9) {
                rightLable.text = [[self.dataArr objectAtIndex:i] objectForKey:@"noteContent"];
                UILabel *right =  [self.view viewWithTag:(105+i)];
                CGSize maxsize = CGSizeMake(kScreenWidth-120, MAXFLOAT);
                CGSize labelsize = [self sizeWithText:rightLable.text font:[UIFont systemFontOfSize:12] maxSize:maxsize];
                [leftLable setFrame:CGRectMake(10, CGRectGetMaxY(right.frame), 100, 20)];
                [rightLable setFrame:CGRectMake(rightLable.frame.origin.x,CGRectGetMaxY(right.frame)+3,kScreenWidth-120,labelsize.height)];
                
                 infoScroll1.contentSize = CGSizeMake(0, CGRectGetMaxY(rightLable.frame));
//                [arr addObject:@(CGRectGetMaxY(rightLable.frame))] ;
                
            }
            [infoScroll1 addSubview:rightLable];
            [infoScroll addSubview:infoScroll1];
            
        }
        
        
    }
}
#pragma mark 通过字典设置字体的样式 和字体大小
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};//
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView:(int )index{
    CGPoint offset = scrollView.contentOffset;
    myPageCtrol.currentPage = index; //计算当前的页码
    [infoScroll setContentOffset:CGPointMake(backView.bounds.size.width * (myPageCtrol.currentPage),infoScroll.contentOffset.y) animated:YES]; //设置scrollview的显示为当前滑动到的页面
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    DLog(@"%d",currentIndex);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    myPageCtrol.currentPage = offset.x / (backView.bounds.size.width); //计算当前的页码
    [infoScroll setContentOffset:CGPointMake(backView.bounds.size.width * (myPageCtrol.currentPage),infoScroll.contentOffset.y) animated:YES]; //设置scrollview的显示为当前滑动到的页面
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    DLog(@"%d",currentIndex);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = infoScroll.frame.size.width;
    int page = floor((infoScroll.contentOffset.x - pagewidth/5)/pagewidth)+2;
    page --;  // 默认从第二页开始
    myPageCtrol.currentPage = page;
//    infoScroll1.contentSize = CGSizeMake(0, [arr[page] floatValue]);
    numLable.text = [NSString stringWithFormat:@"第%d条/第%d条",page+1,self.dataArr.count];;
    [infoScroll reloadInputViews];
    
}

- (void)turnPage
{
    float with = kScreenWidth-40;
    float height = kScreenHeight-64;
    infoScroll.contentSize = CGSizeMake(with*self.dataArr.count, height);
    
    int page = myPageCtrol.currentPage; // 获取当前的page
    [infoScroll scrollRectToVisible:CGRectMake(with*self.dataArr.count,0,with,height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
    NSLog(@"page == >%d",page);
    
}

-(void)leftBtn
{
    float with = kScreenWidth-40;
    float height = kScreenHeight-64;
    infoScroll.contentSize = CGSizeMake(with*self.dataArr.count, height);
    int page = myPageCtrol.currentPage; // 获取当前的page
    page--;
    if (page < 0) {
        
    }else{
        myPageCtrol.currentPage = page;
        [infoScroll setContentOffset:CGPointMake(with*page, 0) animated:YES];
    }
    NSLog(@"unTimePage++ == >%d",page);
    
}

-(void)rightBtn
{
    int page = myPageCtrol.currentPage; // 获取当前的page
    page++;
    NSLog(@"unTimePage++ == >%d",page);
    myPageCtrol.currentPage = page;
    float with = kScreenWidth-40;
    float height = kScreenHeight-64;
    infoScroll.contentSize = CGSizeMake(with*self.dataArr.count, height);
    if (page >= self.dataArr.count) {
        
    }else{
        myPageCtrol.currentPage = page;
        [infoScroll setContentOffset:CGPointMake(with*page, 0) animated:YES];
    }
    
}

@end
