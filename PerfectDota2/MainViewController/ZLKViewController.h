//
//  ZLKViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PDTagView.h"
#import "PDTagLabel.h"
@interface ZLKViewController : PDBaseViewController

@property (weak, nonatomic) IBOutlet PDTagView *tagView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, copy) NSString *app1Path;
- (IBAction)zlkInfoClick:(id)sender;
@end
