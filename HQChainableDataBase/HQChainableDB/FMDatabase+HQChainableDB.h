//  Created by qianhongqiang on 15/9/22.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//  tel:18968139188 QQ:395560761

#import "FMDatabase.h"
#import "HQChainableDBblocks.h"

@interface FMDatabase (HQChainableDB)

#pragma mark - select
-(HQSelect)select;
-(HQFrom)from;
-(HQWhere)where;

#pragma mark - update
-(HQUpdate)update;

#pragma mark - insert
-(HQInsert)insert;
-(HQProperty)property;
-(HQValue)values;

#pragma mark - delete
-(HQDeleteFrom)deleteFrom;
-(HQEquals)equals;

#pragma mark - groupBy
-(HQGroupBy)groupBy;

#pragma mark -excute
-(id)excute;
-(BOOL)excuteUp;

@end
