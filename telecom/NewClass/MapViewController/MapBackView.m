//
//  MapBackView.m
//  telecom
//
//  Created by 郝威斌 on 15/5/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MapBackView.h"
#import "fashion.h"

@implementation MapBackView
@synthesize label,numLabel;

- (id)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imageArr withTitleArr:(NSArray*)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        //        if (imageArr.count ==3) {
        for (int i = 0; i<2; i++) {
            UIButton* butt = [UIButton buttonWithType:UIButtonTypeCustom];
            [butt setFrame:CGRectMake((kScreenWidth-90)/2*i, 0, (kScreenWidth-90)/2, 35)];
            [butt addTarget:self action:@selector(topButt:) forControlEvents:UIControlEventTouchUpInside];
            
            [butt setTag:10+i];
            [butt setBackgroundColor:[UIColor whiteColor]];
            
            
            if (butt.tag == 10) {
                [butt setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
            }
            
            UIImageView* backview = [[UIImageView alloc]init];
            [backview setBackgroundColor:[UIColor clearColor]];
            UIImage* image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (35-image.size.height/2)/2, image.size.width/2, image.size.height/2)];
            [imageView setImage:image];
            [backview addSubview:imageView];
            
            CGSize sizeWith = [self labelHight:[titleArr objectAtIndex:i]];
            
    
            label = [[UILabel alloc]initWithFrame:CGRectMake(image.size.width/2+5, 3, sizeWith.width+5, 25)];
            label.text = [titleArr objectAtIndex:i];
            [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
            label.tag = 20+i;
            label.textColor = [UIColor grayColor];
            [backview addSubview:label];
            if (label.tag == 20) {
                label.textColor = [UIColor whiteColor];
            }
            
            
            
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
    }
    return self;
}


- (void)topButt:(UIButton*)sender
{
    
    
//    UIImageView* oneimageView = (UIImageView*)[[self viewWithTag:10] viewWithTag:200];
//    UIImageView* twoimageView = (UIImageView*)[[self viewWithTag:11] viewWithTag:201];
    
    UIButton *button = (UIButton *)[self viewWithTag:10];
    UIButton *button1 = (UIButton *)[self viewWithTag:11];
    
    UILabel *lab = (UILabel *)[self viewWithTag:20];
    UILabel *lab1 = (UILabel *)[self viewWithTag:21];
    
    if (sender.tag == 10) {
        
        [self.delegate mapBtn:0];
        [button setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
        [button1 setBackgroundColor:[UIColor whiteColor]];
        
        lab.textColor = [UIColor whiteColor];
        lab1.textColor = [UIColor grayColor];
        
        
    }else {
    
        [self.delegate mapBtn:1];
        [button1 setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0]];
        [button setBackgroundColor:[UIColor whiteColor]];
        
        lab1.textColor = [UIColor whiteColor];
        lab.textColor = [UIColor grayColor];
        
    }
    
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
