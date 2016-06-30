//
//  DBManager.h
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject


@property (nonatomic, strong, readwrite) FMDatabase *dataBase;

+ (DBManager *)shareManager;

// 关闭数据库
- (void)close;






@end
