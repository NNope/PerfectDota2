//
//  PDTabBar.h
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDTabBar;

@protocol PDTabBarDelegate <NSObject>

@optional
- (void)tabBar:(PDTabBar *)tabBar didSelectItemFrom:(NSInteger)from To:(NSInteger)to;
@end

@interface PDTabBar : UIView
@property (nonatomic, weak) id<PDTabBarDelegate> delegate;

- (void)addTabbarButtonWithImageKey:(NSString *)imgname andSelectImageKey:(NSString *)selectname;

@end
