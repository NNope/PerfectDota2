//
//  TTAdsCell.m
//  AdsCollection
//
//  Created by 谈Xx on 15/11/18.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "TTAdsCell.h"
#import "UIImageView+WebCache.h"
@implementation TTAdsCell

// 给cell设置imgae
//-(void)SetImageWithUrl:(NSString *)url
//{
//    
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:self.placeHoldImage];
//    
//}
-(void)SetImageWithName:(NSString *)name
{
    self.imgView.image = [UIImage imageNamed:name];
    
}

-(void)setImgView:(UIImageView *)imgView
{
    _imgView = imgView;
    _imgView.contentMode = UIViewContentModeScaleToFill;
}
@end
