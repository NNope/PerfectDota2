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
 *  缓存 新闻 data  带type，用来存储，不然不知道什么type
 */
+ (void)getNewsWithUrl:(NSString *)url  Type:(NSString *)type param:(id)param modelClass:(Class)modelClass SuccessBlock:(newsSuccessBlock)successBlock FailureBlock:(requestFailureBlock)failureBlock;
/**
 *  获取视频资讯
 */
+ (void)getVideosWithUrl:(NSString *)url  Type:(NSString *)type param:(id)param modelClass:(Class)modelClass SuccessBlock:(newsSuccessBlock)successBlock FailureBlock:(requestFailureBlock)failureBlock;



@end
