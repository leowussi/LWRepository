//
//  UIFactory.m
//  telecom
//
//  Created by ZhongYun on 14-6-11.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "UIFactory.h"

//p: tag, frame, textColor, font, Text
UILabel* newLabel(UIView* view, NSArray* p)
{
    NSInteger tag = [p[0] integerValue];
    UILabel* label = [[UILabel alloc] initWithFrame:id2rect(p[1])];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = p[2];
    label.font = p[3];
    label.tag = tag;
    label.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    if (p.count >= 5) label.text = p[4];
        
    [view addSubview:label];
    TEST_RGB(label, 1);
    [label release];
    return (UILabel*)[view viewWithTag:tag];
}

UILabel* newLabelLiu(UIView* view, NSArray* p)
{
    NSInteger tag = [p[0] integerValue];
    UILabel* label = [[UILabel alloc] initWithFrame:id2rect(p[1])];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = p[2];
    label.font = p[3];
    label.tag = tag;
    label.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    
//    NSDictionary *attributes = @{NSFontAttributeName:Font(16)};
//  
//    CGRect  rect = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    label.frame =CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, size.height);

    if (p.count >= 5) label.text = p[4];
    
    [view addSubview:label];
    TEST_RGB(label, 1);
    [label release];
    return (UILabel*)[view viewWithTag:tag];
}


//p: tag, frame, textColor, font, placeholder, Text
UITextField* newTextField(UIView* view, NSArray* p)
{
    NSInteger tag = [p[0] integerValue];
    UITextField *textField = [[UITextField alloc] initWithFrame:id2rect(p[1])];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.tag = tag;
    textField.textColor = p[2];
    textField.font = p[3];
    textField.placeholder = p[4];
    textField.text = p[5];
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor clearColor];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [view addSubview:textField];
    textField.delegate = (id<UITextFieldDelegate>)getViewController(view);
    
    TEST_RGB(textField, 1);
    [textField release];
    
    return (UITextField*)[view viewWithTag:tag];
}

//p: tag, frame, textColor, font, Text
UITextView* newTextView(UIView* view, NSArray* p)
{
    NSInteger tag = [p[0] integerValue];
    UITextView *obj = [[UITextView alloc] initWithFrame:id2rect(p[1])];
    obj.tag = tag;
    obj.textColor = p[2];
    obj.font = p[3];
    obj.text = p[4];
    obj.returnKeyType = UIReturnKeyDone;
    obj.backgroundColor = [UIColor clearColor];
    obj.layer.borderWidth = 0.5;
    obj.layer.borderColor = COLOR(210, 210, 210).CGColor;
    obj.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [view addSubview:obj];
    obj.delegate = (id<UITextViewDelegate>)getViewController(view);
    
    TEST_RGB(obj, 1);
    [obj release];
    
    return (UITextView*)[view viewWithTag:tag];
}

//p: tag, imageName, frame
UIImageView* newImageView(UIView* v, NSArray* p)
{
    NSInteger tag = [p[0] integerValue];
    UIImageView* imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:p[1]]];
    imgv.tag = tag;
    if (p.count >= 3)
        imgv.frame = id2rect(p[2]);
    [v addSubview:imgv];
    [imgv release];
    
    return (UIImageView*)[v viewWithTag:tag];
}


