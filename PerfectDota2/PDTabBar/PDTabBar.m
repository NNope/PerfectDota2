//
//  PDTabBar.m
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDTabBar.h"
#import "PDTabBarButton.h"

@interface PDTabBar()
@property (nonatomic, weak) UIImageView *bgImgView;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, strong) NSMutableArray *tabBarBtns;
@end

@implementation PDTabBar

-(instancetype)init
{
    if (self = [super init])
    {
        self.tabBarBtns = [NSMutableArray array];
        
        UIImageView *bgImg = [[UIImageView alloc] init];
        bgImg.image = [UIImage imageNamed:@"tab_bg"];
        self.bgImgView = bgImg;
        [self addSubview:bgImg];
    }
    return self;
}

-(void)layoutSubviews
{
    self.bgImgView.frame = self.bounds;
    // 遍历给frame 给tag
    NSInteger count = self.tabBarBtns.count;
    for (int i = 0; i < count; i++)
    {
        PDTabBarButton *btn = (PDTabBarButton *)self.tabBarBtns[i];
        btn.tag = i;
        CGFloat btnY = 0;
        CGFloat btnW = self.width/count;
        CGFloat btnX = i*btnW;
        CGFloat btnH = self.height;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}


-(void)addTabbarButtonWithImageKey:(NSString *)imgname andSelectImageKey:(NSString *)selectname
{
    PDTabBarButton *btn = [[PDTabBarButton alloc] init];
//    UIImage *a = [UIImage imageNamed:@"tab_bh"];
    [btn setImage:[UIImage imageNamed:imgname] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectname] forState:UIControlStateSelected];

    [self addSubview:btn];
    [btn addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 默认选中第一个 记得有一个背景view
    if (self.subviews.count ==2)
    {
        [self tabBarButtonClick:btn];
    }
    [self.tabBarBtns addObject:btn];
    
}

-(void)tabBarButtonClick:(PDTabBarButton *)btn
{
    // 通知TabBarVC
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItemFrom:To:)])
    {
        [self.delegate tabBar:self didSelectItemFrom:self.selectBtn.tag To:btn.tag];
    }
    // 当前选中的按钮取消
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
}

@end
