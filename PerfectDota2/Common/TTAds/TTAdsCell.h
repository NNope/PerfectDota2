//
//  TTAdsCell.h
//  AdsCollection
//
//  Created by 谈Xx on 15/11/18.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTAdsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, assign) NSInteger currentIndex;

-(void)SetImageWithName:(NSString *)name;
@end
