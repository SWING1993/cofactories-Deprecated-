//
//  SearchCell.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *factoryName;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *authStatus;
@property (weak, nonatomic) IBOutlet UILabel *factoryFree;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@end
