//
//  CommentQuiltViewCell.h
//  TwoDimensions
//
//  Created by mac on 15-1-19.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "TMQuiltViewCell.h"

@interface CommentQuiltViewCell : TMQuiltViewCell
//评论框背景
@property(nonatomic,strong)UIImageView *commentBack;
//用户
@property(nonatomic,strong)UILabel *userName;
//时间
@property(nonatomic,strong)UILabel *times;
//评论内容
@property(nonatomic,strong)UILabel *contents;

-(void)requestDataWithIndex:(int)index;
@end
