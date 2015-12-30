//
//  PDTransition.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDTransitionAnimator.h"

@implementation PDTransitionAnimator

- (instancetype)initWithNavigationController:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        self.vc = (UINavigationController *)vc;
        self.vc.delegate = self;
    }
    return self;
}
-(void)panPopAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint transition = [recognizer translationInView:recognizer.view];
    CGFloat progress = transition.x/recognizer.view.bounds.size.width + 0.05;
    
    /**
     *  稳定进度区间，让它在0.0（未完成）～1.0（已完成）之间
     */
    progress = MIN(1.0, MAX(0.0, progress));
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.vc popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.interactivePopTransition updateInteractiveTransition:progress];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (progress > 0.5)
            {
                [self.interactivePopTransition finishInteractiveTransition];
            }
            else
            {
                [self.interactivePopTransition cancelInteractiveTransition];
            }
            self.interactivePopTransition = nil;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark UIViewControllerAnimatedTransitioning
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 要转场的控制器
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 转到哪个控制器
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (self.isPush)
    {
        [containerView addSubview:fromVc.view];
        [containerView addSubview:toVc.view];
        
        // 一个pop时 tabbar的bug
        if (fromVc.navigationController.viewControllers.count == 2)
        {
            [fromVc.view addSubview:fromVc.tabBarController.tabBar];
        }
        toVc.view.transform = CGAffineTransformTranslate(toVc.view.transform, containerView.bounds.size.width, 0);
        
        [UIView animateWithDuration:duration animations:^{
            fromVc.view.alpha = 0.5;
            fromVc.view.transform = CGAffineTransformScale(fromVc.view.transform, 0.9, 0.95);
            toVc.view.transform = CGAffineTransformTranslate(toVc.view.transform, -containerView.bounds.size.width, 0);
        } completion:^(BOOL finished) {
            // 很关键，因为你手势可能会取消
            fromVc.view.transform = CGAffineTransformIdentity;
            [fromVc.view removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];

    }
    else
    {
        [containerView addSubview:toVc.view];
        [containerView addSubview:fromVc.view];
        toVc.view.alpha = 0.5;
        toVc.view.transform = CGAffineTransformScale(toVc.view.transform, 0.9, 0.95);
        
        //    [containerView insertSubview:toVc.view belowSubview:fromVc.view];
        
        // 一个pop时 tabbar的bug
        if (toVc.navigationController.viewControllers.count == 1)
        {
            [toVc.view addSubview:toVc.tabBarController.tabBar];
            [toVc.view.subviews lastObject].frame = CGRectMake(0, SCREENHEIGHT-49, SCREENWIDTH, 49);
        }
        
        [UIView animateWithDuration:duration animations:^{
            toVc.view.alpha = 1.0;
            toVc.view.transform = CGAffineTransformIdentity;
            
            fromVc.view.transform = CGAffineTransformTranslate(fromVc.view.transform, containerView.bounds.size.width, 0);
            
        } completion:^(BOOL finished) {
            // 很关键，因为你手势可能会取消
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
   }

#pragma mark - UINavigationControllerDelegate PUSH POP

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPop) {
        PDTransitionAnimator *animator = [[PDTransitionAnimator alloc] init];
        animator.isPush = NO;
        return animator;
    }
    else if(operation == UINavigationControllerOperationPush)
    {
        PDTransitionAnimator *animator = [[PDTransitionAnimator alloc] init];
        animator.isPush = YES;
        return animator;
    }
        return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    /**
     *  传递给PopAnimator 是如果是自定义的，返回interactivePopTransition监控完成度
     */
    if ([animationController isKindOfClass:[PDTransitionAnimator class]])
        return self.interactivePopTransition;
    else
        return nil;
}
@end
