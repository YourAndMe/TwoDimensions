//
//  BenefitViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "BenefitViewController.h"
#import "Nav.h"
#import "SecondMenuBtn.h"
#import "NetWorkBlock.h"
#import "Model.h"
#import "InformationDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MyMbd.h"
#import "DetailViewController.h"
#import "CollectionWriteAndReadDB.h"

@interface BenefitViewController ()<MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    SecondMenuBtn *secondBtn;
    NSString *sa;
    int _flag;//用于记录点击那个按钮
    Model *modelHere;
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    CollectionWriteAndReadDB *WAndR;
}
@property(nonatomic,strong)NSMutableArray *pageArr;//记录每个table中的页数
@property(nonatomic,strong)NSMutableArray *yhDataArr;//存储消息数据
@property(nonatomic,strong)NSMutableArray *hdDataArr;//存储新番数据
@property(nonatomic,strong)NSMutableArray *refreshDataArr;//存储上下拉对象
@property(nonatomic,strong)NSMutableArray *infoIdArr;//每条信息的ID
@end

@implementation BenefitViewController
-(void)dealloc
{
    if (self.refreshDataArr.count == 0) {
        return;
    }
    for (int i=0; i<2; i++) {
        [self.refreshDataArr[i][@"head"] free];
        [self.refreshDataArr[i][@"foot"] free];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.yhDataArr = [NSMutableArray arrayWithCapacity:0];
        self.hdDataArr = [NSMutableArray arrayWithCapacity:0];
        self.infoIdArr = [NSMutableArray arrayWithCapacity:0];
        self.refreshDataArr = [NSMutableArray arrayWithCapacity:0];
        sa = @"youhui";
        _flag = 1300;
        self.pageArr = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<2; i++) {
            [self.pageArr addObject:@"0"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self makeUI];
    [self loadData];
	// Do any additional setup after loading the view.
}

-(void)makeUI
{
    //布局导航条
    Nav *nav = [[Nav alloc] initWithFrame:CGRectMake(0, 0, 320, 64) andImage:@"回到主页小房子@2x.png" andTarget:self andAction:@selector(backMainPageDown)];
    [self.view addSubview:nav];
    
    //布局二级菜单
    secondBtn = [[SecondMenuBtn alloc] initWithFrame:CGRectMake(0, 62, 320, 33) andTarget:self andAction:@selector(secondBtnDown:) andBtnName:@[@"优惠",@"书籍",@"周边",@"活动"]];
    [self.view addSubview:secondBtn];
    
    //设置初次进入时，选中的时第一项
    secondBtn.selectImag.hidden = NO;
    secondBtn.selectImag.frame = CGRectMake((1300-1300)*self.view.frame.size.width/4+5, 2, 54, 25);
    [self makeTable];
    
    //初始化将收藏内容写入数据库的封装对象
    WAndR = [[CollectionWriteAndReadDB alloc] init];
    
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"wenzhangSH" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"wenzhangSH-no" object:nil];
}
//接收到收藏通知
-(void)notifyYes:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1300) {
        [WAndR addCollec:articleId andDataArr:self.yhDataArr andFlag:1 andName:@"wenzhangSH"];
    }else{
        [WAndR addCollec:articleId andDataArr:self.hdDataArr andFlag:1 andName:@"wenzhangSH"];
    }
}
//接收到取消收藏通知
-(void)notifyNo:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1300) {
        [WAndR addCollec:articleId andDataArr:self.yhDataArr andFlag:2 andName:@"wenzhangSH"];
    }else{
        [WAndR addCollec:articleId andDataArr:self.hdDataArr andFlag:2 andName:@"wenzhangSH"];
    }
}
-(void)makeTable
{
    //设置table
    for (int i=0; i<2; i++) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, 320, self.view.frame.size.height-95-49) style:UITableViewStylePlain];
        table.delegate =self;
        table.dataSource = self;
        table.hidden = YES;
        table.tag = 1800+i;
        [self.view addSubview:table];
        
        //上下拉刷新
        //UITableView *table1 = (UITableView*)[self.view viewWithTag:1400];
        header = [MJRefreshHeaderView header];
        header.scrollView = table;
        header.delegate = self;
        header.tag = 1820+i;
        
        footer = [MJRefreshFooterView footer];
        footer.scrollView = table;
        footer.delegate = self;
        footer.tag = 1830+i;
        [self.refreshDataArr addObject:@{@"head": header,@"foot":footer}];
    }
}

-(void)loadData
{
    MyMbd *mb = [[MyMbd alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mb];
    
    __weak BenefitViewController *infoTemp = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=list&sa=%@&offset=%d&count=15&&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",sa,[self.pageArr[(_flag-1300)%2] intValue]*15] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        
        MyMbd *mb = (MyMbd*)[infoTemp.view viewWithTag:12345];
        [mb removeFromSuperview];
        
        for (int i=0; i<2; i++) {
            MJRefreshHeaderView *_header = (MJRefreshHeaderView*)[infoTemp.view viewWithTag:1820+i];
            MJRefreshFooterView *_footer = (MJRefreshFooterView*)[infoTemp.view viewWithTag:1830+i];
            [_header endRefreshing];
            [_footer endRefreshing];
            
            
        }
        
        NSArray *arr = result[@"list"];
        if ([self.pageArr[(_flag-1300)%2] intValue] == 0) {
            [infoTemp.infoIdArr removeAllObjects];
            if (_flag == 1300) {
                [infoTemp.yhDataArr removeAllObjects];
            }else if(_flag == 1303) {
                [infoTemp.hdDataArr removeAllObjects];
            }
        }
        for (NSDictionary *temp in arr) {
            Model *model = [[Model alloc] initWithDic:temp];
            model.idInfo = temp[@"id"];
            [infoTemp.infoIdArr addObject:temp[@"id"]];
            if (_flag == 1300) {
                [infoTemp.yhDataArr addObject:model];
            }else if(_flag == 1303) {
                [infoTemp.hdDataArr addObject:model];
            }
        }
        if (_flag == 1300) {
            [self hiddenTable];
            UITableView *table1 = (UITableView*)[infoTemp.view viewWithTag:1800];
            table1.hidden = NO;
            [table1 reloadData];
        }else if(_flag == 1303) {
            [self hiddenTable];
            UITableView *table2 = (UITableView*)[infoTemp.view viewWithTag:1801];
            table2.hidden = NO;
            [table2 reloadData];
        }
        
    } andType:YES];
}
//隐藏table
-(void)hiddenTable
{
    for (int i=0; i<2; i++) {
        UITableView *table = (UITableView*)[self.view viewWithTag:1800+i];
        table.hidden = YES;
    }
}
//二级菜单按钮点击事件
-(void)secondBtnDown:(UIButton*)btn
{
    [UIView animateWithDuration:0.5 animations:^{
        secondBtn.selectImag.hidden = NO;
        secondBtn.selectImag.frame = CGRectMake((btn.tag-1300)*self.view.frame.size.width/4+5, 2, 54, 25);
    }];
    _flag = btn.tag;
    switch (btn.tag) {
        case 1300:
        {
            [self hiddenWebView];
            sa = @"youhui";
            [self loadData];
            break;
        }
        case 1301:
        {
            [self hiddenTable];
            [self makeWebViewWithFlag:0];
            break;
        }
        case 1302:
        {
            [self hiddenTable];
            [self makeWebViewWithFlag:1];
            break;
        }
        case 1303:
        {
            [self hiddenWebView];
            sa = @"huodong";
            [self loadData];
            break;
        }
            
        default:
            break;
    }
}
//隐藏webView
-(void)hiddenWebView
{
    for (int i=0; i<2; i++) {
        UIWebView *web = (UIWebView*)[self.view viewWithTag:15151+i];
        [web removeFromSuperview];
    }
}
-(void)makeWebViewWithFlag:(int)flag
{
    //实例化UIWebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-95-49)];
    webView.tag = 15151 + flag;
    [self.view addSubview:webView];
    
    //准备webView的属性
    NSString *urlStr = @"http://xamysd.taobao.com/";
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

#pragma mark Table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1800) {
        return self.yhDataArr.count;
    }else{
        return self.hdDataArr.count;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    if (cell == nil) {
        cell = [[InformationDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
    }
    if (tableView.tag == 1800) {
        modelHere = self.yhDataArr[indexPath.row];
    }else if(tableView.tag == 1801) {
        modelHere = self.hdDataArr[indexPath.row];
    }
    [cell.picImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",modelHere.icon]]];
    cell.titleLab.text = modelHere.title;
    cell.desLab.text = modelHere.des;
    if (tableView.tag == 1800) {
        if ([modelHere.author isEqualToString:@""]) {
            cell.authorLab.text = [NSString stringWithFormat:@"提供商 : 未知"];
        }else{
            cell.authorLab.text = [NSString stringWithFormat:@"提供商 : %@",modelHere.author];
        }
        
        cell.timeLab.text = modelHere.adddate;
    }else{
        cell.authorLab.frame = CGRectMake(3, 0, 90, 20);
        if ([modelHere.location isEqualToString:@""]) {
            cell.authorLab.text = [NSString stringWithFormat:@"地点 : 未知"];
        }else{
            cell.authorLab.text = [NSString stringWithFormat:@"地点 : %@",modelHere.location];
        }
        cell.timeLab.frame = CGRectMake(100, 0, 110, 20);
        cell.timeLab.text = [NSString stringWithFormat:@"开始时间 : %@",[modelHere.start_time substringToIndex:10]];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1800) {
        modelHere = self.yhDataArr[indexPath.row];
    }else if(tableView.tag == 1801) {
        modelHere = self.hdDataArr[indexPath.row];
    }
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.IDPic = modelHere.idInfo;
    detail.picIdArr = self.infoIdArr;
    detail.detailType = @"wenzhangSH";
    [self presentViewController:detail animated:YES completion:nil];
}
#pragma mark 上下拉代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    for (int i=0; i<2; i++) {
        if (refreshView.tag == 1820+i) {
            [self.pageArr replaceObjectAtIndex:i withObject:@"0"];
            [self loadData];
            break;
        }
    }
    for (int i=0; i<2; i++) {
        if (refreshView.tag == 1830+i) {
            int f = [self.pageArr[i] intValue];
            f++;
            [self.pageArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",f]];
            [self loadData];
            break;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
