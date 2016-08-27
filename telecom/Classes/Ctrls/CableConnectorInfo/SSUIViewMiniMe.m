//
//  SSUIViewMiniMe.m
//  SSUIViewMiniMeDemo
//
//  Created by Segev on 12/13/13.
//  Copyright (c) 2013 Segev. All rights reserved.
//

#import "SSUIViewMiniMe.h"

#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation SSUIViewMiniMe
{
    UIView *zoomedView;
//    UIView *miniMe;
    UIImageView *miniMeImageView;
    UIView *miniMeIndicator;
}

-(SSUIViewMiniMe *)initWithView:(UIView *)viewToMap withRatio:(NSInteger)ratio
{
    self = [super initWithFrame:viewToMap.frame];

    if (self)
    {
        NSLog(@"%f,%f",viewToMap.bounds.size.width,viewToMap.bounds.size.height);
        zoomedView = viewToMap;
        _ratio = ratio;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-72)];
        self.scrollView.contentSize = CGSizeMake(viewToMap.bounds.size.width, viewToMap.bounds.size.height);
        self.scrollView.delegate = self;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.scrollView.minimumZoomScale = 0.585;
        }else{
            self.scrollView.minimumZoomScale = 0.235;
        }
        self.scrollView.maximumZoomScale = 3;
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 125, 20);
        [self.scrollView addSubview:viewToMap];

        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tapGesture.numberOfTapsRequired=1;
        tapGesture.cancelsTouchesInView = NO;
        [self.scrollView addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(holdAction:)];
        longGesture.cancelsTouchesInView = NO;
        [self.scrollView addGestureRecognizer:longGesture];
        
        [self addSubview:self.scrollView];
        
        self.miniMe = [[UIView alloc]initWithFrame:CGRectMake(10, 10, viewToMap.frame.size.width/_ratio, viewToMap.frame.size.height/_ratio)];
        self.miniMe.alpha = 0.7;
        self.miniMe.hidden = YES;
        self.miniMe.clipsToBounds = YES;
        miniMeImageView = [[UIImageView alloc]initWithImage:[self captureScreen:viewToMap]];
        miniMeImageView.frame = CGRectMake(0, 0, self.miniMe.frame.size.width, self.miniMe.frame.size.height);
        [self.miniMe addSubview:miniMeImageView];
        self.scrollView.zoomScale = 0.235;
        [self.miniMe setBackgroundColor:[UIColor blueColor]];
        [self addSubview:self.miniMe];
        
        miniMeIndicator = [[UIView alloc]initWithFrame:CGRectMake(
                                                                  self.scrollView.contentOffset.x/_ratio/self.scrollView.zoomScale,
                                                                  self.scrollView.contentOffset.y/_ratio/self.scrollView.zoomScale,
                                                                  self.miniMe.frame.size.width/self.scrollView.zoomScale,
                                                                  self.miniMe.frame.size.height/self.scrollView.zoomScale)];
        
//        [miniMeIndicator setBackgroundColor:[UIColor whiteColor]];
//        [miniMeIndicator setAlpha:0.40];
        miniMeIndicator.layer.borderWidth = 2;
        miniMeIndicator.layer.borderColor = [UIColor redColor].CGColor;
        [self.miniMe addSubview:miniMeIndicator];
        
        UIButton *miniMeSelectorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        miniMeSelectorBtn.frame = CGRectMake(0, 0, self.miniMe.frame.size.width, self.miniMe.frame.size.height);
        [miniMeSelectorBtn addTarget:self action:@selector(dragBegan:withEvent:) forControlEvents: UIControlEventTouchDragInside | UIControlEventTouchDown];
        
        miniMeSelectorBtn.clipsToBounds = YES;
        [self.miniMe addSubview:miniMeSelectorBtn];
    }
    return self;
}

- (void)enlargeAction
{
  self.scrollView.zoomScale = 2.0;
}

- (void)dragBegan:(UIControl *)c withEvent:ev
{
    //NSLog(@"dragBegan......");
    UITouch *touch = [[ev allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.miniMe];
    //NSLog(@"Touch x : %f y : %f", touchPoint.x, touchPoint.y);
    if(touchPoint.x<0)
    {
        touchPoint.x=0;
    }
    if(touchPoint.y<0)
    {
        touchPoint.y=0;
    }
    
    if(touchPoint.y + self.miniMe.frame.size.height/self.scrollView.zoomScale > self.miniMe.frame.size.height)
    {
        touchPoint.y = self.miniMe.frame.size.height - self.miniMe.frame.size.height/self.scrollView.zoomScale;
    }
    
    if(touchPoint.x + self.miniMe.frame.size.width/self.scrollView.zoomScale > self.miniMe.frame.size.width)
    {
        touchPoint.x = self.miniMe.frame.size.width - self.miniMe.frame.size.width/self.scrollView.zoomScale;
    }
    
    miniMeIndicator.frame = CGRectMake(touchPoint.x, touchPoint.y, self.miniMe.frame.size.width/self.scrollView.zoomScale, self.miniMe.frame.size.height/self.scrollView.zoomScale);
    
    [self.scrollView setContentOffset:CGPointMake(touchPoint.x*_ratio*self.scrollView.zoomScale, touchPoint.y*_ratio*self.scrollView.zoomScale) animated:NO];
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [self performSelector:@selector(updateMiniMe) withObject:nil afterDelay:0.1];
}

- (void)holdAction:(UILongPressGestureRecognizer *)holdRecognizer
{
    if (holdRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Holding...");
    }
    else if (holdRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Released...");
        [self updateMiniMe];
    }
}

- (void)updateMiniMe
{
    miniMeImageView.image = [self captureScreen:zoomedView];
}


-(UIImage*)captureScreen:(UIView*) viewToCapture
{
    CGRect rect = [viewToCapture bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);

    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:willBeginDragging:)])
    {
        [self.delegate enlargedView:self willBeginDragging:self.scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    miniMeIndicator.frame =
    CGRectMake(scrollView.contentOffset.x/_ratio/scrollView.zoomScale,
               scrollView.contentOffset.y/_ratio/scrollView.zoomScale,
               miniMeIndicator.frame.size.width,
               miniMeIndicator.frame.size.height);

    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:didScroll:)])
    {
        [self.delegate enlargedView:self didScroll:self.scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:didEndDragging:)])
    {
        [self.delegate enlargedView:self didEndDragging:self.scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:willBeginDecelerating:)])
    {
        [self.delegate enlargedView:self willBeginDecelerating:self.scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:didEndDecelerating:)])
    {
        [self.delegate enlargedView:self didEndDecelerating:self.scrollView];
    }
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomedView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    NSLog(@"%f",scrollView.zoomScale);
    miniMeIndicator.frame = CGRectMake(miniMeIndicator.frame.origin.x
                                       , miniMeIndicator.frame.origin.y,
                                       self.miniMe.frame.size.width/self.scrollView.zoomScale/1.6,
                                       self.miniMe.frame.size.height/self.scrollView.zoomScale/1.2);
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:didZoom:)]) {
        [self.delegate enlargedView:self didZoom:scrollView];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:didEndZoom:)]) {
        [self.delegate enlargedView:self didEndZoom:scrollView];
    }
}

@end
