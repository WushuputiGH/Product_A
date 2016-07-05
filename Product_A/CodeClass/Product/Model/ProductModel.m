//
//  ProductModel.m
//  Product_A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ProductModel.h"

static ProductModel *productShare = nil;

@implementation ProductModel


+(ProductModel *)productShare{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        productShare = [[ProductModel alloc] init];
    });
    return productShare;
}




@end
