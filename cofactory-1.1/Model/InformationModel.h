//
//  InformationModel.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *interest;
@property (nonatomic, assign) int oid;
@property (nonatomic, strong) NSString *urlString;


@end