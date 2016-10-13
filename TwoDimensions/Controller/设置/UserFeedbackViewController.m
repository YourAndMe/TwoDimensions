//
//  UserFeedbackViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-20.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "UserFeedbackViewController.h"
#import "DetailNav.h"
#import "NetWorkBlock.h"
#import "NSString+URLEncoding.h"

@interface UserFeedbackViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *scr;
    UITextField *labelCount;
    UITextView *textView;
}

@end

@implementation UserFeedbackViewController

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
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:@[] andRightAction:nil andTarget:self andTitleName:@"用户反馈"];
    [self.view addSubview:detailNav];
    
    //导航条右侧按钮
    UIButton *countNum = [UIButton buttonWithType:UIButtonTypeCustom];
    countNum.frame = CGRectMake(detailNav.frame.size.width-50, 10, 40, 24);
    [countNum setImage:[UIImage imageNamed:@"发送1@2x.png"] forState:UIControlStateNormal];
    [countNum addTarget:self action:@selector(rightBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [detailNav addSubview:countNum];
    
    //评论输入框
    UIImageView *textBack = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 74, self.view.frame.size.width-11, 200)];
    textBack.image = [UIImage imageNamed:@"用户反馈输入框@2x.png"];
    [self.view addSubview:textBack];
    textBack.userInteractionEnabled = YES;
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(2, 5, textBack.frame.size.width-4, 240)];
    textView.font = [UIFont systemFontOfSize:16];
    textView.backgroundColor = [UIColor clearColor];
    [textBack addSubview:textView];
    textView.delegate = self;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, textView.frame.size.width-20, 20)];
    label.text = @"请在这里输入您的评论...";
    [textView addSubview:label];
    label.tag = 4998;
    label.userInteractionEnabled = NO;
    
    //邮箱输入框背静图片
    UIImageView *emailBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 284, self.view.frame.size.width, 36)];
    emailBack.image = [UIImage imageNamed:@"用户邮箱输入框@2x.png"];
    [self.view addSubview:emailBack];
    emailBack.userInteractionEnabled = YES;
    //邮箱输入框
    labelCount = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, textBack.frame.size.width-10, 26)];
    labelCount.font = [UIFont systemFontOfSize:14];
    labelCount.backgroundColor = [UIColor clearColor];
    [labelCount addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    [emailBack addSubview:labelCount];
    //邮箱输入提示
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, textView.frame.size.width-20, 20)];
    label1.text = @"邮编:输入您的E-mail以便我们给您回复";
    label1.font = [UIFont systemFontOfSize:14];
    [labelCount addSubview:label1];
    label1.tag = 4999;
    label1.userInteractionEnabled = NO;
    
}
//邮箱输入框点击事件，用来隐藏提示内容
-(void)valueChange:(UITextField*)textF
{
    UILabel *lab = (UILabel*)[self.view viewWithTag:4999];
    lab.hidden = YES;
    if (textF.text.length == 0) {
        lab.hidden = NO;
    }
}
#pragma mark textView代理
-(void)textViewDidChange:(UITextView *)textView
{
    UILabel *lab = (UILabel*)[self.view viewWithTag:4998];
    lab.hidden = YES;
    if (textView.text.length == 0) {
        lab.hidden = NO;
    }
}
//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//导航条右侧按钮点击事件
-(void)rightBtnDown
{
    if (textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您输入对我们的建议！谢谢！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }else if (labelCount.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您输入您的邮箱，以便我们答复您！谢谢！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSString *text = [textView.text urlEncodeString];
        __weak UserFeedbackViewController *user = self;
        NetWorkBlock *net = [NetWorkBlock alloc];
        [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=suggest&suggest=%@&email=%@&os_ver=2.0.4&client_ver=8.1.2&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",text,labelCount.text] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",result[@"msg"]] delegate:user cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        } andType:YES];
    }
}
#pragma mark alertview的代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
