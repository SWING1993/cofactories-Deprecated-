

//
//  LookoverMaterialViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/23.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "LookoverMaterialViewController.h"
#import "LookoverMaterialModel.h"
#import "JKPhotoBrowser.h"
#import "PHPDetailTableViewCell.h"

@interface LookoverMaterialViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView           *_tableView;
    UIView                *_tableHeadView;
    LookoverMaterialModel *_model;
    UIScrollView          *_scrollView;
    FactoryModel          *_userModel;
}

@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";
@implementation LookoverMaterialViewController

- (id)initWithOid:(NSString *)oid{
    if (self = [super init]) {
        [HttpClient getMaterialDetailMessageWithId:oid completionBlock:^(NSDictionary *responseDictionary) {
            NSDictionary *dic = (NSDictionary *)responseDictionary[@"responseObject"];
            _model = [LookoverMaterialModel getModelWith:dic];
            [self creatTableView];
            [self creatGobackButton];
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"bg_navigation.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[PHPDetailTableViewCell class] forCellReuseIdentifier:reuseIdentifier1];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier2];
    [self.view addSubview:_tableView];
    
    _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-30)];
    _tableView.tableHeaderView = _tableHeadView;
    if (_model.photoArray.count == 0) {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:_tableHeadView.frame];
        bgImageView.image = [UIImage imageNamed:@"默认图"];
        [_tableHeadView addSubview:bgImageView];
        
    }else{
        [self creatScrollView];
    }
}

- (void)creatScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-30)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_tableHeadView addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(kScreenW * _model.photoArray.count, (kScreenH)/2.0-30);
    for (int i = 0; i < _model.photoArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_model.photoArray[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
        [button setFrame:CGRectMake(i * kScreenW, 0, kScreenW, (kScreenH)/2.0-30)];
        [button addTarget:self action:@selector(MJPhotoBrowserClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_scrollView addSubview:button];
        
    }
}

- (void)creatGobackButton{
    
    UIButton *gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackButton.frame = CGRectMake(8, 22, 25, 25);
    [gobackButton setBackgroundImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [gobackButton addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gobackButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }if (section == 1) {
        if ([_model.type isEqualToString:@"面料"]) {
            return 6;
        }else{
            return 5;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        PHPDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        cell.phoneButton.hidden = NO;
        [cell.phoneButton addTarget:self action:@selector(contactWithFactory) forControlEvents:UIControlEventTouchUpInside];
        [cell getDataWithModel:_model isMaterial:YES];
        return cell;
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor= [UIColor grayColor];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"类型:  %@",_model.type];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"名称:  %@",_model.name];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"用途:  %@",_model.useage];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"价格:  %zi 元",_model.price];
            break;
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@",_model.descriptions];
            break;
        case 5:
            cell.textLabel.text = [NSString stringWithFormat:@"门幅:  %@ 米",_model.width];
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
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CooperationInfoViewController *vc = [CooperationInfoViewController new];
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"返回";
        backItem.tintColor=[UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backItem;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [HttpClient getUserProfileWithUid:_model.userID andBlock:^(NSDictionary *responseDictionary) {
            _userModel = (FactoryModel *)responseDictionary[@"model"];
            vc.factoryModel = _userModel;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

- (void)MJPhotoBrowserClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[_model.photoArray count]];
    [_model.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_model.photoArray[idx]]];
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = button.tag;
    browser.photos = photos;
    [browser show];
    
}

- (void)contactWithFactory{
    NSString *str = [NSString stringWithFormat:@"telprompt://%@", _model.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)gobackClick{
    
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
