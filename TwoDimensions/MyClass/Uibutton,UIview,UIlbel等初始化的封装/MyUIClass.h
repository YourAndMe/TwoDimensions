//
//  MyUIClass.h
//  UIClass
//
//  Created by student on 14-11-20.
//  Copyright (c) 2014年 student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUIClass : NSObject

+(UIView *)makeUIViewWithFram:(CGRect)rect andBackColor:(UIColor*)color;

+(UILabel *)makeUILabelWithFrame:(CGRect)rect andBackColor:(UIColor*)backColor andText:(NSString *)text andTextColor:(UIColor *)textColor andFont:(UIFont *)font andAlignment:(NSTextAlignment)alignment;

+(UIImageView *)makeUIImageViewWithFrame:(CGRect)rect andImage:(NSString *)imageName;

+(UITextField *)makeUITextFieldWithFrame:(CGRect)rect andDelegate:(id)target andBorderStyle:(UITextBorderStyle)borderStyle andPlaceholder:(NSString *)str  andAutocorrectionType:(UITextAutocorrectionType)autocorrectionType andAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType andClearButtonMode:(UITextFieldViewMode)clearButtonMode andSecureTextEntry:(BOOL)secureTextEntry andKeyboardType:(UIKeyboardType)keyboardType andReturnKeyType:(UIReturnKeyType)returnKeyType;

+(UIButton *)makeUIButtonWithFrame:(CGRect)rect andType:(UIButtonType)type andTitle:(NSString *)title andImageName:(NSString *)iamgeName andTarget:(id)target andSelector:(SEL)selector andEvent:(UIControlEvents)event andState:(UIControlState)state;

@end
