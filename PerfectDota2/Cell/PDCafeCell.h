//
//  PDCafeCell.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/12.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCafeModel.h"

@interface PDCafeCell : UITableViewCell

@property (nonatomic, strong) PDCafeModel *cafeModel;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgFace;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblMachineCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;


@end
