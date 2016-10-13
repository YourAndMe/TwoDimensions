//
//  CartoonTableViewCell.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-17.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "CartoonTableViewCell.h"
#import "Model.h"
#import "UIImageView+WebCache.h"

@implementation CartoonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //向下三角
        self.down = [[UIImageView alloc] initWithFrame:CGRectMake(154.5, 0, 21, 11)];
        self.down.hidden = YES;
        self.down.image = [UIImage imageNamed:@"下拉后三角@2x.png"];
        [self addSubview:self.down];
        //滚动视图
        self.scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
        self.scr.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scr];
    }
    return self;
}
//当有数据源时，布局图片
-(void)makeScrPicWithAction:(SEL)picBtnDown andTarget:(id)target andIndexSection:(int)sections andLastSel:(int)lastSelect
{
    for (id temp in self.scr.subviews) {
        [temp removeFromSuperview];
    }
    self.scr.contentSize = CGSizeMake(99*self.dataPicArr.count, 140);
    for (int i=0; i<self.dataPicArr.count; i++) {
        //漫画图片
        UIImageView *cartoon = [[UIImageView alloc] initWithFrame:CGRectMake(10+99*i, 10, 89, 120)];
        [cartoon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",self.dataPicArr[i][@"icon"]]]];
        [self.scr addSubview:cartoon];
        cartoon.userInteractionEnabled = YES;
        
        //背景
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, cartoon.frame.size.width, 20)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7;
        [cartoon addSubview:view];
        
        //星星图片
        UIImageView *starPic = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 16, 16)];
        starPic.image = [UIImage imageNamed:@"大星星@2x.png"];
        if (lastSelect == i+sections*100) {
            starPic.hidden = NO;
        }else{
            starPic.hidden = YES;
        }
        starPic.tag = 12000+i+sections*100;
        [view addSubview:starPic];
        
        //标题
        UILabel *chapterName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, cartoon.frame.size.width-40, 20)];
        chapterName.font = [UIFont boldSystemFontOfSize:16];
        chapterName.text = [NSString stringWithFormat:@"%02d",[self.dataPicArr[i][@"order"] intValue]];
        chapterName.textAlignment = NSTextAlignmentCenter;
        chapterName.textColor = [UIColor whiteColor];
        [view addSubview:chapterName];
        
        UIButton *btnPic = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPic.backgroundColor = [UIColor clearColor];
        btnPic.frame = cartoon.bounds;
        [btnPic addTarget:target action:picBtnDown forControlEvents:UIControlEventTouchUpInside];
        [btnPic setTitle:self.dataPicArr[i][@"id"] forState:UIControlStateNormal];
        [btnPic setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        btnPic.tag = 17000+i+sections*100;
        [cartoon addSubview:btnPic];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
