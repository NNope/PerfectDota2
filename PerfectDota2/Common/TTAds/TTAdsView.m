//
//  TTAdsView.m
//  TTAdsView
//
//  Created by 谈Xx on 15/11/20.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "TTAdsView.h"
#import "TTAdsCell.h"
#import "UIImageView+WebCache.h"

static NSString* const AdsCellID = @"AdsCell";
static CGFloat const TITLEHEIGHT = 25;
@interface TTAdsView()
/**
*  是否使用网络图片
*/
@property (nonatomic, assign) BOOL isWebImg;
/**
 *  当前的图片索引
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  分页控制
 */
@property(nonatomic,strong)UIPageControl *pageControl;
/**
 *  定时器
 */
@property(nonatomic,strong)NSTimer *timer;

@property (nonatomic, strong) UICollectionView *AdsCollectView;
@property (nonatomic, weak) UILabel *titleLabel;

@end
@implementation TTAdsView

-(instancetype)initWithFrame:(CGRect)frame PlaceholderImage:(UIImage *)image imageNames:(NSArray *)imagearray
{
    if (self = [super initWithFrame:frame])
    {
        self.isWebImg = NO;
        self.currentIndex = 0;
        self.urlArray = imagearray;
        self.placeHolderImg = image;
        self.timeInterval = 5;
        [self setUpcollectionView];
        [self setUpPageControl];
    }
    return self;
}
// url图片
-(instancetype)initWithFrame:(CGRect)frame PlaceholderImage:(UIImage *)image Urls:(NSArray *)urlarray titles:(NSArray *)titlearray
{
    if (self = [super initWithFrame:frame])
    {
        self.isWebImg = YES;
        self.currentIndex = 0;
        self.urlArray = urlarray;
        self.titleArray = titlearray;
        self.placeHolderImg = image;
        self.timeInterval = 5;
        [self setUpcollectionView];
        [self setUpPageControl];
    }
    return self;
}



+(instancetype)TTAdsViewWithFrame:(CGRect)frame PlaceholderImage:(UIImage *)image Urls:(NSArray *)urlarray titles:(NSArray *)titlearray
{
    return [[self alloc] initWithFrame:frame PlaceholderImage:image Urls:urlarray titles:titlearray];
}

#pragma mark - 创建
-(void)setUpcollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 水平间距
    layout.minimumInteritemSpacing = 0;
    // 垂直间距
    layout.minimumLineSpacing = 0;
    // 滚动方向为水平  默认为垂直
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 每个item的size为全屏的size
    layout.itemSize = self.bounds.size;
    
    self.AdsCollectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.AdsCollectView.pagingEnabled = YES;
    self.AdsCollectView.showsHorizontalScrollIndicator = NO;
    self.AdsCollectView.dataSource = self;
    self.AdsCollectView.delegate = self;
    self.AdsCollectView.bounces = false;
    [self addSubview:self.AdsCollectView];
    
    
    [self.AdsCollectView registerNib:[UINib nibWithNibName:@"TTAdsCell" bundle:nil] forCellWithReuseIdentifier:AdsCellID];
    // 滑到第1个item 但是不要动画
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.AdsCollectView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}

-(void)setUpPageControl
{
    self.pageControl = [[UIPageControl alloc] init];
    
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.numberOfPages = self.urlArray.count;
    _pageControl.frame = CGRectMake(0, self.bounds.size.height - (self.titleArray?TITLEHEIGHT+15:15), self.bounds.size.width, 10);
    [self addSubview:_pageControl];
    
    // 如果有title 在下面再加一个标题view 25高度
    if (self.titleArray)
    {
        // 此处增加一个 数组个数的判断
        if (self.urlArray.count != self.titleArray.count)
        {
            [NSException raise:@"TTAdsView" format:@"url数组个数与title数组个数不匹配"];
        }
        
        UIView *titleBG = [[UIView alloc] init];
        titleBG.backgroundColor = [UIColor blackColor];
        titleBG.alpha = 0.3;
        titleBG.frame = CGRectMake(0, self.bounds.size.height-TITLEHEIGHT, self.bounds.size.width, TITLEHEIGHT);
        [self addSubview:titleBG];
        // 不能加到bg上 会一起透明
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:titleBG.frame];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = [UIColor whiteColor];
        // 默认title
        titleLbl.text = self.titleArray[0];
        [self addSubview:titleLbl];
        self.titleLabel = titleLbl;
    }
}

-(void)setTimeInterval:(NSInteger)timeInterval
{
    _timeInterval = timeInterval;
    
    // 先清空定时器 如果再次设置时间
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(beginAnimations) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    
    // 不能开始 此时还没有collectionView
    
    // 开始定时器 5s后
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]];
//    [self.timer fire];
    // 或者
//    [self.timer setFireDate:[NSDate date]];
}

// 设置数组的时候 下载
-(void)setUrlArray:(NSArray *)urlArray
{
    
    _urlArray = urlArray;
    if (self.isWebImg)
    {
        // 提前下载好
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_urlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [NSThread sleepForTimeInterval:5];
                UIImageView *temp = [[UIImageView alloc] init];
                [temp sd_setImageWithURL:obj placeholderImage:nil];
                
            }];

        });
    }
    // 如果使用缓存 需要在重新设置数据源的时候 设置分页 刷新图片 刷新第一个lable
    _pageControl.numberOfPages = self.urlArray.count;
    [self.AdsCollectView reloadData];
    self.titleLabel.text = self.titleArray[0];

}

-(void)stop
{
    [self.timer invalidate];
}

#pragma mark - Private
/**
 *  自动轮播
 */
-(void)beginAnimations
{
    // 当前的偏移量 + 一个宽度 别的不用管，反正就是这样
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:2 inSection:0];
    [self.AdsCollectView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

/**
 *  计算前后的索引
 */
-(NSInteger)getNextImageIndex:(NSInteger)nextindex
{
    if (nextindex == self.urlArray.count)
    {
        // 说明进来的是最后一张
        return 0;
    }
    else if (nextindex == -1)
    {
        return self.urlArray.count - 1;
    }
    else
        return nextindex;
}

// 手动滚 自动滚 最后要回来的处理
-(void)collectionViewNextOffset:(UIScrollView *)collectView
{
    //--/x方向偏移量/-----
    
    NSInteger offsetX = collectView.contentOffset.x;
    
    //--/collectionView窗口宽度/-----
    
    NSInteger viewW = collectView.bounds.size.width;
    
    //--/计算是否要切换图片/-----
    // 要这么算 因为开启了分页，所以最后的肯定是屏宽的倍数
    NSInteger offset = offsetX/viewW - 1;
    if (offset < 0)
    {
        // 左滑
        _currentIndex = [self getNextImageIndex:_currentIndex-1];
    }
    else if(offset > 0)
    {
        // 右滑
        _currentIndex = [self getNextImageIndex:_currentIndex+1];
    }
    // 取到最新的index 可以给分页控制器了
    
    if (offset!=0)// 这样 完成滑动的时候但是没有翻页的时候 就不进来了
    {
        /* 滑动完成  */
        _pageControl.currentPage = _currentIndex;
        // title更换
        _titleLabel.text = self.titleArray[_currentIndex];
        
        // 固定滑动中间一格
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        [self.AdsCollectView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        //--/解决快速拖拽跳帧的现象/-----
        //--/1 关闭动画/-----
        [UIView setAnimationsEnabled:NO];
        //--/2 刷新第一页的Cell  注意@[indexpath]表示的是一个数组（只有一个元素）/-----
        [self.AdsCollectView reloadItemsAtIndexPaths:@[indexpath]];
        //--/3 打开动画/-----
        [UIView setAnimationsEnabled:YES];
    }

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TTAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AdsCellID forIndexPath:indexPath];
    
    // 当前要显示的图片索引 不能拿current，他此时还没更新
    NSInteger index = (indexPath.item - 1 + self.urlArray.count + self.currentIndex) % self.urlArray.count;
    
    // 这里 下载图片 要算好此时的图片索引
    if (self.isWebImg)
    {
        [cell.imgView sd_setImageWithURL:self.urlArray[index] placeholderImage:self.placeHolderImg];
    }
    else
    {
        [cell SetImageWithName:self.urlArray[index]];
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDataSource
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock)
    {
        self.selectBlock(self.currentIndex);
    }
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(TTAdsView:didSelectItemAtIndex:)])
        {
            [self.delegate TTAdsView:collectionView didSelectItemAtIndex:self.currentIndex];
        }
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

// 减速完成
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self collectionViewNextOffset:scrollView];
}

/**
 *  如果是自动滚的 要有这个方法 不是手动减速的
 *
 *  @param scrollView
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self collectionViewNextOffset:scrollView];
}
/**
 *  开始拖动
 *
 *  @param scrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 暂停
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]];
}


@end
