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
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_item (id integer PRIMARY KEY, itemDict blob NOT NULL, idStr text NOT NULL)"];
}

// 存入数据库 插入数据
+ (void)saveItemDict:(NSDictionary *)itemDict {
    
    [_db open];
    // 此处把字典归档成二进制数据直接存入数据库，避免添加过多的数据库字段
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:itemDict];
    
    // 执行更新 format
    [_db executeUpdateWithFormat:@"INSERT INTO t_item (itemDict, idStr) VALUES (%@, %@)",dictData, itemDict[@"id"]];
    [_db close];
}

// 查询
+ (NSMutableArray *)listItemClass:(Class)itemclass
{
    // 查询就要这么写
    [_db open];
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_item"];
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

// 查询某个范围的
+ (NSMutableArray *)listWithRange:(NSRange)range ItemClass:(Class)itemclass

{
    
    [_db open];
    NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM t_item LIMIT %lu, %lu",range.location, range.length];
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
+ (BOOL)isExistWithId:(NSString *)idStr
{
    [_db open];
    BOOL isExist = NO;
    
    FMResultSet *resultSet= [_db executeQuery:@"SELECT * FROM t_item where idStr = ?",idStr];
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
 *  查找某行的某个数据

 NSString *address = [db stringForQuery:@"SELECT Address FROM PersonList WHERE Name = ?",@"John”];

 //找年齡

 int age = [db intForQuery:@"SELECT Age FROM PersonList WHERE Name = ?",@"John”];
 */
@end
