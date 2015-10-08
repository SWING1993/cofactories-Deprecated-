//
//  ShopDetailViewViewController.m
//  cofactory-1.1
//
//  Created by GTF on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "ShopDetailViewViewController.h"
#import "HeaderCollectionReusableView.h"
#import "ClothCollectionViewCell.h"
#import "LookoverMaterialModel.h"
#import "JKPhotoBrowser.h"
#import "OrderPhotoViewController.h"
#import "LookoverMaterialViewController.h"
@interface ShopDetailViewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *_dataArray;
}


@end

@implementation ShopDetailViewViewController
- (id)initWithLookoverMaterialModel:(NSArray *)modelArray{
    if (self = [super init]) {
        _dataArray = [@[] mutableCopy];
        if (modelArray.count > 0) {
            [modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dictionary = (NSDictionary *)obj;
                LookoverMaterialModel *model = [LookoverMaterialModel getModelWith:dictionary];
                [_dataArray addObject:model];
            }];
        }else{
            
        }
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"bg_navigation.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self creatGobackButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((kScreenW-40)/3.0, 120);
    [layout setHeaderReferenceSize:CGSizeMake(kScreenW, kScreenH/2.0-30)];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = YES;
    [collectionView registerClass:[ClothCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.view addSubview:collectionView];
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataArray.count > 0) {
        return  _dataArray.count;
    }else{
        return 1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClothCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell initWithUI];
  
    if (_dataArray.count > 0) {
        LookoverMaterialModel *model = _dataArray[indexPath.row];
        cell.messageLable.text = model.name;
        cell.imageButton.tag = indexPath.row;
        cell.imageButton.enabled = YES;
        [cell.imageButton addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
        if (model.photoArray.count > 0 ) {
            NSString *imageOne = model.photoArray[0];
            [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,imageOne]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder88"]];
            
        }else{
            [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"placeholder88"] forState:UIControlStateNormal];
        }

    }else{
        cell.messageLable.text = @"信息暂无";
        [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"placeholder88"] forState:UIControlStateNormal];
        cell.imageButton.enabled = NO;
    }
    
        return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        
        reusableview = headerView;
        [headerView getDataWithFactoryModel:self.facModel];
        [headerView.userHeader addTarget:self action:@selector(goToUserInterface) forControlEvents:UIControlEventTouchUpInside];
    }
    reusableview.backgroundColor = [UIColor whiteColor];
    return reusableview;
}

- (void)photoClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    LookoverMaterialModel *model = _dataArray[button.tag];
    LookoverMaterialViewController *VC= [[LookoverMaterialViewController alloc]initWithOid:[NSString stringWithFormat:@"%zi",model.materialID]];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title = @"";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)creatGobackButton{
    
    UIButton *gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackButton.frame = CGRectMake(8, 22, 25, 25);
    [gobackButton setBackgroundImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [gobackButton addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gobackButton];
}

//1223435456354
- (void)goToUserInterface{
    
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
