//
//  ZMStatusView.h
//  ZMStatusView
//
//  Created by CreazyLee on 12-11-8.
//  Copyright (c) 2012年 CreazyLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZMStatusType){
    ZMStatusTypeForNil = -1,  //空
    ZMStatusTypeForNetwork = 0,   //网络提示
    ZMStatusTypeForCollection = 1, //收藏
    ZMStatusTypeForPattern = 2    //夜间模式
};

@interface ZMStatusView : UIView

@property (nonatomic, retain) NSTimer *fadeOutTimer;
@property (nonatomic, retain) UIWindow *overlayWindow;
@property (nonatomic, retain) UIView *hudView;
@property (nonatomic, retain) UILabel *stringLabel;
@property (nonatomic, retain) UIImageView *imageView;

+ (void)showWithLabel:(NSString *)string withType:(ZMStatusType)type;

@end
