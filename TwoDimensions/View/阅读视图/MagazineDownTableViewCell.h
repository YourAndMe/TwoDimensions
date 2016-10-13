//
//  MagazineDownTableViewCell.h
//  TwoDimensions
//
//  Created by mac on 15-1-15.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagazineDownTableViewCell : UITableViewCell
//向下三角
@property(nonatomic,strong)UIImageView *down;
//红星
@property(nonatomic,strong)UIImageView *starPic;
//章节标题
@property(nonatomic,strong)UILabel *chapterName;
@end
