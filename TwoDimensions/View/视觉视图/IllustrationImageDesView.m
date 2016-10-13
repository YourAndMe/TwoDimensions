//
//  IllustrationImageDesView.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-19.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "IllustrationImageDesView.h"

@implementation IllustrationImageDesView

- (id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)btnDown
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(0, 0, self.frame.size.width, 30);
        [self.btn setImage:[UIImage imageNamed:@"图片内文页-透明条小@2x.png"] forState:UIControlStateNormal];
        [self.btn addTarget:target action:btnDown forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        
        self.picTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.frame.size.width-15-45, 20)];
        self.picTitle.backgroundColor = [UIColor clearColor];
        self.picTitle.textColor = [UIColor whiteColor];
        self.picTitle.font = [UIFont systemFontOfSize:16];
        self.picTitle.textAlignment = NSTextAlignmentCenter;
        [self.btn addSubview:self.picTitle];
        
        self.upRow = [[UIImageView alloc] initWithFrame:CGRectMake(self.btn.frame.size.width-25, 5, 20, 20)];
        self.upRow.image = [UIImage imageNamed:@"图片说明打开后@2x.png"];
        [self.btn addSubview:self.upRow];
        
        self.describImagBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-160, self.frame.size.width, 160)];
        self.describImagBack.image = [UIImage imageNamed:@"图片内文页-透明条大@2x.png"];
        [self addSubview:self.describImagBack];
        self.describImagBack.userInteractionEnabled = YES;
        
        
        self.imagDesScr = [[UIScrollView alloc] initWithFrame:self.describImagBack.bounds];
        [self.describImagBack addSubview:self.imagDesScr];
        self.imagDesScr.scrollEnabled = YES;
        self.imagDesScr.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        
        self.imagDesLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.imagDesScr.frame.size.width-20, 150)];
        self.imagDesLab.textColor = [UIColor whiteColor];
        self.imagDesLab.backgroundColor = [UIColor clearColor];
        self.imagDesLab.font = [UIFont systemFontOfSize:14];
        self.imagDesLab.numberOfLines = 0;
        [self.imagDesScr addSubview:self.imagDesLab];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
