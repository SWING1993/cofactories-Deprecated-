//
//  PhotoViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//


#import "Header.h"
#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (nonatomic,retain)NSArray*cellArray;
@property (nonatomic,retain)NSMutableArray*employeeArray;
@property (nonatomic,retain)NSMutableArray*environmentArray;
@property (nonatomic,retain)NSMutableArray*equipmentArray;


@end

@implementation PhotoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [HttpClient getFactoryPhotoWithUid:self.userUid type:@"employee" andBlock:^(NSDictionary *dictionary) {

        if ([dictionary[@"statusCode"] intValue]== 200) {
            self.employeeArray = [[NSMutableArray alloc]initWithCapacity:0];
            NSDictionary*responseDictionary = dictionary[@"responseDictionary"];
            NSDictionary*factory=responseDictionary[@"factory"];
            self.employeeArray = factory[@"employee"];

            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];

//            NSLog(@"1");
        }
    }];
    [HttpClient getFactoryPhotoWithUid:self.userUid type:@"environment" andBlock:^(NSDictionary *dictionary) {

        if ([dictionary[@"statusCode"] intValue]== 200) {
            self.environmentArray = [[NSMutableArray alloc]initWithCapacity:0];
            NSDictionary*responseDictionary = dictionary[@"responseDictionary"];
            NSDictionary*factory=responseDictionary[@"factory"];
            self.environmentArray=factory[@"environment"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1],nil] withRowAnimation:UITableViewRowAnimationNone];

//            NSLog(@"2");

        }
    }];

    [HttpClient getFactoryPhotoWithUid:self.userUid type:@"equipment" andBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"statusCode"] intValue]== 200) {
            self.equipmentArray = [[NSMutableArray alloc]initWithCapacity:0];
            NSDictionary*responseDictionary = dictionary[@"responseDictionary"];
            NSDictionary*factory=responseDictionary[@"factory"];
            self.equipmentArray=factory[@"equipment"];

            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:2],nil] withRowAnimation:UITableViewRowAnimationNone];
//            NSLog(@"3");
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"公司相册";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.cellArray=@[@"员工",@"公司环境",@"公司设备"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    switch (indexPath.section) {
        case 0:
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%lu/10",(unsigned long)[self.employeeArray count]];
        }
            break;
        case 1:
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%lu/10",(unsigned long)[self.environmentArray count]];
        }
            break;
        case 2:
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%lu/10",(unsigned long)[self.equipmentArray count]];
        }
            break;

        default:
            break;
    }
    UIImageView*cellImage= [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
    cellImage.image=[UIImage imageNamed:@"set_公司相册"];
    [cell addSubview:cellImage];

    UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, kScreenW-40, 30)];
    cellLabel.font=[UIFont systemFontOfSize:15.0f];
    cellLabel.text=self.cellArray[indexPath.section];
    [cell addSubview:cellLabel];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
            //@param type  图片类型(environment 环境, equipment 设备 , employee  员工, avatar)
        case 0:{
            UploadImageViewController*uploadVC = [[UploadImageViewController alloc]init];
            uploadVC.userUid=self.userUid;
            uploadVC.type=@"employee";
            uploadVC.title=@"员工相册";
            [self.navigationController pushViewController:uploadVC animated:YES];
        }
            break;
        case 1:{
            UploadImageViewController*uploadVC = [[UploadImageViewController alloc]init];
            uploadVC.userUid=self.userUid;
            uploadVC.type=@"environment";
            uploadVC.title=@"环境相册";
            [self.navigationController pushViewController:uploadVC animated:YES];

        }
            break;
        case 2:{
            UploadImageViewController*uploadVC = [[UploadImageViewController alloc]init];
            uploadVC.userUid=self.userUid;
            uploadVC.type=@"equipment";
            uploadVC.title=@"设备相册";
            [self.navigationController pushViewController:uploadVC animated:YES];

        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
