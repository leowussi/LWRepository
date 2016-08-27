//
//  AnnotationTopView.m
//  telecom
//
//  Created by SD0025A on 16/6/22.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "AnnotationTopView.h"

@implementation AnnotationTopView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = COLOR(249, 202, 47);
    }
    return self;
}
- (IBAction)deleteView:(UIButton *)sender {
   
    [self.delegate deleteAnnotationTopView];
}
@end
