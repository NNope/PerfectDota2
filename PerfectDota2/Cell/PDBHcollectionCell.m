//
//  PDBHcollectionCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDBHcollectionCell.h"


@implementation PDBHcollectionCell

-(void)setPdBHModel:(PDBHModel *)pdBHModel
{
    _pdBHModel = pdBHModel;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:pdBHModel.pic] placeholderImage:[UIImage imageNamed:@"common_instruct_img"]];
    self.titleLabel.text = pdBHModel.title;
}

@end
