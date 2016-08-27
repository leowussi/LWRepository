//
//  TopBtnView.m
//  KuanJiaDemo
//
//  Created by 郝威斌 on 14/11/12.
//  Copyright (c) 2014年 XXX. All rights reserved.
//

#import "TopButtonView.h"
#import "fashion.h"
@implementation TopButtonView
@synthesize label;

- (id)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imageArr withTitleArr:(NSArray*)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        if (imageArr.count ==3) {
        for (int i = 0; i<3; i++) {
            UIButton* butt = [UIButton buttonWithType:UIButtonTypeCustom];
            [butt setFrame:CGRectMake(kScreenWidth/3*i, 0, kScreenWidth/3, 35)];
            [butt addTarget:self action:@selector(topButt:) forControlEvents:UIControlEventTouchUpInside];
            
            [butt setTag:10+i];
            [butt setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:193.0/255.0 blue:0.0/255.0 alpha:1.0]];
            
            UIImageView* backview = [[UIImageView alloc]init];
            [backview setBackgroundColor:[UIColor clearColor]];
            
            UIImage* image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (35-image.size.height/2)/2-2, image.size.width/2, image.size.height/2)];
            [imageView setImage:image];
            [backview addSubview:imageView];
            
            CGSize sizeWith = [self labelHight:[titleArr objectAtIndex:i]];
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(image.size.width/2+5, 3, sizeWith.width+5, 25)];
            label.text = [titleArr objectAtIndex:i];
            [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
            label.tag = 20+i;
            label.textColor = [UIColor whiteColor];
            [backview addSubview:label];
//            if (label.tag == 20) {
//                label.textColor = [UIColor whiteColor];
//            }
            
            [backview setFrame:CGRectMake(0, 2.5, image.size.width/2+5+sizeWith.width, 30)];
            [backview setCenter:CGPointMake(butt.frame.size.width/2, butt.frame.size.height/2)];
            [butt addSubview:backview];
            
            
            UIImageView* backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"02-dibu-xuanzhongkuai.png"]];
            [backImageView setFrame:CGRectMake(15, 31, 53, 4)];
            [backImageView setTag:20+i];
            [butt addSubview:backImageView];
            
            if (i != 0) {
                backImageView.hidden = YES;
                
                UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 2, 1, 31)];
                [view setBackgroundColor:[UIColor whiteColor]];
                [butt addSubview:view];
            }
            [self addSubview:butt];
        }
    }else{
        for (int i = 0; i<2; i++) {
            UIButton* butt = [UIButton buttonWithType:UIButtonTypeCustom];
            [butt setFrame:CGRectMake(160*i, 0, 159, 35)];
            [butt addTarget:self action:@selector(topButt:) forControlEvents:UIControlEventTouchUpInside];
            [butt setTag:10+i];
            [butt setBackgroundColor:[UIColor whiteColor]];
            
            
            UIImage* image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (35-image.size.height/2)/2, image.size.width/2, image.size.height/2)];
            [imageView setImage:image];
            
            [butt addSubview:imageView];
            
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(58, 10, 80, 15)];
            label.text = [titleArr objectAtIndex:i];
            [label setFont:[UIFont boldSystemFontOfSize:16.0]];
            label.tag = 20+i;
            [butt addSubview:label];
            if (label.tag == 21) {
                label.textColor = [UIColor blackColor];
            }
            
            UIImageView* backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"02-dibu-xuanzhongkuai.png"]];
            [backImageView setFrame:CGRectMake(53, 31, 53, 4)];
            [backImageView setTag:200+i];
            [butt addSubview:backImageView];
            
            if (i == 1) {
                backImageView.hidden = YES;
                UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 2, 1, 31)];
                [view setBackgroundColor:[UIColor grayColor]];
                [butt addSubview:view];
            }
            
            
            [self addSubview:butt];
            
        }
    }
    
    
    
    //    }
    return self;
}


- (void)topButt:(UIButton*)sender
{
    
    UILabel *oneLable = (UILabel *)[[self viewWithTag:10] viewWithTag:20];
    UILabel *twoLable = (UILabel *)[[self viewWithTag:11] viewWithTag:21];
    UILabel *thirdLable = (UILabel *)[[self viewWithTag:12] viewWithTag:22];
//    UILabel *fourLable = (UILabel *)[[self viewWithTag:13] viewWithTag:23];
    
    UIImageView* oneimageView = (UIImageView*)[[self viewWithTag:10] viewWithTag:200];
    UIImageView* twoimageView = (UIImageView*)[[self viewWithTag:11] viewWithTag:201];
    UIImageView* threeimageView = (UIImageView*)[[self viewWithTag:12] viewWithTag:202];
    
    if (sender.tag == 10) {
//        oneLable.textColor = [UIColor blackColor];
//        twoLable.textColor = [UIColor grayColor];
//        thirdLable.textColor = [UIColor grayColor];
//        fourLable.textColor = [UIColor grayColor];
        oneimageView.hidden = NO;
        twoimageView.hidden = YES;
        threeimageView.hidden = YES;
        [self.delegate topBtn:0];
    }else if (sender.tag == 11){
        
//        oneLable.textColor = [UIColor grayColor];
//        twoLable.textColor = [UIColor blackColor];
//        thirdLable.textColor = [UIColor grayColor];
//        fourLable.textColor = [UIColor grayColor];
        
        oneimageView.hidden = YES;
        twoimageView.hidden = NO;
        threeimageView.hidden = YES;
        
        [self.delegate topBtn:1];
    }else {
//        oneLable.textColor = [UIColor grayColor];
//        twoLable.textColor = [UIColor grayColor];
//        thirdLable.textColor = [UIColor blackColor];
//        fourLable.textColor = [UIColor grayColor];
        oneimageView.hidden = YES;
        twoimageView.hidden = YES;
        threeimageView.hidden = NO;

        [self.delegate topBtn:2];
    }
//    else{
//        oneLable.textColor = [UIColor grayColor];
//        twoLable.textColor = [UIColor grayColor];
//        thirdLable.textColor = [UIColor grayColor];
//        fourLable.textColor = [UIColor blackColor];
//        
//        [self.delegate topViewButt:3];
//    }
    
}


- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
