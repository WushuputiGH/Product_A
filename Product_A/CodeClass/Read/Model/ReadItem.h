//
//  ReadItem.h
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadItem : NSObject

@property (nonatomic, strong, readwrite) NSString *coverimg;
@property (nonatomic, strong, readwrite) NSString *enname;
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *type;

@end
