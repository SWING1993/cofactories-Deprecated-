//
//  FavoriteViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "FavoriteViewController.h"

@interface FavoriteViewController ()

@property (nonatomic,retain)NSMutableArray * cellArray;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cellArray = [[NSMutableArray alloc]initWithCapacity:0];


    self.title=@"我的收藏";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    [HttpClient listPartnerWithBlock:^(NSDictionary *responseDictionary) {
        self.cellArray=responseDictionary[@"responseArray"];
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    UserModel*model=self.cellArray[indexPath.row];
    cell.textLabel.text=model.factoryAddress;
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
