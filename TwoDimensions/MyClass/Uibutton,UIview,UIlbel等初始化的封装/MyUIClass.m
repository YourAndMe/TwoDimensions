
//
//  MyUIClass.m
//  UIClass
//
//  Created by student on 14-11-20.
//  Copyright (c) 2014年 student. All rights reserved.
//

#import "MyUIClass.h"

@implementation MyUIClass

+(UIView *)makeUIViewWithFram:(CGRect)rect andBackColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = color;
    return [view autorelease];
}
+(UILabel *)makeUILabelWithFrame:(CGRect)rect andBackColor:(UIColor *)backColor andText:(NSString *)text andTextColor:(UIColor *)textColor andFont:(UIFont *)font andAlignment:(NSTextAlignment)alignment
{
    UILabel *lab = [[UILabel alloc] initWithFrame:rect];
    lab.text = text;
    lab.backgroundColor = backColor;
    lab.textColor = textColor;
    lab.font = font;
    lab.textAlignment = alignment;
    return [lab autorelease];
    
}

+(UIImageView *)makeUIImageViewWithFrame:(CGRect)rect andImage:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = [UIImage imageNamed:imageName];
    return [imageView autorelease];
}
+(UITextField *)makeUITextFieldWithFrame:(CGRect)rect andDelegate:(id)target andBorderStyle:(UITextBorderStyle)borderStyle andPlaceholder:(NSString *)str andAutocorrectionType:(UITextAutocorrectionType)autocorrectionType andAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType andClearButtonMode:(UITextFieldViewMode)clearButtonMode andSecureTextEntry:(BOOL)secureTextEntry andKeyboardType:(UIKeyboardType)keyboardType andReturnKeyType:(UIReturnKeyType)returnKeyType
{
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    textField.delegate = target;
    textField.borderStyle = borderStyle;
    textField.placeholder = str;
    textField.autocorrectionType =autocorrectionType;
    textField.autocapitalizationType = autocapitalizationType;
    textField.clearButtonMode = clearButtonMode;
    textField.secureTextEntry = secureTextEntry;
    textField.keyboardType = keyboardType;
    textField.returnKeyType = returnKeyType;
    return [textField autorelease];
}
+(UIButton *)makeUIButtonWithFrame:(CGRect)rect andType:(UIButtonType)type andTitle:(NSString *)title andImageName:(NSString *)iamgeName andTarget:(id)target andSelector:(SEL)selector andEvent:(UIControlEvents)event andState:(UIControlState)state
{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = rect;
    if (type == 0) {
        [btn setImage:[UIImage imageNamed:iamgeName] forState:state];
    }else{
        [btn setTitle:title forState:state];
    }
    [btn addTarget:target action:selector forControlEvents:event];
    return btn;
}

@end
