//
//  DetailInfomationView.m
//  TwoDimensions
//
//  Created by mac on 15-1-13.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "DetailInfomationView.h"

@implementation DetailInfomationView
- (id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)btnAction
{
    self = [super initWithFrame:frame];
    if (self) {
        //作者和时间的背景
        UIView *back1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        back1.backgroundColor = [UIColor colorWithRed:232/255.0 green:194/255.0 blue:67/255.0 alpha:1];
        [self addSubview:back1];
        
        //作者
        self.authorLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 160, 20)];
        self.authorLab.font = [UIFont systemFontOfSize:14];
        self.authorLab.textAlignment = NSTextAlignmentLeft;
        [back1 addSubview:self.authorLab];
        
        //时间
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(180, 5, 130, 20)];
        self.timeLab.font = [UIFont systemFontOfSize:14];
        self.timeLab.textAlignment = NSTextAlignmentRight;
        [back1 addSubview:self.timeLab];
        
        //标题与右侧按钮背景
        UIImageView *back2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 320, 42)];
        back2.image = [UIImage imageNamed:@"标题栏底@2x.png"];
        [self addSubview:back2];
        back2.userInteractionEnabled = YES;
        
        //标题
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 220, 32)];
        self.titleLab.font = [UIFont boldSystemFontOfSize:20];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [back2 addSubview:self.titleLab];
        
        //右侧按钮
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(258, 3, 42, 32);
        [self.btn setImage:[UIImage imageNamed:@"更多方块@2x.png"] forState:UIControlStateNormal];
        [self.btn setImage:[UIImage imageNamed:@"load_more_h.png"] forState:UIControlStateHighlighted];
        [self.btn addTarget:target action:btnAction forControlEvents:UIControlEventTouchUpInside];
        [back2 addSubview:self.btn];
        
        //详情
        self.scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 72, 320, self.frame.size.height)];
        self.scr.bounces = NO;
        self.scr.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
        [self addSubview:self.scr];
        self.scr.contentSize = CGSizeMake(320, self.frame.size.height);
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 0)];
        self.detailLab.font = [UIFont systemFontOfSize:16];
        self.detailLab.numberOfLines = 0;
        [self.scr addSubview:self.detailLab];
        
        //详情文字按钮
        self.detailLabBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.detailLabBtn.frame = self.scr.bounds;
        [self.scr addSubview:self.detailLabBtn];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
