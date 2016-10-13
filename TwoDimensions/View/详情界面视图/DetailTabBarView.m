//
//  DetailTabBarView.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-8.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "DetailTabBarView.h"
#import "OperationDB.h"

@implementation DetailTabBarView

- (id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)actionBtn
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrNomal = @[@"article_prev_btn_n.png",@"article_favorites_btn_n.png",@"article_share_btn_n.png",@"draw_comment_btn_n.png",@"article_next_btn_n.png"];
        NSArray *arrHlight = @[@"article_prev_btn_h.png",@"article_favorites_btn_h.png",@"article_share_btn_h.png",@"draw_comment_btn_h.png",@"article_next_btn_h.png"];
        for (int i=0; i<arrNomal.count; i++) {
            UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            downBtn.frame = CGRectMake(64*i, 0, 64, 49);
            [downBtn setImage:[UIImage imageNamed:arrNomal[i]] forState:UIControlStateNormal];
            [downBtn setImage:[UIImage imageNamed:arrHlight[i]] forState:UIControlStateHighlighted];
            [downBtn addTarget:target action:actionBtn forControlEvents:UIControlEventTouchUpInside];
            
            downBtn.tag = 1200+i;
            [self addSubview:downBtn];
            
            if (i==3) {
                self.countLab = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 25, 49)];
                self.countLab.backgroundColor = [UIColor clearColor];
                self.countLab.textColor = [UIColor whiteColor];
                self.countLab.textAlignment = NSTextAlignmentRight;
                self.countLab.font = [UIFont boldSystemFontOfSize:14];
                [downBtn addSubview:self.countLab];
            }
        }
    }
    return self;
}
-(BOOL)readFromFileWithID:(NSString*)picId
{
    
    return NO;
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
