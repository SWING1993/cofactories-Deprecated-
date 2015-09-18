//
//  CommentViewController.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, assign) int oid;

@end
