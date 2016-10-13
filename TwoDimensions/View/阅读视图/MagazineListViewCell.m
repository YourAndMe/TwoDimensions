//
//  MagazineListViewCell.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-15.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MagazineListViewCell.h"

@implementation MagazineListViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        self.magazinePic = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 96, 132)];
        [self addSubview:self.magazinePic];
        
        //标题背景
        UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 112, 96, 20)];
        downView.backgroundColor = [UIColor blackColor];
        downView.alpha = 0.8;
        [self.magazinePic addSubview:downView];
        
        //标题
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 96, 20)];
        self.titleLab.font = [UIFont boldSystemFontOfSize:14];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.textColor = [UIColor whiteColor];
        [downView addSubview:self.titleLab];
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
