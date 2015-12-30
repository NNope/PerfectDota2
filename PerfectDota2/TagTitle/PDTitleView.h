//
//  PDTitleView.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDTitleView;

@protocol PDTitleViewDelegate <NSObject>

@optional
- (void)pdTitleView:(PDTitleView *)titleView clickBackButton:(UIButton *)backbtn;
- (void)pdTitleView:(PDTitleView *)titleView clickRrightButton:(UIButton *)rightbtn;
@end

typedef enum {
    PDTitleTypeNone,           // 无
    PDTitleTypeLike,           // 收藏
    PDTitleTypeInfo,           // 信息
    PDTitleTypeShare,          // 分享
    PDTitleTypeLikeAndShare,   // 收藏+分享
    PDTitleTypeInfoAndShare,   // 信息+分享
    PDTitleTypeRefresh,        // 刷新

}PDTitleType;

@interface PDTitleView : UIView
@property (nonatomic, weak) id<PDTitleViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *btnBack;
@property (nonatomic, weak) UIButton *btnInfo;
@property (nonatomic, weak) UIButton *btnShare;
@property (nonatomic, weak) UIButton *btnLike;
@property (nonatomic, weak) UIButton *btnRefresh; // 可以创建3 4按钮，然后在type中更改tag图片,就不用写几遍一样的约束代码了
/**
 *  是否已收藏
 */
@property (nonatomic, assign) BOOL isLiked;
/**
 *  是否是首页 需要隐藏back
 */
@property (nonatomic, assign) BOOL isHidebtnBack;

@property (nonatomic, assign) PDTitleType titleType;
// 记得要控制back按钮的显示
@end
