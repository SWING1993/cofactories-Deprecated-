//
//  MaterialBidManagerModel.h
//  cofactory-1.1
//
//  Created by gt on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaterialBidManagerModel : NSObject

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *goodsSource;
@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger price;


- (instancetype)initModelWith:(NSDictionary *)dictionary;
+(instancetype)getModelWith:(NSDictionary *)dictionary;

@end
