//
//  PDLikeHeroView.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/18.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDLikeHeroView.h"
#import "PDLikeHeroCell.h"

@implementation PDLikeHeroView

- (void)awakeFromNib
{
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"PDLikeHeroCell" bundle:nil] forCellWithReuseIdentifier:@"PDLikeHeroCellID"];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.lblCount.text = [NSString stringWithFormat:@"%ld",self.heroList.count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.heroList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PDLikeHeroCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PDLikeHeroCellID" forIndexPath:indexPath];
    cell.hero = self.heroList[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDHero *hero = self.heroList[indexPath.item];
    PDLog(@"%@",hero.name);
}

- (NSArray *)heroList
{
    if (_heroList == nil)
    {
        _heroList = [PDHero mj_objectArrayWithFilename:@"TempLikeHeros.plist"];
    }
    return _heroList;
}

@end
