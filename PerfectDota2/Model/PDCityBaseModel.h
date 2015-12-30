//
//  PDQuModel.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/28.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDCityBaseModel : NSObject

@property (nonatomic, assign) NSInteger parent_id;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *name;

@end
