//
//  ReadModel.h
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadItem.h"

@interface ReadModel : NSObject

// 定义属性, 用于存储轮播图的网址
@property (nonatomic, strong, readwrite) NSMutableArray *carouselArray;

// 定义属性, 用于储存轮播图对应的ID
@property (nonatomic, strong, readwrite) NSMutableArray *carouselIDArray;

// 定义属性, 用于存储collction里面的数据
@property (nonatomic, strong, readwrite) NSMutableArray *readItemArray;

// 定义属性, 用于判断返回值(1成功, 0失败)
@property (nonatomic, strong, readwrite) NSNumber *result;

- (void)readModelConfigureWithJsonDict:(NSDictionary *)jsonDict;

@end
