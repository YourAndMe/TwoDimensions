//
//  ArticleWordsViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-20.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "ArticleWordsViewController.h"
#import "DetailNav.h"

@interface ArticleWordsViewController ()
{
    UIButton *selectBtn;
    UILabel *lab2;
    NSUserDefaults *user;
    int k;//用来接收详情页面设置字号后通知传过来的值
}
@end

@implementation ArticleWordsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
	// Do any additional setup after loading the view.
}
-(void)makeUI
{
    //导航条
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:@[] andRightAction:nil andTarget:self andTitleName:@"文章字号"];
    [self.view addSubview:detailNav];
    //背景
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(10, 84, self.view.frame.size.width-20, 350)];
    back.backgroundColor = [UIColor colorWithRed:186/225.0 green:223/225.0 blue:226/225.0 alpha:1];
    back.clipsToBounds = YES;
    back.layer.cornerRadius = 5;
    [self.view addSubview:back];
    
    //提示话语
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
    lab1.textAlignment = NSTextAlignmentLeft;
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.text = @"您当前的文章字号是:";
    [back addSubview:lab1];
    //按钮背景
    UIImageView *backOfBtn = [[UIImageView alloc] initWithFrame:CGRectMake(66, 40, 168, 27)];
    backOfBtn.image = [UIImage imageNamed:@"中字号@2x.png"];
    [back addSubview:backOfBtn];
    backOfBtn.userInteractionEnabled = YES;
    //按钮
    NSArray *nomoralPic = @[@"大字暗@2x.png",@"中字暗@2x.png",@"小字暗@2x.png"];
    NSArray *selectPic = @[@"大字亮@2x.png",@"中字亮@2x.png",@"小字亮@2x.png"];
    for (int i=0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(56*i, 0, 56, 27);
        [btn setImage:[UIImage imageNamed:nomoralPic[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectPic[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(wordBtnDown:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 4800+i;
        [backOfBtn addSubview:btn];
        if (i==1) {
            btn.selected = YES;
            selectBtn = btn;
        }
    }
    //说明文字
    lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 87, 270, 200)];
    lab2.text = @"       欢迎使用本客户端，为了达到更好的阅读体验和浏览效果，请按动上方“大、中、小”三个按钮调整字体大小适应您的阅读习惯，您亦可在正文随时对字体大小进行调整，谢谢！";
    lab2.numberOfLines = 0;
    lab2.font = [UIFont systemFontOfSize:16];
    [back addSubview:lab2];
    //接收详情页面的通知，详情页面字号与当前匹配
    k = [[[NSUserDefaults standardUserDefaults] objectForKey:@"wordSize"] intValue];
    if (k==110) {
        UIButton *btn1= (UIButton*)[self.view viewWithTag:4800];
        [self wordBtnDown:btn1];
    }else if (k==100){
        UIButton *btn2= (UIButton*)[self.view viewWithTag:4801];
        [self wordBtnDown:btn2];
    }else if(k==90){
        UIButton *btn3= (UIButton*)[self.view viewWithTag:4802];
        [self wordBtnDown:btn3];
    }
}
//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//字号按钮点击事件
-(void)wordBtnDown:(UIButton*)btn
{
    switch (btn.tag) {
        case 4800:
        {
            selectBtn.selected = NO;
            btn.selected = YES;
            selectBtn = btn;
            lab2.font = [UIFont systemFontOfSize:18];
            [self userdefaultsMethod:110];
            break;
        }
        case 4801:
        {
            selectBtn.selected = NO;
            btn.selected = YES;
            selectBtn = btn;
            lab2.font = [UIFont systemFontOfSize:16];
            [self userdefaultsMethod:100];
            break;
        }
        case 4802:
        {
            selectBtn.selected = NO;
            btn.selected = YES;
            selectBtn = btn;
            lab2.font = [UIFont systemFontOfSize:14];
            [self userdefaultsMethod:90];
            break;
        }
        default:
            break;
    }
}
//字号设置页面设置好值后，发送通知给详情页面
-(void)userdefaultsMethod:(int)sizeWord
{
    user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSString stringWithFormat:@"%d",sizeWord] forKey:@"wordSize"];
    [user synchronize];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
