//
//  PDDataBase
//
//  Created by Shelin on 15/11/18.
//  Copyright © 2015年 GreatGate. All rights reserved.
//

#import "PDDataBase.h"
#import "FMDatabase.h"

@implementation PDDataBase

static FMDatabase *_db;

+ (void)initialize {
    
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/Data.db",NSHomeDirectory()];
    
    // 创建
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    // 建表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS TNews (id integer PRIMARY KEY, itemDict blob NOT NULL, idStr text NOT NULL, newsType text NOT NULL)"];
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS TNewsAll (id integer PRIMARY KEY, itemDict blob NOT NULL, idStr text NOT NULL, newsType text NOT NULL)"];
}

// 相应表插入相应数据 对应type 插入数据
+(void)saveTable:(NSString *)table ItemDict:(NSDictionary *)itemDict
{
    // 判断是否已存在
    if ([self isExistTable:table WithId:itemDict[@"id"]])
    {
        PDLog(@"新闻已存在");
        return;
    }
    // 此处把字典归档成二进制数据直接存入数据库，避免添加过多的数据库字段
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:itemDict];
    
    // 执行更新 format 因为要把dict转nsdata 所以不好拼接表名 
    if ([table isEqualToString:@"TNewsAll"]) // 全部模块
    {
        // 如果有新增的 要删除多余的 并且要新的插入最前面
        [_db open];
        [_db executeUpdateWithFormat:@"INSERT INTO TNewsAll (itemDict, idStr, newsType) VALUES (%@, %@, %@)",dictData, itemDict[@"id"],itemDict[@"type"]];
        PDLog(@"全部新闻存入数据库");
        [_db close];
    }
    else if([table isEqualToString:@"TNews"]) // 其他模块新闻
    {
        
        [_db open];
        [_db executeUpdateWithFormat:@"INSERT INTO TNews (itemDict, idStr, newsType) VALUES (%@, %@, %@)",dictData, itemDict[@"id"],itemDict[@"newsType"]];
        PDLog(@"新闻存入数据库");
        [_db close];
    }
}

// 查询 对应表 对应type的所有
+(NSMutableArray *)listTbale:(NSString *)table ItemClass:(Class)itemclass type:(NSString *)type
{
    // 查询就要这么写
    [_db open];
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM ? where newsType = ?",table,type];
    NSMutableArray *ModelList = [NSMutableArray array];
    
    // 用[rs next]可以轮询query回来的资料，每一次的next可以得到一个row裡对应的数值，并用[rs stringForColumn:]或[rs intForColumn:]等方法把值转成Object-C的型态。取用完资料后则用[rs close]把结果关闭
    while (set.next)
    {
        // 获得当前所指向的数据
        // itemDict键
        NSData *dictData = [set objectForColumnName:@"itemDict"];
        // 解档
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
        // 用MJ转为model
        [ModelList addObject:[itemclass mj_objectWithKeyValues:dict]];
    }
    
    [set close];
    [_db close];

    return ModelList;
}

// 查询对应表 对应type的 部分
+ (NSMutableArray *)listTbale:(NSString *)table WithRange:(NSRange)range ItemClass:(Class)itemclass type:(NSString *)type
{
    
    [_db open];
    NSString *SQL;
    if (type)
    {
        if (type.length < 1)
        {
            PDLog(@"type不能为空");
        }
        SQL = [NSString stringWithFormat:@"SELECT * FROM %@ where newsType = '%@' order by id desc LIMIT %lu, %lu",table,type,range.location, range.length];
    }
    else
    {
        // 查全部类别
        SQL = [NSString stringWithFormat:@"SELECT * FROM %@ order by id desc LIMIT %lu, %lu",table,range.location, range.length];
    }
    FMResultSet *set = [_db executeQuery:SQL];
    NSMutableArray *list = [NSMutableArray array];
    
    while (set.next) {
        // 获得当前所指向的数据
        
        NSData *dictData = [set objectForColumnName:@"itemDict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
        [list addObject:[itemclass mj_objectWithKeyValues:dict]];
    }
    [set close];
    [_db close];
    return list;
}

// 查询是否存在
+(BOOL)isExistTable:(NSString *)table WithId:(NSString *)idStr
{
    [_db open];
    BOOL isExist = NO;
    FMResultSet *resultSet;
    // 分表查询
    if ([table isEqualToString:@"TNewsAll"])
    {
        resultSet= [_db executeQuery:@"SELECT * FROM TNewsAll where idStr = ?",idStr];
    }
    else if ([table isEqualToString:@"TNews"])
    {
        resultSet= [_db executeQuery:@"SELECT * FROM TNews where idStr = ?",idStr];
    }
    
    while ([resultSet next])
    {
        // 这行有id
        if([resultSet stringForColumn:@"idStr"])
        {
            isExist = YES;
        }
        else
        {
            isExist = NO;
        }
    }
    [resultSet close];
    [_db close];
    return isExist;
}

/**
 * 统计条数
 select count(1) from tb where 条件成立
 */

/**
 *  查找某行的某个数据

 NSString *address = [db stringForQuery:@"SELECT Address FROM PersonList WHERE Name = ?",@"John”];

 //找年齡

 int age = [db intForQuery:@"SELECT Age FROM PersonList WHERE Name = ?",@"John”];
 */
@end
