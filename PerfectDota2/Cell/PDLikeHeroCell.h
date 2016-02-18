//
//  PDLikeHeroCell.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/18.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDHero.h"

@interface PDLikeHeroCell : UICollectionViewCell

@property (nonatomic, strong) PDHero *hero;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end
