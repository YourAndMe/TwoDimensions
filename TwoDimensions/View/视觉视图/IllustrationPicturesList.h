//
//  IllustrationPicturesList.h
//  TwoDimensions
//
//  Created by mac on 15-1-18.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllustrationPicturesList : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scr;
}
@property(nonatomic,strong)NSArray *dataArrr;
-(void)makeFirstUI;
@end
