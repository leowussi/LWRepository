//
//  NewsView.m
//  gonggao
//
//  Created by liuyong on 16/3/5.
//  Copyright © 2016年 Sundear. All rights reserved.
//

#define kPageNumLabelWidth 40

#import "NewsView.h"

@interface NewsView ()<UIScrollViewDelegate>
{
    UIScrollView *_newsScrollView;
    UILabel *_pageNumLabel;
    NSTimer *_timer;
    
    NSArray *_news;
    
    CGRect _frame;
}
@end

@implementation NewsView

- (instancetype)initWithFrame:(CGRect)frame news:(NSArray *)news
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _news = news;
        _frame = frame;
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor colorWithRed:57/255.0f green:165/255.0f blue:249/255.0f alpha:1.0f];
        
        _newsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-kPageNumLabelWidth, frame.size.height)];
        _newsScrollView.delegate = self;
        _newsScrollView.pagingEnabled = YES;
        _newsScrollView.showsHorizontalScrollIndicator = NO;
        _newsScrollView.bounces = NO;
        _newsScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_newsScrollView];
        
        
        
        _pageNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-kPageNumLabelWidth, 0, kPageNumLabelWidth, frame.size.height)];
        _pageNumLabel.font = [UIFont systemFontOfSize:13.0f];
        _pageNumLabel.textColor = [UIColor whiteColor];
        _pageNumLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)news.count];
        [self addSubview:_pageNumLabel];
        
        
        
    }
    return self;
}

- (void)showNewsInfo
{
    for (int i=0; i<_news.count; i++) {
        UILabel *showLabels = [[UILabel alloc] initWithFrame:CGRectMake(0, _frame.size.height*i, _frame.size.width-kPageNumLabelWidth, _frame.size.height)];
        showLabels.text = [[_news objectAtIndex:i] objectForKey:@"noteContent"];
        showLabels.font = [UIFont systemFontOfSize:13.0f];
        showLabels.textColor = [UIColor whiteColor];
        [_newsScrollView addSubview:showLabels];   
    }
    
    _newsScrollView.contentSize = CGSizeMake(_frame.size.width-kPageNumLabelWidth, _frame.size.height*_news.count);
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(nextNew) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint contentOff = _newsScrollView.contentOffset;
    NSInteger index = contentOff.y / _newsScrollView.frame.size.height;
    _pageNumLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)index ,(unsigned long)_news.count];
    [self addTimer];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removetimer];
}

- (void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(nextNew) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removetimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)nextNew{
    __block CGPoint contentOff = _newsScrollView.contentOffset;
    NSInteger index = contentOff.y / _newsScrollView.frame.size.height;
    if (index == _news.count-1) {
        contentOff.y = 0;
        _newsScrollView.contentOffset = contentOff;
        NSInteger pageNum = _newsScrollView.contentOffset.y / _newsScrollView.frame.size.height;
        _pageNumLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)pageNum+1 ,(unsigned long)_news.count];
    }else{
        [UIView animateWithDuration:1.5f animations:^{
            contentOff.y += _newsScrollView.frame.size.height;
            _newsScrollView.contentOffset = contentOff;
            
            NSInteger pageNum = _newsScrollView.contentOffset.y / _newsScrollView.frame.size.height;
            _pageNumLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)pageNum+1 ,(unsigned long)_news.count];
        }];
    }
}

@end
