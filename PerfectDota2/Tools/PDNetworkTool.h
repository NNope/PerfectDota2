//
//  PDNetworkTool.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/7.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface PDNetworkTool : AFHTTPSessionManager

/**
 新闻请求成功block 返回数组
 */
typedef void (^newsSuccessBlock)(id responseArr);

/**
 请求失败block
 */
typedef void (^requestFailureBlock) (NSError *error);


+ (instancetype)sharedNetworkTools;
+ (instancetype)sharedNetworkToolsWithoutBaseUrl;
/**
 *  缓存 新闻 data
 */
+ (void)getNewsWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass SuccessBlock:(newsSuccessBlock)successBlock FailureBlock:(requestFailureBlock)failureBlock;



@end
