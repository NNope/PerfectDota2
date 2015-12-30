//
//  PDCafeSearchView.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/28.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCityModel.h"
@class PDCafeSearchView;

@protocol PDCafeSearchViewDelegate <NSObject>

@required
- (void)pdCafeSearchView:(PDCafeSearchView *)searchview clickCityButton:(UIButton *)citybtn;

@end


@interface PDCafeSearchView : UIView

@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (nonatomic, strong) PDCityModel *city;
@property (nonatomic, weak) id<PDCafeSearchViewDelegate> delegate;
- (IBAction)btnCityClick:(id)sender;
@end
