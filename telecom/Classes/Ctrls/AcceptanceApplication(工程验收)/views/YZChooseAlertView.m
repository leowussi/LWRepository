//
//  YZChooseAlertView.m
//  AcceptanceApplication
//
//  Created by 锋 on 16/5/24.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZChooseAlertView.h"

@implementation YZPlaceholderTextView

#pragma mark - 重写父类方法
- (void)setText:(NSString *)text {
    [super setText:text];
    [self drawPlaceholder];
    return;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (![placeholder isEqual:_placeholder]) {
        _placeholder = placeholder;
        [self drawPlaceholder];
    }
    return;
}

#pragma mark - 父类方法
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureBase];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureBase];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_shouldDrawPlaceholder) {
        [_placeholderTextColor set];
        [_placeholder drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f,
                                            self.frame.size.height - 16.0f) withFont:self.font];
    }
    return;
}

- (void)configureBase {
    [[NSNotificationCenter defaultCenter] addObserver:self
                            selector:@selector(textChanged:)
                                name:UITextViewTextDidChangeNotification
                              object:self];
    
    self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
    _shouldDrawPlaceholder = NO;
    return;
}

- (void)drawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderTextColor && self.text.length == 0;
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
    return;
}

- (void)textChanged:(NSNotification *)notification {
    [self drawPlaceholder];
    return;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    return;
}

@end
@interface YZChooseAlertView ()<UITextViewDelegate>
{
    YZPlaceholderTextView *_textView;
    UIButton *_previousButton;
    UIView *_backgroundView;

    UIView *_bottomButtonView;
}
@end
@implementation YZChooseAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 20);
        _backgroundView.bounds = CGRectMake(0, 0, 290, 220);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        [self addSubview:_backgroundView];
        
        _backgroundView.layer.cornerRadius = 4;
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        _backgroundView.layer.shadowOffset = CGSizeMake(0, 5);
        _backgroundView.layer.shadowRadius = 4;
        _backgroundView.layer.shadowOpacity = .3f;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 100, 40)];
        titleLabel.text = @"提示";
        titleLabel.font = [UIFont systemFontOfSize:20];
        [_backgroundView addSubview:titleLabel];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(240, 10, 40, 40);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"paopao关闭"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:cancelButton];
        
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = [UIColor grayColor].CGColor;
        lineLayer.frame = CGRectMake(0, 50, 290, 0.5);
        [_backgroundView.layer addSublayer:lineLayer];
        
        
        NSArray *array = @[@"合格",@"不合格",@"有遗留问题"];
        
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(24, 54 + (30 + 4) * i, 140, 30);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentLeft;
            [button setTitle:array[i] forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.contentEdgeInsets = UIEdgeInsetsMake(0,28, 0, 0);
            button.tag = i + 1;
            [button addTarget:self action:@selector(selectedButtonForChoose:) forControlEvents:UIControlEventTouchUpInside];
            [_backgroundView addSubview:button];

            CALayer *imageLayer = [CALayer layer];
            imageLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
            imageLayer.frame = CGRectMake(0, 5, 20, 20);
            [button.layer addSublayer:imageLayer];
            
        }
        
        _bottomButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundView.frame.size.height - 51, _backgroundView.frame.size.width, 51)];
        [_backgroundView addSubview:_bottomButtonView];
        CALayer *bottomLineLayer = [CALayer layer];
        bottomLineLayer.backgroundColor = [UIColor grayColor].CGColor;
        bottomLineLayer.frame = CGRectMake(0, 0, 290, 1);
        [_bottomButtonView.layer addSublayer:bottomLineLayer];
        
        UIButton *trueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        trueButton.frame = CGRectMake(144.25, 1, 144.75, 50);
        [trueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [trueButton setTitle:@"确定" forState:UIControlStateNormal];
        [trueButton addTarget:self action:@selector(trueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomButtonView addSubview:trueButton];
        
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        otherButton.frame = CGRectMake(0, 1, 144.75, 50);
        [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [otherButton setTitle:@"取消" forState:UIControlStateNormal];
        [otherButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomButtonView addSubview:otherButton];

        
        CALayer *aLineLayer = [CALayer layer];
        aLineLayer.backgroundColor = [UIColor grayColor].CGColor;
        aLineLayer.frame = CGRectMake(139.75, 1, 0.5, 50);
        [_bottomButtonView.layer addSublayer:aLineLayer];
    }
    return self;
}

- (void)trueButtonClicked:(UIButton *)sender
{
    if (_previousButton.tag != 1 && (_textView.text == nil || [_textView.text isEqualToString:@""])) {
        NSString *message = nil;
        if (_previousButton.tag == 2) {
            message = @"请填写备注信息";
        }else{
            message = @"请填写遗留问题";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    _respBlock(_previousButton.tag,_textView.text);
    [self removeFromSuperview];
}

- (void)selectedButtonForChoose:(UIButton *)sender
{
    if (_previousButton == sender) {
        return;
    }
    sender.selected = YES;
    
    
    if (sender.tag == 1 && _previousButton != nil) {
        [_textView removeFromSuperview];
        [UIView animateWithDuration:.2 animations:^{
           _backgroundView.bounds = CGRectMake(0, 0, 290, 220);
           _bottomButtonView.frame = CGRectMake(0, _backgroundView.frame.size.height - 51, _backgroundView.frame.size.width, 51);
        }];
    }else if (sender.tag == 2) {
        if (_textView == nil) {
            [self addTextView];
        }
        if (_textView.superview == nil) {
            [_backgroundView addSubview:_textView];
            _textView.alpha = 0.0;
            _textView.placeholder = @"请填写备注信息...";
            [UIView animateWithDuration:.2 animations:^{
                _textView.alpha = 1.0;
                _backgroundView.bounds = CGRectMake(0, 0, 290, 300);
                _bottomButtonView.frame = CGRectMake(0, _backgroundView.frame.size.height - 51, _backgroundView.frame.size.width, 51);
            }];

        }else{
             _textView.placeholder = @"请填写备注信息...";
            [_textView setNeedsDisplay];
        }
       
    }else{
        if (_textView == nil) {
            [self addTextView];
        }
        if (_textView.superview == nil) {
            [_backgroundView addSubview:_textView];
            _textView.alpha = 0.0;
            _textView.placeholder = @"请填写遗留问题...";
            [UIView animateWithDuration:.2 animations:^{
                _textView.alpha = 1.0;
                _backgroundView.bounds = CGRectMake(0, 0, 290, 300);
                _bottomButtonView.frame = CGRectMake(0, _backgroundView.frame.size.height - 51, _backgroundView.frame.size.width, 51);
            }];
            
        }else{
            _textView.placeholder = @"请填写遗留问题...";
            [_textView setNeedsDisplay];
        }

    }
    
    
    
    
    CALayer *layer = [sender.layer.sublayers lastObject];
    layer.contents = (id)[UIImage imageNamed:@"select"].CGImage;
    
    if (_previousButton != nil) {
        CALayer *previousLayer = [_previousButton.layer.sublayers lastObject];
        previousLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
    }
    _previousButton = sender;

}

#pragma mark -- 添加textView
- (void)addTextView
{
    _textView = [[YZPlaceholderTextView alloc] initWithFrame:CGRectMake(36, 156, 218, 80)];
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.borderWidth = .5;
    _textView.delegate = self;
    _textView.placeholderTextColor = [UIColor grayColor];
    _textView.font = [UIFont systemFontOfSize:14];
    
}

#pragma mark -- textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint point = _backgroundView.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:7];
    
    point.y = kScreenHeight - 297 - _backgroundView.bounds.size.height/2 + _bottomButtonView.frame.size.height;
    _backgroundView.center = point;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:7];
    
    _backgroundView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 20);
    [UIView commitAnimations];
    
}

- (void)cancelButtonClicked
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
