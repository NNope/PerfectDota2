//
//  PDLikeHeroView.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/18.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLikeHeroView : UICollectionReusableView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UIButton *btnAllLikes;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;

// 收藏的英雄列表
@property (nonatomic, strong) NSArray *heroList;

@end
