//  Created by qianhongqiang on 15/9/22.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//  tel:18968139188 QQ:395560761

#import "FMDatabase.h"
#import <Foundation/Foundation.h>

#ifndef HQChainableDataBase_HQChainableDBblocks_h
#define HQChainableDataBase_HQChainableDBblocks_h

/***************************select************************************/
typedef FMDatabase *(^HQSelect)(NSString *key);
#define HQSelect(key) ^FMDatabase* (NSString *key)

typedef FMDatabase *(^HQFrom)(NSString *tableName);
#define HQFrom(tableName) ^FMDatabase* (NSString *tableName)

typedef FMDatabase *(^HQWhere)(NSString *value,...);
#define HQWhere(value,...) ^FMDatabase* (NSString *value,...)

/***************************update************************************/
typedef FMDatabase *(^HQUpdate)(NSString *key);
#define HQUpdate(key) ^FMDatabase* (NSString *key)

/***************************insert************************************/
typedef FMDatabase *(^HQInsert)(NSString *key);
#define HQInsert(key) ^FMDatabase* (NSString *key)

typedef FMDatabase *(^HQValue)(NSString *key,...);
#define HQValue(key,...) ^FMDatabase* (NSString *key,...)

typedef FMDatabase *(^HQProperty)(NSString *value,...);
#define HQProperty(value,...) ^FMDatabase* (NSString *value,...)

/***************************delete************************************/
typedef FMDatabase *(^HQDeleteFrom)(NSString *tableName);
#define HQDeleteFrom(tableName) ^FMDatabase* (NSString *tableName)

typedef FMDatabase *(^HQEquals)(NSString *value,...);
#define HQEquals(value,...) ^FMDatabase* (NSString *value,...)

/***************************delete************************************/
typedef FMDatabase *(^HQGroupBy)(NSString *key);
#define HQGroupBy(key) ^FMDatabase* (NSString *key)

#endif
