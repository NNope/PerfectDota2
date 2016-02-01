//
//  PDNetworkTool.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/7.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDNetworkTool.h"
#import "PDDataBase.h"

@implementation PDNetworkTool

+ (instancetype)sharedNetworkTools
{
    static PDNetworkTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/"];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        instance = [[self alloc]initWithBaseURL:url sessionConfiguration:config];
//        
//        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
//        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return instance;
}

+ (instancetype)sharedNetworkToolsWithoutBaseUrl
{
    static PDNetworkTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *url = [NSURL URLWithString:@""];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        instance = [[self alloc]initWithBaseURL:url sessionConfiguration:config];
        
//        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
//        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//        mr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    });
    return instance;
}

/**
 *  缓存 新闻 data
 */
+(void)getNewsWithUrl:(NSString *)url Type:(NSString *)type param:(id)param modelClass:(Class)modelClass SuccessBlock:(newsSuccessBlock)successBlock FailureBlock:(requestFailureBlock)failureBlock
{
    [[self sharedNetworkToolsWithoutBaseUrl] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *lists = responseObject[@"data"];
        // 倒序数组 存入数据库
        NSArray *reverseLists = [lists.reverseObjectEnumerator allObjects];
        // 传出去的模型数组
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSDictionary *dict in reverseLists)
        {
            // 单个模型 要正序的
            [modelArray insertObject:[modelClass mj_objectWithKeyValues:dict] atIndex:0];
            
            //先判断数据是否存储过，如果没有，网络请求新数据存入数据库
            // 分表格判断
            if (![PDDataBase isExistTable:type?@"TNews":@"TNewsAll" WithId:dict[@"id"]])
            {
                NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                //存数据库  问题来了 只有全部模块有type
                if (type)
                {
                    [mDict setObject:type forKey:@"newsType"];
                }
                [PDDataBase saveTable:type?@"TNews":@"TNewsAll" ItemDict:mDict];
            }
        }
        // 给外面模型数组
        successBlock(modelArray);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 回调给外面的fail
        failureBlock(error);
    }];
                
}


//+ (void)getVideosWithUrl:(NSString *)url  Type:(NSString *)type param:(id)param modelClass:(Class)modelClass SuccessBlock:(newsSuccessBlock)successBlock FailureBlock:(requestFailureBlock)failureBlock
//{
//    [[self sharedNetworkToolsWithoutBaseUrl] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        // 传出去的模型数组
//        NSMutableArray *modelArray = [NSMutableArray array];
//        for (NSDictionary *dict in responseObject)
//        {
//            // 单个模型 要正序的
//            [modelArray insertObject:[modelClass mj_objectWithKeyValues:dict] atIndex:0];
//            
//            // 有type就是 分类的  无type就是全部 最新
//            NSString *videoType = dict[@"type"];
//            if (![PDDataBase isExistTable:videoType?@"TVideo":@"TVideoNew" WithId:dict[@"_id"]])
//            {
//                NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//                //存数据库  问题来了 只有全部模块有type
//                if (videoType)
//                {
//                    [mDict setObject:type forKey:@"videoType"];
//                }
//                [PDDataBase saveTable:videoType?@"TVideo":@"TVideoNew" ItemDict:mDict];
//            }
//        }
//        // 给外面模型数组
//        successBlock(modelArray);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        // 回调给外面的fail
//        failureBlock(error);
//    }];
//
//}
@end
