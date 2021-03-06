//
//  PDCafeAreaView.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/7.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDHistoryCityButton.h"

typedef void (^areaBlock)(PDHistoryCityButton *btn);

@interface PDCafeAreaView : UIView

@property (nonatomic, strong) NSMutableArray *areaList;
@property (nonatomic, strong) NSMutableArray *btnsArr;
@property (nonatomic, copy) areaBlock areaHandle;
@property (nonatomic, assign) NSInteger row;

-(instancetype)initWithFrame:(CGRect)frame areaList:(NSMutableArray *)arealist;

-(void)setAreaBlock:(areaBlock) handle;


- (void)hideAreaView;
- (void)showAreaView;

@end
