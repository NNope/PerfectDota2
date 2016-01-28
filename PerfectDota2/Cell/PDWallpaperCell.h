//
//  PDWallpaperCell.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/27.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDWallModel.h"

@interface PDWallpaperCell : UICollectionViewCell
@property (nonatomic, strong)  PDWallModel *wallModel;
@property (weak, nonatomic) IBOutlet UIImageView *imgWall;
@property (weak, nonatomic) IBOutlet UILabel *lblFileName;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;


@end
