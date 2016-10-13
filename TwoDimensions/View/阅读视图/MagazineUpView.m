//
//  MagazineUpView.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-15.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MagazineUpView.h"

@implementation MagazineUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片外框
        UIImageView *attention = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 135)];
        attention.image = [UIImage imageNamed:@"b杂志章节里篮筐@2x.png"];
        [self addSubview:attention];
        //左侧图片
        self.leftPic = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 92, 123.5)];
        self.leftPic.clipsToBounds = YES;
        self.leftPic.layer.cornerRadius = 3;
        [attention addSubview:self.leftPic];
        //滚动视图
        self.scr = [[UIScrollView alloc] initWithFrame:CGRectMake(120, 10, 190, 135)];
        self.scr.bounces = NO;
        self.scr.backgroundColor = [UIColor clearColor];
        self.scr.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
        [self addSubview:self.scr];
        self.scr.contentSize = CGSizeMake(190, 95);
        //标题
        self.titleNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scr.frame.size.width, 0)];
        self.titleNameLab.font = [UIFont boldSystemFontOfSize:18];
        self.titleNameLab.numberOfLines = 0;
        [self.scr addSubview:self.titleNameLab];
        //作者
        self.authorLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scr.frame.size.width, 0)];
        self.authorLab.font = [UIFont systemFontOfSize:14];
        self.authorLab.numberOfLines = 0;
        [self.scr addSubview:self.authorLab];
        //刊登
        self.statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scr.frame.size.width, 0)];
        self.statusLab.font = [UIFont systemFontOfSize:14];
        self.statusLab.numberOfLines = 0;
        [self.scr addSubview:self.statusLab];
        //更新时间
        self.updateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scr.frame.size.width, 0)];
        self.updateLab.font = [UIFont systemFontOfSize:14];
        self.updateLab.numberOfLines = 0;
        [self.scr addSubview:self.updateLab];
        //类别
        self.typeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scr.frame.size.width, 0)];
        self.typeLab.font = [UIFont systemFontOfSize:14];
        self.typeLab.numberOfLines = 0;
        [self.scr addSubview:self.typeLab];
        //关键字
        self.keyWordLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scr.frame.size.width, 0)];
        self.keyWordLab.font = [UIFont systemFontOfSize:14];
        self.keyWordLab.numberOfLines = 0;
        [self.scr addSubview:self.keyWordLab];
        //简介
        self.describLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scr.frame.size.width, 0)];
        self.describLab.font = [UIFont systemFontOfSize:14];
        self.describLab.numberOfLines = 0;
        [self.scr addSubview:self.describLab];
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
