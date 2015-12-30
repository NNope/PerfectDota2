//
//  PDContainWebViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/21.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDBaseViewController.h"
#import "PDNavigationController.h"

@interface PDLocalWebViewController : PDBaseViewController<UIWebViewDelegate>
@property (nonatomic, weak) UIScrollView *contenView;
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, assign) BOOL isHideTitle;
@property (nonatomic, assign) BOOL hasPush;
@property (nonatomic, assign) BOOL hasUnzip;



- (instancetype)initWitnContentiew:(UIScrollView *)content;
- (void)loadWebUrl;
@end
