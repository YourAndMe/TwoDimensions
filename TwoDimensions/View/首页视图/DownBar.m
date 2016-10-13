//
//  DownBar.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-6.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "DownBar.h"

@implementation DownBar

- (id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)btnAction
{
    self = [super initWithFrame:frame];
    if (self) {
        //按钮背景
        UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backImg.image = [UIImage imageNamed:@"菜单栏底@2x.png"];
        [self addSubview:backImg];
        backImg.userInteractionEnabled = YES;
        //按钮布局
        NSArray *titleArr = @[@"01-资讯@2x.png",@"02-阅读@2x.png",@"03-生活@2x.png",@"04-视觉@2x.png",@"05-微博@2x.png"];
        for (int i=0; i<titleArr.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(64*i, 0, 64, 49);
            [btn addTarget:target action:btnAction forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1000+i;
            btn.backgroundColor = [UIColor clearColor];
            [backImg addSubview:btn];
            
            UIImageView *btnImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 48, 19)];
            btnImg.image = [UIImage imageNamed:titleArr[i]];
            [btn addSubview:btnImg];
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
