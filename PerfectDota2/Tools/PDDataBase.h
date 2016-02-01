//
//  PDDataBase
//
//  Created by Shelin on 15/11/18.
//  Copyright © 2015年 GreatGate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDDataBase : NSObject

/**
 *  保存单个模型
 *
 *  @param itemDict <#itemDict description#>
 */
+ (void)saveTable:(NSString *)table ItemDict:(NSDictionary *)itemDict;
/**
 *  读取列表
 *
 *  @return <#return value description#>
 */
+ (NSMutableArray *)listTbale:(NSString *)table ItemClass:(Class)itemclass type:(NSString *)type;
/**
 *  分页读取列表
 *
 *  @param range <#range description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableArray *)listTbale:(NSString *)table WithRange:(NSRange)range ItemClass:(Class)itemclass type:(NSString *)type;
/**
 *  删除某个表 多余的条数
 */
+ (BOOL)deleteSurplusTable:(NSString *)table;
/**
 *  判断是否存在
 */
+ (BOOL)isExistTable:(NSString *)table WithId:(NSString *)idStr;

@end
