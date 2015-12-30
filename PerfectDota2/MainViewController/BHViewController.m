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

@interface BHViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@end

// 左右间距
static const CGFloat kCollectionMargin = 15;
static const CGFloat kCellMargin = 1;
static const CGFloat kCellLineCount = 3;
static NSString * const reuseIdentifier = @"PDBHcollectionCellID";
@implementation BHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.titleType = PDTitleTypeRefresh;
    // 比super调的晚就没用了  外界创建可以用
    self.titleView.title = @"宝盒";
    [self.collectionView addHeaderWithTarget:self action:@selector(refresh)];
    [self blackHeadColor];

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
//        self.collectionList = [NSMutableArray arrayWithArray:data[@"list"]];
        self.collectionList = [PDBHModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [self.collectionView headerEndRefreshing];
        [self.collectionView reloadData];
        self.collectionView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        PDLog(@"%@",error);
    }];
}
// 视频下拉没有加载
- (void)blackHeadColor
{
    for (UIView *view in self.collectionView.subviews)
    {
        if ([view isKindOfClass:[MJRefreshHeaderView class]])
        {
            MJRefreshHeaderView *head = (MJRefreshHeaderView *)view;
            head.statusLabel.textColor = [UIColor blackColor];
        }
    }
}

#pragma getter


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionList.count - 1;
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
    // type 原生
    PDBHModel *item = self.collectionList[indexPath.item];
    UIViewController *pushVc;
    if (item.type)
    {
        if ([item.type isEqualToString:@"dota2cafe"])
        {
            pushVc = [[PDCafeTableViewController alloc] init];
            
        }
        [self.navigationController pushViewController:pushVc animated:YES];
    }
    else  // no type   web
    {
        
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
    CGFloat length = (int)(SCREENWIDTH-((kCollectionMargin+kCellMargin) * (kCellLineCount-1)))/kCellLineCount;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, (length+kCellMargin)*kCellLineCount, SCREENWIDTH - kCollectionMargin*(kCellLineCount-1), 400)];
    bottomView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    [self.collectionView addSubview:bottomView];
    
    return CGSizeMake(length, length);
}

@end
