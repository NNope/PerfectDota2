//
//  PDBaseViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDTabBar.h"
#import "PDShareView.h"
#import "PDCafeTableViewController.h"
#import "PDCafeDetailViewController.h"
@interface PDBaseViewController ()<PDTitleViewDelegate>

@end

@implementation PDBaseViewController

-(instancetype)init
{
    if (self = [super init])
    {
        [self setupTitleView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupTitleView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = PDGrayColor;
    [self.view addSubview:self.titleView];
    self.titleView.title = self.title;
    
    // 判断下返回按钮的显示
    if (self.navigationController.childViewControllers.count == 1)
    {
        self.titleView.isHidebtnBack = YES;
    }
    // 是否已收藏
    self.titleView.isLiked = YES;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // titleView 最上面
    [self.view bringSubviewToFront:self.titleView];
    
    // pop到外面的时候 把tabbar还给人家
    for (PDTabBar *tabbar in self.view.subviews)
    {
        if ([tabbar isKindOfClass:[UITabBar class]])
        {
            [self.tabBarController.view addSubview:tabbar];
        }
    }
    
}

- (void)removeSuperTitleView
{
    for (UIView *temp in self.view.subviews)
    {
        // 因为sb创建的 这个title就不要了
        if ([temp isKindOfClass:[PDTitleView class]])
        {
            [temp removeFromSuperview];
        }
    }
}

- (void)setupTitleView
{
    self.titleView = [[PDTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVIBARHEIGHT)];
    self.titleView.delegate = self;
}


#pragma mark - PDTitleViewDelegate
// 返回 pop
-(void)pdTitleView:(PDTitleView *)titleView clickBackButton:(UIButton *)backbtn
{
    if (self.navigationController.topViewController == self)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)pdTitleView:(PDTitleView *)titleView clickRrightButton:(UIButton *)rightbtn
{
    switch (rightbtn.tag)
    {
        case PDTitleTypeLike:
        {
            PDLog(@"是否喜欢%d",rightbtn.selected);
        }
            break;
        case PDTitleTypeRefresh:
        {
            
        }
            break;
        case PDTitleTypeInfo: // 信息 暂时只考虑一种
        {
            // 特权网吧的信息
            PDBaseViewController *vc = [[PDBaseViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PDTitleTypeShare: // 分享
        {
            // 创建分享view 全屏的
            NSArray *imgs = @[@"wechat_",@"friends",@"QQ",@"sina"];
            NSArray *titles = @[@"微信朋友",@"微信朋友圈",@"QQ好友",@"新浪微博"];
            PDShareView *sv = [[PDShareView alloc] initWithFrame:self.view.bounds ShareBtnImgs:imgs btnTitles:titles];
            // 特权网吧 网吧详情特殊指定分享内容
            if ([self isKindOfClass:[PDCafeDetailViewController class]] || [self isKindOfClass:[PDCafeTableViewController class]])
            {
                sv.shareModel = [[PDShareModel alloc] init];
                sv.shareModel.shareLink = @"http://app.dota2.com.cn/web.html";
                sv.shareModel.shareDesc = @"快去下载完美刀塔APP吧，跟我一起享受特权！";
                sv.shareModel.shareTitle = @"特权网吧畅玩《DOTA2》享受特权";
                sv.shareModel.shereThumbImage = [UIImage imageNamed:@"comment_default_avatar"];
            }
            else
            {
                sv.shareModel = self.shareModel;
            }
            [self.view addSubview:sv];
            
        }
            break;
            
        default:
            break;
    }
}

@end
