//
//  PDTransition.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDTransitionAnimator : NSObject<UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UINavigationController *vc;
@property(nonatomic, assign) BOOL isPush;
/**
 *  交互对象 配合手势控制动画
 */
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
- (instancetype)initWithNavigationController:(UIViewController *)vc;
-(void)panPopAction:(UIPanGestureRecognizer *)recognizer;
@end
