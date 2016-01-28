//
//  PDWallpaperViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/27.
//  Copyright © 2016年 谈Xx. All rights reserved.
//  壁纸

#import "PDBaseViewController.h"

@interface PDWallpaperViewController : PDBaseViewController

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionList;


// 当前页码
@property (nonatomic, assign) NSInteger currentpage;
// 总页码
@property (nonatomic, assign) NSInteger totalPages;

@end
