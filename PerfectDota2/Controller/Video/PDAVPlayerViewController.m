//
//  PDAVPlayerViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/23.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation PDAVPlayerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 视频停止了
- (void)stopVideo:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 实现这个方法来控制屏幕方向
/**
 *  控制当前控制器支持哪些方向
 *  返回值是UIInterfaceOrientationMask*
 */

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
