//
//  InformationModel.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "InformationModel.h"

@implementation InformationModel

- (instancetype)initModelWith:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.title = dictionary[@"post_title"];
        self.comment = dictionary[@"comment_count"];
        self.interest = dictionary[@"like"];
        self.oid = [dictionary[@"ID"] intValue];
        self.urlString = dictionary[@"guid"];
        self.imageString = dictionary[@"thumbnail"];
    }
    return self;
}



+(instancetype)getModelWith:(NSDictionary *)dictionary {
    return [[self alloc]initModelWith:dictionary];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@", self.title, self.comment, self.interest, self.urlString, self.imageString];
}



@end
