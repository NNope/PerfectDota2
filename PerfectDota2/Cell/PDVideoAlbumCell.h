//
//  PDVideoAlbumCell.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDVideoAlbumModel.h"

@interface PDVideoAlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discirptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *last_upedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) PDVideoAlbumModel *pdVideoAlbumModel;
@end
