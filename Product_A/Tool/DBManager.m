//
//  DBManager.m
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import "DBManager.h"

static DBManager *manager = nil;

@interface DBManager(){
    NSString *_path; // 数据库的路径
}

@end

@implementation DBManager


+(DBManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}


// 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化数据库
        [self initDataBaseWith:kMySqliteName];
    }
    return self;
}

// 初始化数据库 --> FMDB
- (void)initDataBaseWith:(NSString *)name{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(9, 1, 1) firstObject];
    NSString *filePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@", name]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exit = [fm fileExistsAtPath:filePath];
    if (exit) {
        NSLog(@"%@数据库已经存在", name);
    }else{
        NSLog(@"数据库%@不存在", name);
    }
    _path = filePath;
    [self connect];
}

// 连接数据库
- (void)connect{
    if (!_dataBase){
        _dataBase = [FMDatabase databaseWithPath:_path];
    }
    if (![_dataBase open]) {
        NSLog(@"数据打开失败");
    }
    else {
        NSLog(@"数据库打开成功");
    }
}

- (void)close{
    [_dataBase close];
    manager = nil;
}

-(void)dealloc{
    [self close];
}


@end
















