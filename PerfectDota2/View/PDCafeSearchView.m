//
//  PDCafeSearchView.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/28.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDCafeSearchView.h"
#import "PDLocationTool.h"

@implementation PDCafeSearchView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    // 显示上一次选择的城市
    NSString *lastCityName = [[PDLocationTool shareTocationTool] readLastChooseCity];
    [self.btnCity setTitle:lastCityName forState:UIControlStateNormal];
    self.whiteView.layer.cornerRadius = 4;
    self.whiteView.layer.masksToBounds = YES;
}

- (IBAction)btnCityClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pdCafeSearchView:clickCityButton:)])
    {
        [self.delegate pdCafeSearchView:self clickCityButton:sender];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.imgArrow.transform = CGAffineTransformRotate(self.imgArrow.transform,M_PI);
    } completion:^(BOOL finished) {
        self.imgArrow.transform = CGAffineTransformIdentity;
    }];
}
@end
