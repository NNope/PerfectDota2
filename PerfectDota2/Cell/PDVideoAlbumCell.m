//
//  PDVideoAlbumCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDVideoAlbumCell.h"

@implementation PDVideoAlbumCell

-(void)setPdVideoAlbumModel:(PDVideoAlbumModel *)pdVideoAlbumModel
{
    _pdVideoAlbumModel = pdVideoAlbumModel;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:pdVideoAlbumModel.thumbnail] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.titleLabel.text = pdVideoAlbumModel.title;
    self.discirptionLabel.text = pdVideoAlbumModel.discirption;
    self.totalLabel.text = [NSString stringWithFormat:@"视频数(%lu)",pdVideoAlbumModel.total];
    
    NSDate *lastUpdate = [[NSDate alloc] initWithTimeIntervalSince1970:pdVideoAlbumModel.last_uped/1000];
    NSDateFormatter *laupdateformatter = [[NSDateFormatter alloc] init];
    laupdateformatter.dateFormat = @"MM-dd";
    NSString *strLastUp = [laupdateformatter stringFromDate:lastUpdate];
    self.last_upedLabel.text = strLastUp;
}

@end
