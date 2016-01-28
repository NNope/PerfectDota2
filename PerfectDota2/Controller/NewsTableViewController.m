//
//  NewsTableViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/10.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "NewsTableViewController.h"
#import "MJRefreshHeaderView.h"
#import "PDNewsCell.h"
#import "PDNewestVideoCell.h"
#import "PDVideoAlbumCell.h"
#import "PDNewsModel.h"
#import "PDNewestVideoModel.h"
#import "PDWebViewController.h"
#import "MJRefreshFooterView.h"
#import "PDDataBase.h"


static  NSString *const TopNewsCellID = @"TopNewsCellID";
static  NSString *const PDNewsCellID = @"PDNewsCellID";
static  NSString *const PDNewestVideoCellID = @"PDNewestVideoCellID";
static  NSString *const PDVideoAlbumCellID = @"PDVideoAlbumCellID";

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册cell
    if (self.pdNewsTableType == PDNewsTableTypeAll)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"TopNewsCell" bundle:nil] forCellReuseIdentifier:TopNewsCellID];
    }
    // 监听刷新通知[第一个vc才要]
    if (self.pdNewsTableType == PDNewsTableTypeAll)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(advanceRefresh) name:PDNewsAllRefresh object:nil];
    }
    self.hasAutoRefresh = NO;
    
    [self.tableView addHeaderWithTarget:self action:@selector(refresh)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreNews)];
    
    // 先显示数据库缓存新闻
//    self.newsList = [PDDataBase listItemClass:[PDNewsModel class]];
    PDLog(@"11");
}

// 通知用的 提前刷新，防止cell需要用
- (void)advanceRefresh
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isFirstRefresh];
    self.hasAutoRefresh = YES; // 这个用于解决第一次没有启动图，来不及用通知，所以一起控制
    [self.tableView headerBeginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 理一理 等待的时候，已经进来了，但是此时不要刷新
    // 然后要坐等通知来刷新
    // 然后后面的几个vc 需要刷新
    // 然后别的tab切换回来，不要刷新
    
    // 程序每次置为NO
    if ([[NSUserDefaults standardUserDefaults]boolForKey:isFirstRefresh]) {
        // 第一次是no
        return;
    }
    // 自动刷新 排除第一个vc

    if (!self.hasAutoRefresh)
    {
        // 这个就是后面的vc进来的
        [self.tableView headerBeginRefreshing];
        self.hasAutoRefresh = YES;
    }
   
}

#pragma mark - Get

// 下拉刷新  要注意 每一个新闻模块请求的是不一样的
- (void)refresh
{
    // 新闻版块
    if (!self.isVideo)
    {
        if (self.pdNewsTableType == PDNewsTableTypeAll)
        {
            [self refreshNewsALL];
        }
        else
        {
            [self refreshNewsOrther];
        }
    }
    else // 视频模块
    {
        [self refreshVideo];
    }


}
// 上拉加载
- (void)loadMoreNews
{
    if (!self.isVideo)
    {
        // 加载更多 1 2 3
        NSString *moreNewsUrl = @"";
        // 确定不同的请求url
        if (self.pdNewsTableType == PDNewsTableTypeAll && !self.isVideo)
        {
            // 加载全部更多
            moreNewsUrl = [NSString stringWithFormat:@"http://www.dota2.com.cn/wapnews/hotnewsList%lu.html?%ld",self.newsList.count/20,(long)[[[NSDate alloc] init] timeIntervalSince1970]];
        }
        else
        {
            // 加载其他分类更多
            moreNewsUrl = [NSString stringWithFormat:@"%@index%lu.html?%ld",self.typeBaseUrl,self.newsList.count/20,(long)[[[NSDate alloc] init] timeIntervalSince1970]];
        }
        [[PDNetworkTool sharedNetworkToolsWithoutBaseUrl]GET:moreNewsUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *moreNews = responseObject[@"data"];
            [self.newsList addObjectsFromArray:moreNews];
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            PDLog(@"%@",error);
            [self.tableView headerEndRefreshing];
        }];
    }
    else // 视频模块
    {
        // 视频没有更多 就不自定义了
        [self.tableView tableViewNoMore];
    }
}
#pragma mark - private
// 只有全部板块用到
- (void)isNeedEndRefreshing
{
    if (_topSuccess && _newSuccess)
    {
        [self.tableView headerEndRefreshing];
        _topSuccess = NO;
        _newSuccess = NO;
        
        [self.tableView reloadData];
    }
}
// 视频下拉没有加载
- (void)videoTableViewNoMore
{
    for (UIView *view in self.tableView.subviews)
    {
        if ([view isKindOfClass:[MJRefreshFooterView class]])
        {
            MJRefreshFooterView *foot = (MJRefreshFooterView *)view;
            foot.pullToRefreshText = @"没有更多了";
            foot.releaseToRefreshText = @"没有更多了";
            foot.refreshingText = @"没有更多了";
        }
    }
    [self.tableView footerEndRefreshing];
}
// 刷新视频列表
- (void)refreshVideo
{
    NSString *url = @"";
    // 最新模块
    if (self.pdVideoTableType == PDVideoTableTypeNewest)
    {
        url = [NSString stringWithFormat:@"http://www.dota2.com.cn/app1/data/videoNewest.json?%ld",(long)[[[NSDate alloc] init] timeIntervalSince1970]];
        
    }
    else if (self.pdVideoTableType != PDVideoTableTypeLive)// 赛事 集锦 解说
    {
        url = [NSString stringWithFormat:@"http://www.dota2.com.cn/app1/data/sorts/%lu.json?%ld",self.cid,(long)[[[NSDate alloc] init] timeIntervalSince1970]];
    }
    [[PDNetworkTool sharedNetworkToolsWithoutBaseUrl]GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.videoList = [NSMutableArray arrayWithArray:responseObject];
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        PDLog(@"%@",error);
        [self.tableView headerEndRefreshing];
    }];

}
// 刷新其他模块新闻
- (void)refreshNewsOrther
{
    // 请求其他分类的新闻
    NSString *hotNewsUrl = [NSString stringWithFormat:@"%@index.html?%ld",self.typeBaseUrl,(long)[[[NSDate alloc] init] timeIntervalSince1970]];
    [PDNetworkTool getNewsWithUrl:hotNewsUrl param:nil modelClass:[PDNewsModel class] SuccessBlock:^(id responseArr) {
        self.newsList = responseArr;
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
    } FailureBlock:^(NSError *error) {
        PDLog(@"%@",error);
        [self.tableView headerEndRefreshing];
    }];

}
// 刷新全部模块新闻
- (void)refreshNewsALL
{
    // 这只是all的时候。。。。
    // 请求轮播
    /*http://www.dota2.com.cn/wapnews/sliderImagesData_v2.html?2655449187*/
    NSString *sliderUrl = [NSString stringWithFormat:@"http://www.dota2.com.cn/wapnews/sliderImagesData_v2.html?%ld",(long)[[[NSDate alloc] init] timeIntervalSince1970]];
    [[PDNetworkTool sharedNetworkToolsWithoutBaseUrl]GET:sliderUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.topNewsList = responseObject[@"data"];
        self.topSuccess = YES;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        PDLog(@"%@",error);
        [self.tableView headerEndRefreshing];
    }];
    
    // 请求全部
    NSString *hotNewsUrl = [NSString stringWithFormat:@"http://www.dota2.com.cn/wapnews/hotnewsList.html?%ld",(long)[[[NSDate alloc] init] timeIntervalSince1970]];
    [PDNetworkTool getNewsWithUrl:hotNewsUrl param:nil modelClass:[PDNewsModel class] SuccessBlock:^(id responseArr) {
        self.newsList = responseArr;
        self.newSuccess = YES;
    } FailureBlock:^(NSError *error) {
        PDLog(@"%@",error);
        [self.tableView headerEndRefreshing];
    }];
//    [[PDNetworkTool sharedNetworkToolsWithoutBaseUrl]GET:hotNewsUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        // 应该做数据库保存
//        
//        self.newsList = [PDNewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        self.newSuccess = YES;
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        PDLog(@"%@",error);
//        [self.tableView headerEndRefreshing];
//    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isVideo)
        return self.videoList.count;
    else
        return self.newsList.count + ((self.topNewsList!=nil)?1:0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pdNewsTableType == PDNewsTableTypeAll && !self.isVideo)
    {
        // 全部板块
        if (indexPath.row == 0)
        {
            // 第一个轮播cell
            return 188;
        }
    }
    if ( self.isVideo)
    {
        return 90;
    }

    return 95;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    // 如果是一个cell 并且是All
    if (!self.isVideo)
    {
        // 新闻模块
        if (self.pdNewsTableType == PDNewsTableTypeAll)
        {
            if (indexPath.row == 0)
            {
                // 全部新闻的第一个cell  是轮播
                TopNewsCell *topcell = [tableView dequeueReusableCellWithIdentifier:TopNewsCellID forIndexPath:indexPath];
                topcell.delegate = self;
                topcell.topNewsList = self.topNewsList;
                
                return topcell;
            }
            index -= 1;
        }
            // 其余新闻模块
            PDNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:PDNewsCellID forIndexPath:indexPath];
            newsCell.pdNewsModel = self.newsList[index];
            return newsCell;
        
    }
    else // 视频模块
    {
        if (self.pdVideoTableType == PDVideoTableTypeNewest)
        {
            PDNewestVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:PDNewestVideoCellID forIndexPath:indexPath];
            PDNewestVideoModel *videoModel = [PDNewestVideoModel mj_objectWithKeyValues:self.videoList[indexPath.row]];
            videoCell.pdNewestVideoModel = videoModel;
            return videoCell;
        }
        else
        {
            PDVideoAlbumCell *albumCell = [tableView dequeueReusableCellWithIdentifier:PDVideoAlbumCellID forIndexPath:indexPath];
            PDVideoAlbumModel *albumModel = [PDVideoAlbumModel mj_objectWithKeyValues:self.videoList[indexPath.row]];
            albumCell.pdVideoAlbumModel = albumModel;
            return albumCell;
        }
        
    }
    
//    PDNewestVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:PDNewestVideoCellID forIndexPath:indexPath];
//    PDNewestVideoModel *videoModel = [PDNewestVideoModel mj_objectWithKeyValues:self.newestVideoList[indexPath.row]];
//    videoCell.pdNewestVideoModel = videoModel;
//    return videoCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isVideo)
    {
        NSInteger index = indexPath.row;
        if (self.pdNewsTableType == PDNewsTableTypeAll)
        {
            index -= 1;
            if (indexPath.row == 0)
            {
                return;
            }
        }
        // 新闻cell的点击事件
        PDWebViewController *detailVC = [[PDWebViewController alloc] init];
        PDNewsModel *model = [PDNewsModel mj_objectWithKeyValues:self.newsList[index]];
        detailVC.newsModel = model;
        detailVC.titleView.titleType = PDTitleTypeLikeAndShare;
        detailVC.title = @"资讯详情";
        [self.navigationController pushViewController:detailVC animated:YES];

    }
    
    // 视频的点击要另外处理

}

#pragma mark - TopCellDelagate
- (void)TopNewsCell:(TopNewsCell *)topcell didSelectItemAtIndex:(NSInteger)index Url:(NSString *)url;
{
    
    PDWebViewController *webVC = [[PDWebViewController alloc] init];
    PDNewsModel *model = [PDNewsModel mj_objectWithKeyValues:self.topNewsList[index]];
    webVC.newsModel = model;
    webVC.titleView.titleType = PDTitleTypeShare;
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark - Setter

-(void)setPdVideoTableType:(PDVideoTableType)pdVideoTableType
{
    _pdVideoTableType = pdVideoTableType;
    
    self.isVideo = YES;
    self.cid = 0;
    
    switch (pdVideoTableType)
    {
        case PDVideoTableTypeCommentate:
        {
            self.cid = 4;
        }
            break;
        case PDVideoTableTypeMatch:
        {
            self.cid = 3;
        }
            break;
        case PDVideoTableTypeHighlights:
        {
            self.cid = 2;
        }
            break;
            
        default:
            break;
    }
}

-(void)setPdNewsTableType:(PDNewsTableType)pdNewsTableType
{
    self.isVideo = NO;
    _pdNewsTableType = pdNewsTableType;
    
    switch (pdNewsTableType)
    {
        case PDNewsTableTypeAll:
        {
            self.typeBaseUrl = @"";
        }
            break;
        case PDNewsTableTypeGov:
        {
            self.typeBaseUrl = @"http://www.dota2.com.cn/wapnews/govnews/";
        }
            break;
            
        case PDNewsTableTypeUpdate:
        {
            self.typeBaseUrl = @"http://www.dota2.com.cn/wapnews/vernews/";
        }
            break;
            
        case PDNewsTableTypeMedia:
        {
            self.typeBaseUrl = @"http://www.dota2.com.cn/wapnews/medianews/";
        }
            break;
        case PDNewsTableTypeMatch:
        {
            self.typeBaseUrl = @"http://www.dota2.com.cn/wapnews/matchnews/";
        }
            break;
            
        default:
            break;
    }
}

-(void)setTopSuccess:(BOOL)topSuccess
{
    _topSuccess = topSuccess;
    [self isNeedEndRefreshing];
    
}
-(void)setNewSuccess:(BOOL)newSuccess
{
    _newSuccess = newSuccess;
    [self isNeedEndRefreshing];

}

@end
