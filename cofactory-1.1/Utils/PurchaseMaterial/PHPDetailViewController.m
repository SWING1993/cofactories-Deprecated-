//
//  PHPDetailViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PHPDetailViewController.h"
#import "PHPDetailTableViewCell.h"
#import "PHPDetailMessCell.h"
#import "JKPhotoBrowser.h"
#import "PurchasePublicHistoryModel.h"

@interface PHPDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView    *_tableView;
    UIScrollView   *_scrollView;
    UIView            *_headView;
}

@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";

@implementation PHPDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"bg_navigation.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    [self prefersStatusBarHidden];
    [self creatTableView];
    [self creatGobackButton];
    [self creatBitManagerButton];
   // [self creatBottomTwoButtons];
}

- (void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-40) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[PHPDetailMessCell class] forCellReuseIdentifier:reuseIdentifier1];
    [_tableView registerClass:[PHPDetailTableViewCell class] forCellReuseIdentifier:reuseIdentifier2];
    [self.view addSubview:_tableView];
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-30)];
    _tableView.tableHeaderView = _headView;
    
    if (self.model.photoArray.count == 0) {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:_headView.frame];
        bgImageView.image = [UIImage imageNamed:@"默认图"];
        [_headView addSubview:bgImageView];
        
    }else{
        [self creatScrollView];
    }
}

- (void)creatGobackButton{
    
    UIButton *gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackButton.frame = CGRectMake(8, 22, 25, 25);
    [gobackButton setBackgroundImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [gobackButton addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gobackButton];
}

- (void)creatBitManagerButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, kScreenH-40, kScreenW, 40);
    [button setTitle:@"投标管理" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bidManager) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)creatBottomTwoButtons{
    
    NSArray *array = @[@"致电",@"投标"];
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*kScreenW/2.0, kScreenH-40, kScreenW/2.0, 40);
        button.titleLabel.textColor = [UIColor lightGrayColor];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)creatScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-30)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_headView addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(kScreenW * self.model.photoArray.count, (kScreenH)/2.0-30);
    for (int i = 0; i < self.model.photoArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.model.photoArray[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
        [button setFrame:CGRectMake(i * kScreenW, 0, kScreenW, (kScreenH)/2.0-30)];
        [button addTarget:self action:@selector(MJPhotoBrowserClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_scrollView addSubview:button];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PHPDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier2 forIndexPath:indexPath];
        cell.phoneButton.hidden = YES;
        return cell;
    }
    
    PHPDetailMessCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"采购数量";
            cell.titleLabel.frame = CGRectMake(10, 0, 80, 44);
            cell.messageLabel.frame = CGRectMake(90, 0, kScreenW-10, 44);
            cell.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            cell.messageLabel.textColor = [UIColor orangeColor];
            cell.messageLabel.text = [NSString stringWithFormat:@"%zi%@",self.model.amount,self.model.unit];
            break;
            
        case 1:
            cell.titleLabel.frame = CGRectMake(10, 0, kScreenW-10, 30);
            cell.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.titleLabel.text = self.model.comment;
            cell.messageLabel.frame = CGRectMake(10, 30, kScreenW-10, 30);
            cell.messageLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.messageLabel.textColor = [UIColor grayColor];
            cell.messageLabel.text = [Tools WithTime:self.model.creatTime][0];
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return 60;
        }
    }
    return 44;
}

- (void)MJPhotoBrowserClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.model.photoArray count]];
    [self.model.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.model.photoArray[idx]]];
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = button.tag;
    browser.photos = photos;
    [browser show];
    
}

- (void)buttonTwoBtnClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        
    }else if (button.tag == 1){
        
    }
}

- (void)bidManager{
    DLog(@"11223");
}

- (void)gobackClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
