//
//  DBHelper.m
//
//  Created by PengShuai on 14-4-16.
//  Copyright (c) 2014年 pengshuai. All rights reserved.
//

#import "JJDBHelper.h"

CGFloat const DB_VERSION = 1.0;

NSString * const DB_TABLE_NAME_VERSION = @"DB_TABLE_NAME_VERSION";
NSString * const DB_TABLE_NAME_AD = @"DB_TABLE_NAME_AD";
NSString * const DB_TABLE_NAME_EXCHANGE_CLASS_FIRST = @"DB_TABLE_NAME_EXCHANGE_CLASS_FIRST";
NSString * const DB_TABLE_NAME_EXCHANGE_CLASS_SECOND = @"DB_TABLE_NAME_EXCHANGE_CLASS_SECOND";
NSString * const DB_TABLE_NAME_LIST_CACHE = @"DB_TABLE_NAME_LIST_CACHE";
NSString * const DB_TABLE_NAME_CALL_IMAGE_AD_CACHE = @"DB_TABLE_NAME_CALL_IMAGE_AD_CACHE";;

@interface JJDBHelper()

@end


@implementation JJDBHelper

static JJDBHelper *sharedManager;
+(JJDBHelper*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[JJDBHelper alloc] init];
    });return sharedManager;
}
//+(JJDBHelper*)sharedInstance{
//    
//    
//    static JJDBHelper *sharedManager;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        sharedManager = [[self alloc] init];
//        
//    });
//    return sharedManager;
//    
//}
-(void)updateCacheForId:(NSString*)cacheId
              cacheData:(NSData*)cacheData{

    @weakify(self)
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        @strongify(self)
        if ([db open]) {
            if([self isExistForCacheId:cacheId
                                    db:db]){
                [self updateCacheData:cacheData
                              cacheId:cacheId
                                   db:db];
            }else{
                [self insertCacheData:cacheData
                              cacheId:cacheId
                                   db:db];
            }
            [db close];
        }
    }];
}

-(void)updateCacheForId:(NSString*)cacheId
         cacheDictionry:(NSDictionary *)dictionray{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [self updateCacheForId:cacheId cacheData:jsonData];
}

-(void)updateCacheForId:(NSString*)cacheId cacheArray:(NSArray *)array{
    if ([array isKindOfClass:[NSArray class]]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        [self updateCacheForId:cacheId cacheData:jsonData];
    }
}
#pragma mark - private methods
-(id)convertData:(NSData*)data{
    if(!data){
        return nil;
    }
    NSError *error;
    id jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                  options:kNilOptions
                                                    error:&error];
    if (error) {
        return nil;
    }
    return jsonData;
}
/**
 *  插入缓存数据
 *
 *  @param cacheData data缓存数据
 *  @param cacheId   缓存id(与接口编号相同)
 *  @param db        FMDatabase
 */
-(void)insertCacheData:(NSData*)cacheData
               cacheId:(NSString*)cacheId
                    db:(FMDatabase*)db{
    
    NSString *sql = StringFormat(@"insert into %@ (cacheId,cacheData) values (?,?)",DB_TABLE_NAME_LIST_CACHE);
    if ([db executeUpdate:sql withArgumentsInArray:@[cacheId,cacheData]]) {
        D_NSLog(@"缓存添加成功!");
    }
}
/**
 *  判断缓存是否存在
 *
 *  @param cacheId   缓存id
 *  @param db        FMDatabase
 *
 *  @return YES:存在,NO:不存在
 */
-(BOOL)isExistForCacheId:(NSString*)cacheId
                      db:(FMDatabase*)db{
    
    BOOL isExist = NO;
    NSString *sql = StringFormat(@"select * from %@ where cacheId = ?",DB_TABLE_NAME_LIST_CACHE);
    FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:@[cacheId]];
    if([resultSet next]) {
        isExist = YES;
    }
    [resultSet close];
    return isExist;
}
/**
 *  更新缓存数据
 *
 *  @param cacheData data缓存数据
 *  @param cacheId   缓存id
 *  @param db        FMDatabase
 */
-(void)updateCacheData:(NSData*)cacheData
               cacheId:(NSString*)cacheId
                    db:(FMDatabase*)db{
    
    NSString *sql = StringFormat(@"update %@ set cacheData=? where cacheId=?",DB_TABLE_NAME_LIST_CACHE);
    if ([db executeUpdate:sql withArgumentsInArray:@[cacheData,cacheId]]) {
        D_NSLog(@"更新缓存成功!");
    }
}

-(NSData*)queryCacheDataWithCacheId:(NSString*)cacheId{
    
    __block NSData *data;
    NSString *sql = StringFormat(@"SELECT cacheData from %@ where cacheId = ?",DB_TABLE_NAME_LIST_CACHE);
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:@[cacheId]];
            if([resultSet next]) {
                data = [resultSet dataForColumn:@"cacheData"];
            }
            [resultSet close];
            [db close];
        }
    }];return data;
}

-(id)init{
    if([super init]){
        @weakify(self)
        /**检查是否存在数据库文件**/
        if (![self isExistDB]) {//不存在创建数据库表结构
            D_NSLog(@"数据库不存在－创建数据库表结构");
            self.databaseQueue =[FMDatabaseQueue databaseQueueWithPath:[self getFilePath]];
            [self.databaseQueue inDatabase:^(FMDatabase *db) {
                @strongify(self)
                if ([db open]) {
                    [self createTables:db];
                    [db close];
                }
            }];
        }else {//存在,对比数据库版本号,判断是否需要进行数据升级
            CGFloat version = [self fetchDBVersion];
            if (version > DB_VERSION) {
                D_NSLog(@"数据库存在-进行数据库升级...");
            }else{
                D_NSLog(@"数据库存在-不需要进行升级...");
            }
            self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self getFilePath]];
        }
    }
    D_NSLog(@"数据库地址:%@",[self getFilePath]);
    return self;
}

-(NSString*)getFilePath{
    //获取Document文件夹下的数据库文件,没有则创建
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES)
                           objectAtIndex:0];
    NSString *dbFilePath = [directory stringByAppendingPathComponent:@"SobForIOS.db"];
    return dbFilePath;
}

-(BOOL) isExistDB{
    NSFileManager* fm = [[NSFileManager alloc] init];
    return [fm fileExistsAtPath:[self getFilePath]];
}

#pragma mark - 删除表信息
-(BOOL)deleteTableName:(NSString*)tableName{
    
    __block BOOL result = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = StringFormat(@"delete from %@",tableName);
            result = [db executeUpdate:sql];
            D_NSLog(@"删除 [%@] 信息%@",tableName,result?@"成功":@"失败");
            [db close];
        }
    }];return result;
}

-(void)createTables:(FMDatabase*)db{

    //TODO:创建表
    [self createVersionTable:db];
    [self createADTable:db];
    [self createExchangeClassFirstTable:db];
    [self createExchangeClassSecondTable:db];
    [self createListCacheTable:db];
    [self createCallImageADTable:db];
}

#pragma mark - 数据库版本信息
//数据版本信息表
-(void)createVersionTable:(FMDatabase *)db{
    
    NSString *sql = StringFormat(@"create table if not exists %@(\
                                 vid integer primary key autoincrement,version float)",DB_TABLE_NAME_VERSION);
    
    BOOL isSuccess = [db executeUpdate:sql];
    
    if(isSuccess){
        D_NSLog(@"创建成功----数据库版本表");
        [self insertVersion:db];//插入版本信息
    }else{
        D_NSLog(@"创建失败----数据库版本表");
    }
}
/**
 *  插入版本号
 */
-(void)insertVersion:(FMDatabase*)db{
    
    NSString *sql = StringFormat(@"insert into %@ (version) values (?)",DB_TABLE_NAME_VERSION);
    BOOL result = [db executeUpdate:sql withArgumentsInArray:@[@(DB_VERSION)]];
    if (result) {
        D_NSLog(@"插入数据版本号-成功");
    }else{
        D_NSLog(@"插入数据版本号-失败");
    }
}
/**
 *  读取数据库版本号
 */
-(CGFloat)fetchDBVersion{

    __block CGFloat version = 0;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = StringFormat(@"select * from %@ order by version desc limit 1",DB_TABLE_NAME_VERSION);
            FMResultSet *resultSet = [db executeQuery:sql];
            if([resultSet next]) {
                version = [resultSet doubleForColumn:@"version"];
            }
            [resultSet close];
            [db close];
        }
    }];return version;
}

#pragma mark - 创建广告信息表
/**
 * 1.广告信息表
 */
-(void)createADTable:(FMDatabase *)db{
    
    NSString *sql = StringFormat(@"create table if not exists %@(\
                                 mindex integer primary key autoincrement,\
                                 adid varchar(20),\
                                 ctime varchar(20),\
                                 downurl text,\
                                 endtime varchar(20),\
                                 ID varchar(20),\
                                 isclick varchar(10),\
                                 jigsaw varchar(5),\
                                 largefile text,\
                                 largepic text,\
                                 message text,\
                                 privoity varchar(20),\
                                 signin varchar(20),\
                                 slfile text,\
                                 slpic text,\
                                 smallfile text,\
                                 smallpic text,\
                                 starttime varchar(20),\
                                 tel varchar(20),\
                                 tid varchar(20),\
                                 title text,\
                                 tourl text,\
                                 updateTime DATETIME)",DB_TABLE_NAME_AD);
    
    
    BOOL isSuccess = [db executeUpdate:sql];
    
    if(isSuccess){
        D_NSLog(@"创建成功----广告信息表");
    }else{
        D_NSLog(@"创建失败----广告信息表");
    }
}
#pragma mark - 兑换分类列表(一级目录)
/**
 * 2.兑换分类列表(一级目录)
 */
-(void)createExchangeClassFirstTable:(FMDatabase *)db{
    
    NSString *sql = StringFormat(@"create table if not exists %@(\
                                 fid integer primary key autoincrement,\
                                 ICON text,\
                                 ID varchar(20),\
                                 ISGROOMP varchar(20),\
                                 NAME varchar(20))",DB_TABLE_NAME_EXCHANGE_CLASS_FIRST);
    BOOL isSuccess = [db executeUpdate:sql];
    if(isSuccess){
        D_NSLog(@"创建成功----兑换分类信息表(一级目录)");
    }else{
        D_NSLog(@"创建失败----兑换分类信息表(一级目录)");
    }
}
#pragma mark - 兑换分类列表(二级目录)
/**
 * 3.兑换分类列表(二级目录)
 */
-(void)createExchangeClassSecondTable:(FMDatabase *)db{
    NSString *sql = StringFormat(@"create table if not exists %@(\
                                 fid integer primary key autoincrement,\
                                 FIRSTID varchar(20),\
                                 ID varchar(20),\
                                 NAME varchar(20))",DB_TABLE_NAME_EXCHANGE_CLASS_SECOND);
    
    BOOL isSuccess = [db executeUpdate:sql];
    if(isSuccess){
        D_NSLog(@"创建成功----兑换分类信息表(二级目录)");
    }else{
        D_NSLog(@"创建失败----兑换分类信息表(二级目录)");
    }
}
#pragma mark - 数据缓存表
-(void)createListCacheTable:(FMDatabase*)db{
    NSString *sql = StringFormat(@"create table if not exists %@(\
                                 cid integer primary key autoincrement,\
                                 cacheId varchar(10),\
                                 cacheData blob)",DB_TABLE_NAME_LIST_CACHE);
    BOOL isSuccess = [db executeUpdate:sql];
    if(isSuccess){
        D_NSLog(@"创建成功----数据缓存表");
    }else{
        D_NSLog(@"创建失败----数据缓存表");
    }
}
#pragma mark - 电话广告列表(弹窗广告)
-(void)createCallImageADTable:(FMDatabase*)db{
    NSString *sql = StringFormat(@"create table if not exists %@(\
                                 cid integer primary key autoincrement,\
                                 imageUrl text,\
                                 imageData blob)",DB_TABLE_NAME_CALL_IMAGE_AD_CACHE);
    
    BOOL isSuccess = [db executeUpdate:sql];
    if(isSuccess){
        D_NSLog(@"创建成功----电话广告列表(弹窗广告)");
    }else{
        D_NSLog(@"创建失败----电话广告列表(弹窗广告)");
    }
}

@end










