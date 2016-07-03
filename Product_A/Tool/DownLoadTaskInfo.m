//
//  DownLoadTaskInfo.m
//  Product_A
//
//  Created by lanou on 16/7/2.
//  Copyright © 2016年 H. All rights reserved.
//

#import "DownLoadTaskInfo.h"


@implementation DownLoadTaskInfo

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.task forKey:@"task"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.musicInfo forKey:@"musicInfo"];
    [aCoder encodeObject:@(self.progress) forKey:@"progress"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.task = [aDecoder decodeObjectForKey:@"task"];
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.musicInfo = [aDecoder decodeObjectForKey:@"musicInfo"];
        NSNumber *progress = [aDecoder decodeObjectForKey:@"progress"];
        self.progress = progress.integerValue;
    }
    return self;
}

@end
