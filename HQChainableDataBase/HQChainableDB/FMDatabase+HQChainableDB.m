
#import "FMDatabase+HQChainableDB.h"
#import <objc/runtime.h>

static char *excuteSQLKey = "excuteSQLKey";

@interface FMDatabase (HQChainableDB_private)

@property (nonatomic, copy) NSMutableString *excuteSQL;

@end

@implementation FMDatabase (HQChainableDB_private)

-(void)setExcuteSQL:(NSMutableString *)excuteSQL {
    objc_setAssociatedObject(self, excuteSQLKey, excuteSQL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableString *)excuteSQL {
    return objc_getAssociatedObject(self, excuteSQLKey);
}

@end

@implementation FMDatabase (HQChainableDB)
#pragma mark - select
-(HQSelect)select {
    HQSelect select = HQSelect(key){
        self.excuteSQL = [NSMutableString stringWithFormat:@"SELECT %@ ",key];
        
        return self;
    };
    return select;
}

-(HQFrom)from {
    HQFrom from = HQFrom(tableName){
        [self.excuteSQL appendFormat:@"FROM %@ ",tableName];
        
        return self;
    };
    return from;
}

-(HQWhere)where {
    HQWhere where = HQWhere(value,...){
        [self.excuteSQL appendFormat:@"WHERE "];
        
        NSMutableArray *argsArray = [[NSMutableArray alloc] init];
        va_list params;
        va_start(params,value);
        id arg;
        if (value) {
            id prev = value;
            [argsArray addObject:prev];
            while( (arg = va_arg(params,id)) )
            {
                [argsArray addObject:arg];
            }
            va_end(params);
        }
        
        [argsArray enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
            [self.excuteSQL appendFormat:@"%@ = ",key];
            if (idx != (argsArray.count - 1)) {
                [self.excuteSQL appendString:@","];
            }
        }];
        
        return self;
    };
    return where;
}

-(HQGroup)group {
    HQGroup group = HQGroup(key){
        return self;
    };
    return group;
}

#pragma mark - update
-(HQUpdate)update {
    HQUpdate update = HQUpdate(key){
        self.excuteSQL = [NSMutableString stringWithFormat:@"UPDATE %@ ",key];
        return self;
    };
    return update;
}

#pragma mark - insert
-(HQInsert)insert {
    HQInsert insert = HQInsert(key){
        self.excuteSQL = [NSMutableString stringWithFormat:@"INSERT INTO %@ ",key];
        return self;
    };
    return insert;
}

-(HQProperty)property {
    HQProperty property = HQProperty(value,...){
        
        NSMutableArray *argsArray = [[NSMutableArray alloc] init];
        va_list params;
        va_start(params,value);
        id arg;
        if (value) {
            id prev = value;
            [argsArray addObject:prev];
            while( (arg = va_arg(params,id)) )
            {
                if ( [arg isKindOfClass:[NSString class]]){
                    [argsArray addObject:arg];
                }
            }
            va_end(params);
        }
        [argsArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                [self.excuteSQL appendString:@"("];
            }
            [self.excuteSQL appendFormat:@"%@",key];
            if (idx == (argsArray.count - 1)) {
                [self.excuteSQL appendString:@") "];
            }else{
                [self.excuteSQL appendString:@", "];
            }
        }];
        
        return self;
    };
    return property;
}

-(HQValue)values {
    HQValue values = HQValue(key, ...){
        NSMutableArray *argsArray = [[NSMutableArray alloc] init];
        va_list params;
        va_start(params,key);
        id arg;
        if (key) {
            id prev = key;
            [argsArray addObject:prev];
            while( (arg = va_arg(params,id)) )
            {
                [argsArray addObject:arg];
            }
            va_end(params);
        }
        [argsArray enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                [self.excuteSQL appendString:@"VALUES ("];
            }
            if ([key isKindOfClass:[NSString class]]) {
                [self.excuteSQL appendString:@"'"];
            }
            [self.excuteSQL appendFormat:@"%@",key];
            if ([key isKindOfClass:[NSString class]]) {
                [self.excuteSQL appendString:@"'"];
            }
            if (idx == (argsArray.count - 1)) {
                [self.excuteSQL appendString:@");"];
            }else{
                [self.excuteSQL appendString:@", "];
            }

        }];
        return self;
    };
    return values;
}

#pragma mark - delete
-(HQDeleteFrom)deleteFrom {
    HQDeleteFrom deleteFrom = HQUpdate(tableName){
        self.excuteSQL = [NSMutableString stringWithFormat:@"DELETE FROM %@ ",tableName];
        return self;
    };
    return deleteFrom;
}

-(HQEquals)equals {
    HQEquals equals = HQEquals(value, ...) {
        NSMutableArray *argsArray = [NSMutableArray array];
        va_list params;
        va_start(params,value);
        id arg;
        if (value) {
            id prev = value;
            [argsArray addObject:prev];
            while( (arg = va_arg(params,id)) )
            {
                [argsArray addObject:arg];
            }
            va_end(params);
        }
        
        NSString *searchText = [self.excuteSQL copy];
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"=" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSMutableArray *locationArray = [NSMutableArray array];
        
        [regex enumerateMatchesInString:searchText options:0 range:NSMakeRange(0, searchText.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            [locationArray addObject:result];
        }];
        
        [locationArray enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
            id col = [argsArray objectAtIndex:idx];
            if ([col isKindOfClass:[NSString class]]) {
                [self.excuteSQL replaceCharactersInRange:result.range withString:[NSString stringWithFormat:@"= '%@'",[argsArray objectAtIndex:idx]]];
            }else {
                [self.excuteSQL replaceCharactersInRange:result.range withString:[NSString stringWithFormat:@"= %@",[argsArray objectAtIndex:idx]]];
            }
        }];

        return self;
    };
    return equals;
}

-(id)excute {
   return [self executeQuery:self.excuteSQL];
}

-(BOOL)excuteUp {
    NSLog(@"%@",self.excuteSQL);
    return [self executeUpdate:self.excuteSQL];
}

@end
