//
//  BidManagerViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/7.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "BidManagerViewController.h"
#import "BidManagerTableViewCell.h"
#import "OrderPhotoViewController.h"

static NSString *const cellIdentifer = @"bidCellIdentifer";

@interface BidManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSInteger _selectedRow;
}

@end

@implementation BidManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"投标管理";
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"确认中标" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBid)];
    _selectedRow = -1;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)  style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[BidManagerTableViewCell class] forCellReuseIdentifier:cellIdentifer];
    _tableView.rowHeight = 100;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bidFactoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BidManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    BidManagerModel *model = self.bidFactoryArray[indexPath.row];
//    DLog(@"_competeFactoryArray==%d",model.photoArray.count);
    [cell getDataWithBidManagerModel:model indexPath:indexPath];
    cell.imageButton.tag = indexPath.row+1;
    [cell.imageButton addTarget:self action:@selector(gotoPhotoView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bgImageButton addTarget:self action:@selector(gotoCooperation:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == _selectedRow)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = indexPath.row ;
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark ;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)confirmBid{
    DLog(@"==%ld",(long)_selectedRow);
    if (_selectedRow == -1) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"未选择中标厂商!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 10;
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认让该厂商中标?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        [alertView show];
    }
   
}

- (void)gotoPhotoView:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    BidManagerModel *model = self.bidFactoryArray[button.tag-1];
    
    if (model.photoArray.count > 0) {
        OrderPhotoViewController *vc = [[OrderPhotoViewController alloc]initWithPhotoArray:model.photoArray];
        vc.titleString = @"竞标图片";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"厂家未上传竞标图片" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 11;
        [alertView show];
    }
    
}

- (void)gotoCooperation:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    [HttpClient getUserProfileWithUid:button.tag andBlock:^(NSDictionary *responseDictionary) {
        DLog(@"----%@",responseDictionary);
        NSNumber *number = responseDictionary[@"statusCode"];
        if ([number compare:@200] == NSOrderedSame) {
            CooperationInfoViewController *vc = [CooperationInfoViewController new];
            vc.factoryModel = (FactoryModel *)responseDictionary[@"model"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        BidManagerModel *model = self.bidFactoryArray[_selectedRow];
        if (buttonIndex == 1) {
            [HttpClient closeOrderWithOid:self.oid Uid:model.uid andBlock:^(int statusCode) {
                if (statusCode == 200) {
                    [Tools showSuccessWithStatus:@"招标成功，祝您合作愉快"];
                    NSArray *navArray = self.navigationController.viewControllers;
                    [self.navigationController popToViewController:navArray[1] animated:YES];
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
