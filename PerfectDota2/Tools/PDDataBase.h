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
+ (void)saveItemDict:(NSDictionary *)itemDict;
/**
 *  读取列表
 *
 *  @return <#return value description#>
 */
+ (NSMutableArray *)listItemClass:(Class)itemclass;
/**
 *  分页读取列表
 *
 *  @param range <#range description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableArray *)listWithRange:(NSRange)range ItemClass:(Class)itemclass;
/**
 *  判断是否存在
 *
 *  @param idStr <#idStr description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isExistWithId:(NSString *)idStr;
@end
