//
//  Nav.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-6.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "Nav.h"

@implementation Nav

- (id)initWithFrame:(CGRect)frame andImage:(NSString*)imageName andTarget:(id)target andAction:(SEL)rightAction
{
    self = [super initWithFrame:frame];
    if (self) {
        //导航条
        UIImageView *lab = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
        lab.image = [UIImage imageNamed:@"标题栏底@2x.png"];
        [self addSubview:lab];
        lab.userInteractionEnabled = YES;
        //导航条左侧标题
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 230, 26)];
        leftImage.image = [UIImage imageNamed:@"标题栏logo.png"];
        [lab addSubview:leftImage];
        //导航条右侧按钮
        UIButton *rightIamge = [UIButton buttonWithType:UIButtonTypeCustom];
        rightIamge.frame = CGRectMake(276, 5, 44, 34);
        [rightIamge setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [rightIamge addTarget:target action:rightAction forControlEvents:UIControlEventTouchUpInside];
        [lab addSubview:rightIamge];
        
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
