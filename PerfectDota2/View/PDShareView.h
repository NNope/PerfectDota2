//
//  PDShareView.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/23.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDShareModel.h"

@interface PDShareView : UIView

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *whiteView;
@property (nonatomic, strong) PDShareModel *shareModel;

/**
 *  通过分享按钮创建shareView
 *
 *  @param frame <#frame description#>
 *  @param imgs  <#imgs description#>
 *  @param title <#title description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame ShareBtnImgs:(NSArray *)imgs btnTitles:(NSArray *)title;
@end
