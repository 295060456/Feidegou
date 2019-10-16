//
//  DBHelper.h
//  ZCYX_IOS
//
//  Created by PengShuai on 14-4-16.
//  Copyright (c) 2014年 pengshuai. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabasePool.h"
#import "FMDatabaseAdditions.h"
#import <AddressBook/AddressBook.h>

/**
 *  数据库版本信息表
 */
extern NSString * const DB_TABLE_NAME_VERSION;
/**
 *  广告列表
 */
extern NSString * const DB_TABLE_NAME_AD;
/**
 *  兑换分类列表(一级目录)
 */
extern NSString * const DB_TABLE_NAME_EXCHANGE_CLASS_FIRST;
/**
 *  兑换分类列表(二级目录)
 */
extern NSString * const DB_TABLE_NAME_EXCHANGE_CLASS_SECOND;
/**
 *  列表缓存数据表
 */
extern NSString * const DB_TABLE_NAME_LIST_CACHE;
/**
 *  列表缓存数据表
 */
extern NSString * const DB_TABLE_NAME_CALL_IMAGE_AD_CACHE;

@class FMDatabaseQueue;
@interface JJDBHelper : NSObject

@property (nonatomic,strong) FMDatabaseQueue *databaseQueue;

+(JJDBHelper*)sharedInstance;

-(BOOL)deleteTableName:(NSString*)tableName;


/**
 *  更新缓存数据(没有-添加缓存,有-更新缓存)
 *
 *  @param cacheId   缓存id
 *  @param cacheData 缓存数据
 */
-(void)updateCacheForId:(NSString*)cacheId
              cacheData:(NSData*)cacheData;

-(void)updateCacheForId:(NSString*)cacheId
         cacheDictionry:(NSDictionary *)dictionray;

-(void)updateCacheForId:(NSString*)cacheId
             cacheArray:(NSArray *)array;

-(id)convertData:(NSData*)data;
-(NSData*)queryCacheDataWithCacheId:(NSString*)cacheId;

@end















