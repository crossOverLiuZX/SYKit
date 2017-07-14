//
//  SYDatabaseManager.h
//
//
//  Created by liuZX on 16/5/19.
//  Copyright © 2016年 刘卓鑫. All rights reserved.
//
/**
 *  数据库管理类 做成单例类
 */
#import <Foundation/Foundation.h>


@interface SYDatabaseManager : NSObject

+(instancetype) defaultManager;

//创建数据库表
- (BOOL) createTableFromClass:(Class) tableClass;

//添加数据
- (BOOL) insertObject:(id) obj;

//删除数据
- (BOOL) deleteObject:(id) obj;

//查询所有数据
- (NSArray *) selectAllObjectFromClass:(Class) tableClass;

//判断某一数据在数据库表中是否存在
- (BOOL) isExistWithObject:(id) obj;




@end
