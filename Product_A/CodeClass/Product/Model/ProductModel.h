//
//  ProductModel.h
//  Product_A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, strong, readwrite) NSDictionary *productInfo;

+ (ProductModel *)productShare;

@end
