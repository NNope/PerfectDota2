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
        
        // http://c.m.163.com//nc/article/list/T1348649654285/0-20.html
        // http://c.m.163.com/photo/api/set/0096/57255.json
        // http://c.m.163.com/photo/api/set/54GI0096/57203.html
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
+ (void)getNewsWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass SuccessBlock:(newsSuccessBlock)successBlock FailureBlock:(requestFailureBlock)failureBlock
{
    [[self sharedNetworkToolsWithoutBaseUrl] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        // 要缓存到数据库 只需要把数组传递出去
        // 模型数组
//        NSMutableArray *dataArr = [modelClass mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 因为要把dict直接保存，所以要遍历两次 就不使用上面的方法直接转数组
        NSArray *lists = responseObject[@"data"];
        // 传出去的模型数组
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSDictionary *dict in lists)
        {
            // 单个模型
            [modelArray addObject:[modelClass mj_objectWithKeyValues:dict]];
            
            //先判断数据是否存储过，如果没有，网络请求新数据存入数据库
            if (![PDDataBase isExistWithId:dict[@"id"]])
            {
                //存数据库
                PDLog(@"存入数据库");
                [PDDataBase saveItemDict:dict];
            }
        }
        // 给外面模型数组
        successBlock(modelArray);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 回调给外面的fail
        failureBlock(error);
    }];
//    [XLNetworkRequest getRequest:url params:param success:^(id responseObj) {
//        //数组、字典转化为模型数组
//        
//        dataObj = [self modelTransformationWithResponseObj:responseObj modelClass:modelClass];
//        responseDataBlock(dataObj, nil);
//        
//    } failure:^(NSError *error) {
//        
//        responseDataBlock(nil, error);
//    }];
}
@end
