//
//  StatusViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "StatusViewController.h"
#define CellIdentifier @"Cell"

@interface StatusViewController ()

@property (nonatomic,copy)NSArray * cellTitleArr;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设置状态";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    if (self.factoryType==1) {
        self.cellTitleArr=@[@"公司空闲开关",@"设置空闲时间",@"有无自备货车"];
    }else{
        self.cellTitleArr=@[@"公司空闲开关",@"设置空闲时间"];
    }
    self.tableView.scrollEnabled=NO;
    self.tableView.rowHeight=44.0f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellTitleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenW-70.0f, 7.0f, 60.0f, 28.0f)];
        switchView.on = YES;//设置初始为ON的一边
        switchView.tag=indexPath.section;
        switchView.tag=indexPath.section;
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchView];

        cell.textLabel.font=[UIFont systemFontOfSize:16.0f];
        cell.textLabel.text = self.cellTitleArr[indexPath.section];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (void)switchAction:(UISwitch *)sender {
    UISwitch* switchBtn = (UISwitch *)sender;
    switch (switchBtn.tag) {
        case 0:{
            NSLog(@"公司空闲开关");
        }
            break;
        case 1:{
            NSLog(@"设置空闲时间");
        }
            break;
        case 2:{
            NSLog(@"自备货车");

        }
            break;
            
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
