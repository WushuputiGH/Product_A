//
//  ColumnsDetailModel.m
//  Product_A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ColumnsDetailModel.h"


@implementation ColumnsDetailItem

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _theId = value;
    }
}


@end

@implementation ColumnsDetailModel


- (instancetype)init{
    self= [super init];
    if (self) {
        
    }
    return self;
}

- (void)columnsDetailModelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    self.columnsDetailItemArray = [NSMutableArray array];
    NSDictionary *dataDic = jsonDic[@"data"];
    NSDictionary *columnsInfoDic = dataDic[@"columnsInfo"];
    self.typeId = columnsInfoDic[@"typeid"];
    self.typeName = columnsInfoDic[@"typename"];
    NSArray *listArray = dataDic[@"list"];
    for (NSDictionary *listDict in listArray) {
        ColumnsDetailItem *columnsDetailItem = [[ColumnsDetailItem alloc] init];
        [columnsDetailItem setValuesForKeysWithDictionary:listDict];
        [self.columnsDetailItemArray addObject:columnsDetailItem];
    }
    self.total = dataDic[@"total"];
    self.result = jsonDic[@"result"];
}


@end
