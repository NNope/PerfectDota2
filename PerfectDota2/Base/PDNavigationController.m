//
//  PDNavigationController
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDNavigationController.h"
#import "PDTransitionAnimator.h"

@interface PDNavigationController()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) PDTransitionAnimator *transition;
@end

@implementation PDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 取到当前的pop手势 和所在的view
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    // 设为不可用
    gesture.enabled = NO;
    // 把新手势添加到 老pop手势的view上
    UIView *gestureView = gesture.view;
    
    
    
    self.transition = [[PDTransitionAnimator alloc] initWithNavigationController:self];
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.transition action:@selector(panPopAction:)];
    popRecognizer.delegate = self;
    popRecognizer.edges = UIRectEdgeLeft;
    [gestureView addGestureRecognizer:popRecognizer];
    
    NSOperation *op = [[NSOperation alloc] init];
    [op main];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}

@end
