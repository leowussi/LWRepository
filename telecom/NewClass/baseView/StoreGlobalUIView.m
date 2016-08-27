//
//  CouponGlobalUIView.m
//  Coupon
//
//  Created by chenliang Fu on 14/1/8.
//  Copyright (c) 2014 . All rights reserved.
//

#import "StoreGlobalUIView.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIView (Store)

- (void)removeAllSubViews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end

//@implementation KaKaViewController (Store)
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo"]];
//    
//    int top = 11;
//    CGSize size = iconImageView.frame.size;
//    iconImageView.frame = CGRectMake(0, top, size.width, size.height);
//    
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, top + size.height)];
//    [titleView addSubview:iconImageView];
//    
//    self.navigationItem.titleView = titleView;
//    
//}

//- (void)onLogonTimeoutException {
//    Member *member = [LoginUtils checkLoginStatus];
//    
//    if (member != nil) {
//        [GlobalData shared].applicationHelper.logonMember = member;
//    }else {
//        
//        //[AlertUtils alert:@"您尚未登录，或登录超时。"];
//        
//        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController"];
//        controller.presentModal = YES;
//        
//        if ([self conformsToProtocol:@protocol(LoginDelegate)]) {
//            NSObject<LoginDelegate> *delegate = (NSObject<LoginDelegate> *)self;
//            controller.loginDelegate = delegate;
//        }
//        
//        [self.navigationController presentModalViewController:controller animated:YES];
//    }
//    
//}

//@end



//For iOS 4.x
@implementation UINavigationBar (Store)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    //只替换默认类型的navigationbar
	if (![self isMemberOfClass:[UINavigationBar class]] ||
		self.barStyle != UIBarStyleDefault) {
		return [super drawLayer:layer inContext:ctx];
	}
	UIImage *image = [UIImage imageNamed:@"02-dibulan"];
    //	CGContextClip(ctx);
	CGContextTranslateCTM(ctx, 0, self.frame.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	CGContextDrawImage(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), image.CGImage);
}

@end


//For iOS 5.x up
@implementation UINavigationController (Store) 

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationBar.barStyle != UIBarStyleDefault) {
        return;
    }
    [self.navigationBar setTintColor:[UIColor redColor]];//[UIColor colorWithRed:21/255 green:43/255 blue:68/255 alpha:1]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],
                                    NSForegroundColorAttributeName,
                                    [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0],
                                    NSFontAttributeName,nil];
        [self.navigationBar setTitleTextAttributes:attributes];
        self.navigationBar.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:43.0/255.0 blue:68.0/255.0 alpha:1];
    }
    if ([self.navigationBar respondsToSelector:@selector(setTintColor:)]) {
        [self.navigationBar setTintColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0]];
    }
}

@end

