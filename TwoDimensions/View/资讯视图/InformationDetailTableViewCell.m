//
//  InformationDetailTableViewCell.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-12.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "InformationDetailTableViewCell.h"

@implementation InformationDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //信息图片
        self.picImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
        [self addSubview:self.picImage];
        
        //标题
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200, 25)];
        self.titleLab.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:self.titleLab];
        
        //描述
        self.desLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 200, 35)];
        self.desLab.font = [UIFont systemFontOfSize:13];
        self.desLab.textColor = [UIColor blackColor];
        self.desLab.numberOfLines = 0;
        [self addSubview:self.desLab];

        //作者和时间背景
        self.backLab = [[UIView alloc] initWithFrame:CGRectMake(100, 75, 210, 20)];
        self.backLab.backgroundColor = [UIColor colorWithRed:230/255.0 green:237/255.0 blue:240/255.0 alpha:1];
        self.backLab.clipsToBounds = YES;
        self.backLab.tag = 1212;
        self.backLab.layer.cornerRadius = 8;
        [self addSubview:self.backLab];

        //作者
        self.authorLab = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 100, 20)];
        self.authorLab.font = [UIFont systemFontOfSize:10];
        self.authorLab.textColor = [UIColor blackColor];
        [self.backLab addSubview:self.authorLab];
    
        //时间
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 90, 20)];
        self.timeLab.font = [UIFont systemFontOfSize:10];
        self.timeLab.textColor = [UIColor blackColor];
        [self.backLab addSubview:self.timeLab];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
