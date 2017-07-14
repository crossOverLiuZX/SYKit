//
//  SYDatabaseManager.m
//
//
//  Created by liuZX on 16/5/19.
//  Copyright © 2016年 刘卓鑫. All rights reserved.
//
/**
 *  利用runtime机制实现通用数据库操作
 */
#import "DatabaseManager.h"
#import "FMDatabase.h"
#import <objc/runtime.h>

@implementation SYDatabaseManager {
    //数据管理对象
    FMDatabase *_fmDatabase;
}

//废掉init方法
- (instancetype)init {
    
    //抛出异常 不允许调用init方法
    @throw [NSException exceptionWithName:@"不允许调用init方法" reason:@"因为DatabaseManager是一个单例,只能通过defaultManager获取对象" userInfo:nil];
}

//写一个自己的(私有)init方法
- (instancetype)initPrivate {
    //父类的init方法可以调用
    if (self = [super init]) {
        //在这里做一系列的初始化
        [self createDB];
    }
    return self;
}


+(instancetype)defaultManager {
    static SYDatabaseManager *instance = nil;
    
    //线程保护--确保在多线程状况下也只有唯一的对象
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
       
        if (!instance) {
            instance = [[DatabaseManager alloc] initPrivate];
        }
    });
    return instance;
}

#pragma mark - 创建数据库

- (void) createDB {

    //参数1：找寻目录的名字
    //参数2：在哪一个用户上面找
    //参数3：是否展开波浪号
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentPath = [searchPaths lastObject];
    
    //拼接数据库保存地址
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"application.db"];
    
    NSLog(@"%@", dbPath);
    
    //创建数据库管理对象
    _fmDatabase = [[FMDatabase alloc] initWithPath:dbPath];

    //打开数据库
    if ([_fmDatabase open]) {
        //打开成功
        
        
        
    } else {
        //数据库打开失败
        NSLog(@"数据库打开失败");
        @throw [NSException exceptionWithName:@"数据库打开失败" reason:@"未知错误" userInfo:nil];
    }



}



#pragma mark - 实现数据库操作

#pragma mark - 创建数据库表
- (BOOL)createTableFromClass:(Class)tableClass {

    NSString *tableName = NSStringFromClass(tableClass);
    
    //获取所有属性
    NSArray *propertyArray = [self getAllPropertiesFromClass:tableClass];
    
    //利用sqlite是无类型的 拼接出语句
    NSString *filedStr = [propertyArray componentsJoinedByString:@","];
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE t_%@ (ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, %@);", tableName, filedStr];
    
    //执行sql语句
    return [_fmDatabase executeUpdate:sql];
    
    
}

#pragma mark - 利用runtime返回类的所有的属性名字
- (NSArray *)getAllPropertiesFromClass:(Class) tableClass {

    NSMutableArray *propertyArray = [NSMutableArray array];
    
    unsigned int propertyCount = 0;
    //获取class 中的属性名称---返回值为存储着所有属性的数组的首元素
    objc_property_t *propertyTypeArray = class_copyPropertyList(tableClass, &propertyCount);
    //循环遍历数组
    for (int idx = 0; idx < propertyCount; idx ++) {
        objc_property_t propertyType = propertyTypeArray[idx];
        //从结构体中获取属性名称
        const char *propertyName = property_getName(propertyType);
        NSString *properyStr = [NSString stringWithUTF8String:propertyName];
        [propertyArray addObject:properyStr];
    }
    
    return [propertyArray copy];

}

#pragma mark - 获得属性的值
- (NSArray *) getAllPropertyValuesFromObject:(id) obj {

    NSArray *propertyArray = [self getAllPropertiesFromClass:[obj class]];
    
    NSMutableArray *propertyValuesArray = [NSMutableArray array];
    
    for (NSString *pro in propertyArray) {
        //通过KVC模式拿到属性的值
        id propValue = [obj valueForKey:pro];
        
        if (!propValue) {
            [propertyValuesArray addObject:[NSNull null]];
        } else {
            [propertyValuesArray addObject:propValue];
        }
        
    }
    return [propertyValuesArray copy];
}



#pragma mark - 实现插入数据
- (BOOL)insertObject:(id)obj {
 
    //创建表
    [self createTableFromClass:[obj class]];
    //利用runtime取到表名
    const char *table = class_getName([obj class]);
    NSString *tableName = [NSString stringWithUTF8String:table];
    
    //利用runtime获取属性名
    NSArray *propertyArray = [self getAllPropertiesFromClass:[obj class]];
    
    //获得属性的值
    NSArray *propValueArray = [self getAllPropertyValuesFromObject:obj];
    
    NSString *propertyValueStr = [propValueArray componentsJoinedByString:@"','"];
    //在第一个和最后一个追加“ ‘ ”
    NSString *valueStr = [NSString stringWithFormat:@"'%@'", propertyValueStr];
                                  
    NSString *proStr = [propertyArray componentsJoinedByString:@"','"];
    NSString *proString = [NSString stringWithFormat:@"'%@'", proStr];
    
    //利用SQL语句中statment占位符
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_%@ (%@) VALUES (%@)", tableName, proString, valueStr];
    //NSLog(@"%@", insertSql);
    //执行sql
    return [_fmDatabase executeUpdate:insertSql];
    
}


#pragma mark - 删除数据

- (BOOL)deleteObject:(id)obj {

    
    NSString *tableName = NSStringFromClass([obj class]);
    NSString *ID = [obj valueForKey:@"ID"];
    NSString *deletSql = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE ID = %@", tableName, ID];

    return [_fmDatabase executeUpdate:deletSql];
}


- (NSArray *)selectAllObjectFromClass:(Class)tableClass {

    NSString *tableName = NSStringFromClass(tableClass);
    
    NSString *selectAllSql = [NSString stringWithFormat:@"SELECT *FROM t_%@", tableName];
    //返回结果集合
    FMResultSet *ret = [_fmDatabase executeQuery:selectAllSql];

    //遍历结果集-获取所有属性的名称
    NSArray *propertyArray = [self getAllPropertiesFromClass:tableClass];
    
    //创建一个数组 存储所有数据
    NSMutableArray *objectArray = [NSMutableArray array];
    while ([ret next]) {
        //根据class信息创建对象
        id obj = [[tableClass alloc] init];
        
        //遍历所有属性
        for (NSString *prop in propertyArray) {
            
            //从结果集中取出数据并为对象赋值
            id columnValue = [ret objectForColumnName:prop];
            //通过KVC方式为对象赋值
            [obj setValue:columnValue forKey:prop];
            
        }
        //取出ID值
        NSInteger ID = [ret intForColumn:@"ID"];
        
        [obj setValue:[NSNumber numberWithInteger:ID] forKey:@"ID"];
        
        [objectArray addObject:obj];
        
    }
    return [objectArray copy];

}


- (BOOL) isExistWithObject:(id)obj {
    
    NSString *tableName = NSStringFromClass([obj class]);
    
    NSNumber *ID = [obj valueForKey:@"ID"];
    
    NSString *selectSql = [NSString stringWithFormat:@"SELEC COUNT(*) FROM t_%@ WHERE ID=%@", tableName, ID];
    
    //执行
    FMResultSet *set = [_fmDatabase executeQuery:selectSql];
    
    if ([set next]) {
        //判断取出的数据大小
        int columnNum = [set intForColumnIndex:0];
        
        if (columnNum == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}


@end
