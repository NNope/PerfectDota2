//
//  TopImgCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/9.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "TopNewsCell.h"

@implementation TopNewsCell

- (void)awakeFromNib {
    
}

// 设置轮播的数据 如果相同，外层不设置，防止多次调用
-(void)setTopNewsList:(NSArray *)topNewslList
{
    _topNewsList = topNewslList;
    //
    [self setUpArrays];
    
    // [1.2.3, 1.2.3, 1.2.3]
    // 分别组成相应的数组
    [_topNewsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.pics addObject:obj[@"pic"]];
        [self.titles addObject:obj[@"title"]];
        [self.urls addObject:obj[@"url"]];
    }];
    
    if (!self.ttAdsView)
    {
        TTAdsView *AdsView = [TTAdsView TTAdsViewWithFrame:self.bounds PlaceholderImage:[UIImage imageNamed:@"BannerLoading"] Urls:self.pics titles:self.titles];
        AdsView.delegate = self;
        [self addSubview:AdsView];
        self.ttAdsView = AdsView;
    }
    else // 如果存在了，只修改数组
    {
        self.ttAdsView.urlArray = self.pics;
        self.ttAdsView.titleArray = self.titles;
    }
   
    // 反正每次都是新的block
//    self.ttAdsView.selectBlock = ^(NSInteger index){
//        PDLog(@"点击了第%ld站图片",index);
//        // 打开一个资讯detail的VC
//        NSString *selUrl = self.urls[index];
//        PDWebInfoViewController *webVC = [[PDWebInfoViewController alloc] init];
//
//    };
}

- (void)setUpArrays
{
    if (!self.urls)
    {
        self.urls = [NSMutableArray array];
    }
    else
    {
        [self.urls removeAllObjects];
    }
    if (!self.pics)
    {
        self.pics = [NSMutableArray array];
    }
    else
    {
        [self.pics removeAllObjects];
    }
    if (!self.titles)
    {
        self.titles = [NSMutableArray array];
    }
    else
    {
        [self.titles removeAllObjects];
    }
}

-(void)TTAdsView:(UICollectionView *)tTAdsView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(TopNewsCell:didSelectItemAtIndex:Url:)])
    {
        [self.delegate TopNewsCell:self didSelectItemAtIndex:index Url:self.urls[index]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
