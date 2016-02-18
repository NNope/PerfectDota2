//
//  PDMineCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/2.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDMineCell.h"


@implementation PDMineCell

- (void)awakeFromNib {
    
}

-(void)setMineCellModel:(PDMineCellModel *)mineCellModel
{
    _mineCellModel = mineCellModel;
    self.lblName.text = mineCellModel.name;
    self.imgIcon.image = [UIImage imageNamed:mineCellModel.image];
    self.imgIcon.contentMode = UIViewContentModeCenter;
}

@end
