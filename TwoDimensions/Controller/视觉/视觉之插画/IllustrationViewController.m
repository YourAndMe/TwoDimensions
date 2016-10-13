//
//  IllustrationViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "IllustrationViewController.h"
#import "Nav.h"
#import "SecondMenuBtn.h"
#import "IllustrationCollectionViewCell.h"
#import "NetWorkBlock.h"
#import "UIImageView+WebCache.h"
#import "Model.h"
#import "MJRefresh.h"
#import "MyMbd.h"
#import "CartoonViewController.h"
#import "IllustrationDetailViewController.h"
#import "CollectionWriteAndReadDB.h"

@interface IllustrationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MJRefreshBaseViewDelegate>
{
    SecondMenuBtn *secondBtn;
    NSString *sa;
    NSString *actions;
    int _flag;
    int _page;
    Model *modelHere;
    IllustrationCollectionViewCell *cell;
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    CollectionWriteAndReadDB *WAndR;
}
@property(nonatomic,strong)NSMutableArray *pageArr;//记录每个collection中的页数
@property(nonatomic,strong)NSMutableArray *chDataArr;//存储插画数据
@property(nonatomic,strong)NSMutableArray *cosDataArr;//存储cos数据
@property(nonatomic,strong)NSMutableArray *mhDataArr;//存储漫画数据
@property(nonatomic,strong)NSMutableArray *xcDataArr;//存储宣传数据
@property(nonatomic,strong)NSMutableArray *refreshDataArr;//存储上下拉对象
@end

@implementation IllustrationViewController
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
        self.pageArr = [NSMutableArray arrayWithCapacity:0];
        self.chDataArr = [NSMutableArray arrayWithCapacity:0];
        self.cosDataArr = [NSMutableArray arrayWithCapacity:0];
        self.mhDataArr = [NSMutableArray arrayWithCapacity:0];
        self.xcDataArr = [NSMutableArray arrayWithCapacity:0];
        self.refreshDataArr = [NSMutableArray arrayWithCapacity:0];
        sa = @"chahua";
        actions = @"piclist";
        _page = 0;
        _flag = 1300;
        
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
    secondBtn = [[SecondMenuBtn alloc] initWithFrame:CGRectMake(0, 62, 320, 33) andTarget:self andAction:@selector(secondBtnDown:) andBtnName:@[@"插画",@"COS",@"漫画",@"宣传"]];
    [self.view addSubview:secondBtn];
    
    //设置初次进入时，选中的时第一项
    secondBtn.selectImag.hidden = NO;
    secondBtn.selectImag.frame = CGRectMake((1300-1300)*self.view.frame.size.width/4+5, 2, 54, 25);
    
    [self makeCollection];
    
    //初始化将收藏内容写入数据库的封装对象
    WAndR = [[CollectionWriteAndReadDB alloc] init];
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"tupianArAA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"tupianArAA-no" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"tupianArBB" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"tupianArBB-no" object:nil];
}
//接收到收藏通知
-(void)notifyYes:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.cosDataArr andFlag:1 andName:@"tupianArAA"];
    }else if (_flag == 1300){
        [WAndR addCollec:articleId andDataArr:self.chDataArr andFlag:1 andName:@"tupianArAA"];
    }else if (_flag == 1302){
        [WAndR addCollec:articleId andDataArr:self.mhDataArr andFlag:1 andName:@"tupianArBB"];
    }else{
        [WAndR addCollec:articleId andDataArr:self.xcDataArr andFlag:1 andName:@"tupianArAA"];
    }
}
//接收到取消收藏通知
-(void)notifyNo:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.cosDataArr andFlag:2 andName:@"tupianArAA"];
    }else if (_flag == 1300){
        [WAndR addCollec:articleId andDataArr:self.chDataArr andFlag:2 andName:@"tupianArAA"];
    }else if (_flag == 1302){
        [WAndR addCollec:articleId andDataArr:self.mhDataArr andFlag:2 andName:@"tupianArBB"];
    }else{
        [WAndR addCollec:articleId andDataArr:self.xcDataArr andFlag:2 andName:@"tupianArAA"];
    }
}
-(void)makeCollection
{
    NSArray *idenArr = @[@"aa",@"bb",@"cc",@"dd"];
    for (int i=0; i<4; i++) {
        //设置collecView的UICollectionViewFlowLayout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        //实例化collectionView，初始化的时候用布局来初始化它
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 95, 320, self.view.frame.size.height-95-49) collectionViewLayout:layout];
        collection.dataSource = self;
        collection.delegate = self;
        collection.tag = 1500+i;
        collection.hidden = YES;
        collection.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:collection];
        
        //给collectionView注册复用的cell
        [collection registerClass:[IllustrationCollectionViewCell class] forCellWithReuseIdentifier:idenArr[i]];
        
        //上下拉刷新
        header = [MJRefreshHeaderView header];
        header.scrollView = collection;
        header.delegate = self;
        header.tag = 1520+i;
        
        footer = [MJRefreshFooterView footer];
        footer.scrollView = collection;
        footer.delegate = self;
        footer.tag = 1530+i;
        [self.refreshDataArr addObject:@{@"head": header,@"foot":footer}];
    }
}

-(void)loadData
{
    MyMbd *mb = [[MyMbd alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mb];
    
    __weak IllustrationViewController *illustration = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=%@&sa=%@&offset=%d&count=10&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",actions,sa,[self.pageArr[_flag-1300] intValue]*10] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        
        MyMbd *mb = (MyMbd*)[illustration.view viewWithTag:12345];
        [mb removeFromSuperview];
        
        for (int i=0; i<4; i++) {
            MJRefreshHeaderView *_header = (MJRefreshHeaderView*)[illustration.view viewWithTag:1520+i];
            MJRefreshFooterView *_footer = (MJRefreshFooterView*)[illustration.view viewWithTag:1530+i];
            [_header endRefreshing];
            [_footer endRefreshing];
        }
        
        NSArray *arr = result[@"list"];
        if ([self.pageArr[_flag-1300] intValue] == 0) {
            if (_flag == 1300) {
                [illustration.chDataArr removeAllObjects];
            }else if(_flag == 1301) {
                [illustration.cosDataArr removeAllObjects];
            }else if(_flag == 1302) {
                [illustration.mhDataArr removeAllObjects];
            }else {
                [illustration.xcDataArr removeAllObjects];
            }
        }
        for (NSDictionary *temp in arr) {
            Model *model = [[Model alloc] initWithDic:temp];
            model.idInfo = temp[@"id"];
            if (_flag == 1300) {
                [illustration.chDataArr addObject:model];
            }else if(_flag == 1301) {
                [illustration.cosDataArr addObject:model];
            }else if(_flag == 1302) {
                [illustration.mhDataArr addObject:model];
            }else {
                [illustration.xcDataArr addObject:model];
            }
        }
        if (_flag == 1300) {
            [self hiddenCollection];
            UICollectionView *collection1 = (UICollectionView*)[illustration.view viewWithTag:1500];
            collection1.hidden = NO;
            [collection1 reloadData];
        }else if(_flag == 1301) {
            [self hiddenCollection];
            UICollectionView *collection2 = (UICollectionView*)[illustration.view viewWithTag:1501];
            collection2.hidden = NO;
            [collection2 reloadData];
        }else if(_flag == 1302) {
            [self hiddenCollection];
            UICollectionView *collection3 = (UICollectionView*)[illustration.view viewWithTag:1502];
            collection3.hidden = NO;
            [collection3 reloadData];
        }else {
            [self hiddenCollection];
            UICollectionView *collection4 = (UICollectionView*)[illustration.view viewWithTag:1503];
            collection4.hidden = NO;
            [collection4 reloadData];
        }
    } andType:YES];
}
//隐藏collection
-(void)hiddenCollection
{
    for (int i=0; i<4; i++) {
        UICollectionView *collection = (UICollectionView*)[self.view viewWithTag:1500+i];
        collection.hidden = YES;
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
            sa = @"chahua";
            actions = @"piclist";
            [self loadData];
            break;
        }
        case 1301:
        {
            sa = @"cos";
            actions = @"piclist";
            [self loadData];
            break;
        }
        case 1302:
        {
            sa = @"chahua";
            actions = @"cartoon_list";
            [self loadData];
            break;
        }
        case 1303:
        {
            sa = @"xuanchuan";
            actions = @"piclist";
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

#pragma mark collection代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1500) {
        return self.chDataArr.count;
    }else if(collectionView.tag == 1501) {
        return self.cosDataArr.count;
    }else if(collectionView.tag == 1502) {
        return self.mhDataArr.count;
    }else {
        return self.xcDataArr.count;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1500) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"aa" forIndexPath:indexPath];
        modelHere = self.chDataArr[indexPath.row];
    }else if(collectionView.tag == 1501) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bb" forIndexPath:indexPath];
        modelHere = self.cosDataArr[indexPath.row];
    }else if(collectionView.tag == 1502) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cc" forIndexPath:indexPath];
        modelHere = self.mhDataArr[indexPath.row];
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dd" forIndexPath:indexPath];
        modelHere = self.xcDataArr[indexPath.row];
    }
    if (collectionView.tag == 1502) {
        cell.backImage.frame = CGRectMake(10, 5, 140, 215);
        cell.picImage.frame = CGRectMake(5, 5, 130, 180);
        [cell.picImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",modelHere.icon]]];
        cell.nameLab.frame = CGRectMake(5, 190, 130, 20);
        cell.nameLab.text = modelHere.title;
        return cell;
    }else{
        [cell.picImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",modelHere.icon]]];
        cell.nameLab.text = modelHere.title;
        return cell;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1502) {
        return CGSizeMake(160, 220);
    }else{
        return CGSizeMake(160, 170);
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IllustrationDetailViewController *picDetailView = [[IllustrationDetailViewController alloc] init];
    switch (_flag) {
        case 1300:
        {
            Model *modelHe = self.chDataArr[indexPath.row];
            picDetailView.picId = modelHe.gid;
            picDetailView.commentCount = modelHe.comment_totals;
            picDetailView.detailType = @"tupianArAA";
            picDetailView.picTitleName = modelHe.title;
            [self presentViewController:picDetailView animated:YES completion:nil];
            break;
        }
        case 1301:
        {
            Model *modelHe = self.cosDataArr[indexPath.row];
            picDetailView.picId = modelHe.gid;
            picDetailView.commentCount = modelHe.comment_totals;
            picDetailView.detailType = @"tupianArAA";
            picDetailView.picTitleName = modelHe.title;
            [self presentViewController:picDetailView animated:YES completion:nil];
            break;
        }
        case 1302:
        {
            Model *modelHe = self.mhDataArr[indexPath.row];
            CartoonViewController *detailView = [[CartoonViewController alloc] init];
            detailView.Id = modelHe.idInfo;
            //detailView.action = flag;
            detailView.leftPic = modelHe.icon;
            detailView.titleName = @"漫画";
            detailView.infoTitleName = modelHe.title;
            detailView.authorName = modelHe.author;
            detailView.statusName = modelHe.status;
            detailView.updateName = modelHe.update;
            detailView.typeName = modelHe.type;
            detailView.keyWordName = modelHe.keyword;
            detailView.describName = modelHe.des;
            [self presentViewController:detailView animated:YES completion:nil];
            break;
        }
        case 1303:
        {
            Model *modelHe = self.xcDataArr[indexPath.row];
            picDetailView.picId = modelHe.gid;
            picDetailView.commentCount = modelHe.comment_totals;
            picDetailView.detailType = @"tupianArAA";
            picDetailView.picTitleName = modelHe.title;
            [self presentViewController:picDetailView animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
    
}
#pragma mark 上下拉代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    for (int i=0; i<4; i++) {
        if (refreshView.tag == 1520+i) {
            [self.pageArr replaceObjectAtIndex:i withObject:@"0"];
            [self loadData];
            break;
        }
    }
    for (int i=0; i<4; i++) {
        if (refreshView.tag == 1530+i) {
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
