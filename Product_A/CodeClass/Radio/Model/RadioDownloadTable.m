//
//  RadioDownloadTable.m
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RadioDownloadTable.h"

@implementation RadioDownloadTable


- (instancetype)init{
    self = [super init];
    if (self) {
        _dataBase = [DBManager shareManager].dataBase;
    }
    return self;
}

- (void)creatTable{
    // 判断是否有表存在
    NSString *query = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'", kRadioDownloadTable];
    FMResultSet *set = [_dataBase executeQuery:query];
    [set next];
    int count = [set intForColumnIndex:0];
    BOOL exist = count;
    if (exist) {
        NSLog(@"%@表存在", kRadioDownloadTable);
    }else{
        // 建表
        NSString *update = [NSString stringWithFormat:@"create table %@(musicID  INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, title text, musicUrl text, musicImg text, musicPath text)", kRadioDownloadTable];
        BOOL result = [_dataBase executeUpdate:update];
        if (result) {
            NSLog(@"表%@创建成功", kRadioDownloadTable);
        }else{
            NSLog(@"表%@创建失败", kRadioDownloadTable);
        }
    }
}

- (void)insertIntoTabel:(NSArray *)Info{
    
    NSString *updata = [NSString stringWithFormat:@"INSERT INTO %@ (title, musicUrl, musicImg, musicPath) values(?, ?, ?, ?)", kRadioDownloadTable];
    BOOL result = [_dataBase executeUpdate:updata withArgumentsInArray:Info];
    if (result) {
        NSLog(@"成功插入");
       
    }else {
        NSLog(@"插入失败");
    }
}

// 查询所有的数据
- (NSArray *)selectAll{
    NSString *query = [NSString stringWithFormat:@"select *from %@", kRadioDownloadTable];
    FMResultSet *set = [_dataBase executeQuery:query];
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[set columnCount]];
    while ([set next]) {
        NSString *title = [set stringForColumn:@"title"];
        NSString *musicUrl = [set stringForColumn:@"musicUrl"];
        NSString *musicImg = [set stringForColumn:@"musicImg"];
        NSString *musicPath = [set stringForColumn:@"musicPath"];
        [mArray addObject:@[title, musicUrl, musicImg, musicPath]];
    }
    return mArray;
}

@end
