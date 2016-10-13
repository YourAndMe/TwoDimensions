//
//  InformationViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "InformationViewController.h"
#import "Nav.h"
#import "SecondMenuBtn.h"
#import "NetWorkBlock.h"
#import "Model.h"
#import "InformationDetailTableViewCell.h"
#import "UIImageView+WebCache.h" 
#import "MJRefresh.h"
#import "MyMbd.h"
#import "DetailViewController.h"
#import "OperationDB.h"
#import "CollectionWriteAndReadDB.h"

@interface InformationViewController ()<MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate>
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
@property(nonatomic,strong)NSMutableArray *xxDataArr;//存储消息数据
@property(nonatomic,strong)NSMutableArray *xfDataArr;//存储新番数据
@property(nonatomic,strong)NSMutableArray *xpDataArr;//存储新品数据
@property(nonatomic,strong)NSMutableArray *qwDataArr;//存储新闻数据
@property(nonatomic,strong)NSMutableArray *refreshDataArr;//存储上下拉对象
@property(nonatomic,strong)NSMutableArray *infoIdArr;//每条信息的ID
@end

@implementation InformationViewController
-(void)dealloc
{
    if (self.refreshDataArr.count == 0) {
        return;
    }
    for (int i=0; i<4; i++) {
        [self.refreshDataArr[i][@"head"] free];
        [self.refreshDataArr[i][@"foot"] free];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.xxDataArr = [NSMutableArray arrayWithCapacity:0];
        self.xfDataArr = [NSMutableArray arrayWithCapacity:0];
        self.xpDataArr = [NSMutableArray arrayWithCapacity:0];
        self.qwDataArr = [NSMutableArray arrayWithCapacity:0];
        self.infoIdArr = [NSMutableArray arrayWithCapacity:0];
        self.refreshDataArr = [NSMutableArray arrayWithCapacity:0];
        sa = @"xiaoxi";
        _flag = 1300;
        self.pageArr = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<4; i++) {
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
    secondBtn = [[SecondMenuBtn alloc] initWithFrame:CGRectMake(0, 62, 320, 33) andTarget:self andAction:@selector(secondBtnDown:) andBtnName:@[@"消息",@"新番",@"新品",@"趣闻"]];
    [self.view addSubview:secondBtn];
    
    //设置初次进入时，选中的时第一项
    secondBtn.selectImag.hidden = NO;
    secondBtn.selectImag.frame = CGRectMake((1300-1300)*self.view.frame.size.width/4+5, 2, 54, 25);
    [self makeTable];
    
    //初始化将收藏内容写入数据库的封装对象
    WAndR = [[CollectionWriteAndReadDB alloc] init];
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"wenzhangZX" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"wenzhangZX-no" object:nil];
}
//接收到收藏通知
-(void)notify:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1300) {
        [WAndR addCollec:articleId andDataArr:self.xxDataArr andFlag:1 andName:@"wenzhangZX"];
    }else if(_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.xfDataArr andFlag:1 andName:@"wenzhangZX"];
    }else if(_flag == 1302) {
        [WAndR addCollec:articleId andDataArr:self.xpDataArr andFlag:1 andName:@"wenzhangZX"];
    }else {
        [WAndR addCollec:articleId andDataArr:self.qwDataArr andFlag:1 andName:@"wenzhangZX"];
    }
}
//接收到取消收藏通知
-(void)notifyNo:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1300) {
        [WAndR addCollec:articleId andDataArr:self.xxDataArr andFlag:2 andName:@"wenzhangZX"];
    }else if(_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.xfDataArr andFlag:2 andName:@"wenzhangZX"];
    }else if(_flag == 1302) {
        [WAndR addCollec:articleId andDataArr:self.xpDataArr andFlag:2 andName:@"wenzhangZX"];
    }else {
        [WAndR addCollec:articleId andDataArr:self.qwDataArr andFlag:2 andName:@"wenzhangZX"];
    }
}

-(void)makeTable
{
    //设置table
    for (int i=0; i<4; i++) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, 320, self.view.frame.size.height-95-49) style:UITableViewStylePlain];
        table.delegate =self;
        table.dataSource = self;
        table.hidden = YES;
        table.tag = 1400+i;
        [self.view addSubview:table];
        
        //上下拉刷新
        header = [MJRefreshHeaderView header];
        header.scrollView = table;
        header.delegate = self;
        header.tag = 1420+i;
        
        footer = [MJRefreshFooterView footer];
        footer.scrollView = table;
        footer.delegate = self;
        footer.tag = 1430+i;
        [self.refreshDataArr addObject:@{@"head": header,@"foot":footer}];
    }
}

-(void)loadData
{
    MyMbd *mb = [[MyMbd alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mb];
    
    __weak InformationViewController *infoTemp = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=list&sa=%@&offset=%d&count=15&&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",sa,[self.pageArr[_flag-1300] intValue]*15] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        
        MyMbd *mb = (MyMbd*)[infoTemp.view viewWithTag:12345];
        [mb removeFromSuperview];
        
        for (int i=0; i<4; i++) {
            MJRefreshHeaderView *_header = (MJRefreshHeaderView*)[infoTemp.view viewWithTag:1420+i];
            MJRefreshFooterView *_footer = (MJRefreshFooterView*)[infoTemp.view viewWithTag:1430+i];
            [_header endRefreshing];
            [_footer endRefreshing];
        }
        
        NSArray *arr = result[@"list"];
        if ([infoTemp.pageArr[_flag-1300] intValue] == 0) {
            [infoTemp.infoIdArr removeAllObjects];
            if (_flag == 1300) {
                [infoTemp.xxDataArr removeAllObjects];
            }else if(_flag == 1301) {
                [infoTemp.xfDataArr removeAllObjects];
            }else if(_flag == 1302) {
                [infoTemp.xpDataArr removeAllObjects];
            }else {
                [infoTemp.qwDataArr removeAllObjects];
            }
        }
        for (NSDictionary *temp in arr) {
            Model *model = [[Model alloc] initWithDic:temp];
            model.idInfo = temp[@"id"];
            [infoTemp.infoIdArr addObject:temp[@"id"]];
            if (_flag == 1300) {
                [infoTemp.xxDataArr addObject:model];
            }else if(_flag == 1301) {
                [infoTemp.xfDataArr addObject:model];
            }else if(_flag == 1302) {
                [infoTemp.xpDataArr addObject:model];
            }else {
                [infoTemp.qwDataArr addObject:model];
            }
        }
        if (_flag == 1300) {
            [self hiddenTable];
            UITableView *table1 = (UITableView*)[infoTemp.view viewWithTag:1400];
            table1.hidden = NO;
            [table1 reloadData];
        }else if(_flag == 1301) {
            [self hiddenTable];
            UITableView *table2 = (UITableView*)[infoTemp.view viewWithTag:1401];
            table2.hidden = NO;
            [table2 reloadData];
        }else if(_flag == 1302) {
            [self hiddenTable];
            UITableView *table3 = (UITableView*)[infoTemp.view viewWithTag:1402];
            table3.hidden = NO;
            [table3 reloadData];
        }else {
            [self hiddenTable];
            UITableView *table4 = (UITableView*)[infoTemp.view viewWithTag:1403];
            table4.hidden = NO;
            [table4 reloadData];
        }
        
    } andType:YES];
}

//隐藏table
-(void)hiddenTable
{
    for (int i=0; i<4; i++) {
        UITableView *table = (UITableView*)[self.view viewWithTag:1400+i];
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
            sa = @"xiaoxi";
            [self loadData];
            break;
        }
        case 1301:
        {
            sa = @"xinfan";
            [self loadData];
            break;
        }
        case 1302:
        {
            sa = @"xinpin";
            [self loadData];
            break;
        }
        case 1303:
        {
            sa = @"quwen";
            [self loadData];
            break;
        }
            
        default:
            break;
    }
}

//回到主页按钮点击事件
-(void)backMainPageDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1400) {
        return self.xxDataArr.count;
    }else if(tableView.tag == 1401) {
        return self.xfDataArr.count;
    }else if(tableView.tag == 1402) {
        return self.xpDataArr.count;
    }else {
        return self.qwDataArr.count;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    if (cell == nil) {
        cell = [[InformationDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
    }
    if (tableView.tag == 1400) {
        modelHere = self.xxDataArr[indexPath.row];
    }else if(tableView.tag == 1401) {
        modelHere = self.xfDataArr[indexPath.row];
    }else if(tableView.tag == 1402) {
        modelHere = self.xpDataArr[indexPath.row];
    }else {
        modelHere = self.qwDataArr[indexPath.row];
    }
    [cell.picImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",modelHere.icon]]];
    cell.titleLab.text = modelHere.title;
    cell.desLab.text = modelHere.des;
    cell.authorLab.text = [NSString stringWithFormat:@"作者 : %@",modelHere.author];
    cell.timeLab.text = modelHere.adddate;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1400) {
        modelHere = self.xxDataArr[indexPath.row];
    }else if(tableView.tag == 1401) {
        modelHere = self.xfDataArr[indexPath.row];
    }else if(tableView.tag == 1402) {
        modelHere = self.xpDataArr[indexPath.row];
    }else {
        modelHere = self.qwDataArr[indexPath.row];
    }
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.IDPic = modelHere.idInfo;
    detail.picIdArr = self.infoIdArr;
    detail.detailType = @"wenzhangZX";
    [self presentViewController:detail animated:YES completion:nil];
}

#pragma mark 上下拉代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    for (int i=0; i<4; i++) {
        if (refreshView.tag == 1420+i) {
            [self.pageArr replaceObjectAtIndex:i withObject:@"0"];
            [self loadData];
            break;
        }
    }
    for (int i=0; i<4; i++) {
        if (refreshView.tag == 1430+i) {
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
