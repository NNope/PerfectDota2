//
//  PDTabBarViewController.m
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDTabBarViewController.h"
#import "PDTabBar.h"
#import "PDAdManager.h"

@interface PDTabBarViewController ()<PDTabBarDelegate>
@property (nonatomic, weak) UIImageView *adImgView;
@property (nonatomic, weak) UILabel *lblTime;
@property (nonatomic, assign) NSInteger adTimeNum;
@property (nonatomic, strong) NSTimer *adTimer;


@end

@implementation PDTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 先下载
    [PDAdManager loadLatestAdImage];
    if ([PDAdManager isShouldDisplayAd])// 如果本地有图片
    {
        [self addAdsImg];
    }
    else
    {
//        [[NSNotificationCenter defaultCenter]postNotificationName:PDNewsAllRefresh object:nil];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isFirstRefresh];
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    }
    
//            [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    // 添加tabbar
    PDTabBar *tabbar = [[PDTabBar alloc] init];
    tabbar.delegate = self;
    tabbar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:tabbar];
    
    // 增加TabBarButoon
    [tabbar addTabbarButtonWithImageKey:@"tab_zx" andSelectImageKey:@"tab_zxon"];
    [tabbar addTabbarButtonWithImageKey:@"tab_zlk" andSelectImageKey:@"tab_zlkon"];
    [tabbar addTabbarButtonWithImageKey:@"tab_bh" andSelectImageKey:@"tab_bhon"];
    [tabbar addTabbarButtonWithImageKey:@"tab_video" andSelectImageKey:@"tab_videoon"];
    [tabbar addTabbarButtonWithImageKey:@"tab_mine" andSelectImageKey:@"tab_mineon"];
}

// 添加广告图
-(void)addAdsImg
{
    UIImageView *adImg = [[UIImageView alloc] initWithImage:[PDAdManager getAdImage]];
    adImg.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:adImg];
    // 倒计时 36 36
    UIView *timeView = [[UIView alloc] init];
    CGFloat width = 36;
    timeView.backgroundColor = [UIColor colorWithRed:150/255.0 green:131/255.0 blue:130/255.0 alpha:0.8];
    timeView.layer.masksToBounds = YES;
    timeView.layer.cornerRadius = width/2;
    timeView.frame = CGRectMake(SCREENWIDTH-10-width, 20, width, width);
    [adImg addSubview:timeView];
    self.adImgView = adImg;
    // 时间
    UILabel *lbllTime = [[UILabel alloc] init];
    lbllTime.text = @"1";
    lbllTime.textAlignment = NSTextAlignmentCenter;
    lbllTime.textColor = [UIColor blackColor];
    lbllTime.font = [UIFont systemFontOfSize:16];
    lbllTime.frame = timeView.bounds;
    [timeView addSubview:lbllTime];
    self.lblTime = lbllTime;
    // 计时器
    self.adTimeNum = 1;
    self.adTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(adTimeChange:) userInfo:nil repeats:YES];

}
// 广告倒计时
-(void)adTimeChange:(id)sender
{
    self.adTimeNum--;
    if (self.adTimeNum >= 0)
    {
        self.lblTime.text = [NSString stringWithFormat:@"%ld",(long)self.adTimeNum];
    }
    else if (self.adTimeNum == -1)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
        [UIView animateWithDuration:1.1 animations:^{
            self.adImgView.transform = CGAffineTransformMakeTranslation(0, -SCREENHEIGHT);
        } completion:^(BOOL finished) {
            [self.adTimer invalidate];
            [self.adImgView removeFromSuperview];
            // 发送通知 提前刷新
            [[NSNotificationCenter defaultCenter]postNotificationName:PDNewsAllRefresh object:nil];
        }];
        
    }
}

#pragma mark - PDTabBarDelegate
-(void)tabBar:(PDTabBar *)tabBar didSelectItemFrom:(NSInteger)from To:(NSInteger)to
{
    self.selectedIndex = to;
}

@end
