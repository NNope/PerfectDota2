//
//  PDCafeTabelHeaderView.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/28.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDCafeTabelHeaderView.h"

@implementation PDCafeTabelHeaderView

-(void)awakeFromNib
{
    self.BtnScale.selected = YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}



-(void)setPDCafeTabelHeaderViewClickBlock:(clickHandle)clickhandle
{
    self.clickhandle = clickhandle;
    
    // 有问题啊 如果每次
    [self distanceClick:nil];
}

/**
 *  手动让全区按钮恢复收缩状态
 */
- (void)resumeAreaBtn
{
    self.BtnArea.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.imgArrow.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)areaClick:(id)sender
{
    if (self.clickhandle)
    {
        self.clickhandle(PDCafeTabelHeaderBtnArea,sender);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.imgArrow.transform = CGAffineTransformRotate(self.imgArrow.transform,M_PI);
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)distanceClick:(id)sender
{
    if (self.BtnDistance.selected == YES)
    {
        return;
    }
    self.BtnScale.selected = !self.BtnScale.selected;
    self.BtnDistance.selected = !self.BtnDistance.selected;
    if (self.clickhandle)
    {
        self.clickhandle(PDCafeTabelHeaderBtnDistance,sender);
    }
//    self.BtnDistance.enabled = NO;
//    self.BtnScale.enabled = YES;
}

- (IBAction)scaleClick:(id)sender
{
    if (self.BtnScale.selected == YES)
    {
        return;
    }
    self.BtnScale.selected = !self.BtnScale.selected;
    self.BtnDistance.selected = !self.BtnDistance.selected;

    if (self.clickhandle)
    {
        self.clickhandle(PDCafeTabelHeaderBtnScale,sender);
    }
//    self.BtnDistance.enabled = YES;
//    self.BtnScale.enabled = NO;
}
@end
