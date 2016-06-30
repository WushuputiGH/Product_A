//
//  ReadModel.m
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ReadModel.h"

@implementation ReadModel


- (instancetype)init{
    self = [super init];
    if (self) {
        self.readItemArray = [NSMutableArray array];
        self.carouselArray = [NSMutableArray array];
        self.carouselIDArray = [NSMutableArray array];
    }
    return self;
}

- (void)readModelConfigureWithJsonDict:(NSDictionary *)jsonDict{
    self.result = jsonDict[@"result"];
    
    NSDictionary *dataDic = jsonDict[@"data"];
    
    NSArray *carouselArray = dataDic[@"carousel"];
    for (NSDictionary *carousel in carouselArray) {
        NSString *string = carousel[@"img"];
        NSString *theId = [[carousel[@"url"] componentsSeparatedByString:@"/"] lastObject];
        [self.carouselArray addObject:string];
        [self.carouselIDArray addObject:theId];
    }
    
    NSArray *listArray = dataDic[@"list"];
    for (NSDictionary *list in listArray) {
        ReadItem *readItem = [[ReadItem alloc] init];
        [readItem setValuesForKeysWithDictionary:list];
        [self.readItemArray addObject:readItem];
    }
}


@end
