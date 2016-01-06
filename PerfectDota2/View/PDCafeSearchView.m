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
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PDchooseCityChanged:) name:PDChooseCityChanged object:nil];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    // 显示上一次选择的城市
    [self updateBtnChooseCityTitle];
    self.whiteView.layer.cornerRadius = 4;
    self.whiteView.layer.masksToBounds = YES;
}

// 更新选择的城市按钮
- (void)updateBtnChooseCityTitle
{
    [self.btnCity setTitle:[[PDLocationTool shareTocationTool] readLastChooseCity] forState:UIControlStateNormal];
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

#pragma mark - Private
// 修改了选择的城市 通知
- (void)PDchooseCityChanged:(NSNotification *)noti
{
    NSString *choose = noti.userInfo[chooseCityInfoKey];
    [[PDLocationTool shareTocationTool] saveChooseCity:choose];
    [self.btnCity setTitle:choose forState:UIControlStateNormal];
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
