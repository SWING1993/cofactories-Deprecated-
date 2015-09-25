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

@property (nonatomic,assign)NSUInteger employeeCount;
@property (nonatomic,assign)NSUInteger environmentCount;
@property (nonatomic,assign)NSUInteger equipmentCount;


@end

@implementation PhotoViewController {
    dispatch_queue_t _serialQueue;
}

//get
- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {

        DLog(@"创建窜行队列");
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
    }
    return _serialQueue;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"公司相册";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.cellArray=@[@"员工",@"公司环境",@"公司设备"];

    [self getImageCount];
}

- (void)getImageCount {

    _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列

    dispatch_async([self serialQueue], ^{//把block中的任务放入串行队列中执行，这是第一个任务
        //        sleep(2);//假装这个viewController创建起来很花时间。。其实view都还没加载，根本不花时间。
        DLog(@"prepared");
        [HttpClient getFactoryPhotoWithUid:self.userUid type:@"employee" andBlock:^(NSDictionary *dictionary) {

            if ([dictionary[@"statusCode"] intValue]== 200) {
//                NSMutableArray*employeeArray = [[NSMutableArray alloc]initWithCapacity:10];
                NSDictionary*responseDictionary = dictionary[@"responseDictionary"];
                NSDictionary*factory=responseDictionary[@"factory"];
                NSArray*employeeArray = factory[@"employee"];
                self.employeeCount = [employeeArray count];

                int Section = 0;
                NSIndexPath *indexPaths=[NSIndexPath indexPathForRow:0 inSection:Section];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationNone];

                DLog(@"0");
            }
        }];
        [HttpClient getFactoryPhotoWithUid:self.userUid type:@"environment" andBlock:^(NSDictionary *dictionary) {

            if ([dictionary[@"statusCode"] intValue]== 200) {
//                NSMutableArray*environmentArray = [[NSMutableArray alloc]initWithCapacity:10];
                NSDictionary*responseDictionary = dictionary[@"responseDictionary"];
                NSDictionary*factory=responseDictionary[@"factory"];
                NSArray*environmentArray=factory[@"environment"];
                self.environmentCount = [environmentArray count];

                int Section = 1;
                NSIndexPath *indexPaths=[NSIndexPath indexPathForRow:0 inSection:Section];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationNone];
                DLog(@"1");

            }
        }];

        [HttpClient getFactoryPhotoWithUid:self.userUid type:@"equipment" andBlock:^(NSDictionary *dictionary) {
            if ([dictionary[@"statusCode"] intValue]== 200) {
//                NSMutableArray*equipmentArray = [[NSMutableArray alloc]initWithCapacity:10];
                NSDictionary*responseDictionary = dictionary[@"responseDictionary"];
                NSDictionary*factory=responseDictionary[@"factory"];
                NSArray*equipmentArray=factory[@"equipment"];
                self.equipmentCount = [equipmentArray count];

                int Section = 2;
                NSIndexPath *indexPaths=[NSIndexPath indexPathForRow:0 inSection:Section];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationNone];
                DLog(@"2");
            }
        }];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    switch (indexPath.section) {
        case 0:
        {
            if (self.employeeCount) {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%lu/10",(unsigned long)self.employeeCount];
            }else{
                cell.detailTextLabel.text = @"暂无照片";
            }
        }
            break;
        case 1:
        {
            if (self.environmentCount) {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%lu/10",(unsigned long)self.environmentCount];
            }else{
                cell.detailTextLabel.text = @"暂无照片";
            }
        }
            break;
        case 2:
        {
            if (self.equipmentCount) {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%lu/10",(unsigned long)self.equipmentCount];
            }else{
                cell.detailTextLabel.text = @"暂无照片";
            }
        }
            break;

        default:
            break;
    }
    UIImageView*cellImage= [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
    cellImage.image=[UIImage imageNamed:@"set_公司相册"];
    [cell addSubview:cellImage];

    UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, kScreenW-40, 30)];
    cellLabel.font=kLargeFont;
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
            uploadVC.isMySelf = self.isMySelf;
            uploadVC.type=@"employee";
            uploadVC.title=@"员工相册";
            [self.navigationController pushViewController:uploadVC animated:YES];
        }
            break;
        case 1:{
            UploadImageViewController*uploadVC = [[UploadImageViewController alloc]init];
            uploadVC.userUid=self.userUid;
            uploadVC.isMySelf = self.isMySelf;
            uploadVC.type=@"environment";
            uploadVC.title=@"环境相册";
            [self.navigationController pushViewController:uploadVC animated:YES];

        }
            break;
        case 2:{
            UploadImageViewController*uploadVC = [[UploadImageViewController alloc]init];
            uploadVC.userUid=self.userUid;
            uploadVC.isMySelf = self.isMySelf;
            uploadVC.type=@"equipment";
            uploadVC.title=@"设备相册";
            [self.navigationController pushViewController:uploadVC animated:YES];

        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
