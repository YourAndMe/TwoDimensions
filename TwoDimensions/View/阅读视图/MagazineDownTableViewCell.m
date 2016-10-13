//
//  MagazineDownTableViewCell.m
//  TwoDimensions
//
//  Created by mac on 15-1-15.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MagazineDownTableViewCell.h"

@implementation MagazineDownTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //向下三角
        self.down = [[UIImageView alloc] initWithFrame:CGRectMake(154.5, 0, 21, 11)];
        self.down.hidden = YES;
        self.down.image = [UIImage imageNamed:@"下拉后三角@2x.png"];
        [self addSubview:self.down];
        
        //图片
        self.starPic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        self.starPic.image = [UIImage imageNamed:@"大星星@2x.png"];
        self.starPic.hidden = YES;
        [self addSubview:self.starPic];
        
        //标题
        self.chapterName = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 275, 20)];
        self.chapterName.font = [UIFont boldSystemFontOfSize:16];
        self.chapterName.textAlignment = NSTextAlignmentLeft;
        self.chapterName.textColor = [UIColor whiteColor];
        [self addSubview:self.chapterName];
    }
    return self;
}

@end
