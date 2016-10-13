//
//  IllustrationCollectionViewCell.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-12.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "IllustrationCollectionViewCell.h"

@implementation IllustrationCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 140, 165)];
        self.backImage.image = [UIImage imageNamed:@"图片列表-蓝底@2x.png"];
        [self addSubview:self.backImage];
        
        //图片
        self.picImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 130, 130)];
        self.picImage.clipsToBounds = YES;
        self.picImage.layer.cornerRadius = 5;
        [self.backImage addSubview:self.picImage];
        
        //标题
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, 130, 20)];
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        self.nameLab.font = [UIFont boldSystemFontOfSize:16];
        self.nameLab.textColor = [UIColor whiteColor];
        [self.backImage addSubview:self.nameLab];
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
