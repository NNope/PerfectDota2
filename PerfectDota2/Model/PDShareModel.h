//
//  PDShareModel.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/25.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDShareModel : NSObject

// 分享链接
@property (nonatomic, copy) NSString *shareLink;
// 分享标题
@property (nonatomic, copy) NSString *shareTitle;
// 分享描述
@property (nonatomic, copy) NSString *shareDesc;
// 分享缩略图
@property (nonatomic, strong) UIImage *shereThumbImage;
@end
