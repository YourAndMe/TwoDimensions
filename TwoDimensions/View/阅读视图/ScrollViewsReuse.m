//
//  ScrollViewsReuse.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-13.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "ScrollViewsReuse.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
#import "MainPageScrView.h"
#import "MagazeneAndNovelDetailViewController.h"

@implementation ScrollViewsReuse

- (id)initWithFrame:(CGRect)frame andData:(NSMutableArray*)dataArrSource andMainPage:(DetailInfomationView*)detailPages andAction:(SEL)detailLabBtnDown andTarget:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        //首页图片显示
        self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        self.carousel.backgroundColor = [UIColor colorWithRed:40/255.0 green:55/255.0 blue:62/255.0 alpha:1];
        self.detailInfoPage = detailPages;
        self.dataArr = [NSArray arrayWithArray:dataArrSource];
        self.carousel.bounces = NO;
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
        self.carousel.type = iCarouselTypeLinear;
        [self addSubview:self.carousel];
        
        //图片选中框
        UIImageView *attention = [[UIImageView alloc] initWithFrame:CGRectMake(90, 6, 142, 197)];
        attention.image = [UIImage imageNamed:@"b杂志章节里篮筐@2x.png"];
        [self.carousel addSubview:attention];
    
    }
    return self;
}

#pragma mark 图片切换代理
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    Model *modelHe = self.dataArr[index];
    MagazeneAndNovelDetailViewController *detailView = [[MagazeneAndNovelDetailViewController alloc] init];
    detailView.Id = modelHe.idInfo;
    detailView.leftPic = modelHe.icon;
    detailView.infoTitleName = modelHe.title;
    detailView.authorName = modelHe.author;
    detailView.statusName = modelHe.status;
    detailView.updateName = modelHe.update;
    detailView.typeName = modelHe.type;
    detailView.keyWordName = modelHe.keyword;
    detailView.describName = modelHe.des;
    //做一个通知，用来通知页面跳转
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSNotification *notify = [NSNotification notificationWithName:@"pp" object:detailView];//第一个参数
    [center postNotification:notify];
}

-(void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
    
}

-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if (self.dataArr.count) {
        Model *modelHere = self.dataArr[carousel.currentItemIndex];
        self.detailInfoPage.authorLab.text = [NSString stringWithFormat:@"作者 : %@",modelHere.author];
        self.detailInfoPage.timeLab.text = modelHere.update;
        self.detailInfoPage.titleLab.text = modelHere.title;
        self.detailInfoPage.scr.contentSize = CGSizeMake(320, [self getWidthWithNSString:modelHere.des]);
        self.detailInfoPage.detailLab.frame = CGRectMake(20, 10, 300, [self getWidthWithNSString:modelHere.des]);
        self.detailInfoPage.detailLab.text = modelHere.des;
        [self.detailInfoPage.detailLabBtn setTitle:modelHere.magazineId forState:UIControlStateNormal];
        [self.detailInfoPage.detailLabBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
}


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.dataArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    Model *modelHere = self.dataArr[index];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 180)];
    [view setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com%@",modelHere.icon]]];
    if (index == 0) {
        self.detailInfoPage.authorLab.text = [NSString stringWithFormat:@"作者 : %@",modelHere.author];
        self.detailInfoPage.timeLab.text = modelHere.update;
        self.detailInfoPage.titleLab.text = modelHere.title;
        self.detailInfoPage.scr.contentSize = CGSizeMake(320, [self getWidthWithNSString:modelHere.des]);
        self.detailInfoPage.detailLab.frame = CGRectMake(20, 10, 300, [self getWidthWithNSString:modelHere.des]);
        self.detailInfoPage.detailLab.text = modelHere.des;
        [self.detailInfoPage.detailLabBtn setTitle:modelHere.magazineId forState:UIControlStateNormal];
        [self.detailInfoPage.detailLabBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        
    };
    //图片白框
    UIImageView *attention = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -6, 142, 197)];
    attention.image = [UIImage imageNamed:@"b杂志章节里白框@2x.png"];
    [view addSubview:attention];
    return view;
}


- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return self.dataArr.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}
//计算一定宽度下文字所占的高度
-(float)getWidthWithNSString:(NSString*)str
{
	return [str boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
}
-(BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return self.boundary;
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
