//
//  IllustrationDetailViewController.m
//  TwoDimensions
//
//  Created by mac on 15-1-18.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "IllustrationDetailViewController.h"
#import "IllustrationPicturesList.h"
#import "IllustrationNav.h"
#import "IllustrationImageDesView.h"
#import "NetWorkBlock.h"
#import "MyMbd.h"
#import "Model.h"
#import "CommemtContentViewController.h"
#import "OperationDB.h"
#import "UIImageView+WebCache.h"
#import "ShareSettingViewController.h"
#import "ShareContentViewController.h"

@interface IllustrationDetailViewController ()<UIActionSheetDelegate>
{
    IllustrationPicturesList *list;
    IllustrationNav *illNav;
    IllustrationImageDesView *illImagView;
    BOOL isSelect;//记录下面的详情按钮是否点击
    int sumNum;//图片总数
    OperationDB *opDB;
    int current;
}
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation IllustrationDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        isSelect = NO;
        current = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:40/255.0 green:55/255.0 blue:62/255.0 alpha:1];
    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    opDB = [[OperationDB alloc] init];
    
    UIImageView *picLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 115, 46)];
    picLogo.center = self.view.center;
    picLogo.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:picLogo];
    
    list = [[IllustrationPicturesList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:list];
    
    illNav = [[IllustrationNav alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44) andLeftImage:@[@"返回@2x.png",@"Image评论@2x.png"] andLeftImageHeightLight:@[] andLeftAction:@selector(leftAction:) andRightImage:@[@"draw_share_btn_n.png",@"下载@2x.png",@"收藏前@2x.png"] andRightAction:@selector(rightAction:) andTarget:self andTitleName:nil];
    illNav.countLab.text = [NSString stringWithFormat:@"%@",self.commentCount];
    [self.view addSubview:illNav];
    
    NSMutableArray *set = [opDB readDataFromDBWithTableName:@"isSelsected" andDataName:@"Collection.db" andListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"]];
    for (int i=0; i<set.count; i++) {
        if (self.isID.length == 1) {
            if ([set[i][@"pictureId"] isEqualToString:self.novelAndMagaID]) {
                UIButton *btnn = (UIButton*)[self.view viewWithTag:4202];
                if ([set[i][@"indexPathSection"] boolValue]) {
                    [btnn setImage:[UIImage imageNamed:@"收藏后@2x.png"] forState:UIControlStateNormal];
                }
            }
        }else{
            if ([set[i][@"pictureId"] isEqualToString:self.picId]) {
                UIButton *btnn = (UIButton*)[self.view viewWithTag:4202];
                if ([set[i][@"indexPathSection"] boolValue]) {
                    [btnn setImage:[UIImage imageNamed:@"收藏后@2x.png"] forState:UIControlStateNormal];
                }
            }
        }
        
    }
    
    illImagView = [[IllustrationImageDesView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 190) andTarget:self andAction:@selector(downBtnDown)];
    [self.view addSubview:illImagView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"picCurrent" object:nil];
}
-(void)notify:(NSNotification*)noti
{
    NSString *currentPage = [noti object];
    current = [currentPage intValue];
    illNav.titleLab.text = [NSString stringWithFormat:@"%@/%d",currentPage,sumNum];
}
//导航条左侧按钮点击事件
-(void)leftAction:(UIButton*)btn
{
    if (btn.tag == 4100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        CommemtContentViewController *comment = [[CommemtContentViewController alloc]init];
        comment.picID = self.picId;
        comment.commentSum = self.commentCount;
        [self presentViewController:comment animated:YES completion:nil];
    }
}
//导航条右侧按钮点击事件
-(void)rightAction:(UIButton*)btn
{
    switch (btn.tag) {
        case 4200:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博",@"分享到腾讯微博",@"分享到人人网", nil];
            [sheet showInView:self.view];
            break;
        }
        case 4201:
        {
            //创建保存图片文件夹
            NSString *document = [NSHomeDirectory() stringByAppendingString:@"/Documents"];//找到沙盒中的Documents文件夹
            NSFileManager *manager = [NSFileManager defaultManager];
            BOOL isDirectory = [manager createDirectoryAtPath:[document stringByAppendingString:@"/pictureDownland"] withIntermediateDirectories:YES attributes:nil error:nil];//第一个参数是这次要创建的文件夹的完整路径
            if(isDirectory)
            {
                NSLog(@"目录创建成功");
            }
            else
            {
                NSLog(@"目录创建失败");
            }
            //异步下载图片
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            Model *model = self.dataArr[current-1];
            [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com%@",model.icon]]];
            //获取当前时间
            NSData *imagedata=UIImagePNGRepresentation(img.image);
            NSDate *date = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//一个日历对象
            NSDateComponents *com = [[NSDateComponents alloc] init];//一个日历中元素的对象
            //设置日历元素对象的集合，（选择你想要用的那些元素）
            NSInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
            com = [calendar components:flag fromDate:date];//第一个参数就是上面做的元素对象的集合
            int year = [com year];
            int month = [com month];
            int day = [com day];
            int hour = [com hour];
            int minute = [com minute];
            int second = [com second];
            //存储图片
            [manager createFileAtPath:[[NSHomeDirectory() stringByAppendingString:@"/Documents/pictureDownland"] stringByAppendingString:[NSString stringWithFormat:@"/image_%d%d%d%d%d%d.png",year,month,day,hour,minute,second]] contents:imagedata attributes:nil];    //将图片保存为PNG格式
            //提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下载成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            break;
        }
        case 4202:
        {
            if (self.isID.length == 1) {
                isSelect = [self readFromFileWithID:self.novelAndMagaID];
            }else{
                isSelect = [self readFromFileWithID:self.picId];
            }
            
            if (isSelect==NO) {
                [btn setImage:[UIImage imageNamed:@"收藏后@2x.png"] forState:UIControlStateNormal];
                //做一个通知，用来通知页面跳转
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                if (self.isID.length == 1) {
                    NSNotification *notify = [NSNotification notificationWithName:self.detailType object:self.novelAndMagaID];//第一个参数
                    [center postNotification:notify];
                    [self writeToFileWithID:self.novelAndMagaID andSelect:isSelect];
                }else{
                    NSNotification *notify = [NSNotification notificationWithName:self.detailType object:self.picId];//第一个参数
                    [center postNotification:notify];
                    [self writeToFileWithID:self.picId andSelect:isSelect];
                }
                
            }else{
                [btn setImage:[UIImage imageNamed:@"收藏前@2x.png"] forState:UIControlStateNormal];
                //做一个通知，用来通知页面跳转
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                if (self.isID.length == 1) {
                    NSNotification *notify = [NSNotification notificationWithName:[NSString stringWithFormat:@"%@-no",self.detailType] object:self.novelAndMagaID];//第一个参数
                    [center postNotification:notify];
                    [self writeToFileWithID:self.novelAndMagaID andSelect:isSelect];
                }else{
                    NSNotification *notify = [NSNotification notificationWithName:[NSString stringWithFormat:@"%@-no",self.detailType] object:self.picId];//第一个参数
                    [center postNotification:notify];
                    [self writeToFileWithID:self.picId andSelect:isSelect];
                }
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
//图片描述点击按钮
-(void)downBtnDown
{
    [UIView animateWithDuration:1 animations:^{
        if (isSelect == NO) {
            illImagView.upRow.image = [UIImage imageNamed:@"图片说明打开前@2x.png"];
            illImagView.frame = CGRectMake(0, self.view.frame.size.height-190, self.view.frame.size.width, 190);
            isSelect = YES;
        }else{
            illImagView.upRow.image = [UIImage imageNamed:@"图片说明打开后@2x.png"];
            illImagView.frame = CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 190);
            isSelect = NO;
        }
        
    }];
}
-(void)loadData
{
    MyMbd *mb = [[MyMbd alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mb];
    __weak IllustrationDetailViewController *tempMagazine = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=picture&gid=%d&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",[self.picId intValue]] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        
        MyMbd *mb = (MyMbd*)[tempMagazine.view viewWithTag:12345];
        [mb removeFromSuperview];
        NSMutableArray *tempIcons = [NSMutableArray arrayWithCapacity:0];
        NSArray *arr = result;
        [tempMagazine.dataArr removeAllObjects];
        for (NSDictionary *temp in arr) {
            Model *model = [[Model alloc] initWithDic:temp];//kvc赋值
            model.chapterId = temp[@"id"];
            [tempMagazine.dataArr addObject:model];
            [tempIcons addObject:model.icon];
        }
        sumNum = arr.count;
        
        if (arr.count) {
            if ([[NSString stringWithFormat:@"%@",arr[0][@"title"]] isEqualToString:@"<null>"]) {
                illImagView.picTitle.text = @"";
            }else{
                illImagView.picTitle.text = [NSString stringWithFormat:@"%@",arr[0][@"title"]];
            }
            if ([[NSString stringWithFormat:@"%@",arr[0][@"des"]] isEqualToString:@"<null>"] || [[NSString stringWithFormat:@"%@",arr[0][@"des"]] isEqualToString:@""]) {
                illImagView.imagDesLab.text = @"暂无图说";
            }else{
                illImagView.imagDesScr.contentSize = CGSizeMake(self.view.frame.size.width, [self getWidthWithNSString:arr[0][@"des"] andStrSize:14]);
                illImagView.imagDesLab.frame = CGRectMake(10, 10, self.view.frame.size.width-20, [self getWidthWithNSString:arr[0][@"des"] andStrSize:14]);
                
                illImagView.imagDesLab.text = arr[0][@"des"];
            } 
        }

        list.dataArrr = tempIcons;
        [list makeFirstUI];
        
    } andType:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//计算一定宽度下文字所占的高度
-(float)getWidthWithNSString:(NSString*)str andStrSize:(int)sizeNum
{
	return [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:sizeNum]} context:nil].size.height;
}
#pragma mark actionsheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ShareContentViewController *shareCon = [[ShareContentViewController alloc] init];
    switch (buttonIndex) {
        case 0:
        {
            shareCon.wbName = @"新浪微博";
            shareCon.shareTitle = self.picTitleName;
            [self presentViewController:shareCon animated:YES completion:nil];
            break;
        }
        case 1:
        {
            shareCon.wbName = @"腾讯微博";
            shareCon.shareTitle = self.picTitleName;
            [self presentViewController:shareCon animated:YES completion:nil];
            break;
        }
        case 2:
        {
            shareCon.wbName = @"人人网";
            shareCon.shareTitle = self.picTitleName;
            [self presentViewController:shareCon animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
