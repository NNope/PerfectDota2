//
//  ZXViewController.h
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QRCodeReaderViewController.h"

@interface ZXViewController : PDBaseViewController<UIScrollViewDelegate,QRCodeReaderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *ScanBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIView *TagView;
@property (nonatomic, strong) NSArray *tagNameList;
@property (nonatomic, weak) UIView *markView;
@property (nonatomic, assign) BOOL isTagChange;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIImageView *im;

@end
