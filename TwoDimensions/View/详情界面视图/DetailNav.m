//
//  DetailNav.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-8.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "DetailNav.h"

@implementation DetailNav

- (id)initWithFrame:(CGRect)frame andLeftImage:(NSString*)leftImage andLeftImageHeightLight:(NSString*)hightImage andLeftAction:(SEL)leftAction andRightImage:(NSArray*)rightImageArr andRightAction:(SEL)rightAction andTarget:(id)target andTitleName:(NSString*)name
{
    self = [super initWithFrame:frame];
    if (self) {
        //导航条背景图
        UIImageView *lab = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        lab.image = [UIImage imageNamed:@"标题栏底@2x.png"];
        [self addSubview:lab];
        lab.userInteractionEnabled = YES;
        
        //导航条左侧按钮
        UIButton *leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(5, 6, 47.25, 36);
        [leftBtn setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
        [leftBtn addTarget:target action:leftAction forControlEvents:UIControlEventTouchUpInside];
        [lab addSubview:leftBtn];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 80, 34)];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.textColor = [UIColor colorWithRed:55/255.0 green:156/255.0 blue:192/255.0 alpha:1];
        self.titleLab.text = name;
        self.titleLab.font = [UIFont boldSystemFontOfSize:20];
        [lab addSubview:self.titleLab];
        
        //导航条右侧按钮
        for (int i=0; i<rightImageArr.count; i++) {
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(self.frame.size.width-20-72+46*i, 6, 36, 36);
            [rightBtn setImage:[UIImage imageNamed:rightImageArr[i]] forState:UIControlStateNormal];
            [rightBtn addTarget:target action:rightAction forControlEvents:UIControlEventTouchUpInside];
            rightBtn.tag = 1100+i;
            [lab addSubview:rightBtn];
        }
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
