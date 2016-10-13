//
//  CommentQuiltViewCell.m
//  TwoDimensions
//
//  Created by mac on 15-1-19.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "CommentQuiltViewCell.h"

@implementation CommentQuiltViewCell
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void)requestDataWithIndex:(int)index
{
    //评论显示框
    self.commentBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 102)];
    if(index%2==0){
        self.commentBack.image = [UIImage imageNamed:@"评论显示框-1@2x.png"];
    }else{
        self.commentBack.image = [UIImage imageNamed:@"评论显示框-2@2x.png"];
    }
    [self addSubview:self.commentBack];

    //用户名
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 140, 20)];
    self.userName.font = [UIFont boldSystemFontOfSize:14];
    self.userName.textAlignment = NSTextAlignmentLeft;
    [self.commentBack addSubview:self.userName];
    
    //时间
    self.times = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 140, 20)];
    self.times.font = [UIFont systemFontOfSize:14];
    self.times.textAlignment = NSTextAlignmentRight;
    [self.commentBack addSubview:self.times];
    
    //评论内容
    self.contents = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, self.commentBack.frame.size.width-10, 70)];
    self.contents.font = [UIFont systemFontOfSize:14];
    self.contents.numberOfLines = 0;
    [self.commentBack addSubview:self.contents];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
