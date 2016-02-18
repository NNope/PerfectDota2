//
//  PDMineCell.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/2.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMineCellModel.h"

@interface PDMineCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, strong) PDMineCellModel *mineCellModel;

@end
