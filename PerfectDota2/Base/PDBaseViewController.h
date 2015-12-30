//
//  PDBaseViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDTitleView.h"
#import "PDShareModel.h"

@interface PDBaseViewController : UIViewController
@property (nonatomic, strong) PDTitleView *titleView;
@property (nonatomic, strong) PDShareModel *shareModel;


- (void)removeSuperTitleView;
@end
