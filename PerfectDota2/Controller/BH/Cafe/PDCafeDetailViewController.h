//
//  PDCafeDetailViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/20.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDBaseViewController.h"
@class PDCafeModel;

@interface PDCafeDetailViewController : PDBaseViewController

@property (nonatomic, strong) PDCafeModel *cafeModel;
@property (nonatomic, weak) UIWebView *webView;
- (IBAction)btnPhoneClick:(id)sender;
- (IBAction)btnToMap:(id)sender;

@end
