//
//  PushHelperViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/14.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "ModelsHeader.h"
#import "Tools.h"
#import "PushHelperViewController.h"
#import "PushEditViewController.h"

//#define ClouthesCellIdentifier @"ClouthesCell"
//#define OtherCellIdentifier @"OtherCell"
#define cellHeight 150

//#define CellIdentifier @"CellIdentifier"

@interface PushHelperViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{


}

@property (nonatomic, strong) NSMutableArray *listArray;

//- (void)addItemClicked:(id)sender;
//- (void)deleteButtonClicked:(id)sender;
//- (void)saveButtonClicked:(id)sender;

@end

@implementation PushHelperViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.   00.00
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"推送助手";
    self.listArray = [[NSMutableArray alloc] initWithCapacity:0];

    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.rowHeight=cellHeight;

    UIView*tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenW, 0, 30)];
    tableHeaderView.backgroundColor=[UIColor whiteColor];
    UIButton*addOrderBtn=[UIButton buttonWithType:UIButtonTypeContactAdd];
    addOrderBtn.frame=CGRectMake((kScreenW-120)/2, 0, 120, 30);
    addOrderBtn.tintColor=[UIColor redColor];
    addOrderBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [addOrderBtn setTitle:@"添加订单" forState:UIControlStateNormal];
    [addOrderBtn addTarget:self action:@selector(addOrderClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:addOrderBtn];
    self.tableView.tableHeaderView = tableHeaderView;


    [HttpClient getPushSettingWithBlock:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        NSMutableArray*responseArray=[NSMutableArray arrayWithArray:dictionary[@"responseArray"]];
        NSLog(@"responseArray=%@",responseArray);
        if (responseArray.count != 0 && [responseArray[0] isKindOfClass:[NSError class]]) {
            // 报错
            NSLog(@"%@", responseArray);
            return;
        }
        for (int i = 0; i < responseArray.count; ++i) {
            PushHelperItemModel *model = [[PushHelperItemModel alloc] initWithType:[[responseArray[i] objectForKey:@"factoryType"] intValue] andDistanceNum:[responseArray[i] objectForKey:@"range"] andSize:[responseArray[i] objectForKey:@"people"] andBusinessType:[responseArray[i] objectForKey:@"businessType"]];

            [self.listArray addObject:model];
        }
//        [self.collectionView reloadData];

    }];

    // 返回按钮
    //        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked:)];
    //        self.navigationItem.leftBarButtonItem = backButton;



}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSArray*imageArr=@[@"pushIcon_1",@"pushIcon_2",@"pushIcon_3",@"pushIcon_4"];

    for (int i=0; i<4; i ++) {
        UIImageView*cellImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10+(10+25)*i, 25, 25)];
        cellImage.image=[UIImage imageNamed:imageArr[i]];
        [cell addSubview:cellImage];

        UILabel*cellLabel=[[UILabel alloc]initWithFrame:CGRectMake(45, 10+(10+25)*i, 120, 25)];
        cellLabel.text=@"cellLabel";
        [cell addSubview:cellLabel];

    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 25)];

    UILabel*orderInfoLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
    orderInfoLabel.font=[UIFont boldSystemFontOfSize:16];
    orderInfoLabel.text=@"订单信息";
    orderInfoLabel.textAlignment=NSTextAlignmentCenter;
    [view addSubview:orderInfoLabel];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-60, 0, 50, 25)];
    btn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateSelected];
    btn.tag=section;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

    
//    view.backgroundColor = [UIColor greenColor];
    return view;
}

- (void)clickBtn:(UIButton*)sender {
    UIButton*button = (UIButton *)sender;
    button.selected=!button.selected;
    NSLog(@"%d",button.tag);
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
//    view.backgroundColor = [UIColor blackColor];
//    return view;
//}

#pragma mark - Button Event Method
- (void)addOrderClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"服装厂订单", @"加工厂订单", @"代裁厂订单", @"锁眼钉扣订单", nil];
    [actionSheet showInView:self.tableView];
}

#pragma mark <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 4) {
        NSInteger itemType = buttonIndex;
        PushEditViewController *pushEditViewController = [[PushEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
        pushEditViewController.itemType = itemType;
        pushEditViewController.listArray = self.listArray;
        switch (buttonIndex) {
            case 0:
                pushEditViewController.title = @"服装厂订单";
                pushEditViewController.pickList =@[@[@"10公里以内", @"50公里以内", @"100公里以内", @"150公里以内", @"不限距离"],@[@"500件以内", @"500件-1000件", @"1000件-2000件", @"2000件-5000件", @"5000件以上"],@[@"童装", @"成人装"]];
                break;
            case 1:
                pushEditViewController.title = @"加工厂订单";
                pushEditViewController.pickList =@[@[@"10公里以内", @"50公里以内", @"100公里以内", @"150公里以内", @"不限距离"],@[@"2人", @"2人-4人", @"4人以上"],@[@"针织", @"梭织"]];
                break;
            case 2:
                pushEditViewController.title = @"代裁厂订单";
                pushEditViewController.pickList =@[@[@"10公里以内", @"50公里以内", @"100公里以内", @"150公里以内", @"不限距离"],@[@"2人", @"2人-4人", @"4人以上"],@[@" "]];
                break;
            case 3:
                pushEditViewController.title = @"锁眼钉扣订单";
                pushEditViewController.pickList =@[@[@"10公里以内", @"50公里以内", @"100公里以内", @"150公里以内", @"不限距离"],@[@"2人", @"2人-4人", @"4人以上"],@[@" "]];
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:pushEditViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
