//
//  ScrollViewsReuse.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-13.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DetailInfomationView.h"
#define ITEM_SPACING 180

@interface ScrollViewsReuse : UIView<iCarouselDataSource,iCarouselDelegate>
{
    UIScrollView *_scr;
}
@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) DetailInfomationView *detailInfoPage;
@property (nonatomic, assign) BOOL boundary;
@property (nonatomic, assign) SEL btnDown;
- (id)initWithFrame:(CGRect)frame andData:(NSMutableArray*)dataArrSource andMainPage:(DetailInfomationView*)detailPages andAction:(SEL)detailLabBtnDown andTarget:(id)target;
@end
