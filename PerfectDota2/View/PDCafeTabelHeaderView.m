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
    [self distanceClick:nil];
}



-(void)setPDCafeTabelHeaderViewClickBlock:(clickHandle)clickhandle
{
    self.clickhandle = clickhandle;
}

- (IBAction)areaClick:(id)sender
{
    if (self.clickhandle)
    {
        self.clickhandle(PDCafeTabelHeaderBtnArea,sender);
    }
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
