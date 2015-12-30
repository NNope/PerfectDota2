//
//  PDWebInfoViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/11.
//  Copyright © 2015年 谈Xx. All rights reserved.


#import "PDBaseViewController.h"
#import "PDNewsModel.h"

@interface PDWebViewController : PDBaseViewController

@property (nonatomic, assign) BOOL isHideTitle;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, weak) UIImageView *failImg;
@property (nonatomic, weak) UIImageView *loadingImage;
@property (nonatomic, weak) UIButton *refreshBtn;

@property (nonatomic, strong) PDNewsModel *newsModel;

-(void)setWebUrl:(NSString *)webUrl;

@end
