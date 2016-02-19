//
//  BHViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "BHViewController.h"
#import "PDBHcollectionCell.h"
#import "MJRefreshHeaderView.h"
#import "PDCafeTableViewController.h"
#import "PDWallpaperViewController.h"
#import "PDWebViewController.h"

@interface BHViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@end

// 左右间距
//static const CGFloat kCollectionMargin = 15;
//static const CGFloat kCellMargin = 1;
static const CGFloat kCellLineCount = 3;
static NSString * const reuseIdentifier = @"PDBHcollectionCellID";
@implementation BHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.titleType = PDTitleTypeRefresh;
    // 比super调的晚就没用了  外界创建可以用
    self.titleView.title = @"宝盒";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 添加刷新
    [self.collectionView addHeaderWithTarget:self action:@selector(refresh)];
//    [self blackHeadColor];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.isAutoRefresh)
    {
        [self.collectionView headerBeginRefreshing];
        self.isAutoRefresh = YES;
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)refresh
{
    [[PDNetworkTool sharedNetworkToolsWithoutBaseUrl]GET:[NSString stringWithFormat:@"http://www.dota2.com.cn/wapnews/baoheListData.html?%ld",(long)[[[NSDate alloc] init] timeIntervalSince1970]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *data = responseObject[@"data"][0];
        NSMutableArray *m = [PDBHModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        self.collectionList = [NSMutableArray arrayWithArray:m];
        for (PDBHModel *item in m)
        {
            // 暂时去除
            if ([item.title isEqualToString:@"我的2015"] || [item.title isEqualToString:@"好友PK"] || [item.title isEqualToString:@"背景音乐"])
            {
                [self.collectionList removeObject:item];
            }
        }
        [self.collectionView headerEndRefreshing];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        PDLog(@"%@",error);
        [self.collectionView headerEndRefreshing];
    }];
}


#pragma getter


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDBHcollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PDBHModel *model = self.collectionList[indexPath.item];
    cell.pdBHModel = model;
    return cell;
}
#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PDBHModel *item = self.collectionList[indexPath.item];
    if (item.type)// 有type 原生
    {
        UIViewController *pushVc;
        if ([item.type isEqualToString:@"dota2cafe"])// 特权网吧
        {
            pushVc = [[PDCafeTableViewController alloc] init];
            
        }
        /*
         {
         "pic": "http://dota2.wanmei.com/resources/png/151019/10251445244000110.png",
         "title": "DOTA2壁纸",
         "url": "",
         "type": "dota2wallpaper",
         "tag": "New"
         },
         */
        else if ([item.type isEqualToString:@"dota2wallpaper"]) // 壁纸
        {
            pushVc = [[PDWallpaperViewController alloc] init];
        }
        [self.navigationController pushViewController:pushVc animated:YES];
    }
    else  // no type   web
    {
        PDWebViewController *webVc = [[PDWebViewController alloc] init];
        /**
         *
         "title": "天梯排行",
         "url": "http://www.dota2.com.cn/event/201406/ttph/index.htm"
         */
//        if ([item.title isEqualToString:@"天梯排行"])
//        {
            webVc.webUrl = item.url;
//        }
        [self.navigationController pushViewController:webVc animated:YES];
    }
    
}

#pragma mark <UICollectionViewDelegateFlowLayout>
/**
 *  Cell的大小 即使你设置了cell最小间距，还是会优先cell的大小，到时候间距就不对了
 *  所以要结合间距，算出cell的大小 才是最合适的
 *
 *  @return <#return value description#>
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 2边间距 + 中间的1 *2
    CGFloat length = SCREENWIDTH/kCellLineCount;
    
    return CGSizeMake(length, length);
}


@end
