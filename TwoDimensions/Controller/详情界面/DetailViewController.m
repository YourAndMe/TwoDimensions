//
//  DetailViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-8.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailNav.h"
#import "DetailTabBarView.h"
#import "NetWorkBlock.h"
#import "Model.h"
#import "CommemtContentViewController.h"
#import "OperationDB.h"
#import "ShareSettingViewController.h"
#import "ShareContentViewController.h"

@interface DetailViewController ()<UIWebViewDelegate,UIActionSheetDelegate>
{
    UIWebView *webViews;
    DetailTabBarView *downBtn;
    int k;
    int m;
    NSUserDefaults *user;
    BOOL isSelect;
    OperationDB *opDB;
    NSString *webTitle;
}
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        k=100;
        m=0;
        isSelect = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self makeWebView];
	// Do any additional setup after loading the view.
}

-(void)makeUI
{
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:@[@"字体放大@2x.png",@"字体缩小@2x.png"] andRightAction:@selector(rightBtnDown:) andTarget:self andTitleName:nil];
    [self.view addSubview:detailNav];
    
    for (int i=0; i<self.picIdArr.count; i++) {
        if ([self.picIdArr[i] isEqualToString:self.IDPic]) {
            m = i;
        }
    }
    k = [[[NSUserDefaults standardUserDefaults] objectForKey:@"wordSize"] intValue];
    UIButton *rightBtnOne = (UIButton*)[self.view viewWithTag:1100];
    UIButton *rightBtnTwo = (UIButton*)[self.view viewWithTag:1101];
    if (k==110) {
        [rightBtnOne setImage:[UIImage imageNamed:@"字体放大-极限@2x.png"] forState:UIControlStateNormal];
        [rightBtnOne setEnabled:NO];
    }else if (k==90) {
        [rightBtnTwo setImage:[UIImage imageNamed:@"字体缩小-极限@2x.png"] forState:UIControlStateNormal];
        [rightBtnTwo setEnabled:NO];
    }else{
        [rightBtnTwo setImage:[UIImage imageNamed:@"字体缩小@2x.png"] forState:UIControlStateNormal];
        [rightBtnTwo setEnabled:YES];
        [rightBtnOne setImage:[UIImage imageNamed:@"字体放大@2x.png"] forState:UIControlStateNormal];
        [rightBtnOne setEnabled:YES];
    }
    opDB = [[OperationDB alloc] init];
}

//底部按钮点击事件
-(void)downBtnDown:(UIButton*)btn
{
    switch (btn.tag) {
        case 1200:
        {
            if (m==0) {
                m=0;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有更多信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                self.IDPic = self.picIdArr[--m];
                [webViews removeFromSuperview];
                [downBtn removeFromSuperview];
                [self makeWebView];
            }
            break;
        }
        case 1201:
        {
            if (self.isID.length == 1) {
                isSelect = [self readFromFileWithID:self.novelAndMagaID];
            }else{
                isSelect = [self readFromFileWithID:self.IDPic];
            }
            
            if (isSelect==NO) {
                [btn setImage:[UIImage imageNamed:@"draw_faved_btn_n.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"draw_faved_btn_h.png"] forState:UIControlStateHighlighted];
                //做一个通知，用来通知页面跳转
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                if (self.isID.length == 1) {
                    NSNotification *notify = [NSNotification notificationWithName:self.detailType object:self.novelAndMagaID];//第一个参数
                    [center postNotification:notify];
                    [self writeToFileWithID:self.novelAndMagaID andSelect:isSelect];
                }else{
                    NSNotification *notify = [NSNotification notificationWithName:self.detailType object:self.IDPic];//第一个参数
                    [center postNotification:notify];
                    [self writeToFileWithID:self.IDPic andSelect:isSelect];
                }
                
            }else{
                [btn setImage:[UIImage imageNamed:@"draw_favorites_btn_n.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"draw_favorites_btn_h.png"] forState:UIControlStateHighlighted];
                //做一个通知，用来通知页面跳转
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                if (self.isID.length == 1) {
                    NSNotification *notify = [NSNotification notificationWithName:[NSString stringWithFormat:@"%@-no",self.detailType] object:self.novelAndMagaID];//第一个参数
                    [center postNotification:notify];
                    [self writeToFileWithID:self.novelAndMagaID andSelect:isSelect];
                }else{
                    NSNotification *notify = [NSNotification notificationWithName:[NSString stringWithFormat:@"%@-no",self.detailType] object:self.IDPic];//第一个参数
                    [center postNotification:notify];
                    [self writeToFileWithID:self.IDPic andSelect:isSelect];
                }
            }
            break;
        }
        case 1202:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博",@"分享到腾讯微博",@"分享到人人网", nil];
            [sheet showInView:self.view];
            break;
        }
        case 1203:
        {
            CommemtContentViewController *comment = [[CommemtContentViewController alloc]init];
            comment.picID = self.IDPic;
            comment.commentSum = downBtn.countLab.text;
            [self presentViewController:comment animated:YES completion:nil];
            break;
        }
        case 1204:
        {
            if (m==self.picIdArr.count-1) {
                m=self.picIdArr.count-1;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有更多信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                [webViews removeFromSuperview];
                [downBtn removeFromSuperview];
                self.IDPic = self.picIdArr[++m];
                [self makeWebView];
            }
            break;
        }
        default:
            break;
    }
}
-(BOOL)readFromFileWithID:(NSString*)picId
{
    NSMutableArray *set = [opDB readDataFromDBWithTableName:@"isSelsected" andDataName:@"Collection.db" andListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"]];
    for (int i=0; i<set.count; i++) {
        if ([set[i][@"pictureId"] isEqualToString:picId]) {
            return [set[i][@"indexPathSection"] boolValue];
        }
    }
    return NO;
}

-(void)writeToFileWithID:(NSString*)picId andSelect:(BOOL)isSel
{
    NSMutableArray *set = [opDB readDataFromDBWithTableName:@"isSelsected" andDataName:@"Collection.db" andListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"]];
    if (!set.count) {
        [opDB whiteDataToDBWithListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"] andParameter:@{@"pictureId":picId,@"indexPathSection":[NSString stringWithFormat:@"%d",!isSel],@"indexPathRow":@"0"} andTabelName:@"isSelsected" andDataName:@"Collection.db" andCate:1];
    }else{
        int i=0;
        for (; i<set.count; i++) {
            if ([set[i][@"pictureId"] isEqualToString:picId]) {
                [opDB whiteDataToDBWithListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"] andParameter:@{@"pictureId":picId,@"indexPathSection":[NSString stringWithFormat:@"%d",!isSel],@"indexPathRow":@"0"}  andTabelName:@"isSelsected" andDataName:@"Collection.db" andCate:2];
                break;
            }
        }
        if (i == set.count && i != 0) {
            [opDB whiteDataToDBWithListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"] andParameter:@{@"pictureId":picId,@"indexPathSection":[NSString stringWithFormat:@"%d",!isSel],@"indexPathRow":@"0"} andTabelName:@"isSelsected" andDataName:@"Collection.db" andCate:1];
        }
    }
}

//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//导航条右侧按钮点击事件
-(void)rightBtnDown:(UIButton*)btn
{
    if (btn.tag == 1100) {
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                              k+=10];
        [webViews stringByEvaluatingJavaScriptFromString:jsString];
        UIButton *btn1 = (UIButton*)[self.view viewWithTag:1101];
        [btn1 setImage:[UIImage imageNamed:@"字体缩小@2x.png"] forState:UIControlStateNormal];
        [btn1 setEnabled:YES];
        if (k==110) {
            [btn setImage:[UIImage imageNamed:@"字体放大-极限@2x.png"] forState:UIControlStateNormal];
            [btn setEnabled:NO];
        }
        user = [NSUserDefaults standardUserDefaults];
        [user setObject:[NSString stringWithFormat:@"%d",k] forKey:@"wordSize"];
        [user synchronize];
    }else{
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                              k-=10];
        [webViews stringByEvaluatingJavaScriptFromString:jsString];
        UIButton *btn1 = (UIButton*)[self.view viewWithTag:1100];
        [btn1 setImage:[UIImage imageNamed:@"字体放大@2x.png"] forState:UIControlStateNormal];
        [btn1 setEnabled:YES];
        if (k==90) {
            [btn setImage:[UIImage imageNamed:@"字体缩小-极限@2x.png"] forState:UIControlStateNormal];
            [btn setEnabled:NO];
        }
        user = [NSUserDefaults standardUserDefaults];
        [user setObject:[NSString stringWithFormat:@"%d",k] forKey:@"wordSize"];
        [user synchronize];
    }
    
}

-(void)makeWebView
{
    //实例化UIWebView
    webViews = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:webViews];
    
    //准备webView的属性
    NSString *urlStr = [NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=article&platform=i&uid=12858666&id=%d&mobile=unkowniphone&pid=10070&e=8c8a161c0f3feec349e68a73b8a41191",[self.IDPic intValue]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webViews loadRequest:req];
    webViews.scalesPageToFit = YES;//让页面大小适配
    webViews.delegate = self;
    
    downBtn = [[DetailTabBarView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 49) andTarget:self andAction:@selector(downBtnDown:)];
    downBtn.backgroundColor = [UIColor colorWithRed:20/255.0 green:190/255.0 blue:245/255.0 alpha:0.8];
    [self.view addSubview:downBtn];
    NSMutableArray *set = [opDB readDataFromDBWithTableName:@"isSelsected" andDataName:@"Collection.db" andListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"]];
    for (int i=0; i<set.count; i++) {
        if (self.isID.length == 1) {
            if ([set[i][@"pictureId"] isEqualToString:self.novelAndMagaID]) {
                UIButton *btnn = (UIButton*)[self.view viewWithTag:1201];
                if ([set[i][@"indexPathSection"] boolValue]) {
                    [btnn setImage:[UIImage imageNamed:@"draw_faved_btn_n.png"] forState:UIControlStateNormal];
                    [btnn setImage:[UIImage imageNamed:@"draw_faved_btn_h.png"] forState:UIControlStateHighlighted];
                }
            }
        }else{
            if ([set[i][@"pictureId"] isEqualToString:self.IDPic]) {
                UIButton *btnn = (UIButton*)[self.view viewWithTag:1201];
                if ([set[i][@"indexPathSection"] boolValue]) {
                    [btnn setImage:[UIImage imageNamed:@"draw_faved_btn_n.png"] forState:UIControlStateNormal];
                    [btnn setImage:[UIImage imageNamed:@"draw_faved_btn_h.png"] forState:UIControlStateHighlighted];
                }
            }
        }
        
    }
   
    [self loadData];
}
-(void)loadData
{
    __weak DetailViewController *tempFirst = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=get_comment_count&aid=%d&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",[self.IDPic intValue]] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        
        NSDictionary *arr = result;
        [tempFirst.dataArr removeAllObjects];
        Model *model = [[Model alloc] initWithDic:arr];//kvc赋值
        [tempFirst.dataArr addObject:model];
        downBtn.countLab.text = model.count;
        
    } andType:YES];
}
#pragma mark webView代理
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                          k];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
#pragma mark actionsheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ShareContentViewController *shareCon = [[ShareContentViewController alloc] init];
    switch (buttonIndex) {
        case 0:
        {
            shareCon.wbName = @"新浪微博";
            shareCon.shareTitle = webTitle;
            [self presentViewController:shareCon animated:YES completion:nil];
            break;
        }
        case 1:
        {
            shareCon.wbName = @"腾讯微博";
            shareCon.shareTitle = webTitle;
            [self presentViewController:shareCon animated:YES completion:nil];
            break;
        }
        case 2:
        {
            shareCon.wbName = @"人人网";
            shareCon.shareTitle = webTitle;
            [self presentViewController:shareCon animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
