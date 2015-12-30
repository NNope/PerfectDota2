//
//  PDNewestVideoCell.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/16.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDNewestVideoModel.h"

@interface PDNewestVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (nonatomic, strong) PDNewestVideoModel *pdNewestVideoModel;

@end
