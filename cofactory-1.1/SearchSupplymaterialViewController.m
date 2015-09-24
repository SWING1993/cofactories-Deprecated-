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
@interface SearchSupplymaterialViewController () {
    NSArray *titleArray1;
    NSArray *titleArray2;
    UIScrollView *scrollView;
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
    [self creatToolBar];
    
    //注册cell
    [self.tableView registerClass:[MaterialInfoCell class] forCellReuseIdentifier:searchCellIdentifier];
    [self.tableView registerClass:[userInformationCell class] forCellReuseIdentifier:userCellIdentifier];
    
    titleArray1 = @[@"类型:", @"名称:", @"价格:", @"门幅:", @"产品用途:", @"面料说明:"];
    titleArray2 = @[@"类型:", @"名称:", @"价格:", @"面料说明:"];

}


- (void)netWork {
    [HttpClient getMaterialMessageWithID:self.oid completionBlock:^(NSDictionary *responseDictionary) {
        self.history = responseDictionary[@"model"];

        [self.tableView reloadData];
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
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
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
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(20, 30, 30, 30);
    [cancleButton setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    cancleButton.layer.cornerRadius = 15;
    cancleButton.layer.masksToBounds = YES;
    [cancleButton addTarget:self action:@selector(pressCancleButton) forControlEvents:UIControlEventTouchUpInside];
    
    cancleButton.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.430];
    [self.view addSubview:cancleButton];

}

- (void)creatToolBar {
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenH - 40, kScreenW, 40)];
    //UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
//    phoneBtn.backgroundColor = [UIColor redColor];
    [phoneBtn setTitle: @"电话" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(pressphoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:phoneBtn];
    [self.view addSubview:toolBar];
    
}


- (void)creatTableView {
//    [self.navigationController.navigationBar setHidden:YES];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenW, kScreenH - 20) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        DLog(@"rrrrrrrrrrr%@", self.type);
        if ([self.type isEqualToString:@"面料"]) {
            
            return 6;
        } else {
            return 4;
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        userInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    MaterialInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                cell.infoLabel.text = [NSString stringWithFormat:@"%ld", self.history.price];
                
                break;
            case 3:
                cell.infoLabel.text = [NSString stringWithFormat:@"%ld", self.history.width];
                
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
                cell.infoLabel.text = [NSString stringWithFormat:@"%ld", self.history.price];
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
    if (indexPath.section == 0) {
        return 80;
    } else {
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 1;
}




- (void)pressCancleButton {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressphoneBtn:(UIButton *)button {
    DLog(@"打电话");
    
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
