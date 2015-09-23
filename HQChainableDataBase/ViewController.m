//
//  ViewController.m
//  HQChainableDataBase
//
//  Created by qianhongqiang on 15/9/22.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase+HQChainableDB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FMDatabase *db = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];
    
    if ([db open]) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
    }else{
        NSLog(@"fail to open");
    }
    
    BOOL ok = db.insert(@"t_student").property(@"name",@"age",nil).values(@"pll",@99,nil).excuteUp;
    
    NSLog(@"%d",ok);
    
    BOOL OKDelete = db.deleteFrom(@"t_student").where(@"name",nil).equals(@"qhq",nil).excuteUp;
    NSLog(@"%d",OKDelete);
    
    FMResultSet *set = db.select(@"*").from(@"t_student").excute;
    
    while ([set next]) {
        int ID = [set intForColumn:@"id"];
        NSString *name = [set stringForColumn:@"name"];
        int age = [set intForColumn:@"age"];
        NSLog(@"%d %@ %d", ID, name, age);
    }
}

@end
