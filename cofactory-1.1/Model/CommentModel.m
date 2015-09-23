//
//  CommentModel.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (instancetype)initModelWith:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.authour = dictionary[@"comment_author"];
        self.time = dictionary[@"comment_date"];
        self.comment = dictionary[@"comment_content"];
    }
    return self;
}
+(instancetype)getModelWith:(NSDictionary *)dictionary {
    return [[self alloc] initModelWith:dictionary];
}




@end
