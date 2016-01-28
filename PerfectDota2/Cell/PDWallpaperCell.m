//
//  PDWallpaperCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/27.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDWallpaperCell.h"

@implementation PDWallpaperCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setWallModel:(PDWallModel *)wallModel
{
    _wallModel = wallModel;
    self.lblFileName.text = wallModel.filename;
    self.lblAuthor.text = wallModel.filefrom;
    [self.imgWall sd_setImageWithURL:[NSURL URLWithString:wallModel.thumbnail] placeholderImage:[UIImage imageNamed:@"Loading-wall"]];
}

@end
