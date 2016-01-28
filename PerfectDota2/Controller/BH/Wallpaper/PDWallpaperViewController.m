//
//  PDWallpaperViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/27.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDWallpaperViewController.h"
#import "PDWallpaperCell.h"
static  NSString *const PDWallpaperCellID = @"PDWallpaperCell";

@interface PDWallpaperViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation PDWallpaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"刀塔壁纸";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 2.每个cell的尺寸 140 280
    layout.itemSize = CGSizeMake(140, 295);
    // 3.设置cell之间的水平间距
    layout.minimumInteritemSpacing = 48;
    // 4.设置cell之间的垂直间距
    layout.minimumLineSpacing = 0;
    // 5.设置四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 22, 0, 22);
    UICollectionView *coll = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVIBARHEIGHT) collectionViewLayout:layout];
    [self.view addSubview:coll];
    coll.backgroundColor = PDGrayColor;
    self.collectionView = coll;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 添加刷新
    [self.collectionView addHeaderWithTarget:self action:@selector(refresh)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreNews)];
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"PDWallpaperCell" bundle:nil] forCellWithReuseIdentifier:PDWallpaperCellID];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView headerBeginRefreshing];
}


- (void)refresh
{
    [[PDNetworkTool sharedNetworkToolsWithoutBaseUrl]GET:[NSString stringWithFormat:@"http://www.dota2.com.cn/app1/wallpaper/list.html?%ld",(long)[[[NSDate alloc] init] timeIntervalSince1970]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        /**
         *  "total_pages": 1,
         "pageSize": 20,
         "curentPage": 1,
         "wallpapers": [{
         */
        self.totalPages = [responseObject[@"total_pages"] integerValue];
        self.currentpage = [responseObject[@"curentPage"] integerValue];
        self.collectionList = [PDWallModel mj_objectArrayWithKeyValuesArray:responseObject[@"wallpapers"]];
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        PDLog(@"%@",error);
        [self.collectionView headerEndRefreshing];
    }];
}
- (void)loadMoreNews
{
    // 加载更多
    if (self.currentpage < self.totalPages)
    {
        
    }
    else
    {
        // 没有更多了
        [self.collectionView tableViewNoMore];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDWallpaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PDWallpaperCellID forIndexPath:indexPath];
    cell.wallModel = self.collectionList[indexPath.row];
    return cell;
}
//
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionList.count;
}

/**
 *  点击后 下载原图。。。。
 */

@end
