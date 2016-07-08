//
//  RadioDownloadTable.h
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface RadioDownloadTable : NSObject

@property (nonatomic, strong, readwrite) FMDatabase *dataBase;

// 建表
- (void)creatTable;

// 取出
- (NSArray *)selectAll;

// 插入
- (void)insertIntoTabel:(NSArray *)Info;

// 删除
- (void)deleteWithUrl:(NSString *)musicUrl;






@end
