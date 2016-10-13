//
//  SecondMenuBtn.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "SecondMenuBtn.h"

@implementation SecondMenuBtn

- (id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)btnAction andBtnName:(NSArray*)nameArr
{
    self = [super initWithFrame:frame];
    if (self) {
        //按钮背景
        UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backImg.image = [UIImage imageNamed:@"二级菜单底@2x.png"];
        [self addSubview:backImg];
        backImg.userInteractionEnabled = YES;
        
        //布局按钮选中效果图
        self.selectImag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.selectImag.image = [UIImage imageNamed:@"二级选择效果@2x.png"];
        self.selectImag.hidden = YES;
        [backImg addSubview:self.selectImag];
        
        //按钮布局
        for (int i=0; i<nameArr.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(80*i, 0, 80, 33);
            [btn addTarget:target action:btnAction forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1300+i;
            btn.backgroundColor = [UIColor clearColor];
            [backImg addSubview:btn];
            
            UILabel *btnText = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 20)];
            btnText.text = nameArr[i];
            btnText.textColor = [UIColor whiteColor];
            btnText.font = [UIFont boldSystemFontOfSize:18];
            [btn addSubview:btnText];
        }
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
