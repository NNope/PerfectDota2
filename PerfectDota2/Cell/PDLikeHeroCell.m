//
//  PDLikeHeroCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/18.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDLikeHeroCell.h"

@implementation PDLikeHeroCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setHero:(PDHero *)hero
{
    self.imgView.image = [UIImage imageNamed:hero.image];
    self.lblName.text = hero.name;
}

@end
