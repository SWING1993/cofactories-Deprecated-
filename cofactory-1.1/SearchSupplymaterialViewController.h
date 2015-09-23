//
//  SearchSupplymaterialViewController.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSupplymaterialViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIView *tableViewHeadView;
@property (nonatomic, strong) SupplyHistory *history;


@property (nonatomic, strong) NSString *oid;//id
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableArray *photoArray;
@end
