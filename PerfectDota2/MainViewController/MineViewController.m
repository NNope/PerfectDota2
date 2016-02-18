//
//  PDMineViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/2.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "MineViewController.h"
#import "PDMineCell.h"
#import "PDLikeHeroView.h"
#import "PDHero.h"

#define kWindowHeight 256.0f
#define kImageHeight 375.0f
#define kColumnCount 3
#define kLikeCellHeight 75
static  NSString *const PDMineCellID = @"PDMineCellID";
@interface MineViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self removeSuperTitleView];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.mineBGScrollView.frame = CGRectMake(0,kWindowHeight - kImageHeight+(kImageHeight-kWindowHeight-10)/2.0f, self.view.frame.size.width, kImageHeight - kWindowHeight + self.view.frame.size.height);
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TABBARHEIGHT);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PDMineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PDMineCellID forIndexPath:indexPath];
    cell.mineCellModel = self.collectionList[indexPath.item];
    return cell;
}

// header footer
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Identifierhead" forIndexPath:indexPath];
        headView.backgroundColor = [UIColor clearColor];
        
        reusableview = headView;
    }
    else if (kind == UICollectionElementKindSectionFooter)
    {
        PDLikeHeroView *footView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Identifierfoot" forIndexPath:indexPath];
        
        footView.heroList = self.heroList;
        
        reusableview = footView;
    }
    
    
    return reusableview;
    
}

// Item Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat length = (self.view.width - 1.5)/ kColumnCount;
    return CGSizeMake(length, 80);
}
#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateOffsets];
}

- (void)updateOffsets {
    CGFloat yOffset   = _collectionView.contentOffset.y;
    CGFloat threshold = kImageHeight - kWindowHeight - 7;
    PDLog(@"%f",self.mineBGScrollView.height);
    
    if (yOffset > -threshold && yOffset < 0) {
        // 一开始
        _mineBGScrollView.contentOffset = CGPointMake(0.0, floorf(yOffset / 2.0));
    } else if (yOffset < 0) {
        // 最后面
        _mineBGScrollView.contentOffset = CGPointMake(0.0, yOffset + floorf(threshold / 2.0));
        
    } else {
        // 往上
        _mineBGScrollView.contentOffset = CGPointMake(0.0, yOffset);
        
    }
#warning 加入放大效果
    //    _animateFactor = -(_tableView.contentOffset.y)*0.03;
    //
    //    ((UIScrollView *)[_scrollView viewWithTag:9999]).transform = CGAffineTransformMakeScale(_animateFactor < 1.0 ? 1.0 : _animateFactor,
    //                                                         _animateFactor < 1.0 ? 1.0 : _animateFactor);
    
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 3.设置cell之间的水平间距1
        layout.minimumInteritemSpacing = 0;
        // 4.设置cell之间的垂直间距
        layout.minimumLineSpacing = 0.5;
        // 5.设置四周的内边距
//        layout.sectionInset = UIEdgeInsetsMake(0, 22, 0, 22);
        layout.headerReferenceSize = CGSizeMake(300.0f, kWindowHeight);  //设置head大小
        CGFloat lineCount = self.heroList.count%3 != 0?(self.heroList.count/3)+1:self.heroList.count/3;
        layout.footerReferenceSize = CGSizeMake(300.0f, 10+(lineCount-1)*6 + lineCount*kLikeCellHeight + 36);
        UICollectionView *coll = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - TABBARHEIGHT) collectionViewLayout:layout];
        [self.view addSubview:coll];
        coll.backgroundColor = [UIColor clearColor];
        self.collectionView = coll;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        // 注册cell
        [self.collectionView registerNib:[UINib nibWithNibName:@"PDMineCell" bundle:nil] forCellWithReuseIdentifier:PDMineCellID];
        // 头
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Identifierhead"];
        
        // 尾部 自定义
        [self.collectionView registerNib:[UINib nibWithNibName:@"PDLikeHeroView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Identifierfoot"];
        
        
        _collectionView = coll;
    }
    return _collectionView;

}

// 图片背景
- (UIScrollView *)mineBGScrollView
{
    if (!_mineBGScrollView) {
        UIScrollView *scrol = [[UIScrollView alloc] init];
        _mineBGScrollView = scrol;
        _mineBGScrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_mineBGScrollView];
        // 背景图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, kImageHeight);
        imageView.tag = 9999;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"mine_bg_default"];
        [_mineBGScrollView addSubview:imageView];
    }
    return _mineBGScrollView;
}

/**
 *  暂时没用
 *
 *  @return <#return value description#>
 */
-(UIScrollView *)BGScrollView
{
    if (!_BGScrollView)
    {
        UIScrollView *bg = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.BGScrollView = bg;
//        self.BGScrollView.backgroundColor = [UIColor redColor];
        self.BGScrollView.delegate = self;
        self.BGScrollView.alwaysBounceVertical = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:self.BGScrollView];
    }
    return _BGScrollView;
}

-(NSArray *)collectionList
{
    if (!_collectionList)
    {
        _collectionList = [PDMineCellModel mj_objectArrayWithFilename:@"PDMineIcon.plist"];
    }
    return _collectionList;
}

- (NSArray *)heroList
{
    if (_heroList == nil)
    {
        _heroList = [PDHero mj_objectArrayWithFilename:@"TempLikeHeros.plist"];
    }
    return _heroList;
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
