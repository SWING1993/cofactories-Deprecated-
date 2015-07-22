//
//  PushEditViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "PushEditViewController.h"
#import "PushHelperItemModel.h"
#import "PushEditCell.h"


#define CellIdentifier @"Cell"

@interface PushEditViewController ()
@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) NSMutableArray *cellArray;

@end

@implementation PushEditViewController{

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.listData = @[@"距离", @"规模", @"业务类型（选填）"];

    self.cellArray = [[NSMutableArray alloc] initWithCapacity:3];

    for (int i = 0; i < 3; ++i) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PushEditCell" owner:nil options:nil];
        PushEditCell *cell = [nib objectAtIndex:0];
        cell.name.text = self.listData[i];
        cell.cellPickList = self.pickList[i];
        cell.textField.text = cell.cellPickList[0];
        [self.cellArray insertObject:cell atIndex:i];
    }


//    self.tableView.scrollEnabled=NO;
    self.tableView.rowHeight=44;

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked:)];
    self.navigationItem.rightBarButtonItem = saveButton;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellArray[indexPath.section];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}



- (void)saveButtonClicked:(id)sender {
    PushHelperItemModel *model = [[PushHelperItemModel alloc] initWithType:self.itemType andDistance:((PushEditCell *)self.cellArray[0]).textField.text andSize:((PushEditCell *)self.cellArray[1]).textField.text andBusinessType:((PushEditCell *)self.cellArray[2]).textField.text];
    [self.listArray insertObject:model atIndex:self.listArray.count];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
