//
//  Categorys.m
//  quanzhi
//
//  Created by ZhongYun on 14-1-9.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "Categorys.h"
#import <objc/runtime.h>

@implementation UIView (Postion)
-(CGFloat)fx {return self.frame.origin.x;}
-(CGFloat)fy {return self.frame.origin.y;}
-(CGFloat)fw {return self.frame.size.width;}
-(CGFloat)fh {return self.frame.size.height;}
-(CGFloat)bx {return self.bounds.origin.x;}
-(CGFloat)by {return self.bounds.origin.y;}
-(CGFloat)bw {return self.bounds.size.width;}
-(CGFloat)bh {return self.bounds.size.height;}

-(CGFloat)ex {return self.frame.origin.x + self.frame.size.width;}
-(CGFloat)ey {return self.frame.origin.y + self.frame.size.height;}

-(void)setFx:(CGFloat)fx {CGRect frame=self.frame;frame.origin.x=fx;self.frame=frame;}
-(void)setFy:(CGFloat)fy {CGRect frame=self.frame;frame.origin.y=fy;self.frame=frame;}
-(void)setFw:(CGFloat)fw {CGRect frame=self.frame;frame.size.width=fw;self.frame=frame;}
-(void)setFh:(CGFloat)fh {CGRect frame=self.frame;frame.size.height=fh;self.frame=frame;}
-(void)setBx:(CGFloat)bx {CGRect frame=self.bounds;frame.origin.x=bx;self.bounds=frame;}
-(void)setBy:(CGFloat)by {CGRect frame=self.bounds;frame.origin.y=by;self.bounds=frame;}
-(void)setBw:(CGFloat)bw {CGRect frame=self.bounds;frame.size.width=bw;self.bounds=frame;}
-(void)setBh:(CGFloat)bh {CGRect frame=self.bounds;frame.size.height=bh;self.bounds=frame;}

@end


@implementation NSDictionary (MutableDeepCopy)
-(NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
    NSArray *keys=[self allKeys];
    for(id key in keys)
    {
        id value=[self objectForKey:key];
        id copyValue = nil;
        if ([value respondsToSelector:@selector(mutableDeepCopy)]) {
            //如果key对应的元素可以响应mutableDeepCopy方法(还是NSDictionary)，调用mutableDeepCopy方法复制
            copyValue=[value mutableDeepCopy];
        } else if([value isKindOfClass:[NSNumber class]]) {
            copyValue=[value copy];
        } else if([value respondsToSelector:@selector(mutableCopy)]) {
            copyValue=[value mutableCopy];
        }
        if(copyValue==nil)
            copyValue=[value copy];
        [dict setObject:copyValue forKey:key];
        
    }
    return dict;
}
@end


@implementation NSString (NoNullString)
- (NSString*)noNull
{
    return (self && ![self isEqual:[NSNull null]] ? self : @"");
}
@end

@implementation NSString (StringToJson)
- (id)jsonValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end


@implementation UIAlertView (Block)
static char key;
id oldDelegate = nil;

- (void)showWithBlock:(UIAlertViewButtonClick)block
{
    if (block) {
        //移除所有关联
        objc_removeAssociatedObjects(self);
        //创建关联
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        oldDelegate = self.delegate;
        self.delegate = self;
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //获取关联的对象，通过关键字。
    UIAlertViewButtonClick block = objc_getAssociatedObject(self, &key);
    if (block) {
        block(buttonIndex);
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView  // before animation and showing view
{
    if ([oldDelegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [oldDelegate performSelector:@selector(willPresentAlertView:) withObject:alertView];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation
{
    if ([oldDelegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [oldDelegate performSelector:@selector(didPresentAlertView:) withObject:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
    if ([oldDelegate respondsToSelector:@selector(alertView: didDismissWithButtonIndex:)]) {
        [oldDelegate performSelector:@selector(alertView: didDismissWithButtonIndex:) withObject:alertView withObject:nil];
    }
}

@end


@implementation UIButton(Block)
static char overviewKey;
@dynamic event;

//- (void)clickBlock:(UIControlEvents)event withBlock:(ActionBlock)block {
//    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
//}

- (void) clickBlock:(ActionBlock)block
{
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}


@end



