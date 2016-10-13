//
//  MainPageViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-6.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MainPageViewController.h"
#import "Nav.h"
#import "DownBar.h"
#import "iCarousel.h"
#import "MainPageScrView.h"
#import "NetWorkBlock.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
#import "MainPageControl.h"
#import "DetailViewController.h"
#import "InformationViewController.h"
#import "MyTabBarViewController.h"
#import "SingleTag.h"
#import "SettingMainPageViewController.h"
#import "CollectionWriteAndReadDB.h"
#define ITEM_SPACING 250

@interface MainPageViewController ()<iCarouselDataSource,iCarouselDelegate>
{
    MainPageScrView *mainPage;
    int _page;//页数
    UIButton *addBtn;
    UIButton *refresBtn;
    BOOL _boundary;//是否循环旋转，即是否有边界
    MainPageControl *pageCon;
    DownBar *downBtn;
    CollectionWriteAndReadDB *WAndR;
}
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *picIdArr;
@end

@implementation MainPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        self.picIdArr = [NSMutableArray arrayWithCapacity:0];
        _page = 0;
        _boundary = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self makeUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"sss" object:nil];
	// Do any additional setup after loading the view.
}
-(void)notify:(NSNotification*)noti
{
    NSString *index = [noti object];
    self.carousel.type = [index integerValue];
}
//页面布局
-(void)makeUI
{
    //导航条布局
    Nav *nav = [[Nav alloc] initWithFrame:CGRectMake(0, 0, 320, 64) andImage:@"设置@2x.png" andTarget:self andAction:@selector(rightBtnDown)];
    [self.view addSubview:nav];
    
    //底部按钮布局
    downBtn = [[DownBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 49) andTarget:self andAction:@selector(downBtnDown:)];
    [self.view addSubview:downBtn];
    
    //首页图片显示
    self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64-250)];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCylinder;
    [self.view addSubview:self.carousel];
    self.carousel.backgroundColor = [UIColor cyanColor];
    
    //向左滑动弹出“载入更多”按钮
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(320, 214, 70, 30);
    [addBtn setImage:[UIImage imageNamed:@"more_btn_n.png"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"more_btn_h.png"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    //向右滑动弹出“点击刷新”按钮
    refresBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refresBtn.frame = CGRectMake(-70, 214, 70, 30);
    [refresBtn setImage:[UIImage imageNamed:@"reflash_btn_n.png"] forState:UIControlStateNormal];
    [refresBtn setImage:[UIImage imageNamed:@"reflash_btn_h.png"] forState:UIControlStateHighlighted];
    [refresBtn addTarget:self action:@selector(refresBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refresBtn];
    
    //图片下面的页数显示
    pageCon = [[MainPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64-250-20, 320, 20)];
    [self.carousel addSubview:pageCon];
    pageCon.backgroundColor = [UIColor blackColor];
    pageCon.alpha = 0.7;
    
    //首页图片标题和简介
    mainPage = [[MainPageScrView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-250, 320, 250-49)];
    [self.view addSubview:mainPage];
    mainPage.scrollEnabled = YES;
    mainPage.backgroundColor = [UIColor whiteColor];
    mainPage.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    //初始化将收藏内容写入数据库的封装对象
    WAndR = [[CollectionWriteAndReadDB alloc] init];
    
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"wenzhangMain" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"wenzhangMain-no" object:nil];
    
}
//接收到收藏通知
-(void)notifyYes:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    [WAndR addCollec:articleId andDataArr:self.dataArr andFlag:1 andName:@"wenzhangMain"];
}
//接收到取消收藏通知
-(void)notifyNo:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    [WAndR addCollec:articleId andDataArr:self.dataArr andFlag:2 andName:@"wenzhangMain"];
}
//载入更多按钮点击事件
-(void)addBtnDown
{
    [UIView animateWithDuration:1 animations:^{
        addBtn.frame = CGRectMake(320, 214, 70, 30);
    }];
    _page++;
    [self loadData];
}
//点击刷新按钮点击事件
-(void)refresBtnDown
{
    [UIView animateWithDuration:1 animations:^{
        refresBtn.frame = CGRectMake(-70, 214, 70, 30);
    }];
    _page=0;
    [self loadData];
}
//导航条右侧按钮点击事件
-(void)rightBtnDown
{
    NSLog(@"设置界面");
    SettingMainPageViewController *sett = [[SettingMainPageViewController alloc] init];
    [self.navigationController pushViewController:sett animated:YES];
}

//底部按钮点击事件
-(void)downBtnDown:(UIButton*)btn
{
    SingleTag *single = [SingleTag shareInstance];
    single.tag = [NSString stringWithFormat:@"%d",btn.tag];
    MyTabBarViewController *tab = [[MyTabBarViewController alloc] init];
    [self presentViewController:tab animated:YES completion:nil];
}

-(void)loadData
{
    __weak MainPageViewController *tempFirst = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=top&sa=(null)&offset=%d&count=8&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",_page*8] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        
        NSArray *arr = result;
        if (_page==0) {
            [tempFirst.dataArr removeAllObjects];
            [tempFirst.picIdArr removeAllObjects];
        }
        
        for(NSDictionary *temp in arr)
        {
            Model *model = [[Model alloc] initWithDic:temp];//kvc赋值
            model.idInfo = temp[@"id"];
            [tempFirst.picIdArr addObject:temp[@"id"]];
            [tempFirst.dataArr addObject:model];
        }
        [tempFirst.carousel reloadData];
    } andType:YES];
}
#pragma mark 图片切换代理
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    Model *model = self.dataArr[index];
    DetailViewController *detailPage = [[DetailViewController alloc] init];
    detailPage.IDPic = model.idInfo;
    detailPage.picIdArr = self.picIdArr;
    detailPage.detailType = @"wenzhangMain";
    [self presentViewController:detailPage animated:YES completion:nil];
}

-(void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
    //_boundary = NO;
    if (carousel.scrollOffset > 250*((_page+1)*8-1)) {
        [UIView animateWithDuration:1 animations:^{
            addBtn.frame = CGRectMake(250, 214, 70, 30);
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            addBtn.frame = CGRectMake(320, 214, 70, 30);
        }];
    }
    if (carousel.scrollOffset < 0) {
        [UIView animateWithDuration:1 animations:^{
            refresBtn.frame = CGRectMake(0, 214, 70, 30);
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            refresBtn.frame = CGRectMake(-70, 214, 70, 30);
        }];
    }
}

-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if (self.dataArr.count) {
        Model *modelHere = self.dataArr[carousel.currentItemIndex];
        mainPage.titleLabel.text = modelHere.title;
        mainPage.desLabel.text = [NSString stringWithFormat:@"       %@",modelHere.des];
        mainPage.desLabel.frame = CGRectMake(10, 35, 300, [self getWidthWithNSString:modelHere.des]);
        pageCon.pageControlBtn.frame = CGRectMake(49.9+carousel.scrollOffset/250*221/self.dataArr.count, 0, 20, 20);
        [pageCon.pageControlBtn setTitle:[NSString stringWithFormat:@"%d",(int)carousel.scrollOffset/250+1] forState:UIControlStateNormal];
        mainPage.contentSize = CGSizeMake(320, mainPage.titleLabel.frame.size.height+mainPage.desLabel.frame.size.height);
        [mainPage.labBtn setTitle:modelHere.idInfo forState:UIControlStateNormal];
        [mainPage.labBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [mainPage.labBtn addTarget:self action:@selector(labBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.dataArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    Model *modelHere = self.dataArr[index];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 230)];
    [view setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com%@",modelHere.icon]]];
    if (index == 0) {
        mainPage.titleLabel.text = modelHere.title;
        mainPage.desLabel.text = [NSString stringWithFormat:@"       %@",modelHere.des];
        mainPage.desLabel.frame = CGRectMake(10, 35, 300, [self getWidthWithNSString:modelHere.des]);
        mainPage.contentSize = CGSizeMake(320, mainPage.titleLabel.frame.size.height+mainPage.desLabel.frame.size.height);
        [mainPage.labBtn setTitle:modelHere.idInfo forState:UIControlStateNormal];
        [mainPage.labBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [mainPage.labBtn addTarget:self action:@selector(labBtnDown:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    //首页图片上关注
    UIImageView *attention = [[UIImageView alloc] initWithFrame:CGRectMake(140, 0, 40, 70)];
    attention.image = [UIImage imageNamed:@"head_focus.png"];
    [view addSubview:attention];
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return self.dataArr.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}

-(BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return _boundary;
}

//计算一定宽度下文字所占的高度
-(float)getWidthWithNSString:(NSString*)str
{
	return [str boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
}

//下面图片简介按钮点击事件
-(void)labBtnDown:(UIButton*)btn
{
    DetailViewController *detailPage = [[DetailViewController alloc] init];
    detailPage.IDPic = btn.titleLabel.text;
    detailPage.picIdArr = self.picIdArr;
    detailPage.detailType = @"wenzhangMain";
    [self presentViewController:detailPage animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    _boundary = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
