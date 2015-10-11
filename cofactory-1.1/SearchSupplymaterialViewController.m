//
//  SearchSupplymaterialViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "SearchSupplymaterialViewController.h"
#import "userInformationCell.h"
#import "MaterialInfoCell.h"
#import "PHPDetailTableViewCell.h"
@interface SearchSupplymaterialViewController () {
    NSArray *titleArray1;
    NSArray *titleArray2;
    UIScrollView *scrollView;
    FactoryModel  *_userModel;
}

@end

static NSString *searchCellIdentifier = @"SearchCell";
static NSString *userCellIdentifier = @"userCell";
@implementation SearchSupplymaterialViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self creatCancleButton];
    [self creatHeaderView];
    
    [self netWork];
    
    //注册cell
    [self.tableView registerClass:[MaterialInfoCell class] forCellReuseIdentifier:searchCellIdentifier];
    [self.tableView registerClass:[PHPDetailTableViewCell class] forCellReuseIdentifier:userCellIdentifier];
    
    titleArray1 = @[@"类型:", @"名称:", @"价格:", @"门幅:", @"产品用途:", @"面料说明:"];
    titleArray2 = @[@"类型:", @"名称:", @"价格:", @"面料说明:"];

}


- (void)netWork {
    [HttpClient getMaterialMessageWithID:self.oid completionBlock:^(NSDictionary *responseDictionary) {
        self.history = responseDictionary[@"model"];
        [self getFactory];
        [self.tableView reloadData];
    }];
}




- (void)getFactory {
    [HttpClient getUserProfileWithUid:[self.history.factoryUid integerValue] andBlock:^(NSDictionary *responseDictionary) {
        _userModel = (FactoryModel *)responseDictionary[@"model"];
    }];
}

- (void)creatHeaderView {
    self.tableViewHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.85 *kScreenW)];

    if (self.photoArray.count == 0) {
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.85 *kScreenW)];
        self.photoView.image = [UIImage imageNamed:@"没有上传图片"];
        [self.tableViewHeadView addSubview:self.photoView];
        
    } else {
        [self creatScrollView];
    }
    self.tableView.tableHeaderView = self.tableViewHeadView;
}
- (void)creatScrollView{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.85 *kScreenW)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.tableViewHeadView addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(kScreenW * self.photoArray.count, 0.85 *kScreenW);
    for (int i = 0; i < self.photoArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.photoArray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
        [button setFrame:CGRectMake(i * kScreenW, 0, kScreenW, 0.85 *kScreenW)];
        [button addTarget:self action:@selector(MJPhotoBrowserClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [scrollView addSubview:button];
        
    }
    

}

- (void)MJPhotoBrowserClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.photoArray count]];
    [self.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.photoArray[idx]];
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = button.tag;
    browser.photos = photos;
    [browser show];
    
}
- (void)creatCancleButton {
    UIImageView *cancleImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    cancleImage.image = [UIImage imageNamed:@"goback"];
    [self.view addSubview:cancleImage];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, 20, 80, 40);
    [cancleButton addTarget:self action:@selector(pressCancleButton) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cancleButton];

}




- (void)creatTableView {
//    [self.navigationController.navigationBar setHidden:YES];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenW, kScreenH + 20) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
        if ([self.type isEqualToString:@"面料"]) {
            
            return 6;
        } else {
            return 4;
        }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        PHPDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentifier forIndexPath:indexPath];
//        cell.phoneButton.hidden = NO;
//        [cell.phoneButton addTarget:self action:@selector(contactWithFactory) forControlEvents:UIControlEventTouchUpInside];
//        [cell getDataWithOtherModel:[self.history.factoryUid integerValue] isMaterial:YES];
//    }
    MaterialInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.font = [UIFont systemFontOfSize:14];
    cell.nameLabel.textColor = [UIColor grayColor];
    cell.infoLabel.textColor = [UIColor grayColor];
    cell.infoLabel.font = [UIFont systemFontOfSize:14];
    if ([self.type isEqualToString:@"面料"]) {
        cell.nameLabel.text = titleArray1[indexPath.row];
        
        InformationModel *information = [[InformationModel alloc] init];
        
        switch (indexPath.row) {
            case 0:
                cell.infoLabel.text = self.history.type;
                
                break;
            case 1:
                cell.infoLabel.text = self.history.name;
                
                break;
            case 2:
                cell.infoLabel.text = [NSString stringWithFormat:@"%ld 元", (long)self.history.price];
                
                break;
            case 3:
                cell.infoLabel.text = [NSString stringWithFormat:@"%@ 米", self.history.width];
                
                break;
                
            case 4:
                information.title = self.history.usage;
                cell.info = information;
                break;
            case 5:
                information.title = self.history.info;
                cell.info = information;
                break;
            
            default:
                break;
        }
        
        return cell;
    } else {
        cell.nameLabel.text = titleArray2[indexPath.row];
        InformationModel *information = [[InformationModel alloc] init];
        
        switch (indexPath.row) {
            case 0:
                cell.infoLabel.text = self.history.type;
                break;
            case 1:
                cell.infoLabel.text = self.history.name;
                break;
            case 2:
                cell.infoLabel.text = [NSString stringWithFormat:@"%ld 元", (long)self.history.price];
                break;
            
            case 3:
                information.title = self.history.info;
                cell.info = information;
                break;
                
            default:
                break;
        }

        return cell;
    }
    

    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 80;
//    }
        if ([self.type isEqualToString:@"面料"]) {
            if (indexPath.row == 4 && self.history.info.length != 0) {
                return [MaterialInfoCell heightOfCell:self.history.usage];
            } else if (indexPath.row == 5 && self.history.info.length != 0) {
                return [MaterialInfoCell heightOfCell:self.history.info];
            } else {
                return 40;
            }
        } else {
            if (indexPath.row == 3 && self.history.info.length != 0) {
                return [MaterialInfoCell heightOfCell:self.history.info];
            } else {
                return 40;
            }

        }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return 10;
//    }
    return 10;
}




- (void)pressCancleButton {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressphoneBtn:(UIButton *)button {
    DLog(@"打电话");
    
}

//裁剪图片
//- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
//{
//    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
//    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
//    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return reSizeImage;
//}

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
