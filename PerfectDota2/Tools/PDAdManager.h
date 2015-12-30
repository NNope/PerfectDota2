//
//  PDAdManager.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/7.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDAdManager : NSObject

+ (BOOL)isShouldDisplayAd;
+ (void)loadLatestAdImage;

+ (UIImage *)getAdImage;
@end
