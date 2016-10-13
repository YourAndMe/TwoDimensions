//
//  IllustrationNav.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-19.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "IllustrationNav.h"

@implementation IllustrationNav

- (id)initWithFrame:(CGRect)frame andLeftImage:(NSArray*)leftImage andLeftImageHeightLight:(NSArray*)hightImage andLeftAction:(SEL)leftAction andRightImage:(NSArray*)rightImageArr andRightAction:(SEL)rightAction andTarget:(id)target andTitleName:(NSString*)name
{
    self = [super initWithFrame:frame];
    if (self) {
        //导航条背景图
        UIImageView *lab = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        lab.image = [UIImage imageNamed:@"ad_title_bg@2x.png"];
        [self addSubview:lab];
        lab.userInteractionEnabled = YES;
        
        //导航条左侧按钮
        for (int i=0; i<leftImage.count; i++) {
            UIButton *leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.frame = CGRectMake(5+36*i, 6.5, 31, 31);
            [leftBtn setImage:[UIImage imageNamed:leftImage[i]] forState:UIControlStateNormal];
//            [leftBtn setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
            [leftBtn addTarget:target action:leftAction forControlEvents:UIControlEventTouchUpInside];
            leftBtn.tag = 4100+i;
            [lab addSubview:leftBtn];
        }
        self.countLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 40, 34)];
        self.countLab.textAlignment = NSTextAlignmentLeft;
        self.countLab.textColor = [UIColor whiteColor];
        self.countLab.font = [UIFont boldSystemFontOfSize:14];
        [lab addSubview:self.countLab];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 80, 34)];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.textColor = [UIColor whiteColor];
        self.titleLab.font = [UIFont boldSystemFontOfSize:20];
        [lab addSubview:self.titleLab];
        
        //导航条右侧按钮
        for (int i=0; i<rightImageArr.count; i++) {
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(self.frame.size.width-36-36*i, 6.5, 31, 31);
            [rightBtn setImage:[UIImage imageNamed:rightImageArr[i]] forState:UIControlStateNormal];
            [rightBtn addTarget:target action:rightAction forControlEvents:UIControlEventTouchUpInside];
            rightBtn.tag = 4200+i;
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
