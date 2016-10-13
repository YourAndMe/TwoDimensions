//
//  BindingWBViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-20.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "BindingWBViewController.h"
#import "DetailNav.h"

@interface BindingWBViewController ()
{
    UIWebView *webView;
    BOOL select;
}
@end

@implementation BindingWBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        select = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self makeWebView];
	// Do any additional setup after loading the view.
}
-(void)makeUI
{
    //导航条
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:@[] andRightAction:nil andTarget:self andTitleName:[NSString stringWithFormat:@"绑定%@",self.wbName]];
    detailNav.titleLab.frame = CGRectMake(70, 5, 320-140, 34);
    [self.view addSubview:detailNav];
    //推荐应用
    UILabel *EmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, 180, 30)];
    EmailLabel.text = @"推荐此应用到我的微博";
    EmailLabel.font = [UIFont boldSystemFontOfSize:16];
    EmailLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:EmailLabel];
    //绑定按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width-88, 74, 78, 29);
    [btn setImage:[UIImage imageNamed:@"开@2x.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"关@2x.png"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)makeWebView
{
    //实例化UIWebView
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:webView];
    
    //准备webView的属性
    NSString *urlStr = [NSString stringWithFormat:@"http://push.cms.palmtrends.com/wb/bind_v2.php?pid=10070&cid=1&uid=12858583&&sname=%@&sug2weibo=1",self.sname];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
    webView.scalesPageToFit = YES;//让页面大小适配

    
}
//绑定按钮点击事件
-(void)btnDown:(UIButton*)btn
{
    btn.selected = select;
    select = !select;
}
//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
