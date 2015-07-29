//
//  CofactoryPhotoViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/29.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "CofactoryPhotoViewController.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"

@interface CofactoryPhotoViewController ()

@end

@implementation CofactoryPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 200;

    self.title = @"公司图片";
    NSLog(@"%@",self.employee);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if ([self.employee count]<5) {
            return 100;
        }
        if ([self.employee count]<9) {
            return 200;

        }if ([self.employee count]<11) {
            return 300;
        }
    }if (indexPath.section==1) {
        if ([self.environment count]<5) {
            return 100;
        }
        if ([self.environment count]<9) {
            return 200;

        }if ([self.environment count]<11) {
            return 300;
        }



    }if (indexPath.section==2) {
        if ([self.equipment count]<5) {
            return 100;
        }
        if ([self.equipment count]<9) {
            return 200;

        }if ([self.equipment count]<11) {
            return 300;
        }

    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    UILabel*titleLB=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    titleLB.textAlignment=NSTextAlignmentCenter;
    if (section==0) {
        titleLB.text=@"公司员工相册";

    }
    if (section==1) {
        titleLB.text=@"公司环境相册";

    }
    if (section==2) {
        titleLB.text=@"公司设备相册";

    }
    [view addSubview:titleLB];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.01f)];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }


    if (indexPath.section==0) {
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];

        NSMutableArray *temp = [NSMutableArray array];

        [self.employee enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            NSString*urlString =[NSString stringWithFormat:@"http://cdn.cofactories.com%@",self.employee[idx]];
            item.thumbnail_pic = urlString;
            [temp addObject:item];
        }];

        photoGroup.photoItemArray = [temp copy];
        [cell.contentView addSubview:photoGroup];

    }
    if (indexPath.section==1) {
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];

        NSMutableArray *temp = [NSMutableArray array];

        [self.environment enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            NSString*urlString =[NSString stringWithFormat:@"http://cdn.cofactories.com%@",self.environment[idx]];
            item.thumbnail_pic = urlString;
            [temp addObject:item];
        }];

        photoGroup.photoItemArray = [temp copy];
        [cell.contentView addSubview:photoGroup];

    }
    if (indexPath.section==2) {
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];

        NSMutableArray *temp = [NSMutableArray array];

        [self.equipment enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            NSString*urlString =[NSString stringWithFormat:@"http://cdn.cofactories.com%@",self.equipment[idx]];
            item.thumbnail_pic = urlString;
            [temp addObject:item];
        }];

        photoGroup.photoItemArray = [temp copy];
        [cell.contentView addSubview:photoGroup];

    }

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
