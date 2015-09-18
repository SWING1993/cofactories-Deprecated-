//
//  InformationModel.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "InformationModel.h"

@implementation InformationModel


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@", self.title, self.comment, self.interest];
}

@end
