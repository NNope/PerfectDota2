//
//  TTAdsView.h
//  TTAdsView
//
//  Created by 谈Xx on 15/11/20.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTAdsView;

// 协议
@protocol TTAdsViewDelegate <NSObject>
@optional
- (void)TTAdsView:(UICollectionView *)tTAdsView didSelectItemAtIndex:(NSInteger)index;
@end

typedef void (^SelectHandle)(NSInteger index);


@interface TTAdsView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *  图片url数组
 */
@property (nonatomic, strong) NSArray *urlArray;
/**
 *  标题数组 非必要
 */
@property (nonatomic, strong) NSArray *titleArray;
/**
 *  占位图
 */
@property (nonatomic, strong) UIImage *placeHolderImg;
/**
 *  间隔 默认5s
 */
@property (nonatomic,assign) NSInteger timeInterval;
/**
 *  点击block
 */
@property (nonatomic,copy) SelectHandle selectBlock;
/**
 *  代理
 */
@property (nonatomic,weak) id <TTAdsViewDelegate> delegate;

// 本地图片 一般就不用标题了
-(instancetype)initWithFrame:(CGRect)frame PlaceholderImage:(UIImage *)image imageNames:(NSArray *)imagearray;

// url图片带标题
-(instancetype)initWithFrame:(CGRect)frame PlaceholderImage:(UIImage *)image Urls:(NSArray *)urlarray titles:(NSArray *)titlearray;

// url图片带标题
+(instancetype)TTAdsViewWithFrame:(CGRect)frame PlaceholderImage:(UIImage *)image Urls:(NSArray *)urlarray titles:(NSArray *)titlearray;

-(void)stop;

@end
