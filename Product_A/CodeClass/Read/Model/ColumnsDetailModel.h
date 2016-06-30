//
//  ColumnsDetailModel.h
//  Product_A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColumnsDetailItem: NSObject

@property (nonatomic, strong, readwrite) NSString *content;
@property (nonatomic, strong, readwrite) NSString *coverimg;
@property (nonatomic, strong, readwrite) NSString *theId;
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *title;

@end



@interface ColumnsDetailModel : NSObject

@property (nonatomic, strong, readwrite) NSString *typeId;
@property (nonatomic, strong, readwrite) NSString *typeName;
@property (nonatomic, strong, readwrite) NSMutableArray <ColumnsDetailItem *> *columnsDetailItemArray;
@property (nonatomic, strong, readwrite) NSString *total;
@property (nonatomic, strong, readwrite) NSNumber *result;


- (void)columnsDetailModelConfigureWithJsonDic:(NSDictionary *)jsonDic;



@end
