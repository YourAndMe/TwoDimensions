//
//  MicroblogViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MicroblogViewController.h"
#import "Nav.h"

@interface MicroblogViewController ()

@end

@implementation MicroblogViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self makeUI];
    [self makeWebView];
	// Do any additional setup after loading the view.
}

-(void)makeUI
{
    Nav *nav = [[Nav alloc] initWithFrame:CGRectMake(0, 0, 320, 64) andImage:@"回到主页小房子@2x.png" andTarget:self andAction:@selector(backMainPageDown)];
    [self.view addSubview:nav];
}
-(void)makeWebView
{
    //实例化UIWebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49)];
    [self.view addSubview:webView];
    
    //准备webView的属性
    NSString *urlStr = @"http://weibo.com/2dmania?topnav=1&wvr=6&topsug=1";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
    webView.scalesPageToFit = YES;//让页面大小适配
    
}
//回到主页按钮点击事件
-(void)backMainPageDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
