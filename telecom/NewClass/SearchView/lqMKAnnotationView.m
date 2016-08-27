//
//  lqMKAnnotationView.m
//  telecom
//
//  Created by Sundear on 15/12/30.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "lqMKAnnotationView.h"
#import "lqAnnition.h"

@implementation lqMKAnnotationView
//@synthesize annotationImageView = _annotationImageView;
//@synthesize annotationImages = _annotationImages;
//
//- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
//    if (self) {
//        //        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
//        [self setBounds:CGRectMake(0.f, 0.f, 32.f, 32.f)];
//        
//        [self setBackgroundColor:[UIColor clearColor]];
//        
//        _annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _annotationImageView.contentMode = UIViewContentModeCenter;
//        [self addSubview:_annotationImageView];
//    }
//    return self;
//}
//
//- (void)setAnnotationImages:(NSMutableArray *)images {
//    _annotationImages = images;
//    [self updateImageView];
//}
//
//- (void)updateImageView {
//    if ([_annotationImageView isAnimating]) {
//        [_annotationImageView stopAnimating];
//    }
//    
//    _annotationImageView.animationImages = _annotationImages;
//    _annotationImageView.animationDuration = 0.5 * [_annotationImages count];
//    _annotationImageView.animationRepeatCount = 0;
//    [_annotationImageView startAnimating];
//}



+ (instancetype)myAnnoViewWithMapView:(BMKMapView *)mapView
{
    // 2.添加自己的大头针的View
    static NSString *ID = @"myAnnoView";
    lqMKAnnotationView *myAnnoView = (lqMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (myAnnoView == nil) {
        myAnnoView = [[lqMKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        
        // 1.设置标题和子标题可以呼出
        myAnnoView.canShowCallout = YES;
    }
    return myAnnoView;
}


-(void)setAnnotation:(lqAnnition *)annotation{
//    self.image = [UIImage imageNamed:annotation.icon];
    [super setAnnotation:annotation];

}

@end
