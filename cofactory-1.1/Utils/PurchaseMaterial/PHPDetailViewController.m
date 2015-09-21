//
//  PHPDetailViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PHPDetailViewController.h"
#import "PHPDetailTableViewCell.h"
#import "JKPhotoBrowser.h"

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
    self.navigationItem.title = @"发布详情";

    [self prefersStatusBarHidden];
    [self creatTableView];
}

- (void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier1];
    [_tableView registerClass:[PHPDetailTableViewCell class] forCellReuseIdentifier:reuseIdentifier2];
    [self.view addSubview:_tableView];
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-40)];
    _tableView.tableHeaderView = _headView;
    
    if (self.model.photoArray.count == 0) {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:_headView.frame];
        bgImageView.image = [UIImage imageNamed:@"默认图"];
        [_headView addSubview:bgImageView];
        [self creatGobackButton];
        
    }else{
        [self creatScrollView];
    }
}

- (void)creatGobackButton{
    
    UIButton *gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackButton.frame = CGRectMake(15, 15, 30, 30);
    [gobackButton setBackgroundImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [gobackButton addTarget:self action:@selector(bobackClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:gobackButton];
}

- (void)creatScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-40)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_headView addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(kScreenW * self.model.photoArray.count, (kScreenH)/2.0-40);
    for (int i = 0; i < self.model.photoArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.model.photoArray[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
        [button setFrame:CGRectMake(i * kScreenW, 0, kScreenW, (kScreenH)/2.0-40)];
        [button addTarget:self action:@selector(MJPhotoBrowserClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_scrollView addSubview:button];
        
        if (i == 0) {
            UIButton *gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
            gobackButton.frame = CGRectMake(15, 15, 30, 30);
            [gobackButton setBackgroundImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
            [gobackButton addTarget:self action:@selector(bobackClick) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = YES;
            [button addSubview:gobackButton];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PHPDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier2 forIndexPath:indexPath];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
           
            
            break;
            
        case 1:
            
            break;
            
        case 2:
            
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
    }return 44;
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


- (void)bobackClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
