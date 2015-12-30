//
//  TTTagView.h
//  TTTagView
//
//  Created by 谈Xx on 15/12/3.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDTagView;
@class PDTagLabel;

@protocol PDTagViewDelegate <NSObject>

@optional
/**
 *  点击tag后把当前index传递出去
 */
- (void)pdTagView:(PDTagView *)tagView didSelectTaglabel:(PDTagLabel *)label;
@end

@interface PDTagView : UIView

@property (nonatomic, assign) id<PDTagViewDelegate> delegate;
@property (nonatomic, strong) NSArray *tagNameList;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, weak) UIView *markView;
@property (nonatomic, weak) UIView *redLine;
/**
 *  tag宽度
 */
@property (nonatomic, assign) CGFloat TagLabelWidth;
/**
 *   数量小于3个
 */
@property (nonatomic, assign) BOOL isNeedMargin;
/**
 *  点击tag的时候 不要scroll做tag的缩放 默认yse
 */
@property (nonatomic, assign) BOOL isTagChange;

// 在约束确定后给控件设置frame
-(void)setSubviewsFrame;
// 点击后使markView偏移
-(void)moveMarkViewFromIndex:(NSInteger)oldindex ToIndex:(NSInteger)newIndex;

@end
