//
//  PopularMesageTableViewCell.h
//  cofactory-1.1
//
//  Created by gt on 15/9/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class InformationModel;
@interface PopularMesageTableViewCell : UITableViewCell

@property (nonatomic, strong)InformationModel *information;


- (void)getDataWithDictionary:(NSDictionary *)dictionary;
@end
