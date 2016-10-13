//
//  ZMStatusView.m
//  ZMStatusView
//
//  Created by CreazyLee on 12-11-8.
//  Copyright (c) 2012年 CreazyLee. All rights reserved.
//

#import "ZMStatusView.h"
#import <QuartzCore/QuartzCore.h>

#define StatusViewVisibleDuration 3.0f
#define StatusViewFadeOutDuration 1.0f

@implementation ZMStatusView
ZMStatusView *shareView;

@synthesize fadeOutTimer,overlayWindow,hudView,stringLabel,imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)showWithStatusView:(NSString *)string withType:(ZMStatusType)type{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.overlayWindow addSubview:self];
        [self showWithType:type status:string duration:StatusViewVisibleDuration];
    }
    
    return self;
}
+ (void)showWithLabel:(NSString *)string withType:(ZMStatusType)type
{
    [[ZMStatusView shareView] showWithStatusView:string withType:type];
}

+ (ZMStatusView *)shareView
{
    shareView = [[ZMStatusView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    return shareView;
}

- (void)position
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    CGFloat posY = floor(activeHeight*0.52);
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default:
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    }
    
    self.hudView.transform = CGAffineTransformMakeRotation(rotateAngle);
    self.hudView.center = newCenter;
    
}

- (UIView *)hudView
{
    if(!hudView) {
        hudView = [[UIView alloc] initWithFrame:CGRectZero];
		hudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"提示底.png"]]; //设置底
        hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:hudView];
    }
    return hudView;
}

- (UILabel *)stringLabel {
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 120, 26)];
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = NO;
        stringLabel.minimumFontSize = 10.0;
		stringLabel.textAlignment = NSTextAlignmentCenter;
		stringLabel.font = [UIFont boldSystemFontOfSize:12.0];
		[self.hudView addSubview:stringLabel];
    }
    return stringLabel;
}
- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
    }
    return overlayWindow;
}

- (UIImageView *)imageView {
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.backgroundColor = [UIColor clearColor];
		[self.hudView addSubview:imageView];
    }
    return imageView;
}

- (void)setStatusView:(NSString *)string {
	
    CGFloat hudWidth = 120;
    CGFloat hudHeight = 102;
	
	self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    if (!string) {
        self.imageView.center = CGPointMake(self.hudView.bounds.size.width/2, self.hudView.bounds.size.height/2);
    }else
    {
        self.imageView.center = CGPointMake(self.hudView.bounds.size.width/2, 46.0);
    }
    
	self.stringLabel.hidden = NO;
	self.stringLabel.text = string;
}

- (void)showWithType:(ZMStatusType)type status:(NSString *)string duration:(NSTimeInterval)duration
{
    UIImage *img;
    switch (type) {
        case 0:
            img = [UIImage imageNamed:@"网络连接.png"];
            break;
        case 1:
            img = [UIImage imageNamed:@"收藏.png"];
            break;
        case 2:
            img = [UIImage imageNamed:@"夜间模式.png"];
            break;
        case -1:
            img = [UIImage imageNamed:@""];
        default:
            break;
    }
    self.imageView.image = img;
    self.imageView.frame = CGRectMake(0, 70, img.size.width, img.size.height);
    [self setStatusView:string];
    [self position];
     [self.overlayWindow makeKeyAndVisible];
    
    if(fadeOutTimer != nil)
    {
        [fadeOutTimer invalidate];
        [fadeOutTimer release];
        fadeOutTimer = nil;
    }

	
	fadeOutTimer = [[NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(dismiss) userInfo:nil repeats:NO] retain];
    
    [self setNeedsDisplay];
}

- (void)dismiss {
	
    [UIView animateWithDuration:StatusViewFadeOutDuration
						  delay:0
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 self.alpha = 0;
					 }
					 completion:^(BOOL finished){
                         if(self.alpha == 0) {
                             [overlayWindow release];
                             overlayWindow = nil;
                             [self removeFromSuperview];
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                             [[UIApplication sharedApplication].windows.lastObject makeKeyAndVisible];
                         }
                     }];
}

- (void)dealloc
{
    [fadeOutTimer release];
    [hudView release];
    [stringLabel release];
    [imageView release];
    [overlayWindow release];
    
    [super dealloc];
}

@end


