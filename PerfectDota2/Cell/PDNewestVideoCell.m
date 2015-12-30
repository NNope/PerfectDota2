//
//  PDNewestVideoCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/16.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDNewestVideoCell.h"

@implementation PDNewestVideoCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setPdNewestVideoModel:(PDNewestVideoModel *)pdNewestVideoModel
{
    _pdNewestVideoModel = pdNewestVideoModel;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:pdNewestVideoModel.thumbnail] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.titleLabel.text = pdNewestVideoModel.title;
    
    NSString *strPublished = pdNewestVideoModel.published;
    NSString *strDate = [strPublished substringToIndex:10];
    self.dateLabel.text = strDate;
    
    // 时长 duration
    self.durationLabel.text = [NSString stringWithDuration:pdNewestVideoModel.duration];
    self.typeLabel.text = pdNewestVideoModel.type; 
    
}

@end
