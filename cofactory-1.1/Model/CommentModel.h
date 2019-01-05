//
//  CommentModel.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, strong) NSString *authour;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) NSInteger uid;
- (instancetype)initModelWith:(NSDictionary *)dictionary;
+(instancetype)getModelWith:(NSDictionary *)dictionary;


@end
