//
//  BHViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHViewController : PDBaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *collectionList;
@property (nonatomic, assign) BOOL isAutoRefresh;

@end
