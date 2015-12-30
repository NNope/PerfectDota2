//
//  PDTitleView.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDTitleView.h"

@implementation PDTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleFrame];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setTitleFrame];
    }
    return self;
}

// 初始化子控件布局
-(void)setTitleFrame
{
    self.bounds = CGRectMake(0, 0, SCREENWIDTH, NAVIBARHEIGHT);
    self.backgroundColor = PDBlackColor;
    self.title = @"";
    [self addTitleSubview];
 

}
// 增加子控件
-(void)addTitleSubview
{
    // 添加返回按钮
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImg = [UIImage imageNamed:@"wall_back"];
    [back setBackgroundImage:backImg forState:UIControlStateNormal];
    [back addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:back];
    self.btnBack = back;
    
    // 添加标题
    UILabel *title = [[UILabel alloc] init];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:18];
    [self addSubview:title];
    self.titleLabel = title;
    
    // 分享按钮
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareImg = [UIImage imageNamed:@"wall_share"];
    [share setBackgroundImage:shareImg forState:UIControlStateNormal];
    [share addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:share];
    share.tag = PDTitleTypeShare;
    self.btnShare = share;
    // 收藏按钮
    UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *likeImg = [UIImage imageNamed:@"navi_btn_collect"];
    UIImage *likeImged = [UIImage imageNamed:@"navi_btn_collected"];
    [like setBackgroundImage:likeImg forState:UIControlStateNormal];
    [like setBackgroundImage:likeImged forState:UIControlStateSelected];
    [like addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:like];
    like.tag = PDTitleTypeLike;
    self.btnLike = like;
    // 刷新按钮
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *refreshImg = [UIImage imageNamed:@"box_refresh"];
    [refresh setBackgroundImage:refreshImg forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refresh];
    refresh.tag = PDTitleTypeRefresh;
    self.btnRefresh = refresh;
    // 信息按钮
    UIButton *info = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *infoImg = [UIImage imageNamed:@"navi_btn_info"];
    [info setBackgroundImage:infoImg forState:UIControlStateNormal];
    [info addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:info];
    info.tag = PDTitleTypeInfo;
    self.btnInfo = info;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    // 返回按钮的约束
    NSDictionary *dic = @{@"self":self,@"back":self.btnBack,@"title":self.titleLabel};
    NSDictionary *metricsBack = @{@"width":@(self.btnBack.currentBackgroundImage.size.width),@"height":@(self.btnBack.currentBackgroundImage.size.height),@"right":@(self.btnBack.currentBackgroundImage.size.width + 18)};
    [self.btnBack setTranslatesAutoresizingMaskIntoConstraints:NO];
    // go
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[back(width)]" options:0 metrics:metricsBack views:dic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[back(height)]-|" options:0 metrics:metricsBack views:dic]];
    
    // title的约束
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[back]-10-[title]-right-|" options:0 metrics:metricsBack views:dic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[title]|" options:0 metrics:nil views:dic]];
    if (self.isHidebtnBack)
    {
        self.btnBack.hidden = YES;
    }
    if (self.titleType == PDTitleTypeLike || self.titleType == PDTitleTypeLikeAndShare)
    {
        self.btnLike.selected = self.isLiked;
    }
    // 如果没有设置type 默认值 remove
    if (self.titleType == PDTitleTypeNone)
    {
        self.titleType = PDTitleTypeNone;
    }
}

#pragma mark - 设置
/**
 *  设置title样式
 *  设置约束 去除不需要的
 *  @param titleType 主要是右边的按钮
 */
-(void)setTitleType:(PDTitleType)titleType
{
    _titleType = titleType;
    NSDictionary *dic = @{@"self":self,
                          @"like":self.btnLike,
                          @"info":self.btnInfo,
                          @"refresh":self.btnRefresh,
                          @"share":self.btnShare};
    switch (titleType)
    {
        case PDTitleTypeNone:
        {
            [self.btnLike removeFromSuperview];
            [self.btnRefresh removeFromSuperview];
            [self.btnShare removeFromSuperview];
            [self.btnInfo removeFromSuperview];
        }
            break;
        case PDTitleTypeLike:
        {
            [self.btnRefresh removeFromSuperview];
            [self.btnShare removeFromSuperview];
            [self.btnInfo removeFromSuperview];
            
            [self.btnLike setTranslatesAutoresizingMaskIntoConstraints:NO];
            NSDictionary *metrics = @{@"width":@(self.btnLike.currentBackgroundImage.size.width),@"height":@(self.btnBack.currentBackgroundImage.size.height)};
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[like(>=width)]-|" options:0 metrics:metrics views:dic]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[like(>=height)]-|" options:0 metrics:metrics views:dic]];
        }
            break;
        case PDTitleTypeInfo:
        {
            [self.btnRefresh removeFromSuperview];
            [self.btnShare removeFromSuperview];
            [self.btnLike removeFromSuperview];
            
            [self.btnInfo setTranslatesAutoresizingMaskIntoConstraints:NO];
            NSDictionary *metrics = @{@"width":@(self.btnInfo.currentBackgroundImage.size.width),@"height":@(self.btnInfo.currentBackgroundImage.size.height)};
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[info(>=width)]-|" options:0 metrics:metrics views:dic]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[info(>=height)]-|" options:0 metrics:metrics views:dic]];
        }
            break;
        case PDTitleTypeShare:
        {
            [self.btnLike removeFromSuperview];
            [self.btnRefresh removeFromSuperview];
            [self.btnInfo removeFromSuperview];
            
            [self.btnShare setTranslatesAutoresizingMaskIntoConstraints:NO];
            NSDictionary *metrics = @{@"width":@(self.btnShare.currentBackgroundImage.size.width),@"height":@(self.btnShare.currentBackgroundImage.size.height)};
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[share(>=width)]-|" options:0 metrics:metrics views:dic]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[share(>=height)]-|" options:0 metrics:metrics views:dic]];
        }
            break;
        case PDTitleTypeLikeAndShare:
        {
            [self.btnRefresh removeFromSuperview];
            [self.btnInfo removeFromSuperview];
            
            [self.btnShare setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.btnLike setTranslatesAutoresizingMaskIntoConstraints:NO];
            NSDictionary *metrics = @{@"sharewidth":@(self.btnShare.currentBackgroundImage.size.width),
                                      @"shareheight":@(self.btnShare.currentBackgroundImage.size.height),
                                      @"likewidth":@(self.btnLike.currentBackgroundImage.size.width),
                                      @"likeheight":@(self.btnLike.currentBackgroundImage.size.height)};
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[like(>=likewidth)]-[share(>=sharewidth)]-|" options:NSLayoutFormatAlignAllBottom|NSLayoutFormatAlignAllTop metrics:metrics views:dic]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[share(>=shareheight)]-|" options:0 metrics:metrics views:dic]];
        }
            break;
        case PDTitleTypeInfoAndShare: // 信息+分享
        {
            [self.btnRefresh removeFromSuperview];
            [self.btnLike removeFromSuperview];
            
            [self.btnShare setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.btnInfo setTranslatesAutoresizingMaskIntoConstraints:NO];
            NSDictionary *metrics = @{@"sharewidth":@(self.btnShare.currentBackgroundImage.size.width),
                                      @"shareheight":@(self.btnShare.currentBackgroundImage.size.height),
                                      @"infowidth":@(self.btnInfo.currentBackgroundImage.size.width),
                                      @"infoheight":@(self.btnInfo.currentBackgroundImage.size.height)};
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[info(>=infowidth)]-[share(>=sharewidth)]-|" options:NSLayoutFormatAlignAllBottom|NSLayoutFormatAlignAllTop metrics:metrics views:dic]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[share(>=shareheight)]-|" options:0 metrics:metrics views:dic]];
        }
            break;
        case PDTitleTypeRefresh:
        {
            [self.btnLike removeFromSuperview];
            [self.btnShare removeFromSuperview];
            [self.btnInfo removeFromSuperview];
            
            [self.btnRefresh setTranslatesAutoresizingMaskIntoConstraints:NO];
            NSDictionary *metrics = @{@"width":@(self.btnRefresh.currentBackgroundImage.size.width),@"height":@(self.btnRefresh.currentBackgroundImage.size.height)};
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[refresh(>=width)]-|" options:0 metrics:metrics views:dic]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[refresh(>=height)]-|" options:0 metrics:metrics views:dic]];
        }
            break;
            
        default:
            break;
    }
}
-(void)setIsHidebtnBack:(BOOL)isHidebtnBack
{
    _isHidebtnBack = isHidebtnBack;
}
// 更改title名称
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}


#pragma mark - 事件

-(void)returnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(pdTitleView:clickBackButton:)])
    {
        [self.delegate pdTitleView:self clickBackButton:sender];
    }
}

-(void)rightClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case PDTitleTypeLike:
        {
            PDLog(@"PDTitleTypeLike");
            sender.selected = !sender.selected;
            self.isLiked = sender.selected;
        }
            break;
            
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(pdTitleView:clickRrightButton:)])
    {
        [self.delegate pdTitleView:self clickRrightButton:sender];
    }
}

@end
