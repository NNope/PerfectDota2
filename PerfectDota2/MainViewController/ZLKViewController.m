//
//  ZLKViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "ZLKViewController.h"
#import "PDLocalWebViewController.h"
#import "PDWebViewController.h"
#import "SSZipArchive.h"
static CGFloat TagCount;

@interface ZLKViewController ()<PDTagViewDelegate,UIScrollViewDelegate,SSZipArchiveDelegate,MBProgressHUDDelegate>

@property (nonatomic, weak) MBProgressHUD *hud;

@property (nonatomic, assign) double unZipProgress;

@end

@implementation ZLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.unZipProgress = 0.f;
    // 解压目的路径
    self.app1Path = APP1PATH;
    
    NSArray *arr = @[@"英雄",@"物品"];
    self.tagView.tagNameList = arr;
    self.tagView.delegate = self;
    TagCount = self.tagView.tagNameList.count;
    
    [self removeSuperTitleView];

    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.childViewControllers.count ==0)
    {
        // 给tagview布局
        [self.tagView setSubviewsFrame];
        
        [self addChildVc];
        // 添加默认控制器
        UIViewController *vc1 = [self.childViewControllers firstObject];
        [self.contentScrollView addSubview:vc1.view];
        vc1.view.frame = self.contentScrollView.bounds;
    }
    
    // 第一次需要解压
    if (![[NSFileManager defaultManager]fileExistsAtPath:self.app1Path isDirectory:NULL])
    {
        PDLog(@"%@",_app1Path);
        // 显示 进度 进度里做解压
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.delegate = self;
        HUD.labelText = @"正在解压本地资料库...";
        [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
        self.hud = HUD;
    }
    
}
// 创建childVC
-(void)addChildVc
{
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width*TagCount, -20);
    for (int i = 0; i < TagCount ; i++)
    {
        PDLocalWebViewController *temp = [[PDLocalWebViewController alloc] init];
        temp.isHideTitle = YES;
        temp.title = self.tagView.tagNameList[i];
        [self addChildViewController:temp];
    }
    
}

// 进入资料库版本日志
- (IBAction)zlkInfoClick:(id)sender
{
    PDWebViewController *webVersion = [[PDWebViewController alloc] init];
    webVersion.webUrl = @"http://www.dota2.com.cn/app1/version/history_data.html";
    [self.navigationController pushViewController:webVersion animated:YES];
}

- (void)myProgressTask
{
    //  解压(文件大, 会比较耗时)
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"app1.zip" ofType:nil];
    [SSZipArchive unzipFileAtPath:path1 toDestination:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] delegate:self];
}

#pragma mark - SSZipArchiveDelegate
/**
 *  获取解压进度
 *
 *  @param loaded 当前解压大小
 *  @param total  zip总大小
 */
-(void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total
{
    
    CGFloat a = (float)loaded/total;
    self.hud.progress = a;
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.hud removeFromSuperview];
    self.hud = nil;
    // 第一次解压完刷新下
    for (PDLocalWebViewController *vc in self.childViewControllers)
    {
        [vc loadWebUrl];
    }
    
}


#pragma mark - UIScrollViewDelegate
// 代码控制偏移结束后 要载入对应才childVc
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    // so 只要加入对应的要显示的ChildVc就可以
    NSInteger index = scrollView.contentOffset.x/self.contentScrollView.width;
    UIViewController *indexVc = self.childViewControllers[index];
    
    self.tagView.selectIndex = index;
    self.tagView.isTagChange = YES;
    // 如果不是第一次添加
    if (indexVc.view.superview)
        return;
    [self.contentScrollView addSubview:indexVc.view];
    // scrollView的bounds就是当前偏移后位置
    indexVc.view.frame = self.contentScrollView.bounds;
}

// 手指控制偏移结束后 要载入对应才childVc
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
// 滚动过程中需要实时变化tag 和 markView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 边缘就是负的了
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat offsetABS = ABS(offsetX/scrollView.width);
    // 左滑 或者右滑时  每次左边的index
    NSInteger leftIndex = (int)offsetABS;
    // 对应的右边的index
    NSInteger rightIndex = offsetABS + 1;
    CGFloat rightScale = offsetABS - leftIndex;
    // 左边的就 取反了
    CGFloat leftScale = 1 - rightScale;
    
    // 防止第一个左滑是影响第一个
    // 防止最后一个右滑时影响自己
    if (rightIndex < TagCount && offsetX > 0)
    {
        if (self.tagView.isTagChange)
        {
            PDTagLabel *lblLeft = self.tagView.subviews[leftIndex];
            lblLeft.scalePercent = leftScale;
            
            // 如果是第一个 ，再往左不处理
            PDTagLabel *lblRight = self.tagView.subviews[rightIndex];
            lblRight.scalePercent = rightScale;
        }
        // 移动markView
        CGFloat markTranslate = (offsetX/scrollView.width)*self.tagView.TagLabelWidth;
        self.tagView.markView.transform = CGAffineTransformMakeTranslation(markTranslate, 0);
        
    }
    
    
}

#pragma mark - PDTagDelegate
-(void)pdTagView:(PDTagView *)tagView didSelectTaglabel:(PDTagLabel *)label
{
    CGFloat lblOffset = label.tag * self.contentScrollView.width;
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    // 点击之后不要让didscroll里去一个个的变化，但是要变化指定的
    if (self.tagView.selectIndex != label.tag)
    {
        self.tagView.isTagChange = NO;
    }
    [self.tagView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PDTagLabel class]])
        {
            PDTagLabel *temp = (PDTagLabel*)obj;
            temp.scalePercent = 0;
        }
    }];
    label.scalePercent = 1.0;
    self.tagView.selectIndex = label.tag;
    [self.contentScrollView setContentOffset:CGPointMake(lblOffset, offsetY) animated:YES];
}


@end
