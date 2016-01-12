//
//  PDCafeCell.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/12.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDCafeCell.h"

@implementation PDCafeCell

-(void)setCafeModel:(PDCafeModel *)cafeModel
{
    _cafeModel = cafeModel;
    
    [self.imgFace sd_setImageWithURL:[NSURL URLWithString:cafeModel.cafe_face_img_small] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.lblName.text = cafeModel.cafe_name;
    self.lblAddress.text = cafeModel.address_detail;
    self.lblMachineCount.text = cafeModel.machine_count;
    self.lblDistance.text = [NSString stringWithFormat:@"%.2f",cafeModel.distance];
    
}

@end
